Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbZC3HZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbZC3HZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZC3HYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:24:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:38007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZC3HYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:24:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="398608464"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>,
       Markus Metzger <markus.t.metzger@googlemail.com>
CC: "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Mar 2009 08:24:01 +0100
Subject: RE: [rfc] x86, bts: fix crash
Thread-Topic: [rfc] x86, bts: fix crash
Thread-Index: AcmvI6U4PpqZaExDT6u3n/ie5jVDDgB4RT6Q
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266B8F1@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com>
 <20090326015801.GA451@redhat.com>
 <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com>
 <20090327165038.GA25762@redhat.com> <1238175204.6077.18.camel@raistlin>
 <20090327212933.GA5325@redhat.com>
In-Reply-To: <20090327212933.GA5325@redhat.com>
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
>Sent: Friday, March 27, 2009 10:30 PM
>To: Markus Metzger


>> Regarding the race on task->thread.ds_ctx between ds_release_bts() and
>> ds_switch_to(), how would I prevent a task from being rescheduled for
>> a small amount of time?
>
>I don't see how we can do this. We can split wait_task_inactive() into
>2 functions, the first one returns with task_rq_lock() held and interrupts
>disabled. But this is nasty, and in any case wait_task_inactive(p) can't
>force "p" to be deactivated.
>
>Can't we do something different?
>
>For simplicity, let's suppose that we have only task_struct->bts and it
>is just a blob of memory which can be used by CPU somehow.
>
>First, we add "struct rcu_head" into task_struct->bts, and then
>
>	void free_bts((struct rcu_head *rcu)
>	{
>		struct bts_tracer *bts = container_of();
>		...
>		kfree(bts);
>	}
>
>	void ds_release_bts(struct bts_tracer *tracer)
>	{
>		struct task_struct *child = tracer->ds.context->task;
>		struct bts_tracer *bts = child->bts;
>
>		child->bts = NULL;
>
>		// make sure child will NOT use ->bts
>		// after the next context switch,
>		// clear TIF_DS_AREA_MSR or something
>		...

But that's exactly the problem if the bts_tracer is released by another
task (!= current).
We first need to disable tracing by clearing bits in debugctlmsr.
Then, we can set ->bts to NULL and clear TIF_DS_AREA_MSR.

If the traced task is currently in a context switch, clearing debugctlmsr bits
might come too late. We need to wait for the next context switch until we can
clear TIF_DS_AREA_MSR.


The benefit would be that I don't need to hook into do_exit() anymore.
This would rid us of the nasty ->ptraced loop.
I will give it a try.


I use something like this to wait for the context switch:
  nvcsw = task->nvcsw + 1;
  nivcsw = task->nivcsw + 1;
  for (;;) {
	if (nvcsw < task->nvcsw)
		break;
	if (nivcsw < task->nivcsw)
		break;
	if (task->state != TASK_RUNNING)
		break;
  }

I would need to check for overflows, but for my examples, I don't expect any.


regards,
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

