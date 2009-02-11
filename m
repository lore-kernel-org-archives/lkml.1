Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbZBKWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbZBKWLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZBKWLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:11:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53588 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbZBKWLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:11:11 -0500
Date: Wed, 11 Feb 2009 23:08:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch] x86, ptrace: fix double-free on race
Message-ID: <20090211220821.GA17637@redhat.com>
References: <20090211151027.A16643@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211151027.A16643@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Markus Metzger wrote:
>
> Ptrace_detach() races with __ptrace_unlink() if the traced task is
> reaped while detaching. This might cause a double-free of the BTS
> buffer.
>
> Change the ptrace_detach() path to only do the memory accounting in
> ptrace_bts_detach() and leave the buffer free to ptrace_bts_untrace()
> which will be called from __ptrace_unlink().

Thanks Markus, I think this should close the "really bad" problems
for 2.6.29.


Off-topic. This is subjective, so please feel to ignore, but personally
I dislike the usage of ptrace_fork() in copy_process(). And ptrace_fork()
itself.

To me, this has nothing to do with ptrace at all. copy_process() or
dup_task_struct() just must clear/tweak some fields after memcpy().

Perhaps it is better to kill all these ptrace_fork/arch_ptrace_fork/
x86_ptrace_fork/ptrace_bts_fork helpers, and make a single function

	static inline void arch_bts_init(struct task_struct *p)
	{
	#ifdef CONFIG_X86_PTRACE_BTS
		if (unlikely(p->bts)) {
			p->bts = NULL;
			p->bts_buffer = NULL;
			p->bts_size = 0;
			p->thread.bts_ovfl_signal = 0;
		}
	#endif /* CONFIG_X86_PTRACE_BTS */
	}

which is called by arch_dup_task_struct(). The "if (ptrace)" check
in copy_process() is just wrong imho, even if it is currently correct.
Let's suppose we add, say, bts_spinlock to the fields above. In that
case we must initialize it even if the forking task is not ptraced.

Of course, in any case this is not 2.6.29 material.


Btw, just curious, bts_ovfl_signal is not used, except the user can
set/get it via PTRACE_BTS_CONFIG/PTRACE_BTS_STATUS ?

Oleg.

