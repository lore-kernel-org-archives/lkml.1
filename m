Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZJUPYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZJUPYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 11:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZJUPYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 11:24:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47984 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZJUPYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 11:24:43 -0400
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support
 for MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 11:24:46 -0400
Message-Id: <1256138686.18347.3039.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 22:34 +0800, Wu Zhangjin wrote:

> +++ b/arch/mips/kernel/mcount.S
> @@ -0,0 +1,94 @@
> +/*
> + * the mips-specific _mcount implementation
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive for
> + * more details.
> + *
> + * Copyright (C) 2009 DSLab, Lanzhou University, China
> + * Author: Wu Zhangjin <wuzj@lemote.com>
> + */
> +
> +#include <asm/regdef.h>
> +#include <asm/stackframe.h>
> +#include <asm/ftrace.h>
> +
> +	.text
> +	.set noreorder
> +	.set noat
> +
> +	/* since there is a "addiu sp,sp,-8" before "jal _mcount" in 32bit */
> +	.macro RESTORE_SP_FOR_32BIT
> +#ifdef CONFIG_32BIT
> +	PTR_ADDIU	sp, 8
> +#endif
> +	.endm
> +
> +	.macro MCOUNT_SAVE_REGS
> +	PTR_SUBU	sp, PT_SIZE
> +	PTR_S	ra, PT_R31(sp)
> +	PTR_S	AT, PT_R1(sp)
> +	PTR_S	a0, PT_R4(sp)
> +	PTR_S	a1, PT_R5(sp)
> +	PTR_S	a2, PT_R6(sp)
> +	PTR_S	a3, PT_R7(sp)
> +#ifdef CONFIG_64BIT
> +	PTR_S	a4, PT_R8(sp)
> +	PTR_S	a5, PT_R9(sp)
> +	PTR_S	a6, PT_R10(sp)
> +	PTR_S	a7, PT_R11(sp)
> +#endif
> +	.endm
> +
> +	.macro MCOUNT_RESTORE_REGS
> +	PTR_L	ra, PT_R31(sp)
> +	PTR_L	AT, PT_R1(sp)
> +	PTR_L	a0, PT_R4(sp)
> +	PTR_L	a1, PT_R5(sp)
> +	PTR_L	a2, PT_R6(sp)
> +	PTR_L	a3, PT_R7(sp)
> +#ifdef CONFIG_64BIT
> +	PTR_L	a4, PT_R8(sp)
> +	PTR_L	a5, PT_R9(sp)
> +	PTR_L	a6, PT_R10(sp)
> +	PTR_L	a7, PT_R11(sp)
> +#endif
> +	PTR_ADDIU	sp, PT_SIZE
> +.endm
> +
> +	.macro MCOUNT_SET_ARGS
> +	move	a0, ra		/* arg1: next ip, selfaddr */
> +	move	a1, AT		/* arg2: the caller's next ip, parent */
> +	PTR_SUBU a0, MCOUNT_INSN_SIZE
> +	.endm
> +
> +	.macro RETURN_BACK
> +	jr ra
> +	move ra, AT 
> +	.endm
> +
> +NESTED(_mcount, PT_SIZE, ra)
> +	RESTORE_SP_FOR_32BIT
> +	PTR_LA	t0, ftrace_stub
> +	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */

Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
the dynamics of C function ABI.

-- Steve


> +	bne	t0, t1, static_trace
> +	nop
> +
> +	j	ftrace_stub
> +	nop
> +
> +static_trace:
> +	MCOUNT_SAVE_REGS
> +
> +	MCOUNT_SET_ARGS			/* call *ftrace_trace_function */
> +	jalr	t1
> +	nop
> +
> +	MCOUNT_RESTORE_REGS
> +	.globl ftrace_stub
> +ftrace_stub:
> +	RETURN_BACK
> +	END(_mcount)
> +

