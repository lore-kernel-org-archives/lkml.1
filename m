Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYJ1UNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYJ1UNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 16:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYJ1UMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 16:12:53 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:39627 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751379AbYJ1UMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 16:12:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tiII1N2xPhYZbKMtJ0LyoM/ixT6cgAIzbTPrDROyrFVXYIK2Wnqlz+d/eVIJNAGxhP+HTUZDDWEI3EaPX8hGFXqDJgHs6zhP//GSsauL7rUAfXgvZCcFqQFAn9pBoETRQOkSkcxNTXxuT+DakSQqqTpjjHbjV0jSbSz+k9rRgck=  ;
X-YMail-OSG: yJAGEMkVM1n9vRir_stFarrsNb6o2VImd59l4ZR5olDvZof3geEJb1Djz_MTs1tODYwx4M_VpfDZdg8YLgTWZhYZnPGkGoAlrQzxt2JnELf7lHO8ddfMum1CJjV6H_TmK3Bu6jqmygv0Cg6bK_RtXex7CZcojA5XazbTj1GyDJZBhjHm4fxRM_.jZGJr
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
Date: Tue, 28 Oct 2008 12:41:24 -0700
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200810271426.27110.david-b@pacbell.net> <200810281022.42803.david-b@pacbell.net> <1225215416.15763.32.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1225215416.15763.32.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281241.25006.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008, Peter Zijlstra wrote:
> > > > Workaround: depend on LOCKDEP=n ... 
> > > 
> > > In all previous such cases it was deemed the IRQ handler should deal
> > > with whatever it gets.
> > 
> > In which case I'll wait until someone changes that IRQ handler (or that
> > ARM MM utility, or lockdep), and give up using AT91 platforms for sanity
> > testing kernel changes; lockdep is important, when it doesn't lie.
> > 
> > I do think that lockdep should warn when that it's ignoring such driver
> > requests, however.  I seem to have been tripping over it a lot lately,
> > and knowing that IRQ handlers were using strange modes would have saved
> > a bunch of time from being wasted.
> > 
> > Threaded IRQ handlers are going to need to rely even more on running
> > with IRQs enabled ... not to mention needing to sleep.  So it's clear
> > to me that there *are* lockdep issues yet to be addressed here.
> 
> Sure, care so send a patch fixing those? :-)

Here's one for the warning; that's the only one straightforward enough
to justify detouring from Real Work.  Plus, the IRQ threading patches
aren't that near a merge queue yet.  ;)

- Dave


========================== CUT HERE
From: David Brownell <dbrownell@users.sourceforge.net>

When lockdep turns on IRQF_DISABLED, emit a warning to make it
easier to track down problems this introduces in drivers that
expect handlers to run with IRQs enabled.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 kernel/irq/manage.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -681,7 +681,11 @@ int request_irq(unsigned int irq, irq_ha
 	/*
 	 * Lockdep wants atomic interrupt handlers:
 	 */
-	irqflags |= IRQF_DISABLED;
+	if (!(irqflags & IRQF_DISABLED)) {
+		pr_warning("IRQ %d/%s: lockdep sets IRQF_DISABLED\n",
+				irq, devname);
+		irqflags |= IRQF_DISABLED;
+	}
 #endif
 	/*
 	 * Sanity-check: shared interrupts must pass in a real dev-ID,
