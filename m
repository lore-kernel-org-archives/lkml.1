Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYAPGvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYAPGvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 01:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYAPGvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 01:51:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34361 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbYAPGvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 01:51:47 -0500
Date: Wed, 16 Jan 2008 07:51:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Balaji Rao <balajirrao@gmail.com>
Subject: Re: hpet_late_init hang
Message-ID: <20080116065133.GA26783@elte.hu>
References: <86802c440801151932o6aaea248w7d1137eaa2ac3579@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440801151932o6aaea248w7d1137eaa2ac3579@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Balaji Cc:-ed)

* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> "
> commit e5ed385fa0d6f35406e3e3ed75e5eb9adeb811df
> Author: Balaji Rao <balajirrao@gmail.com>
> Date:   Tue Jan 15 16:53:29 2008 +0100
> 
>     Assign IRQs to HPET Timers
> "
> in x86.git
> 
> cause my servers hang
> after
> Calling initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100()

i'm wondering, where does it hang exactly and why?

> after reverting that I got:
> 
> initcall 0xffffffff80b947d1 ran for 19 msecs: pci_iommu_init+0x0/0x13()
> Calling initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100()
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> initcall 0xffffffff80b9a465: hpet_late_init+0x0/0x100() returned 0.
> initcall 0xffffffff80b9a465 ran for 7 msecs: hpet_late_init+0x0/0x100()
> 
>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
>       CPU6       CPU7
>   0:         86          0          0          0          0          0
>          1          0   IO-APIC-edge      timer
>   4:          0          0          0          0          0          0
>          1        838   IO-APIC-edge      serial
>   7:          1          0          0          0          0          0
>          0          0   IO-APIC-edge
>   8:          0          0          0          0          0          0
>          0          0   IO-APIC-edge      rtc0
> 
> for mcp55, it should already route hpet to ioapic pin2 or the irq0.

hm, these new bits:

+       /* Assign IRQs statically for legacy devices */
+       hpetp->hp_dev[0].hd_hdwirq = hdp->hd_irq[0];
+       hpetp->hp_dev[1].hd_hdwirq = hdp->hd_irq[1];

seem to be different from where we came from:

-       for (i = 2; i < nrtimers; timer++, i++)
-               hd.hd_irq[i] = (timer->hpet_config & Tn_INT_ROUTE_CNF_MASK) >>
-                       Tn_INT_ROUTE_CNF_SHIFT;

	Ingo
