Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZILFtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZILFtX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 01:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZILFtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 01:49:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZILFtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 01:49:22 -0400
Date: Sat, 12 Sep 2009 07:49:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: Jesper Juhl <jj@chaosbits.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [GIT PULL] sched/core for v2.6.32
Message-ID: <20090912054917.GB9420@elte.hu>
References: <20090911192505.GA20006@elte.hu> <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net> <alpine.LFD.2.01.0909111546050.3654@localhost.localdomain> <alpine.LNX.2.00.0909120119190.31018@swampdragon.chaosbits.net> <12c511ca0909111924s42d000dsbf378009d9434ddc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12c511ca0909111924s42d000dsbf378009d9434ddc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> On Fri, Sep 11, 2009 at 4:34 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > That may be so; but most people I've ever talked to about multiple
> > processes, fork, vfork and the like, have mostly assumed child-runs-first.
> > That is just my personal experience.
> > So I get worried when that assumption is made false.
> 
> With multi-core cpus becoming (being?) the norm, almost all 
> systems are SMP now.  So child and parent can surely end up 
> running in parallel very often.  So applications that make 
> assumptions about child running first are going to be frequently 
> surprised.  Aren't they?

We had parent-runs-first briefly, in v2.6.23 - this got changed by 
v2.6.24 - but yes, it did trigger at least one app bug that i 
remember (dont remember which one it was though).

We are almost two years later now - maybe it works fine now.

In any case, as a precaution i made the sched_child_runs_first 
sysctl knob unconditional (previously it was under 
CONFIG_SCHED_DEBUG).

So if an old distro is upgraded with a new kernel (and user-space is 
not updated), it can be worked around by putting this into 
/etc/sysctl.conf:

    kernel.sched_child_runs_first = 1

You are right to suggest that due to SMP and due to the general 
non-determinism of preemption we _never_ made any 'promise' to run 
the child first.

It was a statistical property based on performance considerations - 
and now we flipped it around based on latency and for kbuild 
performance/throughput reasons: Serge Belyshev reported a 7% 
increase on a quad due to this change and i measured a 1.5% 
peak-kbuild performance increase.

So it's worth it for multiple reasons and even in the worst-case 
problems can be worked around easily and without rebooting the 
system.

	Ingo
