Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYGAKqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYGAKqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 06:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYGAKqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 06:46:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:42027 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYGAKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 06:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fBAYFnFczyafqZ9Z7cf2tla4QshoFNbNlaGoefDuR3heYyASWJU8PSJcaUiWJprWPC
         yC4FAdIzkgb/fiBS1I5A0yXggjci850RUhstIyFL3QniGCx2hwMv/X3chdG7tA996F1J
         ccqE78ZZ6ePsXU8DLk5edlZzxw6A6vHHJSSXM=
Message-ID: <b647ffbd0807010346l2833f376y4c394bcbf49fa086@mail.gmail.com>
Date: Tue, 1 Jul 2008 12:46:20 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratable tasks over migratable ones"
Cc: "Gregory Haskins" <ghaskins@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1213643862.16944.142.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213138710.26530.51.camel@earth> <1213174382.31518.69.camel@twins>
	 <b647ffbd0806110305p2be38608iadc1d2e91e3be57a@mail.gmail.com>
	 <48563FDB.BA47.005A.0@novell.com>
	 <b647ffbd0806161059q7048ea40id0f4235ab19d6ca0@mail.gmail.com>
	 <1213643862.16944.142.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/16 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Mon, 2008-06-16 at 19:59 +0200, Dmitry Adamushko wrote:
>
>> One way or another, we have different aritifacts (and mine have likely
>> more) but conceptually, both "violates" POSIX if a strict round-robin
>> scheduling is required.
>
> http://www.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_08.html#tag_02_08_04_01
>
> Is quite strict on what FIFO should do, and I know of two points where
> we deviate and should work to match.
>


btw., rt group scheduling seems to well, slightly wreck this (per-rq)
FIFO model as well.

say, group_A has N SCHED_FIFO tasks of equal prio. So far so good,
they all run strictly one after another.

Now group_B gets task_S. On a group layer, group_B gets enqueued after group_A.

This changes when a current task (that belongs to group_A)
relinquishes a CPU: dequeue_stack -> __enqueue_rt_entity() will place
group_A in the tail of its list.

So the next task to run is task_S, although group_A migth have plenty
of tasks of the same prio that were enqueued ealrier.

We can't get a strict FIFO ordering with this pure tree-like hierarchy.


btw #2,

Gregory, our new modification also doesn't work nicely with group-scheduling.

We may place a task in the head of its queue, yes. But its group will
still remain where it was.

rt_se->nr_cpus_allowed just has no adequat sense for groups and
__enqueue_rt_entity() always places a group at the tail.

IOW, even if check_preempt_curr_rt() calls resched_task() based on
analysis of the newly arrived task 'p', 'p' won't be necessarily
picked up by pick_next_task_rt(). Although, there is a way to fix it.


-- 
Best regards,
Dmitry Adamushko
