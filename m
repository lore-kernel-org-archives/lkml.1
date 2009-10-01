Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZJALgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZJALgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 07:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756447AbZJALgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 07:36:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445AbZJALgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 07:36:23 -0400
Date: Thu, 1 Oct 2009 13:36:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, ak@suse.de, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com
Subject: Re: [PATCH 2/4] jump label - base patch
Message-ID: <20091001113608.GB2962@elte.hu>
References: <cover.1253831945.git.jbaron@redhat.com> <98c4c0b11300ac3b7de3acb2096f8f34184b1457.1253831946.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98c4c0b11300ac3b7de3acb2096f8f34184b1457.1253831946.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> Base jump label patch which creates macros for jump patching. This 
> feature is dependent on gcc version >= 4.5
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  arch/x86/include/asm/jump_label.h |   27 +++++++++++
>  arch/x86/kernel/Makefile          |    2 +-
>  arch/x86/kernel/jump_label.c      |   92 +++++++++++++++++++++++++++++++++++++
>  include/asm-generic/vmlinux.lds.h |   11 ++++
>  include/linux/jump_label.h        |   53 +++++++++++++++++++++
>  5 files changed, 184 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/jump_label.h
>  create mode 100644 arch/x86/kernel/jump_label.c
>  create mode 100644 include/linux/jump_label.h
> 
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> new file mode 100644
> index 0000000..21a7b79
> --- /dev/null
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -0,0 +1,27 @@
> +#ifndef _ASM_X86_JUMP_LABEL_H
> +#define _ASM_X86_JUMP_LABEL_H
> +
> +#include <asm/nops.h>
> +
> +#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 5)
> +#define __HAVE_ARCH_JUMP_LABEL
> +#endif

that should be:

> +#if (__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 5))

Also, please use:

#if ...
# define
#endif

whitespace constructs to keep them more readable.

> +
> +#ifdef __HAVE_ARCH_JUMP_LABEL
> +
> +#define JUMP_LABEL(tag, label, cond)                                       \

(these spaces should be tabs)

