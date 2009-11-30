Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZK3UHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZK3UHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZK3UH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbZK3UHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:07:24 -0500
Date: Mon, 30 Nov 2009 21:01:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Veaceslav Falico <vfalico@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com, Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: powerpc: syscall_dotrace() && retcode (Was: powerpc: fork &&
	stepping)
Message-ID: <20091130200136.GB11764@redhat.com>
References: <20091126145051.GB4382@redhat.com> <20091126172524.GA14768@redhat.com> <20091126182226.GF12355@darkmag.usersys.redhat.com> <20091126202312.GA21945@redhat.com> <19214.63688.860929.962005@cargo.ozlabs.ibm.com> <20091126223703.GA28556@redhat.com> <20091127174627.GB26193@darkmag.usersys.redhat.com> <20091128073049.GD23108@in.ibm.com> <20091129210716.GA19205@redhat.com> <1259536501.2076.39.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259536501.2076.39.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30, Benjamin Herrenschmidt wrote:
>
> On Sun, 2009-11-29 at 22:07 +0100, Oleg Nesterov wrote:
> >
> > If I change the test-case to use NEWVAL == 1000 (or any other value
> > greater than NR_syscalls), then the tracee sees ENOSYS and this is
> > correct too.
> >
> > But I do not see how it is possible to change the retcode on powerpc.
> > Unlike x86, powepc doesn't set -ENOSYS "in advance", before doing
> > do_syscall_trace_enter() logic. This means that if the tracer "cancels"
> > syscall, r3 will be overwritten by syscall_enosys.
> >
> > This probably means the kernel should be fixed too, but I am not
> > brave enough to change the asm which I can't understand ;)
>
> Yes, the asm should be changed. I suppose we could check if the result
> of do_syscall_trace_enter is negative, and if it is, branch to the exit
> path using r3 as the error code. Would that be ok ?
>
> Something like this:
>
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -240,6 +240,9 @@ syscall_dotrace:
>  	bl	.save_nvgprs
>  	addi	r3,r1,STACK_FRAME_OVERHEAD
>  	bl	.do_syscall_trace_enter
> +	cmpdi	cr0,r3,0
> +	blt	syscall_exit
> +

Yes, but this doesn't allow to a) cancel this syscall and b) make it
return a non-negative result to the tracee.

Perhaps poweprc should set pt_regs->result = -ENOSYS before calling
do_syscall_trace_enter() like x86 does ? (in this case syscall_exit()
shouldn't change RESULT(r1)). This way the tracer can change both
pt_regs->result and gpr[0] independently.

Oleg.

