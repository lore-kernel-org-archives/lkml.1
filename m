Return-Path: <linux-kernel-owner+w=401wt.eu-S934375AbYDVPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375AbYDVPbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763084AbYDVPaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:30:39 -0400
Received: from rn-out-0910.google.com ([64.233.170.186]:64965 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760252AbYDVPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n6i8b1GOcGL4KziJzVU3n7jV+X/XR+PuBa0PFnERsFgOkj5ZFf+Iul9hGN7Cp7ec9sYz01q0B0B9yZkOkvzNjDFYeHSI9BaEzXhlrmnZ9RR7WA080eoOxSGuSlHFIKoPtO7qI8HxaDiGSbQfqKfoCxUnZgi8RID/9Q70mTobPhs=
Message-ID: <b647ffbd0804220830h6524e788n1467b027bc5bc4d2@mail.gmail.com>
Date: Tue, 22 Apr 2008 17:30:35 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 1/2] sched: push rt tasks only if newly activated tasks have been added
Cc: mingo@elte.hu, suresh.b.siddha@intel.com, rostedt@goodmis.org,
       chinang.ma@intel.com, arjan@linux.intel.com, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20080421181015.4560.7658.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080421180747.4560.67794.stgit@novell1.haskins.net>
	 <20080421181015.4560.7658.stgit@novell1.haskins.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,


consider the following 2-cpu system: cpu0 and cpu1.

cpu0: is idle --> in such a state, it never pulls RT tasks on its own.

T0 and T1 are RT tasks


square#0:

cpu1:  T0 is running

T1 is of the same prio as T0 (shouldn't really matter but to get the
same result it would require altering the flow of events slightly)

T1's affinity allows it to be run only on cpu1.
T0 can run on both.

try_to_wake_up() is called for T1.
|
--> select_task_rq_rt() => gives cpu1
|
--> task_wake_up_rt()
   |
   ---> push_rt_tasks() -> rq->rt.pushed = 1

now, neither T1 (due to its affinity), nor T0 (it's running) can be
pushed away to cpu0.

[ btw., (1) I'd expect that this task_wake_up_rt() thing should be
redundant, logically-wise... I'll check once more and comment later
on.
(2) any example when (p->prio >= rq->rt.highest_prio) is not true in
task_wake_up_rt() ?
]

as a result, rq->rt.pushed == 1.

Now, post_schedule_rt() won't call push_rt_tasks().

T0 and T1 are both running for some time on cpu1 (possibly
context-switching if they are both of SCHED_RR type).

Then they both block, _first_ T1 and then T0.

After some interval of time, they wake up (let's say they are
periodic) in the following order: _first_ T0 and then T1.

rq->rt.pushed becomes 0 and here we are back to square#0. The whole
story repeats again.

cpu0 is idle so it won't pull T0. Both T0 and T1 are competing for the
same cpu. Not good.

am I missing smth?


-- 
Best regards,
Dmitry Adamushko
