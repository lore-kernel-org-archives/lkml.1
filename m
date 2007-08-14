Return-Path: <linux-kernel-owner+w=401wt.eu-S934783AbXHNT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbXHNT1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXHNT1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:27:08 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:54883 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758100AbXHNT1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:27:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=Nqh2w42uZ8G96HASXFj0xcVLo595tJ1uP2sMnemRAOh2tH5sNkLl9CgSxphnN393;
  h=Received:Message-ID:Reply-To:From:To:Cc:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE:X-ELNK-Trace:X-Originating-IP;
Message-ID: <000501c7dea9$3bfca1c0$6501a8c0@earthlink.net>
Reply-To: "Mitchell Erblich" <erblichs@earthlink.net>
From: "Mitchell Erblich" <erblichs@earthlink.net>
To: "\"Linux Kernel Mailing List\"" <linux-kernel@vger.kernel.org>
Cc: "\"Ingo Molnar\"" <mingo@elte.hu>,
       "\"\\\"Dmitry Adamushko\\\"\"" <dmitry.adamushko@gmail.com>
Subject: QUESTION: RT & SCHED & fork: ?MISSING EQUIV of task_new_fair for RT tasks.
Date: Tue, 14 Aug 2007 12:28:02 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1106
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79730e926b7c02cb502fba3827aea6b507350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 68.164.86.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Group, Ingo Molnar, etc,

Why does the rt sched_class contain fewer elements than fair?
missing is the RT for .task_new.

called by do_fork(): fork.c , which calls wake_up_new_task() via
if (!(clone_flags & CLONE_STOPPED))
      wake_up_new_task(p, clone_flags);

which is in sched.c and calls
if (!p->sched_class->task_new ||

       and
 p->sched_class->task_new(rq, p, now);


sched_rt.c:
static struct sched_class rt_sched_class __read_mostly = {
217         .enqueue_task           = enqueue_task_rt,
218         .dequeue_task           = dequeue_task_rt,
219         .yield_task             = yield_task_rt,
220 
221         .check_preempt_curr     = check_preempt_curr_rt,
222 
223         .pick_next_task         = pick_next_task_rt,
224         .put_prev_task          = put_prev_task_rt,
225 
226         .load_balance           = load_balance_rt,
227 
228         .task_tick              = task_tick_rt,
229 };


sched_fair.c:
struct sched_class fair_sched_class __read_mostly = {
1075         .enqueue_task           = enqueue_task_fair,
1076         .dequeue_task           = dequeue_task_fair,
1077         .yield_task             = yield_task_fair,
1078 
1079         .check_preempt_curr     = check_preempt_curr_fair,
1080 
1081         .pick_next_task         = pick_next_task_fair,
1082         .put_prev_task          = put_prev_task_fair,
1083 
1084         .load_balance           = load_balance_fair,
1085 
1086         .set_curr_task          = set_curr_task_fair,
1087         .task_tick              = task_tick_fair,
1088         .task_new               = task_new_fair,
1089 };
1090 

The missing rt equivalent item is:
/*
1014  * Share the fairness runtime between parent and child, thus the
1015  * total amount of pressure for CPU stays equal - new tasks
1016  * get a chance to run but frequent forkers are not allowed to
1017  * monopolize the CPU. Note: the parent runqueue is locked,
1018  * the child is not running yet.
1019  */
1020 static void task_new_fair(struct rq *rq, struct task_struct *p)
1021 {

Mitchell Erblich

