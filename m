Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbZFOUPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbZFOUPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZFOUO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:14:57 -0400
Received: from claw.goop.org ([74.207.240.146]:53581 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbZFOUO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:14:56 -0400
Message-ID: <4A36ABB5.1040109@goop.org>
Date: Mon, 15 Jun 2009 13:14:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       npiggin@suse.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain support
 to use NMI-safe methods
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/09 12:04, Linus Torvalds wrote:
> That's an odd way of writing it.
>
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

We have to restore the usermode %gs somewhere...

     J
