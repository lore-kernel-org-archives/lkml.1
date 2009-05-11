Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbZEKOUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbZEKOUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbZEKOUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:20:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZEKOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:20:38 -0400
Date: Mon, 11 May 2009 10:20:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip v5 2/7] kprobes: checks probe address is instruction
 boudary on x86
In-Reply-To: <20090509004847.5505.37957.stgit@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905111011060.14976@gandalf.stny.rr.com>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004847.5505.37957.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 May 2009, Masami Hiramatsu wrote:

> Ensure safeness of inserting kprobes by checking whether the specified
> address is at the first byte of a instruction on x86.
> This is done by decoding probed function from its head to the probe point.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  arch/x86/kernel/kprobes.c |   54 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 54 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 7b5169d..3d5e85f 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -48,12 +48,14 @@
>  #include <linux/preempt.h>
>  #include <linux/module.h>
>  #include <linux/kdebug.h>
> +#include <linux/kallsyms.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/desc.h>
>  #include <asm/pgtable.h>
>  #include <asm/uaccess.h>
>  #include <asm/alternative.h>
> +#include <asm/insn.h>
>  
>  void jprobe_return_end(void);
>  
> @@ -244,6 +246,56 @@ retry:
>  	}
>  }
>  
> +/* Recover the probed instruction at addr for further analysis. */
> +static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
> +{
> +	struct kprobe *kp;
> +	kp = get_kprobe((void *)addr);
> +	if (!kp)
> +		return -EINVAL;
> +

I'm just doing a casual scan of the patch set.

> +	/*
> +	 * Don't use p->ainsn.insn, which could be modified -- e.g.,

This comment talks about "p", what's that? It's not used in this function.

> +	 * by fix_riprel().
> +	 */
> +	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> +	buf[0] = kp->opcode;

Why is it OK to copy addr to "buf" and then rewrite the first character of 
buf?  Does it have something to do with the above "p"?

I don't mean to be critical here, but I've been doing "Mother Day" 
activities all weekend and for some reason that was also the best time for 
everyone to Cc me on patches. I'm way behind in my email, and it would be 
nice if the comments described why things that "look" wrong are not.


> +	return 0;
> +}
> +
> +/* Dummy buffers for kallsyms_lookup */
> +static char __dummy_buf[KSYM_NAME_LEN];
> +
> +/* Check if paddr is at an instruction boundary */
> +static int __kprobes can_probe(unsigned long paddr)
> +{
> +	int ret;
> +	unsigned long addr, offset = 0;
> +	struct insn insn;
> +	kprobe_opcode_t buf[MAX_INSN_SIZE];
> +
> +	/* Lookup symbol including addr */

The above comment is very close to a "add one to i" for i++ type of 
comment.

> +	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
> +		return 0;
> +
> +	/* Decode instructions */
> +	addr = paddr - offset;
> +	while (addr < paddr) {
> +		insn_init_kernel(&insn, (void *)addr);
> +		insn_get_opcode(&insn);
> +		if (OPCODE1(&insn) == BREAKPOINT_INSTRUCTION) {
> +			ret = recover_probed_instruction(buf, addr);

Oh, the above puts back the original op code. That is why it is OK?

I'd comment that a little bit more. Just so that reviewers have an easier 
idea of what is happening.

> +			if (ret)
> +				return 0;
> +			insn_init_kernel(&insn, buf);

insn_init_kernel? Is that like a text poke or something?

> +		}
> +		insn_get_length(&insn);
> +		addr += insn.length;
> +	}
> +
> +	return (addr == paddr);
> +}
> +
>  /*
>   * Returns non-zero if opcode modifies the interrupt flag.
>   */
> @@ -359,6 +411,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
>  
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
> +	if (!can_probe((unsigned long)p->addr))
> +		return -EILSEQ;
>  	/* insn: must be on special executable page on x86. */
>  	p->ainsn.insn = get_insn_slot();

Oh look, I found the phantom "p"!

-- Steve

>  	if (!p->ainsn.insn)
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 
