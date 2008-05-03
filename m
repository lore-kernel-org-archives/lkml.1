Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYECXir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYECXir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbYECXik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:38:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40075 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbYECXij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:38:39 -0400
Date: Sun, 4 May 2008 01:38:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       elendil@planet.nl, parag.warudkar@gmail.com,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
Message-ID: <20080503233825.GB30600@elte.hu>
References: <1209853855.26383.28.camel@pasglop> <20080503223844.GA18344@elte.hu> <20080503.160408.238581868.davem@davemloft.net> <20080503.163600.93588714.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503.163600.93588714.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Sat, 03 May 2008 16:04:08 -0700 (PDT)
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Sun, 4 May 2008 00:38:44 +0200
> > 
> > > the same bug existed on x86 too: that too does a few IPIs without 
> > > irq_enter/irq_exit. We now removed the softlockup dependency so it 
> > > should not be required to do an irq_enter()/exit anymore - unless the 
> > > code that the IPI uses accesses jiffies. (but that would be unusual)
> > 
> > That move doesn't solve the problem, I'm strongly certain
> > arch's still need to add the irq_{enter,exit}().
> > 
> > I'll revert the irq_{enter,exit}() changes on one of my
> > sparc64 boxes to validate this later today.
> 
> False alarm, which is good news, thanks Ingo.  I can revert the 
> following it seems:
> 
> commit 2664ef44cf5053d2b7dff01cecac70bc601a5f68
> Author: David S. Miller <davem@davemloft.net>
> Date:   Fri Apr 25 03:11:37 2008 -0700
> 
>     [SPARC64]: Wrap SMP IPIs with irq_enter()/irq_exit().

ah, good! It really looks like unnecessary overhead for the "simple 
IPIs". But ... i'm wondering ... what about softirq processing? Do these 
IPIs process softirqs on the way out? In that case the non-processed 
jiffies might be a problem.

it's all a bit messy. I wish we could start turning jiffies into a 
function (which would just read GTOD and estimate jiffies from there), 
but i fear we are not there yet ...

	Ingo
