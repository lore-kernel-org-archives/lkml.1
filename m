Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZC0PBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZC0PBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 11:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZC0PBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 11:01:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:20575 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZC0PB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 11:01:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,432,1233561600"; 
   d="scan'208";a="501342630"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "Kleen, Andi" <andi.kleen@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>
Date: Fri, 27 Mar 2009 15:01:14 +0000
Subject: RE: [rfc] x86, bts: fix crash
Thread-Topic: [rfc] x86, bts: fix crash
Thread-Index: AcmttsWCvVKtxb+lS8Wk08NtkOjzZABLMK4Q
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E9266B699@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77E9260843D@irsmsx504.ger.corp.intel.com>
 <20090326015801.GA451@redhat.com>
In-Reply-To: <20090326015801.GA451@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: C0nz GM8X IfLk Je/b MZjx N/dZ ROwX Rk4K WTmi WVDG Xyhn
 Z+7O gBGG kKLt mAAL
 pRO5;5;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AYQByAGsAdQBzAC4AdAAuAG0AZQB0AHoAZwBlAHIAQABnAG0AYQBpAGwALgBjAG8AbQA7AG0AaQBuAGcAbwBAAGUAbAB0AGUALgBoAHUAOwBvAGwAZQBnAEAAcgBlAGQAaABhAHQALgBjAG8AbQA7AHIAbwBsAGEAbgBkAEAAcgBlAGQAaABhAHQALgBjAG8AbQA=;Sosha1_v1;7;{F7D3CDF4-5998-44B6-8A2D-BABBFE91E244};bQBhAHIAawB1AHMALgB0AC4AbQBlAHQAegBnAGUAcgBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Fri,
 27 Mar 2009 15:01:14
 GMT;UgBFADoAIABbAHIAZgBjAF0AIAB4ADgANgAsACAAYgB0AHMAOgAgAGYAaQB4ACAAYwByAGEAcwBoAA==
x-cr-puzzleid: {F7D3CDF4-5998-44B6-8A2D-BABBFE91E244}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Oleg Nesterov [mailto:oleg@redhat.com]
>Sent: Thursday, March 26, 2009 2:58 AM
>To: Metzger, Markus T


>Metzger, let's move this discussion to lkml, I also cc'ed Roland.
>Imho, this problem (which I don't fully understand ;) needs more
>eyes.

Oleg,

I just found your reply in my spam folder;-)


>> +static void ptrace_bts_exit_tracer(void)
>>  {
>> +	struct task_struct *child, *n;
>> +
>>  	/*
>> -	 * Ptrace_detach() races with ptrace_untrace() in case
>> -	 * the child dies and is reaped by another thread.
>> +	 * We must not hold the tasklist_lock when we release the bts
>> +	 * tracer, since we need to make sure the cpu executing the
>> +	 * tracee stops tracing before we may free the trace buffer.
>>  	 *
>> -	 * We only do the memory accounting at this point and
>> -	 * leave the buffer deallocation and the bts tracer
>> -	 * release to ptrace_bts_untrace() which will be called
>> -	 * later on with tasklist_lock held.
>> +	 * read_lock(&tasklist_lock) and smp_call_function() may
>> +	 * deadlock with write_lock_irq(&tasklist_lock).
>> +	 *
>> +	 * As long as we're the only one modifying our list of traced
>> +	 * children, we should be safe, since we're currently busy.
>>  	 */
>> -	release_locked_buffer(child->bts_buffer, child->bts_size);
>> +	list_for_each_entry_safe(child, n, &current->ptraced, ptrace_entry) {
>
>It is not safe to iterate over current->ptraced lockless, the comment
>is not right. Anoter subthread can reap the dead tracee, or at least
>do ptrace_unlink() if the tracee is not the child of our thread group.


I meanwhile changed that to read_lock(&tasklist_lock) around the iteration.
I temporarily drop the lock in the loop body.
After retaking the lock, I check whether next is still child->next.
If not, I start over again.

Individual adds or removes should not be able to break this. We could break it
if we split the list, but I'm not aware of such an operation on the list of
ptraced children.


>> +static void ptrace_bts_exit_tracee(void)
>> +{
>> +	struct mm_struct *mm = NULL;
>> +
>> +	/*
>> +	 * This code may race with ptrace reparenting.
>> +	 *
>> +	 * We hold the tasklist lock while we check whether we're
>> +	 * ptraced and grab our ptracer's mm.
>> +	 *
>> +	 * It does not really matter if we're reparented,
>> +	 * afterwards. We hold onto the correct mm.
>> +	 *
>> +	 * If we're reparented before we get the tasklist_lock, our
>> +	 * former ptrace parent will release the bts tracer.
>> +	 */
>> +	write_lock_irq(&tasklist_lock);
>> +	if (current->ptrace)
>> +		mm = get_task_mm(current->parent);
>
>We can't take task_lock() (called by get_task_mm) under write_lock(tasklist),
>this is deadlockable. Afaics, read_lock() is enough here, in that case it is
>safe to call get_task_mm().

Thanks. I changed that to read_lock.


>> @@ -752,6 +752,14 @@ void ds_release_bts(struct bts_tracer *t
>>
>>  	ds_suspend_bts(tracer);
>>
>> +	/*
>> +	 * We must wait for the suspend to take effect before we may
>> +	 * free the tracer and the ds configuration.
>> +	 */
>> +	if (tracer->ds.context->task &&
>> +	    (tracer->ds.context->task != current))
>> +		wait_task_inactive(tracer->ds.context->task, 0);
>
>I am not sure I understand the problem. From the changelog:
>
>	If the children are currently executing, the buffer
>	may be freed while the hardware is still tracing.
>	This might cause the hardware to overwrite memory.
>
>So, the problem is that ds.context->task must not be running before we
>can start to disable/free ds, yes? Something like ds_switch_to() should
>be completed, right?
>
>In that case I don't really understand how wait_task_inactive() can help.
>If the task is killed it can be scheduled again, right after
>wait_task_inactive() returns.

We first call ds_suspend_bts().
This clears the branch tracing control bits for the traced task and already
writes the updated value to the msr, if running on the current cpu.
If the task is running on a different cpu, the updated value will be written
when the task is scheduled out.
By waiting for the task to become inactive, we know that it has been scheduled out
at least once after we changed the bits. So we know that the hardware will not use
the tracing configuration for that task and we can safely free the memory.


>Also. This function is called from ptrace_bts_exit_tracer(), when the
>tracee is not stopped. In this case wait_task_inactive() can spin forever.
>For example, if the tracee simply does "for (;;) ;" it never succeeds.

As far as I understand, wait_task_inactive() returns when the task is scheduled out.
It just loops as long as the task is running.


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

