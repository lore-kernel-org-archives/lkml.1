Return-Path: <linux-kernel-owner+w=401wt.eu-S1752472AbZBCDZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbZBCDZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZBCDZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:25:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42716 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBCDZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:25:32 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
References: <20090130123358.GA26216@redhat.com>
	<20090130125058.GA26931@redhat.com>
	<200901312246.07737.rusty@rustcorp.com.au>
	<20090201102117.GA5728@redhat.com> <m1wsc82033.fsf@fess.ebiederm.org>
	<20090202194105.GA23141@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 02 Feb 2009 19:25:44 -0800
In-Reply-To: <20090202194105.GA23141@redhat.com> (Oleg Nesterov's message of "Mon\, 2 Feb 2009 20\:41\:05 +0100")
Message-ID: <m1hc3c19s7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, vgusev@openvz.org, xemul@openvz.org, mingo@elte.hu, hch@lst.de, akpm@linux-foundation.org, rusty@rustcorp.com.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 02/02, Eric W. Biederman wrote:
>>
>> Oleg on that note we should not need a barrier at all. We should be
>> able to simply say:
>>
>> cmplp = k->vfork_done;
>> if (cmplp){
>> 	/* if vfork_done is NULL we have passed mm_release */
>> 	kthread = container_of(cmplp, struct kthread, exited);
>> 	kthread->should_stop = 1;
>> 	wake_up_process(k);
>> 	wait_for_completion(&kthread->exited);
>> }
>
> Yes, but the compiler can read ->vfork_done twice, and turn this code
> into
>
> 	cmplp = k->vfork_done;
> 	if (cmplp){
> 		kthread = container_of(k->vfork_done, struct kthread, exited);
> 		...
>
> and when we read k->vfork_done again it can be already NULL.
> Probably we could use ACCESS_ONCE() instead.
>
> Perhaps this barrier() is not needed in practice, but just to be safe.

Certainly.   I definitely see where you are coming from.
And of course all of this only works because a pointer is a word size
so it is read and updated atomically by the compiler.

I wish we had a good idiom we could use to make it clear what we
are doing.  The rcu pointer read code perhaps?

> And in fact I saw the bug report with this code:
>
> 	ac.ac_tty = current->signal->tty ?
> 		old_encode_dev(tty_devnum(current->signal->tty)) : 0;
>
> this code is wrong anyway, but ->tty was read twice. I specially
> asked for .s file because I wasn't able to believe the bug manifests
> itself this way.

Interesting.

>> Thinking of it I wish we had someplace we could store a pointer
>> that would not be cleared so we could remove that whole confusing
>> conditional.  I just looked through task_struct and there doesn't
>> appear to be anything promising.
>>
>> Perhaps we could rename vfork_done mm_done and not clear it in
>> mm_release.
>
> Yes, in that case we don't need the barrier().
>
> I was thinking about changing mm_release() too, but we should clear
> ->vfork_done (or whatever) in exec_mmap() anyway.

Yes.  I realized that just after I wrote that.  So clearing
vfork_done in all cases is a good idea so we don't make get sloppy.

Eric

