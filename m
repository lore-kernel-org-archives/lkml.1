Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYAQP7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYAQP7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYAQP7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:59:15 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:23946 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYAQP7O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=M47EVtHeoOwnc9W5gJbZPGHoEn8DjaWYeT+kjJjonmGibQJKtA6Wne3dPGYeowOIVbG14H9ugF0F2aTObxScbVVPW+tTYGy5AAqCoXVG4Rr3GAvPsv+Rs96DUnKWgwtXJuO3mf2QiGPyTDaqBs3VFpwyoEaOYYUPNJFuKn/i6Yc=
From: Balaji Rao <balajirrao@gmail.com>
Organization: NITK
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: hpet_late_init hang
Date: Thu, 17 Jan 2008 21:42:41 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <86802c440801151932o6aaea248w7d1137eaa2ac3579@mail.gmail.com> <200801161404.33519.balajirrao@gmail.com> <86802c440801161339h4e3e983co67e05a231666d050@mail.gmail.com>
In-Reply-To: <86802c440801161339h4e3e983co67e05a231666d050@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801172142.41787.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008 03:09:42 am Yinghai Lu wrote:
> > Looks like IRQ 31 is assigned to timer 3, even without the patch! I wonder who wrote the number 31. But the manual says
> > that it is zero by default.
> >
> > I think we should check whether the timer has been allocated an IRQ before proceeding to assign one to it.
> > Here is a patch that does this.
> >
> > Yinghai, could you please apply this on top of my patch and check ?
> >
> > ---
> > Index: linux-2.6/arch/x86/kernel/hpet.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/hpet.c
> ...
> >
> 
> it works
> 
Cool!

Ingo, here's the patch with the SOB. Please apply.

regards,
balaji rao

Check if there's an IRQ assigned to the timer before assigning one.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -116,7 +116,8 @@ int is_hpet_enabled(void)
 static void hpet_reserve_platform_timers(unsigned long id)
 {
        struct hpet __iomem *hpet = hpet_virt_address;
-       unsigned int nrtimers;
+       struct hpet_timer __iomem *timer = &hpet->hpet_timers[2];
+       unsigned int nrtimers, i;
        struct hpet_data hd;
 
        nrtimers = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT) + 1;
@@ -134,10 +135,9 @@ static void hpet_reserve_platform_timers
        hd.hd_irq[0] = HPET_LEGACY_8254;
        hd.hd_irq[1] = HPET_LEGACY_RTC;
 
-       /*
-        * IRQs for the other timers are assigned dynamically
-        * in hpet_alloc
-        */
+       for (i = 2; i < nrtimers; timer++, i++)
+              hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
+                      Tn_INT_ROUTE_CNF_SHIFT;
        hpet_alloc(&hd);
 }
 #else
Index: linux-2.6/drivers/char/hpet.c
===================================================================
--- linux-2.6.orig/drivers/char/hpet.c
+++ linux-2.6/drivers/char/hpet.c
@@ -852,6 +852,12 @@ int hpet_alloc(struct hpet_data *hdp)
 
                timer = &hpet->hpet_timers[devp - hpetp->hp_dev];
 
+               /* Check if there's already an IRQ assigned to the timer */
+               if (hdp->hd_irq[i]) {
+                       hpetp->hp_dev[i].hd_hdwirq = hdp->hd_irq[i];
+                       continue;
+               }
+
                hpet_config = readq(&timer->hpet_config);
                irq_bitmap = (hpet_config & Tn_INT_ROUTE_CAP_MASK)
                        >> Tn_INT_ROUTE_CAP_SHIFT;
