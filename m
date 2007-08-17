Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbXHQWEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbXHQWEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbXHQWE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:04:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbXHQWEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:04:25 -0400
Date: Fri, 17 Aug 2007 15:03:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: ananth@in.ibm.com, prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com,
       Jim Keniston <jkenisto@us.ibm.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][kprobes] support kretprobe-blacklist
Message-Id: <20070817150348.0f2f54da.akpm@linux-foundation.org>
In-Reply-To: <46C5FA48.2050308@redhat.com>
References: <46C5FA48.2050308@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007 15:43:04 -0400
Masami Hiramatsu <mhiramat@redhat.com> wrote:

> This patch introduces architecture dependent kretprobe
> blacklists to prohibit users from inserting return
> probes on the function in which kprobes can be inserted
> but kretprobes can not.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> 
> ---
>  <Problem Description>
> When a kretprobe is inserted in the entry of the "__switch_to()",
> it causes kernel panic on i386 with recent kernel.
> 
>  <Problem Analysis>
> In include/asm-i386/current.h, "current" is defined as an entry of
> percpu variables.:
> 
>  DECLARE_PER_CPU(struct task_struct *, current_task);
>  static __always_inline struct task_struct *get_current(void)
>  {
>          return x86_read_percpu(current_task);
>  }
> 
>  #define current get_current()
> 
> This mean the "current" macro is separated from its stack register.
> Kretprobe expects that "current" value when a function is called is
> not changed, or both of "current" value and stack register are changed in
> the target function.
> But __switch_to() in arch/i386/kernel/process.c changes only the value of
> "current", but doesn't changes the stack register(this was already switched
> to new stack before calling __switch_to()):
> 
>  struct task_struct fastcall * __switch_to(struct task_struct *prev_p, struct
>  task_struct *next_p)
>  {
>  	...
>         x86_write_percpu(current_task, next_p);
> 
>         return prev_p;
>  }
> 
> Kretprobe modifies the return address stored in the stack, and
> it saves the original return address in the kretprobe_instance with
> the value of "current".
> When kretprobe is hit at the return of __switch_to(), it searches
> kretprobe_instance related to the probe point from a hash list by
> using the hash-value of the "current" instead of stack address.
> However, since the value of "current" is already changed,
> it can't find proper instance, and invokes BUG() macro.
> 
>  <Solution>
> As a result of discussion with other kprobe developers, I'd
> like to introduce arch-dependent blacklist.
> To introduce "__kretprobes" mark (like "__kprobes") is another way.
> But I thought it is not efficient way, because the kretprobe can
> be inserted only in the entry of functions and there is no need to
> check against a whole function.
> 
> This patch also removes "__kprobes" mark from "__switch_to" on x86_64
> and registers "__switch_to" to the blacklist on x86-64, because that mark
> is to prohibit user from inserting only kretprobe.
> 
> Index: 2.6-mm/include/asm-i386/kprobes.h
> ===================================================================
> --- 2.6-mm.orig/include/asm-i386/kprobes.h
> +++ 2.6-mm/include/asm-i386/kprobes.h
> @@ -44,6 +44,7 @@ typedef u8 kprobe_opcode_t;
> 
>  #define ARCH_SUPPORTS_KRETPROBES
>  #define flush_insn_slot(p)	do { } while (0)
> +#define ARCH_SUPPORTS_KRETPROBE_BLACKLIST

Can we avoid adding this please?

It should at least have been a CONFIG_foo thing, defined in arch/*/Kconfig.

But that still requires nasty ifdefs in the C code.  It would be very small
overhead just to require that all architectures implement
arch_kretprobe_blacklist[] (which can be renamed to kretprobe_blacklist[]).
 Architectures which don't need a blacklist can just have { { 0, 0 } }.

If the few bytes of overhead on non-x86 really offends then one could do
something like this:

in powerpc header file:

#define kretprobe_blacklist_size 0

in x86 header file:

extern const int kretprobe_blacklist_size;

in x86 C file:

const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);

and then this code:

> --- 2.6-mm.orig/kernel/kprobes.c
> +++ 2.6-mm/kernel/kprobes.c
> @@ -716,6 +716,18 @@ int __kprobes register_kretprobe(struct
>  	int ret = 0;
>  	struct kretprobe_instance *inst;
>  	int i;
> +#ifdef ARCH_SUPPORTS_KRETPROBE_BLACKLIST
> +	void *addr = rp->kp.addr;
> +
> +	if (addr == NULL)
> +		kprobe_lookup_name(rp->kp.symbol_name, addr);
> +	addr += rp->kp.offset;
> +
> +	for (i = 0; arch_kretprobe_blacklist[i].name != NULL; i++) {
> +		if (arch_kretprobe_blacklist[i].addr == addr)
> +			return -EINVAL;
> +	}
> +#endif

can be put inside

	if (kretprobe_blacklist_size) {
		...
	}

so the compiler will remove it all for (say) powerpc.

There are lots of ways of doing it but code like this:

> 
> +#ifdef ARCH_SUPPORTS_KRETPROBE_BLACKLIST
> +	/* lookup the function address from its name */
> +	for (i = 0; arch_kretprobe_blacklist[i].name != NULL; i++) {
> +		kprobe_lookup_name(arch_kretprobe_blacklist[i].name,
> +				   arch_kretprobe_blacklist[i].addr);
> +		if (!arch_kretprobe_blacklist[i].addr)
> +			printk("kretprobe: Unknown blacklisted function: %s\n",
> +			       arch_kretprobe_blacklist[i].name);
> +	}
> +#endif

really isn't the sort of thing we like to see spreading through core kernel
code.

Have a think about it please, see what we can come up with?
