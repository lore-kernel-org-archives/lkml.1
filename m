Return-Path: <linux-kernel-owner+w=401wt.eu-S1763917AbYBLTkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763917AbYBLTkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763099AbYBLTkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:40:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762978AbYBLTk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:40:28 -0500
Subject: Re: Regression in latest sched-git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080212185355.GA6320@linux.vnet.ibm.com>
References: <20080212185355.GA6320@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 20:40:08 +0100
Message-Id: <1202845208.6247.82.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 00:23 +0530, Dhaval Giani wrote:
> Hi Ingo,
> 
> I've been running the latest sched-git through some tests. Here is
> essentially what I am doing,
> 
> 1. Mount the control group
> 2. Create 3-4 groups
> 3. Start kernbench inside each group
> 4. Run cpu hogs in each group
> 
> Essentially the idea is to see how the system responds under extreme CPU
> load.

> This is what I get (and this is in a shell which belongs to the root
> group)
> [root@llm11 ~]# time sleep 1
> 
> real    0m1.212s
> user    0m0.004s
> sys     0m0.000s

> On the sched-devel tree that I have, the same gives me following
> results.
> 
> [root@llm11 ~]# time sleep 1
> 
> real    0m1.057s
> user    0m0.000s
> sys     0m0.004s

Yes, latency isolation is the one thing I had to sacrifice in order to
get the normal latencies under control.

The problem with the old code is that under light load: a kernel make
-j2 as root, under an otherwise idle X session, generates latencies up
to 120ms on my UP laptop. (uid grouping; two active users: peter, root).

Others have reported latencies up to 300ms, and Ingo found a 700ms
latency on his machine.

The source for this problem is I think the vruntime driven wakeup
preemption (but I'm not quite sure). The other things that rely on
global vruntime are sleeper fairness and yield. Now while I can't
possibly care less about yield, the loss of sleeper fairness is somewhat
sad (NB. turning it off with the old group scheduling does improve life
somewhat).

So my first attempt at getting a global vruntime was flattening the
whole RQ structure, you can see that patch in sched.git (I really ought
to have posted that, will do so tomorrow).

With the experience gained from doing that, I think it might be possible
to construct a hierarchical RQ model that has synced vruntime; but
thinking about that still makes my head hurt.

Anyway, yes, its not ideal, but it does the more common case of light
load much better - I basically had to tell people to disable
CONFIG_FAIR_GROUP_SCHED in order to use their computer, which is sad,
because its the default and we want it to be the default in the cgroup
future.

So yes, I share your concern, lets work on this together.

