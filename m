Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXHQXKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXHQXKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 19:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXHQXKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 19:10:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbXHQXKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 19:10:21 -0400
Message-ID: <46C62A80.5040308@redhat.com>
Date: Fri, 17 Aug 2007 19:08:48 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ananth@in.ibm.com, prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][kprobes] support kretprobe-blacklist
References: <46C5FA48.2050308@redhat.com> <20070817150348.0f2f54da.akpm@linux-foundation.org>
In-Reply-To: <20070817150348.0f2f54da.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Thank you for comments.

Andrew Morton wrote:
>> Index: 2.6-mm/include/asm-i386/kprobes.h
>> ===================================================================
>> --- 2.6-mm.orig/include/asm-i386/kprobes.h
>> +++ 2.6-mm/include/asm-i386/kprobes.h
>> @@ -44,6 +44,7 @@ typedef u8 kprobe_opcode_t;
>>
>>  #define ARCH_SUPPORTS_KRETPROBES
>>  #define flush_insn_slot(p)	do { } while (0)
>> +#define ARCH_SUPPORTS_KRETPROBE_BLACKLIST
> 
> Can we avoid adding this please?

Yes, sure. I'll update my patch and eliminate those ifdefs.

> It should at least have been a CONFIG_foo thing, defined in arch/*/Kconfig.
> 
> But that still requires nasty ifdefs in the C code.  It would be very small
> overhead just to require that all architectures implement
> arch_kretprobe_blacklist[] (which can be renamed to kretprobe_blacklist[]).
>  Architectures which don't need a blacklist can just have { { 0, 0 } }.
> 
> If the few bytes of overhead on non-x86 really offends then one could do
> something like this:
> 
> in powerpc header file:
> 
> #define kretprobe_blacklist_size 0
> 
> in x86 header file:
> 
> extern const int kretprobe_blacklist_size;
> 
> in x86 C file:
> 
> const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);

It's looks very nice, thank you for the advice.
I think we can directly define "kretprobe_blacklist" as 0 in (for
example)ppc header instead of introducing "kretprobe_blacklist_size",
and check if "kretprobe_blacklist" is 0 or not in common code, is it OK?

> and then this code:
> 
>> --- 2.6-mm.orig/kernel/kprobes.c
>> +++ 2.6-mm/kernel/kprobes.c
>> @@ -716,6 +716,18 @@ int __kprobes register_kretprobe(struct
>>  	int ret = 0;
>>  	struct kretprobe_instance *inst;
>>  	int i;
>> +#ifdef ARCH_SUPPORTS_KRETPROBE_BLACKLIST
>> +	void *addr = rp->kp.addr;
>> +
>> +	if (addr == NULL)
>> +		kprobe_lookup_name(rp->kp.symbol_name, addr);
>> +	addr += rp->kp.offset;
>> +
>> +	for (i = 0; arch_kretprobe_blacklist[i].name != NULL; i++) {
>> +		if (arch_kretprobe_blacklist[i].addr == addr)
>> +			return -EINVAL;
>> +	}
>> +#endif
> 
> can be put inside
> 
> 	if (kretprobe_blacklist_size) {
> 		...
> 	}
> 
> so the compiler will remove it all for (say) powerpc.
>
> There are lots of ways of doing it but code like this:
> 
>> +#ifdef ARCH_SUPPORTS_KRETPROBE_BLACKLIST
>> +	/* lookup the function address from its name */
>> +	for (i = 0; arch_kretprobe_blacklist[i].name != NULL; i++) {
>> +		kprobe_lookup_name(arch_kretprobe_blacklist[i].name,
>> +				   arch_kretprobe_blacklist[i].addr);
>> +		if (!arch_kretprobe_blacklist[i].addr)
>> +			printk("kretprobe: Unknown blacklisted function: %s\n",
>> +			       arch_kretprobe_blacklist[i].name);
>> +	}
>> +#endif
> 
> really isn't the sort of thing we like to see spreading through core kernel
> code.
> 
> Have a think about it please, see what we can come up with?

OK, I see. I'll do that next time.

Best regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com
Tel: +1-978-392-2419
Tel: +1-508-982-2642 (cell phone)
Fax: +1-978-392-1001
