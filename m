Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZE2JHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZE2JHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 05:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbZE2JHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 05:07:13 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:40129 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771AbZE2JHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 05:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=UTNAfkHGYyojpqVDwQrV6TQUDmEBXZPifUNxoIRF8pSMg7+RO4OOGFjKAYnQwza28k
         psG4AD7q+xuPWvphmWsmaoX3Cj/8AJ1jkVhaLv9sr+xwDPsZF8NkuuWrZFCN2jii4Q2f
         YvkkxV4LNloNkTu68wzn0oqxRrOCnwNYaBKMA=
Subject: Re: [PATCH v1 3/5] mips function graph tracer support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <alpine.DEB.2.00.0905282158020.11238@gandalf.stny.rr.com>
References: <cover.1243543471.git.wuzj@lemote.com>
	 <99ab6b652c259579a34b3592af06f59e28d5f570.1243543471.git.wuzj@lemote.com>
	 <alpine.DEB.2.00.0905282158020.11238@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 29 May 2009 17:07:00 +0800
Message-Id: <1243588020.12679.59.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 22:01 -0400, Steven Rostedt wrote:
> On Fri, 29 May 2009, wuzhangjin@gmail.com wrote:
> > diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
> > index ce8a0ba..bd58f16 100644
> > --- a/arch/mips/kernel/mcount.S
> > +++ b/arch/mips/kernel/mcount.S
> > @@ -28,6 +28,10 @@
> >  	PTR_SUBU	sp, PT_SIZE
> >  	PTR_S	ra, PT_R31(sp)
> >  	PTR_S	$1, PT_R1(sp)
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > +	PTR_S	v0, PT_R2(sp)
> > +	PTR_S	v1, PT_R3(sp)
> > +#endif
> >  	PTR_S	a0, PT_R4(sp)
> >  	PTR_S	a1, PT_R5(sp)
> >  	PTR_S	a2, PT_R6(sp)
> > @@ -43,6 +47,10 @@
> >  	.macro MCOUNT_RESTORE_REGS
> >  	PTR_L	ra, PT_R31(sp)
> >  	PTR_L	$1, PT_R1(sp)
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > +	PTR_L	v0, PT_R2(sp)
> > +	PTR_L	v1, PT_R3(sp)
> > +#endif
> >  	PTR_L	a0, PT_R4(sp)
> >  	PTR_L	a1, PT_R5(sp)
> >  	PTR_L	a2, PT_R6(sp)
> > @@ -89,6 +97,14 @@ ftrace_call:
> >  	nop
> >  
> >  	MCOUNT_RESTORE_REGS
> > +
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > +	.globl ftrace_graph_call
> > +ftrace_graph_call:
> > +	j	ftrace_stub
> > +	nop
> > +#endif
> > +
> >  	.globl ftrace_stub
> >  ftrace_stub:
> >  	RETURN_BACK
> > @@ -106,7 +122,15 @@ NESTED(_mcount, PT_SIZE, ra)
> >  	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
> >  	bne	t0, t1, static_trace
> >  	nop
> > -
> > +#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
> > +	PTR_L	t2, ftrace_graph_return
> > +	bne	t0,	t2, ftrace_graph_caller
> > +	nop
> > +	PTR_LA	t0, ftrace_graph_entry_stub
> > +	PTR_L	t2, ftrace_graph_entry
> > +	bne	t0,	t2, ftrace_graph_caller
> > +	nop
> > +#endif
> >  	j	ftrace_stub
> >  	nop
> >  
> > @@ -125,5 +149,37 @@ ftrace_stub:
> >  
> >  #endif	/* ! CONFIG_DYNAMIC_FTRACE */
> >  
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > +
> > +NESTED(ftrace_graph_caller, PT_SIZE, ra)
> > +	MCOUNT_SAVE_REGS
> > +
> > +	MCOUNT_SET_ARGS
> > +	jal	prepare_ftrace_return
> > +	nop
> > +
> > +	/* overwrite the parent as &return_to_handler: v0 -> $1(at) */
> > +	PTR_S	v0, PT_R1(sp)
> > +
> > +	MCOUNT_RESTORE_REGS
> > +	RETURN_BACK
> > +	END(ftrace_graph_caller)
> > +
> > +	.align	2
> > +	.globl	return_to_handler
> > +return_to_handler:
> > +	MCOUNT_SAVE_REGS
> 
> I'm not sure which version of function_graph tracer you looked at, 

