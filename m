Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbZFOTF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbZFOTF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933847AbZFOTFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:05:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766000AbZFOTFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:05:34 -0400
Date: Mon, 15 Jun 2009 12:04:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
In-Reply-To: <20090615183649.GA16999@elte.hu>
Message-ID: <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal>
 <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Ingo Molnar wrote:
> 
> The gist of it is the replacement of iret with this open-coded 
> sequence:
> 
> +#define NATIVE_INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
> +						movq %rsp, %rax;	\
> +						movq 24+8(%rax), %rsp;	\
> +						pushq 0+8(%rax);	\
> +						pushq 16+8(%rax);	\
> +						movq (%rax), %rax;	\
> +						popfq;			\
> +						ret

That's an odd way of writing it.

Don't we have a per-cpu segment here? I'd much rather just see it do 
something like this (_before_ restoring the regular registers)

	movq EIP(%esp),%rax
	movq ESP(%esp),%rdx
	movq %rax,gs:saved_esp
	movq %rdx,gs:saved_eip

	# restore regular regs
	RESTORE_ALL

	# skip eip/esp to get at eflags
	addl $16,%esp
	popfq

	# restore rsp/rip
	movq gs:saved_esp,%rsp
	jmpq *(gs:saved_eip)

but I haven't thought deeply about it. Maybe there's something wrong with 
the above.

> If it's faster, this becomes a legit (albeit complex) 
> micro-optimization in a _very_ hot codepath.

I don't think it's all that hot. It's not like it's the return to user 
mode.

			Linus