> +	do {								   \
> +		static const char __jlstrtab_##tag[]                       \
> +		__used __attribute__((section("__jump_strings")))  = #tag; \
> +		asm goto ("1:"						   \
> +			"jmp %l[" #label "] \n\t"		           \
> +			".pushsection __jump_table,  \"a\" \n\t"	   \
> +			_ASM_PTR "1b, %l[" #label "], %c0, 0 \n\t"	   \
> +			".popsection \n\t"				   \
> +			: :  "i" (__jlstrtab_##tag) :  : label);	   \
> +	} while (0)
> +
> +#endif
> +
> +#endif
> +
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 91d4189..b6b3e42 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -32,7 +32,7 @@ GCOV_PROFILE_paravirt.o		:= n
>  obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
>  obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
>  obj-y			+= time.o ioport.o ldt.o dumpstack.o
> -obj-y			+= setup.o x86_init.o i8259.o irqinit.o
> +obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
>  obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
>  obj-$(CONFIG_X86_32)	+= probe_roms_32.o
>  obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> new file mode 100644
> index 0000000..207947d
> --- /dev/null
> +++ b/arch/x86/kernel/jump_label.c
> @@ -0,0 +1,92 @@
> +#include <linux/jump_label.h>
> +#include <linux/memory.h>
> +#include <linux/kprobes.h>
> +#include <linux/uaccess.h>
> +
> +#ifdef __HAVE_ARCH_JUMP_LABEL
> +
> +extern struct jump_entry __start___jump_table[];
> +extern struct jump_entry __stop___jump_table[];

externs should go into .h's.

> +
> +DEFINE_MUTEX(jump_label_mutex);

Shouldnt this code rely on text_mutex, which is our generic 'patch 
kernel text' exclusion primitive?

> +
> +union jump_code_union {
> +	char code[RELATIVEJUMP_SIZE];
> +	struct {
> +		char jump;
> +		int offset;
> +	} __attribute__((packed));
> +};
> +
> +void jump_label_transform(struct jump_entry *entry, enum jump_label_type type)
> +{
> +	union jump_code_union code;
> +	long jump_length;
> +	unsigned char opcode;
> +	size_t opcode_length;
> +
> +	if (entry->type == UNKOWN_JUMP) {
> +		if (probe_kernel_read(&opcode, (void *)entry->code, 1))
> +			BUG();

a BUG() is not nice. It results fewer decodable bug reports than a 
WARN_ON_ONCE().

> +
> +		if (opcode == 0xe9)
> +			entry->type = LONG_JUMP;
> +		else if (opcode == 0xeb)
> +			entry->type = SHORT_JUMP;
> +		else
> +			BUG();

ditto.

> +	}
> +
> +	if (entry->type == LONG_JUMP)
> +		opcode_length = 5;
> +	else
> +		opcode_length = 2;
> +
> +	if (type == JUMP_LABEL_ENABLE) {
> +		if (entry->type == SHORT_JUMP) {
> +			code.code[0] = 0xeb;
> +			code.code[1] = 0;
> +		} else {
> +			code.code[0] = 0xe9;
> +			code.offset = 0;
> +		}
> +	} else {
> +		jump_length = entry->target - (entry->code + opcode_length);
> +		if (entry->type == SHORT_JUMP) {
> +			if ((jump_length > 127 || jump_length < -128)) {
> +				BUG();
> +			}

WARN_ON_ONCE() again.

> +			code.code[0] = 0xeb;
> +			code.code[1] = (char)jump_length;
> +		} else {
> +			if ((jump_length > INT_MAX || jump_length < INT_MIN)) {
> +				BUG();
> +			}

ditto.

> +			code.code[0] = 0xe9;
> +			code.offset = jump_length;
> +		}
> +	}
> +
> +	mutex_lock(&text_mutex);
> +	text_poke_fixup((void *)entry->code, &code,
> +			opcode_length, (void *)entry->code + opcode_length);
> +	mutex_unlock(&text_mutex);

Note that here we take the text_mutex anyway. Can drop jump_label_mutex 
and take the text_mutex wider?

> +}
> +
> +int jump_label_update(const char *name, enum jump_label_type type)
> +{
> +	struct jump_entry *iter;
> +	
> +	mutex_lock(&jump_label_mutex);
> +	for (iter = __start___jump_table; iter < __stop___jump_table; iter++) {

how big can this table become, realistically, long term?

> +		if (!strcmp(name, iter->name)) {
> +			if (!(system_state == SYSTEM_RUNNING &&
> +					(init_kernel_text(iter->code))))
> +				jump_label_transform(iter, type);
> +		}
> +	}
> +	mutex_unlock(&jump_label_mutex);
> +	return 0;
> +}

We always seem to return 0 - should be void?

> +
> +#endif
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index e7eae37..d2f38e2 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -213,6 +213,7 @@
>  		*(__vermagic)		/* Kernel version magic */	\
>  		*(__markers_strings)	/* Markers: strings */		\
> 		*(__tracepoints_strings)/* Tracepoints: strings */	\
> +		*(__jump_strings)/* Jump: strings */	\
>  	}								\

inserted line does not follow existing style carefully enough.

>  									\
>  	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
> @@ -220,6 +221,8 @@
>  	}								\
>  									\
>  	BUG_TABLE							\
> +	JUMP_TABLE							\
> +									\
>  									\
>  	/* PCI quirks */						\
>  	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
> @@ -564,6 +567,14 @@
>  #define BUG_TABLE
>  #endif
>  
> +#define JUMP_TABLE							\
> +	. = ALIGN(8);							\
> +	__jump_table : AT(ADDR(__jump_table) - LOAD_OFFSET) {		\
> +		VMLINUX_SYMBOL(__start___jump_table) = .;		\
> +		*(__jump_table)						\
> +		VMLINUX_SYMBOL(__stop___jump_table) = .;			\
> +	}

ditto.

> +
>  #ifdef CONFIG_PM_TRACE
>  #define TRACEDATA							\
>  	. = ALIGN(4);							\
> diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
> new file mode 100644
> index 0000000..eb0a4ef
> --- /dev/null
> +++ b/include/linux/jump_label.h
> @@ -0,0 +1,53 @@
> +#ifndef _LINUX_JUMP_LABEL_H
> +#define _LINUX_JUMP_LABEL_H
> +
> +#include <asm/jump_label.h>
> +
> +struct jump_entry {
> +	unsigned long code;
> +	unsigned long target;
> +	char *name;
> +	unsigned long type;
> +};

please use new structure definition alignments like in 
include/linux/perf_event.h.

> +
> +enum jump_label_type {
> +	JUMP_LABEL_ENABLE,
> +	JUMP_LABEL_DISABLE
> +};

so 0 is enable and 1 is disable?

> +
> +enum jump_label_instruction {
> +	UNKOWN_JUMP,
> +	SHORT_JUMP,
> +	LONG_JUMP
> +};
> +
> +#ifdef __HAVE_ARCH_JUMP_LABEL
> +
> +extern int jump_label_update(const char *name, enum jump_label_type type);
> +
> +#define enable_jump_label(name) \
> +	jump_label_update(name, JUMP_LABEL_ENABLE);
> +
> +#define disable_jump_label(name) \
> +	jump_label_update(name, JUMP_LABEL_DISABLE);
> +
> +#else
> +
> +#define JUMP_LABEL(tag, label, cond)		\
> +	if (likely(!cond))			\
> +		goto label;
> +
> +static inline int enable_jump_label(const char *name, enum jump_label_type type)
> +{
> +	return 0;
> +}
> +
> +static inline int disable_jump_label(const char *name,
> +				     enum jump_label_type type)

just keep the prototype in a single line. (and ignore checkpatch for 
that one)

> +{
> +	return 0;
> +}
> +
> +#endif
> +
> +#endif
> -- 
> 1.6.2.5

	Ingo