currently, I'm using the master branch of the latest linux-mips git
tree. so, the function_graph should be the latest version?

BTW: which git branch should i apply these patches to?

> but I'm 
> pretty sure you can just save the return code registers of the function.
> 
> return_to_handler is called on the return of a function. 

Yeap.

> Thus, any callee 
> saved registers have already been restored and would also be restored by 
> ftrace_return_to_handler.  Any callee registers would have been saved by 
> the function you are about to return to.
> 
> Thus the only things you need to save are the return code registers.

have tried to not save/restore the arguments(a0-7) registers, the kernel
will hang:

CPU 0 Unable to handle kernel paging request at virtual address
0000000c, epc == 80101360, ra == 8010b114
Oops[#1]:
Cpu 0
$ 0   : 00000000 8010b114 00000000 00000000
$ 4   : 87830d00 87830d00 8780c380 10002400
$ 8   : 5607ec00 0000000b 00000000 5607ec00
$12   : 5607ec00 9e3779b9 9e3779b9 00000000
$16   : 00000000 10002400 00000000 87884d00
$20   : 000000d0 801857cc 00000000 80483e00
$24   : 00000000 00000000                  
$28   : 87976000 87977cd8 87977cd8 8010b114
Hi    : 0000000b
Lo    : 5607ec00
epc   : 80101360 plat_irq_dispatch+0x70/0x250
    Not tainted
ra    : 8010b114 return_to_handler+0x0/0x4c
Status: 10002402    KERNEL EXL 
Cause : 50808008
BadVA : 0000000c
PrId  : 00019300 (MIPS 24Kc)
Process bash (pid: 533, threadinfo=87976000, task=8796f560,
tls=2aad5100)
Stack : 00000062 0000006f 80455ef8 9e3779b9 00000000 00000020 87977da8
80101f80
        804b0000 804b0000 87977d08 8010b330 00000000 80483e00 00000000
10002401
        00000000 00000000 804b0000 804b3854 00000000 00000004 08042c2b
8010b0a0
        00000000 0000005f 80455fe4 9e3779b9 9e3779b9 00000000 87884d80
00000020
        00000000 87884d00 000000d0 801857cc 00000000 80483e00 00000000
00000000
        ...
Call Trace:
[<80101360>] plat_irq_dispatch+0x70/0x250
[<80101f80>] ret_from_irq+0x0/0x4
[<80183dd4>] ftrace_run_update_code+0x58/0xdc
[<8018410c>] ftrace_startup+0x7c/0x90
[<80185ab8>] register_ftrace_graph+0x40c/0x440
[<801955a0>] graph_trace_init+0x28/0x54
[<80190d00>] tracer_init+0x34/0x50
[<80190f34>] tracing_set_tracer+0x218/0x2c4
[<801910b8>] tracing_set_trace_write+0xd8/0x144


Code: 00000000  0c05cc3c  02002021 <8c43000c> 02002021  0060f809
00402821  0c04cec0  00000000 
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Fatal exception in interrupt

so, i think there is really a need to use the current
MCOUNT_SAVE/RESTORE_REGS, some arguments registers should be saved.
and we can share this common macros :-)

> -- Steve
> 
> 
> > +
> > +	jal	ftrace_return_to_handler
> > +	nop
> > +
> > +	/* restore the real parent address: v0 -> ra */
> > +	PTR_S	v0, PT_R31(sp)
> > +
> > +	MCOUNT_RESTORE_REGS
> > +	RETURN_BACK
> > +
> > +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> > +
> >  	.set at
> >  	.set reorder
> > diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
> > index 58738c8..67435e5 100644
> > --- a/arch/mips/kernel/vmlinux.lds.S
> > +++ b/arch/mips/kernel/vmlinux.lds.S
> > @@ -36,6 +36,7 @@ SECTIONS
> >  		SCHED_TEXT
> >  		LOCK_TEXT
> >  		KPROBES_TEXT
> > +		IRQENTRY_TEXT
> >  		*(.text.*)
> >  		*(.fixup)
> >  		*(.gnu.warning)
> > -- 
> > 1.6.0.4
> > 
> > 

