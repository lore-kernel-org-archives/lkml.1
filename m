Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYGOMsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYGOMsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759492AbYGOMsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:48:04 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:63971 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760667AbYGOMsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:48:02 -0400
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable
	tasks over migratable ones"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0807010346l2833f376y4c394bcbf49fa086@mail.gmail.com>
References: <1213138710.26530.51.camel@earth>
	 <1213174382.31518.69.camel@twins>
	 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
	 <48563FDB.BA47.005A.0@novell.com>
	 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
	 <1213643862.16944.142.camel@twins>
	 <b647ffbd0807010346l2833f376y4c394bcbf49fa086@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 14:48:26 +0200
Message-Id: <1216126106.12595.180.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 12:46 +0200, Dmitry Adamushko wrote:
> 2008/6/16 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:
> >
> >> One way or another, we have different aritifacts (and mine have likely
> >> more) but conceptually, both "violates" POSIX if a strict round-robin
> >> scheduling is required.
> >
> > http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#tag_02_08_04_01
> >
> > Is quite strict on what FIFO should do, and I know of two points where
> > we deviate and should work to match.
> >
> 
> 
> btw., rt group scheduling seems to well, slightly wreck this (per-rq)
> FIFO model as well.
> 
> say, group_A has N SCHED_FIFO tasks of equal prio. So far so good,
> they all run strictly one after another.
> 
> Now group_B gets task_S. On a group layer, group_B gets enqueued after group_A.
> 
> This changes when a current task (that belongs to group_A)
> relinquishes a CPU: dequeue_stack -> __enqueue_rt_entity() will place
> group_A in the tail of its list.
> 
> So the next task to run is task_S, although group_A migth have plenty
> of tasks of the same prio that were enqueued ealrier.
> 
> We can't get a strict FIFO ordering with this pure tree-like hierarchy.
> 
> 
> btw #2,
> 
> Gregory, our new modification also doesn't work nicely with group-scheduling.
> 
> We may place a task in the head of its queue, yes. But its group will
> still remain where it was.
> 
> rt_se->nr_cpus_allowed just has no adequat sense for groups and
> __enqueue_rt_entity() always places a group at the tail.
> 
> IOW, even if check_preempt_curr_rt() calls resched_task() based on
> analysis of the newly arrived task 'p', 'p' won't be necessarily
> picked up by pick_next_task_rt(). Although, there is a way to fix it.


Yeah, I realized this quite a while back, but 1) posix doesn't say
anything about group scheduling like this, and 2) all the rt group
scheduling stuff is still experimental :-)

I'm open to suggestion though.

