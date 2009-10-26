Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZJZPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZJZPNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 11:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZJZPNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 11:13:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZJZPNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 11:13:18 -0400
Subject: Re: [PATCH -v5 10/11] tracing: add function graph tracer support
 for MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <ac9c325539cc056d9539c96a68743a425f9612ce.1256483735.git.wuzhangjin@gmail.com>
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
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 11:13:21 -0400
Message-Id: <1256570001.26028.298.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 23:17 +0800, Wu Zhangjin wrote:

> +
> +unsigned long ftrace_get_parent_addr(unsigned long self_addr,
> +				     unsigned long parent,
> +				     unsigned long parent_addr,
> +				     unsigned long fp)
> +{
> +	unsigned long sp, ip, ra;
> +	unsigned int code;
> +
> +	/* move to the instruction "move ra, at" */
> +	ip = self_addr - 8;
> +
> +	/* search the text until finding the "move s8, sp" instruction or
> +	 * "s{d,w} ra, offset(sp)" instruction */
> +	do {
> +		ip -= 4;
> +
> +		/* get the code at "ip" */
> +		code = *(unsigned int *)ip;

Probably want to put the above in an asm with exception handling.

> +
> +		/* If we hit the "move s8(fp), sp" instruction before finding
> +		 * where the ra is stored, then this is a leaf function and it
> +		 * does not store the ra on the stack. */
> +		if ((code & MOV_FP_SP) == MOV_FP_SP)
> +			return parent_addr;
> +	} while (((code & S_RA) != S_RA));

Hmm, that condition also looks worrisome. Should we just always search
for s{d,w} R,X(sp)?

Since there should only be stores of registers into the sp above the
jump to mcount. The break out loop is a check for move. I think it would
be safer to have the break out loop is a check for non storing of a
register into SP.

> +
> +	sp = fp + (code & STACK_OFFSET_MASK);
> +	ra = *(unsigned long *)sp;

Also might want to make the above into a asm with exception handling.

> +
> +	if (ra == parent)
> +		return sp;
> +
> +	ftrace_graph_stop();
> +	WARN_ON(1);
> +	return parent_addr;

Hmm, may need to do more than this. See below.

> +}
> +
> +/*
> + * Hook the return address and push it in the stack of return addrs
> + * in current thread info.
> + */
> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> +			   unsigned long fp)
> +{
> +	unsigned long old;
> +	struct ftrace_graph_ent trace;
> +	unsigned long return_hooker = (unsigned long)
> +	    &return_to_handler;
> +
> +	if (unlikely(atomic_read(&current->tracing_graph_pause)))
> +		return;
> +
> +	/* "parent" is the stack address saved the return address of the caller
> +	 * of _mcount, for a leaf function not save the return address in the
> +	 * stack address, so, we "emulate" one in _mcount's stack space, and
> +	 * hijack it directly, but for a non-leaf function, it will save the
> +	 * return address to the its stack space, so, we can not hijack the
> +	 * "parent" directly, but need to find the real stack address,
> +	 * ftrace_get_parent_addr() does it!
> +	 */
> +
> +	old = *parent;
> +
> +	parent = (unsigned long *)ftrace_get_parent_addr(self_addr, old,
> +							 (unsigned long)parent,
> +							 fp);
> +
> +	*parent = return_hooker;

Although you may have turned off fgraph tracer in
ftrace_get_parent_addr, nothing stops the below from messing with the
stack. The return stack may get off sync and break later. If you fail
the above, you should not be calling the push function below.


-- Steve

> +
> +	if (ftrace_push_return_trace(old, self_addr, &trace.depth, fp) ==
> +	    -EBUSY) {
> +		*parent = old;
> +		return;
> +	}
> +
> +	trace.func = self_addr;
> +
> +	/* Only trace if the calling function expects to */
> +	if (!ftrace_graph_entry(&trace)) {
> +		current->curr_ret_stack--;
> +		*parent = old;
> +	}
> +}
> +#endif				/* CONFIG_FUNCTION_GRAPH_TRACER */


