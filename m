Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbYAPIVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbYAPIVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYAPIVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:21:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:12389 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbYAPIVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=gfyVEdGK0qHfxsVYaUQs2/6X5nIgCGBGX8pG7Uol7JCR4tHBLoRGlmGvI5qyE6SH8YdqEJvtRSbS6cDo0SLTT2iiXY+TVv2wzMwlXi1ktNOhZm+v134pZ/dqEeIUE6PQ/OX/MAG4R1D7Yp8r6K/YCqy3jrAgUGDVfoY6y7vcLoQ=
From: Balaji Rao <balajirrao@gmail.com>
Organization: NITK
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: hpet_late_init hang
Date: Wed, 16 Jan 2008 14:04:33 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <86802c440801151932o6aaea248w7d1137eaa2ac3579@mail.gmail.com> <20080116065133.GA26783@elte.hu>
In-Reply-To: <20080116065133.GA26783@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801161404.33519.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 12:21:33 pm Ingo Molnar wrote:
Hi Ingo,
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > "
> > commit e5ed385fa0d6f35406e3e3ed75e5eb9adeb811df
> > Author: Balaji Rao <balajirrao@gmail.com>
> > Date:   Tue Jan 15 16:53:29 2008 +0100
> >
> >     Assign IRQs to HPET Timers
> > "
> > in x86.git
> >
> > cause my servers hang
> > after
> > Calling initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100()
>
> i'm wondering, where does it hang exactly and why?
>
> > after reverting that I got:
> >
> > initcall 0xffffffff80b947d1 ran for 19 msecs: pci_iommu_init+0x0/0x13()
> > Calling initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100()
> > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> > hpet0: 3 32-bit timers, 25000000 Hz
> > initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100() returned 0.
> > initcall 0xffffffff80b9a465 ran for 7 msecs: hpet_late_init+0x0/0x100()
> >
Looks like IRQ 31 is assigned to timer 3, even without the patch! I wonder who wrote the number 31. But the manual says 
that it is zero by default.

I think we should check whether the timer has been allocated an IRQ before proceeding to assign one to it.
Here is a patch that does this.

Yinghai, could you please apply this on top of my patch and check ?

---
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -116,7 +116,8 @@ int is_hpet_enabled(void)
 static void hpet_reserve_platform_timers(unsigned long id)
 {
 	struct hpet __iomem *hpet = hpet_virt_address;
-	unsigned int nrtimers;
+	struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
+	unsigned int nrtimers, i;
 	struct hpet_data hd;
 
 	nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
@@ -134,10 +135,9 @@ static void hpet_reserve_platform_timers
 	hd.hd_irq[0] = HPET_LEGACY_8254;
 	hd.hd_irq[1] = HPET_LEGACY_RTC;
 
-	/*
-	 * IRQs for the other timers are assigned dynamically
-	 * in hpet_alloc
-	 */
+       for (i = 2; i < nrtimers; timer++, i++)
+	       hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
+		       Tn_INT_ROUTE_CNF_SHIFT;
 	hpet_alloc(&hd);
 }
 #else
Index: linux-2.6/drivers/char/hpet.c
===================================================================
--- linux-2.6.orig/drivers/char/hpet.c
+++ linux-2.6/drivers/char/hpet.c
@@ -852,6 +852,12 @@ int hpet_alloc(struct hpet_data *hdp)
 
 		timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
 
+		/* Check if there's already an IRQ assigned to the timer */
+		if (hdp->hd_irq[i]) {
+			hpetp->hp_dev[i].hd_hdwirq = hdp->hd_irq[i];
+			continue;
+		}
+
 		hpet_config = readq(&timer->hpet_config);
 		irq_bitmap = (hpet_config & Tn_INT_ROUTE_CAP_MASK)
 			>> Tn_INT_ROUTE_CAP_SHIFT;

---
regards,
balaji rao
