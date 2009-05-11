Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZEKPAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZEKPAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZEKO72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:59:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44487 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbZEKO71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:59:27 -0400
Message-ID: <4A083DAD.8000009@redhat.com>
Date: Mon, 11 May 2009 11:01:01 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip v5 2/7] kprobes: checks probe address is instruction
 boudary on x86
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004847.5505.37957.stgit@localhost.localdomain> <alpine.DEB.2.00.0905111011060.14976@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905111011060.14976@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 8 May 2009, Masami Hiramatsu wrote:
> 
>> Ensure safeness of inserting kprobes by checking whether the specified
>> address is at the first byte of a instruction on x86.
>> This is done by decoding probed function from its head to the probe point.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> ---
>>
>>  arch/x86/kernel/kprobes.c |   54 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 54 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
>> index 7b5169d..3d5e85f 100644
>> --- a/arch/x86/kernel/kprobes.c
>> +++ b/arch/x86/kernel/kprobes.c
>> @@ -48,12 +48,14 @@
>>  #include <linux/preempt.h>
>>  #include <linux/module.h>
>>  #include <linux/kdebug.h>
>> +#include <linux/kallsyms.h>
>>  
>>  #include <asm/cacheflush.h>
>>  #include <asm/desc.h>
>>  #include <asm/pgtable.h>
>>  #include <asm/uaccess.h>
>>  #include <asm/alternative.h>
>> +#include <asm/insn.h>
>>  
>>  void jprobe_return_end(void);
>>  
>> @@ -244,6 +246,56 @@ retry:
>>  	}
>>  }
>>  
>> +/* Recover the probed instruction at addr for further analysis. */
>> +static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
>> +{
>> +	struct kprobe *kp;
>> +	kp = get_kprobe((void *)addr);
>> +	if (!kp)
>> +		return -EINVAL;
>> +
> 
> I'm just doing a casual scan of the patch set.

Thank you!

> 
>> +	/*
>> +	 * Don't use p->ainsn.insn, which could be modified -- e.g.,
> 
> This comment talks about "p", what's that? It's not used in this function.

oops, this should be kp.

> 
>> +	 * by fix_riprel().
>> +	 */
>> +	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
>> +	buf[0] = kp->opcode;
> 
> Why is it OK to copy addr to "buf" and then rewrite the first character of 
> buf?  Does it have something to do with the above "p"?

Yes, each kprobe copied probed instruction to kp->ainsn.insn,
which is an executable buffer for single stepping.
So, basically, kp->ainsn.insn has an original instruction.
However, RIP-relative instruction can not do single-stepping
at different place, fix_riprel() tweaks the displacement of
that instruction. In that case, we can't recover the instruction
from the kp->ainsn.insn.

On the other hand, kp->opcode has a copy of the first byte of
the probed instruction, which is overwritten by int3. And
the instruction at kp->addr is not modified by kprobes except
for the first byte, we can recover the original instruction
from it and kp->opcode.

> I don't mean to be critical here, but I've been doing "Mother Day" 
> activities all weekend and for some reason that was also the best time for 
> everyone to Cc me on patches. I'm way behind in my email, and it would be 
> nice if the comments described why things that "look" wrong are not.
> 
> 
>> +	return 0;
>> +}
>> +
>> +/* Dummy buffers for kallsyms_lookup */
>> +static char __dummy_buf[KSYM_NAME_LEN];
>> +
>> +/* Check if paddr is at an instruction boundary */
>> +static int __kprobes can_probe(unsigned long paddr)
>> +{
>> +	int ret;
>> +	unsigned long addr, offset = 0;
>> +	struct insn insn;
>> +	kprobe_opcode_t buf[MAX_INSN_SIZE];
>> +
>> +	/* Lookup symbol including addr */
> 
> The above comment is very close to a "add one to i" for i++ type of 
> comment.

Agreed.

> 
>> +	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
>> +		return 0;
>> +
>> +	/* Decode instructions */
>> +	addr = paddr - offset;
>> +	while (addr < paddr) {
>> +		insn_init_kernel(&insn, (void *)addr);
>> +		insn_get_opcode(&insn);
>> +		if (OPCODE1(&insn) == BREAKPOINT_INSTRUCTION) {
>> +			ret = recover_probed_instruction(buf, addr);
> 
> Oh, the above puts back the original op code. That is why it is OK?

Oops, no. I have to use get_kprobe() instead. Thanks!

> 
> I'd comment that a little bit more. Just so that reviewers have an easier 
> idea of what is happening.
> 
>> +			if (ret)
>> +				return 0;
>> +			insn_init_kernel(&insn, buf);
> 
> insn_init_kernel? Is that like a text poke or something?

it's a wrapper of insn_init() which initialize struct insn.

Thank you,

>> +		}
>> +		insn_get_length(&insn);
>> +		addr += insn.length;
>> +	}
>> +
>> +	return (addr == paddr);
>> +}
>> +
>>  /*
>>   * Returns non-zero if opcode modifies the interrupt flag.
>>   */
>> @@ -359,6 +411,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
>>  
>>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>>  {
>> +	if (!can_probe((unsigned long)p->addr))
>> +		return -EILSEQ;
>>  	/* insn: must be on special executable page on x86. */
>>  	p->ainsn.insn = get_insn_slot();
> 
> Oh look, I found the phantom "p"!
> 
> -- Steve
> 
>>  	if (!p->ainsn.insn)
>>
>>
>> -- 
>> Masami Hiramatsu
>>
>> Software Engineer
>> Hitachi Computer Products (America) Inc.
>> Software Solutions Division
>>
>> e-mail: mhiramat@redhat.com
>>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

