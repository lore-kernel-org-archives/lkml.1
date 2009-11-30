Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZK3I70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZK3I70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZK3I7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:59:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:38621 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZK3I7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:59:23 -0500
Message-ID: <4B138950.9040905@kernel.org>
Date: Mon, 30 Nov 2009 17:58:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm
 2009-11-24-16-47 uploaded]
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>  <4B0FEA3E.5050108@gmail.com> <1259335036.6483.440.camel@laptop> <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain> <4B1113C0.30505@redhat.com>
In-Reply-To: <4B1113C0.30505@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/28/2009 09:12 PM, Avi Kivity wrote:
>> Hmm, commit 498657a moved the fire_sched_in_preempt_notifiers() call
>> into the irqs disabled section recently.
>>
>>      sched, kvm: Fix race condition involving sched_in_preempt_notifers
>>
>>      In finish_task_switch(), fire_sched_in_preempt_notifiers() is
>>      called after finish_lock_switch().
>>
>>      However, depending on architecture, preemption can be enabled after
>>      finish_lock_switch() which breaks the semantics of preempt
>>      notifiers.
>>
>>      So move it before finish_arch_switch(). This also makes the in-
>>      notifiers symmetric to out- notifiers in terms of locking - now
>>      both are called under rq lock.
>>
>> It's not a surprise that this breaks the existing code which does the
>> smp function call.
> 
> Yes, kvm expects preempt notifiers to be run with irqs enabled.  Copying
> patch author.

Hmmm... then, it's broken both ways.  The previous code may get
preempted after scheduling but before the notifier is run (which
breaks the semantics of the callback horribly), the current code
doesn't satisfy kvm's requirement.  Another thing is that in the
previous implementation the context is different between the 'in' and
'out' callbacks, which is subtle and nasty.  Can kvm be converted to
not do smp calls directly?

For the time being, maybe it's best to back out the fix given that the
only architecture which may be affected by the original bug is ia64
which is the only one with both kvm and the unlocked context switch.

Thanks.

-- 
tejun
