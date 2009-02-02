Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZBBR5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZBBR5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZBBR52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:57:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37921 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZBBR50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:57:26 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
References: <20090130123358.GA26216@redhat.com>
	<20090130125058.GA26931@redhat.com>
	<200901312246.07737.rusty@rustcorp.com.au>
	<20090201102117.GA5728@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 02 Feb 2009 09:57:36 -0800
In-Reply-To: <20090201102117.GA5728@redhat.com> (Oleg Nesterov's message of "Sun\, 1 Feb 2009 11\:21\:17 +0100")
Message-ID: <m1wsc82033.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, vgusev@openvz.org, xemul@openvz.org, mingo@elte.hu, hch@lst.de, akpm@linux-foundation.org, rusty@rustcorp.com.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 01/31, Rusty Russell wrote:
>>
>> On Friday 30 January 2009 23:20:58 Oleg Nesterov wrote:
>> > On 01/30, Oleg Nesterov wrote:
>> > >
>> > > With this patch kthread() allocates all neccesary data (struct kthread)
>> > > on its own stack, globals kthread_stop_xxx are deleted. ->vfork_done
>> > > is used as a pointer into "struct kthread", this means kthread_stop()
>> > > can easily wait for kthread's exit.
>> 
>> > struct kthread {
>> > 	int should_stop;
>> > 	struct completion exited;
>> > };
>> 
>> Mildly prefer bool in new code.
>
> OK, and
>
>> > #define to_kthread(tsk)	\
>> > 	container_of((tsk)->vfork_done, struct kthread, exited)
>> 
>> This needs a comment.  Especially since to_xxx(yyy) is usually simply a
>> container_of(yyy, xxx, member).  This one is special.
>
> OK, I'll send the cleanup patch.
>
>> > int kthread_stop(struct task_struct *k)
>> > {
>> > 	struct kthread *kthread;
>> > 	int ret;
>> >
>> > 	trace_sched_kthread_stop(k);
>> > 	get_task_struct(k);
>> >
>> > 	kthread = to_kthread(k);
>> > 	barrier(); /* it might have exited */
>> > 	if (k->vfork_done != NULL) {
>> > 		kthread->should_stop = 1;
>> > 		wake_up_process(k);
>> > 		wait_for_completion(&kthread->exited);
>> > 	}
>> > 	ret = k->exit_code;
>>
>> I don't think this works.  How does do_exit() preserve a stack var, other
>> than for a few cycles longer?  Sure, the vfork_done will be OK, but this code
>> here will not be.  I think you'd need a get_task_struct(current) before the
>> do_exit(ret)
>
> I think this works ;)
>
> This stack frame can't disappear until
> __put_task_struct()->...->free_thread_info().
> So, if you have a reference to task_struct, then it it is safe to dereference
> to_kthread(task).

Correct.

> Before this patch, kthread_stop() can only be used when we know that kthread
> must not exit by its own. And with this patch we are safe in this case, note
> that kthread_stop() does get_task_struct() before it sets ->should_stop = 1.
> And this also pins the memory pointed by to_kthread().

>> (the case where the kthread fn calls do_exit() is fine: you're
>> not allowed to call kthread stop on such threads).
>
> This was not allowed, but now this is fine. Please look at the 4/4 patch.
> But, in that case you must pin the task_struct after kthread_create(),
> otherwise (with or without this patch) you just can't use this task_struct
> in any way.

To finish the conversion of everything to kthreads from kernel_thread
we need to be able to call kthread_stop on threads that call do_exit.
That kthread_stop cannot be called on such threads is currently a major
deficiency of the kthread api.

>> In which case using vfork_done is really just a convenience pointer inside
>> struct task_struct to stash the struct kthread.  And that's horribly ugly,
>> which is why I stuck with a simple global.  Changing to a linked-list of
> things
>> to stop would avoid the deadlock you mentioned where a kthread stops another
>> kthread.
>
> Well, this patch overloads ->vfork_done, and I agree this is a bit ugly.
> But what you suggest (if I undestand correctly) is more complex, and doesn't
> have any advantages, imho.

No.  This patch does not overload or really abuse vfork_done.
vfork_done is named a bit misleadingly.  It should arguably be called
mm_done.  vfork_done (if set) always points to a completion that will
be completed when do_exit() -> mm_release() is called.

What we want is some completion called from inside of do_exit.
mm_release happens to be such a completion and the code already
exists.

If mm_release did not do: tsk->vfork_done = NULL then the entire
test of if (k->vfork_done != NULL) would be unnecessary.

Oleg on that note we should not need a barrier at all. We should be
able to simply say: 

cmplp = k->vfork_done;
if (cmplp){
	/* if vfork_done is NULL we have passed mm_release */
	kthread = container_of(cmplp, struct kthread, exited);
	kthread->should_stop = 1;
	wake_up_process(k);
	wait_for_completion(&kthread->exited);
}

Thinking of it I wish we had someplace we could store a pointer
that would not be cleared so we could remove that whole confusing
conditional.  I just looked through task_struct and there doesn't
appear to be anything promising.

Perhaps we could rename vfork_done mm_done and not clear it in
mm_release.

Eric
