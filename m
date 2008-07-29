Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYG2TXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYG2TXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYG2TXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:23:16 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:17438 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYG2TXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:23:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=j3IGsIhJXlY6kOFUNRzvODUSAtZNFaB4ZLjONgI43b2hJXKg3YlkfhEBiwg837W9qb
         mek5VbPkk6xzNefioteEyOG1i5zfLofuQq+xtDzcPuXh5xd+Z/5IqUzzywrODquDC+3M
         i8dzgEea+Zqi+xBwRhXEYald80ZxnOSoQvd8E=
Message-ID: <4b6fba110807291223g16ca0bf1o54c270efac409d45@mail.gmail.com>
Date: Tue, 29 Jul 2008 15:23:11 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: linux-kernel@vger.kernel.org
Subject: scheduling hrtimers while holding rq->lock
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ulrich Drepper" <drepper@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 9131e182517490cc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's the best way for scheduling code to start an hrtimer while
holding the rq->lock?  I am trying to implement SCHED_SPORADIC
(sporadic server) in the realtime scheduling class (rt_sched_class),
and it needs to schedule aperiodic, asynchronous replenishment
operations which are independent of timeslice expiration.  This is to
implement the functionality that when a SCHED_SPORADIC task blocks or
uses up its timeslice, one of these asynchronous events is scheduled
to happen at some time offset in the future that doesn't necessarily
correspond to any timeslice expiration.

Is there some way to schedule this event without duplicating the code
that the generic scheduler currently uses for its hrtick_timer?  As
in, is there a way to do this without adding a thread flag similar in
function to TIF_HRTICK_RESCHED and calling an rt_sched_class function
from do_notify_resume if the flag is set?

The code snippet below is what I am trying to do.

Please CC me explicitly in any replies.

Thanks,
-Daniel


-------------------------------------------------------------------------------------------

static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
{
   //(runqueue lock already held)
   //...
   ss_schedule_replenishment(p,rq);
   //...
}

static void ss_schedule_replenishment(struct task_struct *task, struct rq *rq) {
   //...
   hrtimer_start(&my_hrtimer, offset, HRTIMER_MODE_REL);
   //...
}

-------------------------------------------------------------------------------------------
