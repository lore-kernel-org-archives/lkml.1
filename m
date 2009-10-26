Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZJZQcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZJZQcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZJZQcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:32:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZJZQcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:32:53 -0400
Subject: Re: [PATCH -v5 10/11] tracing: add function graph tracer support
 for MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: wuzhangjin@gmail.com
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <1256573467.5642.214.camel@falcon>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <028867b99ec532b84963a35e7d552becc783cafc.1256483735.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <6ad82af0c2ec8ef7b9f536b0a97bf65d385c3945.1256483735.git.wuzhangjin@gmail.com>
	 <ac9c325539cc056d9539c96a68743a425f9612ce.1256483735.git.wuzhangjin@gmail.com>
	 <1256570001.26028.298.camel@gandalf.stny.rr.com>
	 <1256573467.5642.214.camel@falcon>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 12:32:55 -0400
Message-Id: <1256574775.26028.321.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 00:11 +0800, Wu Zhangjin wrote:
> Hi,
> 
> On Mon, 2009-10-26 at 11:13 -0400, Steven Rostedt wrote:
> [...]
> > > +
> > > +		/* get the code at "ip" */
> > > +		code = *(unsigned int *)ip;
> > 
> > Probably want to put the above in an asm with exception handling.
> > 
> 
> Seems that exception handling in an asm is really "awful"(un-readable)
> and the above ip is what we have got from the ftrace_graph_caller, it
> should be okay. but if exception handling is necessary, I will send a
> new patch for the places(including the following one) which need it. 

Yeah, and probably not as important in the mips world, as it is used
more with embedded devices than desktops. We must always take the
"paranoid" approach for tracing. At least in PPC and x86, we assume
everything is broken ;-)  And we want to be as robust as possible. If
something goes wrong, we want to detect it ASAP and report it. And keep
the system from crashing.

At least with MIPS we don't need to worry about crashing Linus's
desktop. With is the #1 priority we have on x86 ... "Don't crash Linus's
desktop!".

If Linus sees a warning, he'll bitch at us. If we crash his box, and he
was to lose any information, he'll strip out our code!

> 
> > > +
> > > +		/* If we hit the "move s8(fp), sp" instruction before finding
> > > +		 * where the ra is stored, then this is a leaf function and it
> > > +		 * does not store the ra on the stack. */
> > > +		if ((code & MOV_FP_SP) == MOV_FP_SP)
> > > +			return parent_addr;
> > > +	} while (((code & S_RA) != S_RA));
> > 
> > Hmm, that condition also looks worrisome. Should we just always search
> > for s{d,w} R,X(sp)?
> > 
> > Since there should only be stores of registers into the sp above the
> > jump to mcount. The break out loop is a check for move. I think it would
> > be safer to have the break out loop is a check for non storing of a
> > register into SP.
> 
> 
> Okay, let's look at this with -mlong-calls,
> 
> leaf function:
> 
> ffffffff80243cd8 <oops_may_print>:
> ffffffff80243cd8:       67bdfff0        daddiu  sp,sp,-16
> ffffffff80243cdc:       ffbe0008        sd      s8,8(sp)
> ffffffff80243ce0:       03a0f02d        move    s8,sp
> ffffffff80243ce4:       3c038021        lui     v1,0x8021
> ffffffff80243ce8:       646316b0        daddiu  v1,v1,5808
> ffffffff80243cec:       03e0082d        move    at,ra
> ffffffff80243cf0:       0060f809        jalr    v1
> ffffffff80243cf4:       00020021        nop
> 
> non-leaf function:
> 
> ffffffff802414c0 <copy_process>:
> ffffffff802414c0:       67bdff40        daddiu  sp,sp,-192
> ffffffff802414c4:       ffbe00b0        sd      s8,176(sp)
> ffffffff802414c8:       03a0f02d        move    s8,sp
> ffffffff802414cc:       ffbf00b8        sd      ra,184(sp)
> ffffffff802414d0:       ffb700a8        sd      s7,168(sp)
> ffffffff802414d4:       ffb600a0        sd      s6,160(sp)
> ffffffff802414d8:       ffb50098        sd      s5,152(sp)
> ffffffff802414dc:       ffb40090        sd      s4,144(sp)
> ffffffff802414e0:       ffb30088        sd      s3,136(sp)
> ffffffff802414e4:       ffb20080        sd      s2,128(sp)
> ffffffff802414e8:       ffb10078        sd      s1,120(sp)
> ffffffff802414ec:       ffb00070        sd      s0,112(sp)
> ffffffff802414f0:       3c038021        lui     v1,0x8021
> ffffffff802414f4:       646316b0        daddiu  v1,v1,5808
> ffffffff802414f8:       03e0082d        move    at,ra
> ffffffff802414fc:       0060f809        jalr    v1
> ffffffff80241500:       00020021        nop
> ip -->  
> 
> At first, we move to "lui, v1, HI_16BIT_OF_MCOUNT", ip = ip - 12(not 8
> when without -mlong-calls, i need to update the source code later).

