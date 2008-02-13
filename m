Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbYBMMvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbYBMMvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYBMMvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:51:38 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbYBMMvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:51:37 -0500
Subject: Re: Regression in latest sched-git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: vatsa@linux.vnet.ibm.com
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080213030035.GA3402@linux.vnet.ibm.com>
References: <20080212185355.GA6320@linux.vnet.ibm.com>
	 <1202845208.6247.82.camel@lappy> <20080213030035.GA3402@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 13:51:18 +0100
Message-Id: <1202907078.20209.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 08:30 +0530, Srivatsa Vaddagiri wrote:
> On Tue, Feb 12, 2008 at 08:40:08PM +0100, Peter Zijlstra wrote:
> > Yes, latency isolation is the one thing I had to sacrifice in order to
> > get the normal latencies under control.
> 
> Hi Peter,
> 	I don't have easy solution in mind either to meet both fairness
> and latency goals in a acceptable way.

Ah, do be careful with 'fairness' here. The single RQ is fair wrt cpu
time, just not quite as 'fair' wrt to latency.

> But I am puzzled at the max latency numbers you have provided below:
> 
> > The problem with the old code is that under light load: a kernel make
> > -j2 as root, under an otherwise idle X session, generates latencies up
> > to 120ms on my UP laptop. (uid grouping; two active users: peter, root).
> 
> If it was just two active users, then max latency should be:
> 
> 	latency to schedule user entity (~10ms?) +
> 	latency to schedule task within that user 
> 
> 20-30 ms seems more reaonable max latency to expect in this scenario.
> 120ms seems abnormal, unless the user had large number of tasks.
> 
> On the same lines, I cant understand how we can be seeing 700ms latency
> (below) unless we had: large number of active groups/users and large number of 
> tasks within each group/user.

All I can say it that its trivial to reproduce these horrid latencies.

As for Ingo's setup, the worst that he does is run distcc with (32?)
instances on that machine - and I assume he has that user niced waay
down.

> > Others have reported latencies up to 300ms, and Ingo found a 700ms
> > latency on his machine.
> > 
> > The source for this problem is I think the vruntime driven wakeup
> > preemption (but I'm not quite sure). The other things that rely on
> > global vruntime are sleeper fairness and yield. Now while I can't
> > possibly care less about yield, the loss of sleeper fairness is somewhat
> > sad (NB. turning it off with the old group scheduling does improve life
> > somewhat).
> > 
> > So my first attempt at getting a global vruntime was flattening the
> > whole RQ structure, you can see that patch in sched.git (I really ought
> > to have posted that, will do so tomorrow).
> 
> We will do some exhaustive testing with this approach. My main concern
> with this is that it may compromise the level of isolation between two
> groups (imagine one group does a fork-bomb and how it would affect
> fairness for other groups).

Again, be careful with the fairness issue. CPU time should still be
fair, but yes, other groups might experience some latencies.



