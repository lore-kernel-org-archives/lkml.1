Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZBDP7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZBDP7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZBDP7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:59:24 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46889 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZBDP7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:59:22 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
References: <20090130123358.GA26216@redhat.com>
	<20090203134110.GC6607@linux.vnet.ibm.com>
	<m1ocxivlch.fsf@fess.ebiederm.org>
	<200902042134.32346.rusty@rustcorp.com.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Feb 2009 07:59:35 -0800
In-Reply-To: <200902042134.32346.rusty@rustcorp.com.au> (Rusty Russell's message of "Wed\, 4 Feb 2009 21\:34\:31 +1030")
Message-ID: <m1r62ew5ug.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, vgusev@openvz.org, xemul@openvz.org, mingo@elte.hu, hch@lst.de, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rusty Russell <rusty@rustcorp.com.au>
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

Rusty Russell <rusty@rustcorp.com.au> writes:

> On Wednesday 04 February 2009 15:40:06 Eric W. Biederman wrote:
>> static struct kthread *to_kthread(struct task_struct *tsk)
>> {
>> 	void *stack = task_stack_page(tsk);
>> 	return (struct kthread *)(stack + kthread_offset);
>>         
>> }
> ...
>> It would remove the test and be simple and obviously correct.
>
> Clever? Sure.  Neat? Yes.
>
> But you are using a definition of obvious with which I was not previously
> familiar :)

Well the way you compute kthread_offset is:

	struct kthread kthread;
	void *stack = task_stack_page(current);
        kthread_offset = (void *)&kthread - stack;

Now Rusty I don't know about you but after I learned to do
addition and subtraction it has always been obvious to me that
one is the opposite of the other.

Further I think the rest of that code becomes a lot clearer if
we can remove that stupid, unnecessary conditional.  As worrying
if the process has exited implies we care about a lot of things
that we really don't and seem to make the code generally less
comprehensible.

I am slightly concerned that using task_stack_page(tsk) may be
overly clever, but compared to ACCESS_ONCE(), memory barriers,
or not letting kthread_stop be called on a thread that may exit
I think I am ahead of the game.

Eric
