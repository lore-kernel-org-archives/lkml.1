Return-Path: <linux-kernel-owner+w=401wt.eu-S1757589AbYCKVJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589AbYCKVJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYCKVIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:08:55 -0400
Received: from www.tglx.de ([62.245.132.106]:49887 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbYCKVIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:08:54 -0400
Date: Tue, 11 Mar 2008 22:08:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for
 pageattr-test.c
In-Reply-To: <20080311114832.GE18917@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803112128190.3781@apollo.tec.linutronix.de>
References: <20080311013014.GA28682@basil.nowhere.org> <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de> <20080311104531.GB18917@one.firstfloor.org> <alpine.LFD.1.00.0803111233440.3781@apollo.tec.linutronix.de>
 <20080311114832.GE18917@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Andi Kleen wrote:
> > > > > Use an own random generator for pageattr-test.c
> > > > > 
> > > > > [Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
> > > > > candidate because it fixes a subtle bug]
> > > > 
> > > > Care to point out which "subtle bug" is fixed ? 
> > > > 
> > > > You replace a random generator by another to get repeateable
> > > > sequences. The non repeatability of the cpa test patterns is hardly a
> > > > "subtle bug".
> > > 
> > > The subtle bug(s) are first that it is not repeatable (it really should),
> > 
> > As I said before. It's hardly a bug. In fact it is questionable
> > whether fully reproducible test patterns are desired.
> 
> Ok then you won't be able to repeat the test ever.
> 
> I consider this bad practice in test code because it makes it impossible
> to stabilize bugs

Test code with constant test patterns tend to miss the corner case
bugs, while random pattern test cases hit them assumed that there is a
broad enough tester base. 

It's a question of how you write such test code to achieve
reproducability. It's not rocket science to track the variables of a
test run and print them along with the printk, when a wrong state is
detected. That way you can inject them for reproduction.

> and when I wrote it I tried to avoid by using the 
> srandom32(). But I originally fell into the trap of assuming it had the 
> same semantics of stdlib srandom() which it didn't. This patch was
> my attempt to fix that mistake.

Well, I agree that you did not intend to code it that way, but calling
it a subtle bug, which needs to be fixed for .25, is just misleading.

> > > then that it only initializes the CPU where the code first runs
> > > (since srandom32 is per CPU) and later might change CPUs and then that it 
> > > adds totally unnecessary state bits to CPU #0 (or whatever runs first).
> > 
> > Can you please elaborate why changing the seed of the random generator
> > is a bug ? Networking reseeds the random generator itself, so what ?
> 
> It adds a non random seed which does not add any randomness only to CPU #0.
> Strictly it doesn't hurt very much, but it's also not useful for anything.

Exactly. Again it's not a subtle bug. It's useless code which does no
harm at all. We can safely dispose that in .26.

Thanks,

	tglx
