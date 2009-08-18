Return-Path: <linux-kernel-owner+w=401wt.eu-S1751779AbZHRXDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbZHRXDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZHRXDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:03:49 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62928 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZHRXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=DF7f1+65Vi/6HYQcb4XpxrXBESPD6wuG1i63SH5JADbkVKxDtLZjTbNDXYZLiLVctW
         kjZgJOgrzU92rG9wfBqdbjmZwLRHbDbPVS1KEv46lPqgVBkbSmlns40w21/opR1p+VDJ
         CvaAMr9XlsMj4eDKMc3QsC+GUCD6rdTvu1z2U=
Date: Wed, 19 Aug 2009 01:03:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 03/12] kprobes: checks probe address is
	instruction boudary on x86
Message-ID: <20090818230340.GF5231@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203428.31965.21939.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090813203428.31965.21939.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 04:34:28PM -0400, Masami Hiramatsu wrote:
> Ensure safeness of inserting kprobes by checking whether the specified
> address is at the first byte of a instruction on x86.
> This is done by decoding probed function from its head to the probe point.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
> Cc: Roland McGrath <roland@redhat.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Vegard Nossum <vegard.nossum@gmail.com>
> ---
> 
>  arch/x86/kernel/kprobes.c |   69 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 69 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index b5b1848..80d493f 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -48,6 +48,7 @@
>  #include <linux/preempt.h>
>  #include <linux/module.h>
>  #include <linux/kdebug.h>
> +#include <linux/kallsyms.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/desc.h>
> @@ -55,6 +56,7 @@
>  #include <asm/uaccess.h>
>  #include <asm/alternative.h>
>  #include <asm/debugreg.h>
> +#include <asm/insn.h>
>  
>  void jprobe_return_end(void);
>  
> @@ -245,6 +247,71 @@ retry:
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
> +	/*
> +	 *  Basically, kp->ainsn.insn has an original instruction.
> +	 *  However, RIP-relative instruction can not do single-stepping
> +	 *  at different place, fix_riprel() tweaks the displacement of
> +	 *  that instruction. In that case, we can't recover the instruction
> +	 *  from the kp->ainsn.insn.
> +	 *
> +	 *  On the other hand, kp->opcode has a copy of the first byte of
> +	 *  the probed instruction, which is overwritten by int3. And
> +	 *  the instruction at kp->addr is not modified by kprobes except
> +	 *  for the first byte, we can recover the original instruction
> +	 *  from it and kp->opcode.
> +	 */
> +	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> +	buf[0] = kp->opcode;
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
> +	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
> +		return 0;
> +
> +	/* Decode instructions */
> +	addr = paddr - offset;
> +	while (addr < paddr) {
> +		kernel_insn_init(&insn, (void *)addr);
> +		insn_get_opcode(&insn);
> +
> +		/* Check if the instruction has been modified. */
> +		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION) {
> +			ret = recover_probed_instruction(buf, addr);



I'm confused about the reason of this recovering. Is it to remove
kprobes behind the current setting one in the current function?

If such cleanup is needed for whatever reason, I wonder what happens
to the corresponding kprobe structure, why isn't it using the arch_disarm_
helper to patch back?

(Questions that may prove my solid misunderstanding of the kprobes code ;-)

Frederic.

