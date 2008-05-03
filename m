Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbYECWjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbYECWjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYECWjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:39:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55933 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbYECWjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:39:04 -0400
Date: Sun, 4 May 2008 00:38:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl, efault@gmx.de,
       elendil@planet.nl, parag.warudkar@gmail.com,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
Message-ID: <20080503223844.GA18344@elte.hu>
References: <20080503082849.GA29605@elte.hu> <20080503.020502.226847930.davem@davemloft.net> <20080503101016.GA18801@elte.hu> <20080503.122734.01023096.davem@davemloft.net> <1209853855.26383.28.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209853855.26383.28.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> On Sat, 2008-05-03 at 12:27 -0700, David Miller wrote:
> > > ( although please note that the growing generalization that goes on
> > >   _did_ find a subtle nohz problem on sparc64 early in the merge
> > window,
> > >   so it's not like these changes are totally useless to you. )
> > 
> > Note that this bug theoretically exists on every platform, even x86, 
> > and only sparc64 is fixed at the moment by adding the 
> > irq_{entry,exit}() guards around all of it's IPI handlers.
> 
> What is the bug ?
> 
> IPIs on power are normal interrupts, so they do happen in 
> irq_entry/exit blocks but I'm curious to know what the root bug is :-)

on nohz we still keep jiffies uptodate - despite there not being an 
explicit 'keep jiffies uptodate' tick interrupt anymore. So on every 
irq_enter() we roll jiffies forward - if needed - and thus emulate 
jiffies behavior to drivers and core kernel code, etc.

if an IPI on Power does not do an irq_enter() then you might miss out on 
updated jiffies. That might not matter for most jiffies, but you might 
also miss out on the 'touch the softlockup watchdog because we just woke 
from idle' action. This is what triggered the false positive warnings on 
Sparc64.

the same bug existed on x86 too: that too does a few IPIs without 
irq_enter/irq_exit. We now removed the softlockup dependency so it 
should not be required to do an irq_enter()/exit anymore - unless the 
code that the IPI uses accesses jiffies. (but that would be unusual)

	Ingo
