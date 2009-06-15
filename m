Return-Path: <linux-kernel-owner+w=401wt.eu-S1764969AbZFOTj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764969AbZFOTj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZFOTjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:39:48 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:37482 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbZFOTjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:39:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFABc+NkpMQWQl/2dsb2JhbACBT9ULhA0F
Date: Mon, 15 Jun 2009 15:39:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, penberg@cs.helsinki.fi, vegard.nossum@gmail.com,
       efault@gmx.de, jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615193934.GA9719@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:37:20 up 107 days, 16:03,  3 users,  load average: 1.68, 1.50,
	1.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 15 Jun 2009, Ingo Molnar wrote:
> > 
> > The gist of it is the replacement of iret with this open-coded 
> > sequence:
> > 
> > +#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
> > +						movq %rsp, %rax;	\
> > +						movq 24+8(%rax), %rsp;	\
> > +						pushq 0+8(%rax);	\
> > +						pushq 16+8(%rax);	\
> > +						movq (%rax), %rax;	\
> > +						popfq;			\
> > +						ret
> 
> That's an odd way of writing it.
> 

There were a few reasons (maybe not all good) for writing it like this :

- Saving I$ (as it is placed close to hot entry.S code paths)
- Staying localized with the top of stack, saving D$ accesses.

But maybe benchmarks will prove my approach overkill, dunno. Also we 
have to be aware that the CPU might behave more slowly in the presence
of unbalanced int/iret, call/ret. I think we should benchmark your 
approach to make sure jmp will not produce such slowdown. But it might
well be faster, and it's definitely clearer.

Thanks,

Mathieu


> Don't we have a per-cpu segment here? I'd much rather just see it do 
> something like this (_before_ restoring the regular registers)
> 
> 	movq EIP(%esp),%rax
> 	movq ESP(%esp),%rdx
> 	movq %rax,gs:saved_esp
> 	movq %rdx,gs:saved_eip
> 
> 	# restore regular regs
> 	RESTORE_ALL
> 
> 	# skip eip/esp to get at eflags
> 	addl $16,%esp
> 	popfq
> 
> 	# restore rsp/rip
> 	movq gs:saved_esp,%rsp
> 	jmpq *(gs:saved_eip)
> 
> but I haven't thought deeply about it. Maybe there's something wrong with 
> the above.
> 
> > If it's faster, this becomes a legit (albeit complex) 
> > micro-optimization in a _very_ hot codepath.
> 
> I don't think it's all that hot. It's not like it's the return to user 
> mode.
> 
> 			Linus

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
