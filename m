Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbYDWO3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbYDWO3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYDWO30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:29:26 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:31523 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYDWO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mQ1xia2/LyjHTxOB1yn7GtckkBPyzj+4jtJ/7tOBJVVOU40nU6NVtDds52+ucv3NgCYfW0FEV0gpOY7p8WkYagmrqi743iaY5XSBz3WqBjgsMeIHrv62DqjcjEoXYjpJNjF4vZNNzd30VFKWHgdh8GfsRq/uwDghn/EehHX70Jk=
Message-ID: <b647ffbd0804230729x70966c0ak91b8f6638282a443@mail.gmail.com>
Date: Wed, 23 Apr 2008 16:29:23 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: Re: [PATCH 1/2] sched: fix RT task-wakeup logic
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20080423111329.4981.88455.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080423111313.4981.37345.stgit@novell1.haskins.net>
	 <20080423111329.4981.88455.stgit@novell1.haskins.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/23 Gregory Haskins <ghaskins@novell.com>:
> Dmitry Adamushko pointed out a logic error in task_wake_up_rt() where we
>  will always evaluate to "true".  You can find the thread here:
>
>  http://lkml.org/lkml/2008/4/22/296
>
>  In reality, we only want to try to push tasks away when a wake up request is
>  not going to preempt the current task.  So lets fix it.
>
>  Note: We introduce test_tsk_need_resched() instead of open-coding the flag
>  check so that the merge-conflict with -rt should help remind us that we
>  may need to support NEEDS_RESCHED_DELAYED in the future, too.
>
>  Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>  CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>

Acked-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


I have to look at the second patch more thoroughly... but I guess,
we'd be better off opting for something more simple/less complex (it
looks a bit heavy at the first glance).

This patch already fixes an 'obvious' problem in task_wake_up_rt() and
narrows down the scope of the original problem.

For the original scenario (as well as for its variants with SCHED_FIFO
and != priorities) push_rt_tasks() is 'delayed' untill a reschedule
(which is already pending and should take place shortly... provided
'bounded/short' latencies :-)

For T0,T1 having equal prios + SCHED_RR, T1 (which can't be migrated
due to its affinity) will wait till T0's timeslice expires
and for SCHED_FIFO -- till T0 releases a CPU.

The 'optimal' way would be moving T0 immediatelly off this cpu.


-- 
Best regards,
Dmitry Adamushko
