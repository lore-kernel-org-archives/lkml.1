Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXC1SnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXC1SnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965626AbXC1SnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:43:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46509 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965645AbXC1SnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:43:13 -0400
Date: Wed, 28 Mar 2007 11:35:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Maxim <maximlevitsky@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-Id: <20070328113555.c17bc1da.randy.dunlap@oracle.com>
In-Reply-To: <20070328180457.GA4253@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<b6a2187b0703261046r46782eedv64464ceddb44bc27@mail.gmail.com>
	<1175065468.4017.1.camel@chaos>
	<200703281543.47049.maximlevitsky@gmail.com>
	<20070328180457.GA4253@mellanox.co.il>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 20:04:57 +0200 Michael S. Tsirkin wrote:

> > Subject    : first disk access after resume takes several minutes
> >              ('date' does not advance after resume from RAM, CONFIG_NO_HZ=n)
> > References : http://lkml.org/lkml/2007/3/8/117
> >              http://lkml.org/lkml/2007/3/25/20
> > Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> 
> ...
> 
> > Subject    : after resume: X hangs after drawing a couple of windows
> > References : http://lkml.org/lkml/2007/3/8/117
> > Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> > Status     : unknown
> 
> ...
> 
> > > > > From: Jeff Chua <jeff.chua.linux@gmail.com>
> > > > > > It's related. I tested without CONFIG_HPET_TIMER, and now my X60 can
> > > > > > suspend and resume from RAM (s2ram). Even better, it works
> > > > > > with/without CONFIG_NO_HZ.
> > 
> > Quoting Maxim <maximlevitsky@gmail.com>:
> > 
> > Hi,
> > 	I almost sure Iknow why this happens,
> > 			The problem is that both hpet clock source
> > 	and hpet clockevents doesn't have a suspend/resume function
> > 	On resume we should enable the main counter _and_ enable
> > 	legacy replacement mode, On my system main counter in
> > 	enabled, by I think by bios, but legacy replacement mode is
> > 	not, so if a system doesn't use lapic as a tick source, but
> > 	use hpet+broadcast, it will hang for sure on resume, and i
> > 	tested it
> > 	
> > 			The patch below is a temporally fix, until
> > 	clock-events and clocksources will get proper suspend/resume
> > 	hooks:
> > 
> > 		Regards,
> > 			Maxim Levitsky
> 
> Bingo!
> 
> The patch below fixes the two problems (listed above) with
> resume from RAM that I have observed on my T60 with
> 2.6.21-rc5: with this patch applied, and with CONFIG_NO_HZ
> unset, date advances correctly, X functions properly and
> there is no delay on first disk access.
> 
> Thanks very much.
> 
> ---
> > Add suspend/resume for HPET
> > Signed-off-by: Maxim Levitsky <maximlevisky@gmail.com>
> 
> Maxim, do you plan to send this upstream?

with whitespace fixes, please...


> Acked-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
> 
> ---
> 
> diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
> index 0fd9fba..a1ec79e 100644
> --- a/arch/i386/kernel/hpet.c
> +++ b/arch/i386/kernel/hpet.c
> @@ -152,6 +152,16 @@ static void hpet_set_mode(enum clock_event_mode mode,
>  	unsigned long cfg, cmp, now;
>  	uint64_t delta;
>  
> +
> +	if ( mode != CLOCK_EVT_MODE_UNUSED && mode != CLOCK_EVT_MODE_SHUTDOWN)
> +	{

	if (mode != CLOCK_EVT_MODE_UNUSED && mode != CLOCK_EVT_MODE_SHUTDOWN) {

> +		unsigned long cfg = hpet_readl(HPET_CFG);
> +		cfg |= HPET_CFG_ENABLE | HPET_CFG_LEGACY;
> +		hpet_writel(cfg, HPET_CFG);
> +		

delete above line.

> +	}
> +		
> +
>  	switch(mode) {
>  	case CLOCK_EVT_MODE_PERIODIC:
>  		delta = ((uint64_t)(NSEC_PER_SEC/HZ)) * hpet_clockevent.mult;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
