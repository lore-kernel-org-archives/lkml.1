Return-Path: <linux-kernel-owner+w=401wt.eu-S965621AbXC1SEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965621AbXC1SEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965626AbXC1SEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:04:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:36716 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965620AbXC1SET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:04:19 -0400
Date: Wed, 28 Mar 2007 20:04:57 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Maxim <maximlevitsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, pavel@suse.cz,
       linux-pm@lists.osdl.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, Jens Axboe <jens.axboe@oracle.com>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [3/6] 2.6.21-rc4: known regressions
Message-ID: <20070328180457.GA4253@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com>
	<1175065468.4017.1.camel@chaos>
	<200703281543.47049.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703281543.47049.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject    : first disk access after resume takes several minutes
>              ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
> References : http://lkml.org/lkml/2007/3/8/117
>              http://lkml.org/lkml/2007/3/25/20
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>

...

> Subject    : after resume: X hangs after drawing a couple of windows
> References : http://lkml.org/lkml/2007/3/8/117
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> Status     : unknown

...

> > > > From: Jeff Chua <jeff.chua.linux@gmail.com>
> > > > > It's related. I tested without CONFIG_HPET_TIMER, and now my X60 can
> > > > > suspend and resume from RAM (s2ram). Even better, it works
> > > > > with/without CONFIG_NO_HZ.
> 
> Quoting Maxim <maximlevitsky@gmail.com>:
> 
> Hi,
> 	I almost sure Iknow why this happens,
> 			The problem is that both hpet clock source
> 	and hpet clockevents doesn't have a suspend/resume function
> 	On resume we should enable the main counter _and_ enable
> 	legacy replacement mode, On my system main counter in
> 	enabled, by I think by bios, but legacy replacement mode is
> 	not, so if a system doesn't use lapic as a tick source, but
> 	use hpet+broadcast, it will hang for sure on resume, and i
> 	tested it
> 	
> 			The patch below is a temporally fix, until
> 	clock-events and clocksources will get proper suspend/resume
> 	hooks:
> 
> 		Regards,
> 			Maxim Levitsky

Bingo!

The patch below fixes the two problems (listed above) with
resume from RAM that I have observed on my T60 with
2.6.21-rc5: with this patch applied, and with CONFIG_NO_HZ
unset, date advances correctly, X functions properly and
there is no delay on first disk access.

Thanks very much.

---
> Add suspend/resume for HPET
> Signed-off-by: Maxim Levitsky <maximlevisky@gmail.com>

Maxim, do you plan to send this upstream?

Acked-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

---

diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index 0fd9fba..a1ec79e 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -152,6 +152,16 @@ static void hpet_set_mode(enum clock_event_mode mode,
 	unsigned long cfg, cmp, now;
 	uint64_t delta;
 
+
+	if ( mode != CLOCK_EVT_MODE_UNUSED && mode != CLOCK_EVT_MODE_SHUTDOWN)
+	{
+		unsigned long cfg = hpet_readl(HPET_CFG);
+		cfg |= HPET_CFG_ENABLE | HPET_CFG_LEGACY;
+		hpet_writel(cfg, HPET_CFG);
+		
+	}
+		
+
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;

-- 
MST
