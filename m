Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZBDFKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZBDFKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:10:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZBDFJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:09:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38696 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZBDFJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:09:54 -0500
To: paulmck@linux.vnet.ibm.com
Cc: Rusty Russell <rusty@rustcorp.com.au>, paulmck@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
References: <20090130123358.GA26216@redhat.com>
	<20090130125058.GA26931@redhat.com>
	<200901312246.07737.rusty@rustcorp.com.au>
	<20090201102117.GA5728@redhat.com> <m1wsc82033.fsf@fess.ebiederm.org>
	<20090202194105.GA23141@redhat.com> <m1hc3c19s7.fsf@fess.ebiederm.org>
	<20090203134110.GC6607@linux.vnet.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Feb 2009 21:10:06 -0800
In-Reply-To: <20090203134110.GC6607@linux.vnet.ibm.com> (Paul E. McKenney's message of "Tue\, 3 Feb 2009 05\:41\:10 -0800")
Message-ID: <m1ocxivlch.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, vgusev@openvz.org, xemul@openvz.org, mingo@elte.hu, hch@lst.de, akpm@linux-foundation.org, rusty@rustcorp.com.au
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;paulmck@linux.vnet.ibm.com
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

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> ACCESS_ONCE() suffices in many cases, but if the pointer being accessed
> points to a structure that might recently have been initialized, then
> rcu_dereference() will be required on Alpha.  Though perhaps the
> discussion below removes the need entirely, but cannot say that I fully
> understand this part of the kernel.

Thanks.  I had overlooked the addition of ACCESS_ONCE() into our set of
tricks.  I thought Oleg was referring to a hypothetical construct.

Currently Oleg's implementation is fine because of an explicit
memory barrier and two dereferences of the pointer.  It just isn't
especially clear.

ACCESS_ONCE would help.

Hmm.

I wonder if it would be better/clearer to define to_kthread as:

static struct kthread *to_kthread(struct task_struct *tsk)
{
	void *stack = task_stack_page(tsk);
	return (struct kthread *)(stack + kthread_offset);
        
}

And to measure kthread_offset the first time kthread() was
called.  I would love to have a fixed compile time offset but
I don't know how to measure it at compile time reliably.

Oleg what do you think.  It would remove the test and be simple and
obviously correct.

Eric



