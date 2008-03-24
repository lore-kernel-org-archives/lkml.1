Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYCXK0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYCXK0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 06:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYCXKZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 06:25:56 -0400
Received: from www.tglx.de ([62.245.132.106]:36903 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbYCXKZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 06:25:55 -0400
Date: Mon, 24 Mar 2008 11:24:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <crazy@frugalware.org>
cc: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47E6E85E.9030008@frugalware.org>
Message-ID: <alpine.LFD.1.00.0803241038420.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com> <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org>
 <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de>
 <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de> <47E50AF9.5070801@frugalware.org> <alpine.LFD.1.00.0803221441370.3781@apollo.tec.linutronix.de> <47E5221B.5040900@frugalware.org> <alpine.LFD.1.00.0803221730560.3781@apollo.tec.linutronix.de>
 <alpine.LFD.1.00.0803222113541.3781@apollo.tec.linutronix.de> <47E58B06.8020905@frugalware.org> <47E63851.7000702@frugalware.org> <47E6E85E.9030008@frugalware.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008, Gabriel C wrote:
> >>> Can you please give it a test ride ?
> >> Done , git head + Andi's patch + this version of your patch does work here.
> >>
> >> Also time-warp-test is just fine and everything else seems to work.
> > 
> > Also I've tested with my other motherboard and is fine too :)
> > 
> > Feel free to add my Tested-by when you push this patch.
> 
> Heh :/
> 
> ...
> 
> [ 5902.632878] Clocksource tsc unstable (delta = 4686687272 ns)
> [ 5920.650516] Time: acpi_pm clocksource has been installed.
> 
> ...
> 
> Seems like something still triggers that :/ 

Hmm. Can you please apply the patch below. It add some more info and
triggers the sysrq-q timer list printout when the watchdog
triggers. That might us give some insight into this.

Thanks,
	tglx

---
 kernel/time/clocksource.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/time/clocksource.c
===================================================================
--- linux-2.6.orig/kernel/time/clocksource.c
+++ linux-2.6/kernel/time/clocksource.c
@@ -87,8 +87,10 @@ static void clocksource_ratewd(struct cl
 	if (delta > -WATCHDOG_THRESHOLD && delta < WATCHDOG_THRESHOLD)
 		return;
 
-	printk(KERN_WARNING "Clocksource %s unstable (delta = %Ld ns)\n",
-	       cs->name, delta);
+	printk(KERN_WARNING
+	       "Clocksource %s unstable (delta = %Ld ns) E:%lu J:%lu\n",
+	       cs->name, delta, watchdog_timer.expires, jiffies);
+	sysrq_timer_list_show();
 	cs->flags &= ~(CLOCK_SOURCE_VALID_FOR_HRES | CLOCK_SOURCE_WATCHDOG);
 	clocksource_change_rating(cs, 0);
 	list_del(&cs->wd_list);
