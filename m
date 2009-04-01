Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbZDAIKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbZDAIKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZDAIK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:10:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:29138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbZDAIKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:10:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,305,1235980800"; 
   d="scan'208";a="502563278"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Wed, 1 Apr 2009 09:09:54 +0100
Subject: RE: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Thread-Topic: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Thread-Index: AcmyX8GZv0e2kQRjQRK+G+a22DolTgAOVEhw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E926D5093@irsmsx504.ger.corp.intel.com>
References: <20090331145947.A12565@sedona.ch.intel.com>
 <20090401001729.GC28228@redhat.com>
In-Reply-To: <20090401001729.GC28228@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Wednesday, April 01, 2009 2:17 AM
>To: Metzger, Markus T


>> +static void wait_to_unschedule(struct task_struct *task)
>> +{
>> +	unsigned long nvcsw;
>> +	unsigned long nivcsw;
>> +
>> +	if (!task)
>> +		return;
>> +
>> +	if (task == current)
>> +		return;
>> +
>> +	nvcsw  = task->nvcsw;
>> +	nivcsw = task->nivcsw;
>> +	for (;;) {
>> +		if (!task_is_running(task))
>> +			break;
>> +		/*
>> +		 * The switch count is incremented before the actual
>> +		 * context switch. We thus wait for two switches to be
>> +		 * sure at least one completed.
>> +		 */
>> +		if ((task->nvcsw - nvcsw) > 1)
>> +			break;
>> +		if ((task->nivcsw - nivcsw) > 1)
>> +			break;
>> +
>> +		schedule();
>
>schedule() is a nop here. We can wait unpredictably long...

Hmmm, As far as I understand the code, rt-workqueues use a higher sched_class
and can thus not be preempted by normal threads. Non-rt workqueues
use the fair_sched_class. And schedule_work() uses a non-rt workqueue.

In practice, task is ptraced. It is either stopped or exiting.
I don't expect to loop very often.


>
>Ingo, do have have any ideas to improve this helper?
>
>Not that I really like it, but how about
>
>	int force_unschedule(struct task_struct *p)
>	{
>		struct rq *rq;
>		unsigned long flags;
>		int running;
>
>		rq = task_rq_lock(p, &flags);
>		running = task_running(rq, p);
>		task_rq_unlock(rq, &flags);
>
>		if (running)
>			wake_up_process(rq->migration_thread);
>
>		return running;
>	}
>
>which should be used instead of task_is_running() ?
>
>
>We can even do something like
>
>	void wait_to_unschedule(struct task_struct *task)
>	{
>		struct migration_req req;
>
>		rq = task_rq_lock(p, &task);
>		running = task_running(rq, p);
>		if (running) {
>			// make sure __migrate_task() will do nothing
>			req->dest_cpu = NR_CPUS + 1;
>			init_completion(&req->done);
>			list_add(&req->list, &rq->migration_queue);
>		}
>		task_rq_unlock(rq, &flags);
>
>		if (running) {
>			wake_up_process(rq->migration_thread);
>			wait_for_completion(&req.done);
>		}
>	}
>
>This way we don't poll, and we need only one helper.
>
>(Can't resist, this patch is not bisect friendly, without the next patches
> wait_to_unschedule() is called under write_lock_irq, this is deadlockable).

I know. See the reply to patch 0; I tried to keep the patches small and focused
to simplify the review work and attract reviewers.

thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

