Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZILWHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZILWHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 18:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbZILWHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 18:07:10 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22470 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZILWHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 18:07:09 -0400
Date: Sun, 13 Sep 2009 00:07:11 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ingo Molnar <mingo@elte.hu>
cc: Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [GIT PULL] sched/core for v2.6.32
In-Reply-To: <20090912054917.GB9420@elte.hu>
Message-ID: <alpine.LNX.2.00.0909122354260.23341@swampdragon.chaosbits.net>
References: <20090911192505.GA20006@elte.hu> <alpine.LNX.2.00.0909120032270.31018@swampdragon.chaosbits.net> <alpine.LFD.2.01.0909111546050.3654@localhost.localdomain> <alpine.LNX.2.00.0909120119190.31018@swampdragon.chaosbits.net>
 <12c511ca0909111924s42d000dsbf378009d9434ddc@mail.gmail.com> <20090912054917.GB9420@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Sep 2009, Ingo Molnar wrote:

> 
> * Tony Luck <tony.luck@intel.com> wrote:
> 
> > On Fri, Sep 11, 2009 at 4:34 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > > That may be so; but most people I've ever talked to about multiple
> > > processes, fork, vfork and the like, have mostly assumed child-runs-first.
> > > That is just my personal experience.
> > > So I get worried when that assumption is made false.
> > 
> > With multi-core cpus becoming (being?) the norm, almost all 
> > systems are SMP now.  So child and parent can surely end up 
> > running in parallel very often.  So applications that make 
> > assumptions about child running first are going to be frequently 
> > surprised.  Aren't they?
> 
> We had parent-runs-first briefly, in v2.6.23 - this got changed by 
> v2.6.24 - but yes, it did trigger at least one app bug that i 
> remember (dont remember which one it was though).
> 
> We are almost two years later now - maybe it works fine now.
> 
> In any case, as a precaution i made the sched_child_runs_first 
> sysctl knob unconditional (previously it was under 
> CONFIG_SCHED_DEBUG).
> 
> So if an old distro is upgraded with a new kernel (and user-space is 
> not updated), it can be worked around by putting this into 
> /etc/sysctl.conf:
> 
>     kernel.sched_child_runs_first = 1
> 

Always goo to have a workaround if something unexpectedly breaks. Makes 
perfect sense for that knob to now be unconditional - and with it, 
changing the behaviour is a much less risky operation. Glad to have it.

> You are right to suggest that due to SMP and due to the general 
> non-determinism of preemption we _never_ made any 'promise' to run 
> the child first.
> 
> It was a statistical property based on performance considerations - 
> and now we flipped it around based on latency and for kbuild 
> performance/throughput reasons: Serge Belyshev reported a 7% 
> increase on a quad due to this change and i measured a 1.5% 
> peak-kbuild performance increase.
> 
Impressive. I wouldn't have expected that much gain by running the parent 
first. Actually I personally would have expected child-first to perform 
better since (in my experience) it's usually the child that's just forked 
that matters the most. A server process that spawns a child to service a 
request wants the child to run asap and process that forks, then execs 
cares primarily about the child.

> So it's worth it for multiple reasons and even in the worst-case 
> problems can be worked around easily and without rebooting the 
> system.
> 
Perfect :-)


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

