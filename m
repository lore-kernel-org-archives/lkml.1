Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbZE2PQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbZE2PQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbZE2PQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:16:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbZE2PQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:16:24 -0400
Date: Fri, 29 May 2009 11:16:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Wu Zhangjin <wuzhangjin@gmail.com>
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v1 3/5] mips function graph tracer support
In-Reply-To: <1243588020.12679.59.camel@falcon>
Message-ID: <alpine.DEB.2.00.0905291108260.31247@gandalf.stny.rr.com>
References: <cover.1243543471.git.wuzj@lemote.com>  <99ab6b652c259579a34b3592af06f59e28d5f570.1243543471.git.wuzj@lemote.com>  <alpine.DEB.2.00.0905282158020.11238@gandalf.stny.rr.com> <1243588020.12679.59.camel@falcon>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 May 2009, Wu Zhangjin wrote:
> > > +
> > > +NESTED(ftrace_graph_caller, PT_SIZE, ra)
> > > +	MCOUNT_SAVE_REGS
> > > +
> > > +	MCOUNT_SET_ARGS
> > > +	jal	prepare_ftrace_return
> > > +	nop
> > > +
> > > +	/* overwrite the parent as &return_to_handler: v0 -> $1(at) */
> > > +	PTR_S	v0, PT_R1(sp)
> > > +
> > > +	MCOUNT_RESTORE_REGS
> > > +	RETURN_BACK
> > > +	END(ftrace_graph_caller)
> > > +
> > > +	.align	2
> > > +	.globl	return_to_handler
> > > +return_to_handler:
> > > +	MCOUNT_SAVE_REGS
> > 
> > I'm not sure which version of function_graph tracer you looked at, 
> 
> currently, I'm using the master branch of the latest linux-mips git
> tree. so, the function_graph should be the latest version?
> 
> BTW: which git branch should i apply these patches to?

Any changes to the core ftrace we would like to go through tip. But 
testing of an arch is best in the arch specific trees. What we did for 
powerpc, was that we made a branch based off of linus's tree and did only 
the change in the core ftrace code that was needed by PPC. Then that 
branch was pulled into both tip and the ppc git tree. Thus it was the same 
change set with the same SHA1. Then it could go via either ppc or tip into 
linus's tree and it would not be a duplicate. We might need to do 
something similar as well for mips.


> 
> > but I'm 
> > pretty sure you can just save the return code registers of the function.
> > 
> > return_to_handler is called on the return of a function. 
> 
> Yeap.
> 
> > Thus, any callee 
> > saved registers have already been restored and would also be restored by 
> > ftrace_return_to_handler.  Any callee registers would have been saved by 
> > the function you are about to return to.
> > 
> > Thus the only things you need to save are the return code registers.
> 
> have tried to not save/restore the arguments(a0-7) registers, the kernel
> will hang:

You might want to look into this. When Frederic first did the code for 
x86_64 he had similar issues. But later I converted it to just the return 
values and everything worked fine. You might be hiding some other kind of 
bug.

But I don not remember the mips binary api. Does the callee own all args 
registers? or just the ones it uses. You must also make sure you preserve 
all return value registers. Again, I don't remember mips api (been 8 years 
since I've worked on mips), but it may be more than one reg.

/me searches for his old mips hand book.

> 
> CPU 0 Unable to handle kernel paging request at virtual address
> 0000000c, epc == 80101360, ra == 8010b114
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 8010b114 00000000 00000000
> $ 4   : 87830d00 87830d00 8780c380 10002400
> $ 8   : 5607ec00 0000000b 00000000 5607ec00
> $12   : 5607ec00 9e3779b9 9e3779b9 00000000
> $16   : 00000000 10002400 00000000 87884d00
> $20   : 000000d0 801857cc 00000000 80483e00
> $24   : 00000000 00000000                  
> $28   : 87976000 87977cd8 87977cd8 8010b114
> Hi    : 0000000b
> Lo    : 5607ec00
> epc   : 80101360 plat_irq_dispatch+0x70/0x250
>     Not tainted
> ra    : 8010b114 return_to_handler+0x0/0x4c
> Status: 10002402    KERNEL EXL 
> Cause : 50808008
> BadVA : 0000000c
> PrId  : 00019300 (MIPS 24Kc)
> Process bash (pid: 533, threadinfo=87976000, task=8796f560,
> tls=2aad5100)
> Stack : 00000062 0000006f 80455ef8 9e3779b9 00000000 00000020 87977da8
> 80101f80
>         804b0000 804b0000 87977d08 8010b330 00000000 80483e00 00000000
> 10002401
>         00000000 00000000 804b0000 804b3854 00000000 00000004 08042c2b
> 8010b0a0
>         00000000 0000005f 80455fe4 9e3779b9 9e3779b9 00000000 87884d80
> 00000020
>         00000000 87884d00 000000d0 801857cc 00000000 80483e00 00000000
> 00000000
>         ...
> Call Trace:
> [<80101360>] plat_irq_dispatch+0x70/0x250
> [<80101f80>] ret_from_irq+0x0/0x4
> [<80183dd4>] ftrace_run_update_code+0x58/0xdc
> [<8018410c>] ftrace_startup+0x7c/0x90
> [<80185ab8>] register_ftrace_graph+0x40c/0x440
> [<801955a0>] graph_trace_init+0x28/0x54
> [<80190d00>] tracer_init+0x34/0x50
> [<80190f34>] tracing_set_tracer+0x218/0x2c4
> [<801910b8>] tracing_set_trace_write+0xd8/0x144
> 
> 
> Code: 00000000  0c05cc3c  02002021 <8c43000c> 02002021  0060f809
> 00402821  0c04cec0  00000000 
> Disabling lock debugging due to kernel taint
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> so, i think there is really a need to use the current
> MCOUNT_SAVE/RESTORE_REGS, some arguments registers should be saved.
> and we can share this common macros :-)

I would still like to understand why it crashes. Perhaps you really need 
to save all regs, but not fully understanding a crash and finding a work 
around does not make me feel too comfortable.

-- Steve
