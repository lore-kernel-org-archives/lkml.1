Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbZK3ApC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbZK3ApC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 19:45:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZK3ApB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 19:45:01 -0500
Received: from gate.crashing.org ([63.228.1.57]:32783 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZK3ApA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 19:45:00 -0500
Subject: Re: powerpc: syscall_dotrace() && retcode (Was: powerpc: fork &&
 stepping)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Veaceslav Falico <vfalico@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
In-Reply-To: <1259536501.2076.39.camel@pasglop>
References: <20091125154052.GA6734@redhat.com>
	 <20091126075335.GA18508@in.ibm.com> <20091126145051.GB4382@redhat.com>
	 <20091126172524.GA14768@redhat.com>
	 <20091126182226.GF12355@darkmag.usersys.redhat.com>
	 <20091126202312.GA21945@redhat.com>
	 <19214.63688.860929.962005@cargo.ozlabs.ibm.com>
	 <20091126223703.GA28556@redhat.com>
	 <20091127174627.GB26193@darkmag.usersys.redhat.com>
	 <20091128073049.GD23108@in.ibm.com>  <20091129210716.GA19205@redhat.com>
	 <1259536501.2076.39.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 11:43:21 +1100
Message-ID: <1259541801.2076.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 10:15 +1100, Benjamin Herrenschmidt wrote:

> Yes, the asm should be changed. I suppose we could check if the result
> of do_syscall_trace_enter is negative, and if it is, branch to the exit
> path using r3 as the error code. Would that be ok ?
> 
> Something like this:

Note however that there's a trace exit too and that's normally the right
place to alter the result don't you think ?

Cheers,
Ben.

> diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
> index 1175a85..7a88c88 100644
> --- a/arch/powerpc/kernel/entry_32.S
> +++ b/arch/powerpc/kernel/entry_32.S
> @@ -419,6 +419,9 @@ syscall_dotrace:
>  	stw	r0,_TRAP(r1)
>  	addi	r3,r1,STACK_FRAME_OVERHEAD
>  	bl	do_syscall_trace_enter
> +	cmpwi	cr0,r3,0
> +	blt	ret_from_syscall
> +
>  	/*
>  	 * Restore argument registers possibly just changed.
>  	 * We use the return value of do_syscall_trace_enter
> diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
> index 9763267..ec709a7 100644
> --- a/arch/powerpc/kernel/entry_64.S
> +++ b/arch/powerpc/kernel/entry_64.S
> @@ -240,6 +240,9 @@ syscall_dotrace:
>  	bl	.save_nvgprs
>  	addi	r3,r1,STACK_FRAME_OVERHEAD
>  	bl	.do_syscall_trace_enter
> +	cmpdi	cr0,r3,0
> +	blt	syscall_exit
> +
>  	/*
>  	 * Restore argument registers possibly just changed.
>  	 * We use the return value of do_syscall_trace_enter
> 
> 
> Cheers,
> Ben.