Yes with -mlong-calls you must jump pass the setting up of the jalr.

> 
> and then, we check whether there is a "Store" instruction, if it's not a
> "Store" instruction, the function should be a leaf? otherwise, we
> continue the searching until finding the "s{d,w} ra, offset(sp)"
> instruction, get the offset, calculate the stack address, and finish?

Note, you are commenting different than your code. Your code matches
more what I want than your comments ;-)  You keep saying "if the
instruction just after the jump to mcount (and preparation for) is not a
store than it is a leaf", where I'm saying (and the code matches),
search above the jump to mcount and if we don't find the store of ra,
then it is a leaf.

> 
> So, we just need to replace this:
> 
> 		if ((code & MOV_FP_SP) == MOV_FP_SP)
> 			return parent_addr;	
> 	
> by
> 
> #define S_INSN	(0xafb0 << 16)
> 
> 		if ((code & S_INSN) != S_INSN)
> 			return parent_addr;

I would be even more paranoid, and make sure each of those stores, store
into sp.

> 
> > 
> > > +
> > > +	sp = fp + (code & STACK_OFFSET_MASK);
> > > +	ra = *(unsigned long *)sp;
> > 
> > Also might want to make the above into a asm with exception handling.
> > 
> > > +
> > > +	if (ra == parent)
> > > +		return sp;
> > > +
> > > +	ftrace_graph_stop();
> > > +	WARN_ON(1);
> > > +	return parent_addr;
> > 
> > Hmm, may need to do more than this. See below.
> > 
> > > +}
> > > +
> > > +/*
> > > + * Hook the return address and push it in the stack of return addrs
> > > + * in current thread info.
> > > + */
> > > +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> > > +			   unsigned long fp)
> > > +{
> > > +	unsigned long old;
> > > +	struct ftrace_graph_ent trace;
> > > +	unsigned long return_hooker = (unsigned long)
> > > +	    &return_to_handler;
> > > +
> > > +	if (unlikely(atomic_read(&current->tracing_graph_pause)))
> > > +		return;
> > > +
> > > +	/* "parent" is the stack address saved the return address of the caller
> > > +	 * of _mcount, for a leaf function not save the return address in the
> > > +	 * stack address, so, we "emulate" one in _mcount's stack space, and
> > > +	 * hijack it directly, but for a non-leaf function, it will save the
> > > +	 * return address to the its stack space, so, we can not hijack the
> > > +	 * "parent" directly, but need to find the real stack address,
> > > +	 * ftrace_get_parent_addr() does it!
> > > +	 */
> > > +
> > > +	old = *parent;
> > > +
> > > +	parent = (unsigned long *)ftrace_get_parent_addr(self_addr, old,
> > > +							 (unsigned long)parent,
> > > +							 fp);
> > > +
> > > +	*parent = return_hooker;
> > 
> > Although you may have turned off fgraph tracer in
> > ftrace_get_parent_addr, nothing stops the below from messing with the
> > stack. The return stack may get off sync and break later. If you fail
> > the above, you should not be calling the push function below.
> > 
> 
> We need to really stop before ftrace_push_return_trace to avoid messing
> with the stack :-) but if we have stopped the tracer, is it important to
> mess with the stack or not?

The ftrace_push_return_trace does not test if the trace stopped, that is
expected to be done by the caller. If you mess with the stack set up,
you will crash the box. Remember, before the failure, you could have
already replaced return jumps. Those will still be falling back to the
return_to_handler. If you mess with the stack, but don't update the
return, the other returns will be out of sync and call the wrong return
address.

-- Steve


