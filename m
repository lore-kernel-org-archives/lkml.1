Return-Path: <linux-kernel-owner+w=401wt.eu-S1759846AbZDCGYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846AbZDCGYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 02:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZDCGYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 02:24:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:13881 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbZDCGYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 02:24:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="503242022"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 07:22:27 +0100
Subject: RE: [patch 04/18] x86, bts: wait until traced task has been
	scheduled out
Thread-Topic: [patch 04/18] x86, bts: wait until traced task has been
	scheduled out
Thread-Index: Acmzx7Z7MZTSkEP4SvOhJKY4RhnXpgAXIRig
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E92718054@irsmsx504.ger.corp.intel.com>
References: <20090402145455.597376000@intel.com>
 <20090402145709.422226000@intel.com> <20090402191730.GD843@elte.hu>
In-Reply-To: <20090402191730.GD843@elte.hu>
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
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Thursday, April 02, 2009 9:18 PM
>To: Metzger, Markus T
>Cc: tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
>eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel.com; linux-
>kernel@vger.kernel.org
>Subject: Re: [patch 04/18] x86, bts: wait until traced task has been scheduled out
>
>
>* markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
>
>> In order to stop branch tracing for a running task, we need to
>> first clear the branch tracing control bits before we may free the
>> tracing buffer. If the traced task is running, the cpu might still
>> trace that task after the branch trace control bits have cleared.
>>
>> Wait until the traced task has been scheduled out before
>> proceeding.
>>
>> A similar problem affects the task debug store context. We first
>> remove the context, then we need to wait until the task has been
>> scheduled out before we can free the context memory.
>>
>>
>> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
>> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
>> ---
>>  arch/x86/kernel/ds.c |   40 	40 +	0 -	0 !
>>  1 file changed, 40 insertions(+)
>>
>> Index: b/arch/x86/kernel/ds.c
>> ===================================================================
>> --- a/arch/x86/kernel/ds.c
>> +++ b/arch/x86/kernel/ds.c
>> @@ -250,6 +250,40 @@ static DEFINE_PER_CPU(struct ds_context
>>  #define system_context per_cpu(system_context_array, smp_processor_id())
>>
>>
>> +/*
>> + * Wait for the traced task to unschedule.
>> + *
>> + * This guarantees that the bts trace configuration has been
>> + * synchronized with the cpu executing the task.
>> + */
>> +static void wait_to_unschedule(struct task_struct *task)
>> +{
>
>this should be in sched.c and task_is_running() should not be
>exported from there.
>
>I.e. your original patch which i objected to is probably the right
>one, but should be named something like "task_wait_context_switch()"
>- which signals its purpose: that it is to wait for the task to
>context-switch at least once, so that its ptrace state is installed
>(or deinstalled) for sure.

OK.

I'll move it to sched.c.

In that case, I would use task_running() without holding the rq lock, since we
don't really care whether we read an old value or not.
Would that be OK with you?

thanks,
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

