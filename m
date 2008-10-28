Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYJ1Rb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYJ1Rb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYJ1RbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:31:14 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:20256 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753021AbYJ1RbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:31:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BDnbSSYKVp8R2YcMIAuhftcjnOwO/CzYPYaQi4Sk4jhC6SXmm/U9njHIT16YAo/U7WPrbzz1eLqi2knc1JfUwLawhqgt6VmSJUBOjgJ1HbV0TFeZM8DaOOfmX2eq0hGI7RugZglv6pYt8i7AiEmCogwPvRPVL2i8ly0eIUWRX7s=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
Date: Tue, 28 Oct 2008 10:22:42 -0700
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200810271426.27110.david-b@pacbell.net> <1225213442.15763.20.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1225213442.15763.20.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810281022.42803.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008, Peter Zijlstra wrote:
> On Mon, 2008-10-27 at 14:26 -0700, David Brownell wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Lockdep reported a problem in the at91_mci driver ... in this case, the
> > issue is with lockdep, not with the driver. ...
> > 
> > When __flush_dcache_aliases() returns -- inlined into flush_dcache_page(),
> > above -- it re-enables IRQs ... since that evidently may only be called with
> > IRQs enabled.  That's OK since the (unshared) IRQ handler doesn't ask for IRQs
> > to be disabled.   Except ... that lockdep went and disabled them, then went on
> > to complains about the breakage *it* caused!
> > 
> > Workaround: depend on LOCKDEP=n ... 
> 
> In all previous such cases it was deemed the IRQ handler should deal
> with whatever it gets.

In which case I'll wait until someone changes that IRQ handler (or that
ARM MM utility, or lockdep), and give up using AT91 platforms for sanity
testing kernel changes; lockdep is important, when it doesn't lie.

I do think that lockdep should warn when that it's ignoring such driver
requests, however.  I seem to have been tripping over it a lot lately,
and knowing that IRQ handlers were using strange modes would have saved
a bunch of time from being wasted.

Threaded IRQ handlers are going to need to rely even more on running
with IRQs enabled ... not to mention needing to sleep.  So it's clear
to me that there *are* lockdep issues yet to be adressed here.

- Dave

