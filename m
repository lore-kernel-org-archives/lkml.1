Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbYENGbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbYENGbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYENGbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:31:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56660 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYENGbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:31:21 -0400
Date: Wed, 14 May 2008 08:30:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: acme@redhat.com, srostedt@redhat.com, linux-kernel@vger.kernel.org,
       Pekka Paalanen <pq@iki.fi>, Pavel Roskin <proski@gnu.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/2]: Add sparc64 ftrace support.
Message-ID: <20080514063055.GA21369@elte.hu>
References: <20080513.220652.24245811.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513.220652.24245811.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> This was a lot more trivial than I expected, about a 20 minute hack.  
> Most of the time was spent on test boots :)

applied, thanks David. Cool stuff! :-)

> The first patch removes the packed attribute from the ftrace_page blob 
> of dynamic ftrace entries, because not only does it cause unaligned 
> accesses on sparc64 it's also totally useless.

ok. It was so for purely histeric raisons, when we still tried to stuff 
it all into 32 bytes per trace entry, 3-4 years ago or so.

> The second patch adds sparc64 ftrace support.
> 
> One thing I noticed is that sparc64 uses an mcount implementation 
> already for a quick-and-dirty stack usage checker.  I tried to make 
> them live alongside eachother.

my thinking would be to perhaps also do an ftrace/max-stack plugin that 
would just measure the maximum stack footprint - coupled with emitting 
the stack trace itself to the trace buffer. This way we could measure 
the maximum stack footprint even of very yucky codepaths where we 
couldnt do a printk or other ad-hoc things.

While such an ftrace/max-stack plugin would be something very similar to 
and would reuse much of trace_functions.c, i think on the UI side it 
should be a separate tracer plugin. I.e. we could tell people "activate 
ftrace/max-stack" and they'd know what to do, and it would just do the 
right thing by default after a:

    echo max-stack > /debug/tracing/current_tracer

> Next, I think the mcount symbol export needs some tweaking.  On sparc, 
> the symbol _mcount is what the compiler references (this seems to be a 
> sparc sysv4'ism) whereas on x86 it appears that plain "mcount" is 
> used.  I provide both symbols and we already have a local export of 
> "_mcount" to take care of this.  I think architectures should deal 
> with this symbol exporting since it is different on every system.

ok, agreed, fixed this bug on x86 - see the first patch below.

[ also a patch integration detail: i took the liberty to move your 
  arch/sparc64/Kconfig's HAVE_FTRACE to the first spot of the SPARC64 
  select lines as per the second patch below - your patch had a conflict 
  against current mainline (which probably means you already changed 
  this file in your Sparc64 tree). By moving that entry to the first 
  line your tree and the ftrace tree should auto-merge just fine without 
  any conflicts. ]

btw., if you have any ftrace usability observations (or any observations 
about it), let us know. ftrace tries to be self-contained (no user-space 
tools required) and 'intuitive by default' - i.e. someone looking into 
/debug/tracing/ and at the trace output for the first time should find 
his way around and should be able to operate most of its functionality 
without much effort.

But there lies the minor complication: it is pretty hard for us ftrace 
developers to look into /debug/tracing/ "for the first time", so we rely 
on others to tell us their first impressions, to improve the code :-)

	Ingo

------------>
Subject: ftrace: fix mcount export bug
From: Ingo Molnar <mingo@elte.hu>
Date: Wed May 14 08:10:31 CEST 2008

David S. Miller noticed the following bug: the -pg instrumentation
function callback is named differently on each platform. On x86 it
is mcount, on sparc it is _mcount. So the export does not make sense
in kernel/trace/ftrace.c - move it to x86.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/i386_ksyms_32.c  |    3 +++
 arch/x86/kernel/x8664_ksyms_64.c |    3 +++
 kernel/trace/ftrace.c            |    3 ---
 3 files changed, 6 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/i386_ksyms_32.c
===================================================================
--- linux.orig/arch/x86/kernel/i386_ksyms_32.c
+++ linux/arch/x86/kernel/i386_ksyms_32.c
@@ -3,6 +3,9 @@
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 
+/* mcount is defined in assembly */
+EXPORT_SYMBOL(mcount);
+
 /* Networking helper routines. */
 EXPORT_SYMBOL(csum_partial_copy_generic);
 
Index: linux/arch/x86/kernel/x8664_ksyms_64.c
===================================================================
--- linux.orig/arch/x86/kernel/x8664_ksyms_64.c
+++ linux/arch/x86/kernel/x8664_ksyms_64.c
@@ -10,6 +10,9 @@
 #include <asm/pgtable.h>
 #include <asm/desc.h>
 
+/* mcount is defined in assembly */
+EXPORT_SYMBOL(mcount);
+
 EXPORT_SYMBOL(kernel_thread);
 
 EXPORT_SYMBOL(__get_user_1);
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c
+++ linux/kernel/trace/ftrace.c
@@ -50,9 +50,6 @@ static struct ftrace_ops ftrace_list_end
 static struct ftrace_ops *ftrace_list __read_mostly = &ftrace_list_end;
 ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 
-/* mcount is defined per arch in assembly */
-EXPORT_SYMBOL(mcount);
-
 void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op = ftrace_list;

------------------->
Subject: sparc64: add ftrace support.
From: David Miller <davem@davemloft.net>
Date: Tue, 13 May 2008 22:06:59 -0700 (PDT)

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/sparc64/Kconfig         |    1 
 arch/sparc64/Kconfig.debug   |    2 
 arch/sparc64/kernel/Makefile |    1 
 arch/sparc64/kernel/ftrace.c |   99 +++++++++++++++++++++++++++++++++++++++++++
 arch/sparc64/lib/mcount.S    |   58 +++++++++++++++++++++++--
 5 files changed, 156 insertions(+), 5 deletions(-)
 create mode 100644 arch/sparc64/kernel/ftrace.c

Index: linux/arch/sparc64/Kconfig
===================================================================
--- linux.orig/arch/sparc64/Kconfig
+++ linux/arch/sparc64/Kconfig
@@ -11,6 +11,7 @@ config SPARC
 config SPARC64
 	bool
 	default y
+	select HAVE_FTRACE
 	select HAVE_IDE
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
Index: linux/arch/sparc64/Kconfig.debug
===================================================================
--- linux.orig/arch/sparc64/Kconfig.debug
+++ linux/arch/sparc64/Kconfig.debug
@@ -33,7 +33,7 @@ config DEBUG_PAGEALLOC
 
 config MCOUNT
 	bool
-	depends on STACK_DEBUG
+	depends on STACK_DEBUG || FTRACE
 	default y
 
 config FRAME_POINTER
Index: linux/arch/sparc64/kernel/Makefile
===================================================================
--- linux.orig/arch/sparc64/kernel/Makefile
+++ linux/arch/sparc64/kernel/Makefile
@@ -14,6 +14,7 @@ obj-y		:= process.o setup.o cpu.o idprom
 		   power.o sbus.o sparc64_ksyms.o chmc.o \
 		   visemul.o prom.o of_device.o hvapi.o sstate.o mdesc.o
 
+obj-$(CONFIG_DYNAMIC_FTRACE) += ftrace.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-$(CONFIG_PCI)	 += ebus.o pci_common.o \
 			    pci_psycho.o pci_sabre.o pci_schizo.o \
Index: linux/arch/sparc64/kernel/ftrace.c
===================================================================
--- /dev/null
+++ linux/arch/sparc64/kernel/ftrace.c
@@ -0,0 +1,99 @@
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include <linux/ftrace.h>
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <linux/list.h>
+
+static const u32 ftrace_nop = 0x01000000;
+
+notrace int ftrace_ip_converted(unsigned long ip)
+{
+	u32 insn = *(u32 *) ip;
+
+	return (insn == ftrace_nop);
+}
+
+notrace unsigned char *ftrace_nop_replace(void)
+{
+	return (char *)&ftrace_nop;
+}
+
+notrace unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+{
+	static u32 call;
+	s32 off;
+
+	off = ((s32)addr - (s32)ip);
+	call = 0x40000000 | ((u32)off >> 2);
+
+	return (unsigned char *) &call;
+}
+
+notrace int
+ftrace_modify_code(unsigned long ip, unsigned char *old_code,
+		   unsigned char *new_code)
+{
+	u32 old = *(u32 *)old_code;
+	u32 new = *(u32 *)new_code;
+	u32 replaced;
+	int faulted;
+
+	__asm__ __volatile__(
+	"1:	cas	[%[ip]], %[old], %[new]\n"
+	"	flush	%[ip]\n"
+	"	mov	0, %[faulted]\n"
+	"2:\n"
+	"	.section .fixup,#alloc,#execinstr\n"
+	"	.align	4\n"
+	"3:	sethi	%%hi(2b), %[faulted]\n"
+	"	jmpl	%[faulted] + %%lo(2b), %%g0\n"
+	"	 mov	1, %[faulted]\n"
+	"	.previous\n"
+	"	.section __ex_table,\"a\"\n"
+	"	.align	4\n"
+	"	.word	1b, 3b\n"
+	"	.previous\n"
+	: "=r" (replaced), [faulted] "=r" (faulted)
+	: [new] "0" (new), [old] "r" (old), [ip] "r" (ip)
+	: "memory");
+
+	if (replaced != old && replaced != new)
+		faulted = 2;
+
+	return faulted;
+}
+
+notrace int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned long ip = (unsigned long)(&ftrace_call);
+	unsigned char old[4], *new;
+
+	memcpy(old, &ftrace_call, 4);
+	new = ftrace_call_replace(ip, (unsigned long)func);
+	return ftrace_modify_code(ip, old, new);
+}
+
+notrace int ftrace_mcount_set(unsigned long *data)
+{
+	unsigned long ip = (long)(&mcount_call);
+	unsigned long *addr = data;
+	unsigned char old[4], *new;
+
+	/*
+	 * Replace the mcount stub with a pointer to the
+	 * ip recorder function.
+	 */
+	memcpy(old, &mcount_call, 4);
+	new = ftrace_call_replace(ip, *addr);
+	*addr = ftrace_modify_code(ip, old, new);
+
+	return 0;
+}
+
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+	ftrace_mcount_set(data);
+	return 0;
+}
Index: linux/arch/sparc64/lib/mcount.S
===================================================================
--- linux.orig/arch/sparc64/lib/mcount.S
+++ linux/arch/sparc64/lib/mcount.S
@@ -28,10 +28,13 @@ ovstack:
 	.skip		OVSTACKSIZE
 #endif
 	.text
-	.align 32
-	.globl mcount, _mcount
-mcount:
+	.align		32
+	.globl		_mcount
+	.type		_mcount,#function
+	.globl		mcount
+	.type		mcount,#function
 _mcount:
+mcount:
 #ifdef CONFIG_STACK_DEBUG
 	/*
 	 * Check whether %sp is dangerously low.
@@ -55,6 +58,53 @@ _mcount:
 	 or		%g3, %lo(panicstring), %o0
 	call		prom_halt
 	 nop
+1:
+#endif
+#ifdef CONFIG_FTRACE
+#ifdef CONFIG_DYNAMIC_FTRACE
+	mov		%o7, %o0
+	.globl		mcount_call
+mcount_call:
+	call		ftrace_stub
+	 mov		%o0, %o7
+#else
+	sethi		%hi(ftrace_trace_function), %g1
+	sethi		%hi(ftrace_stub), %g2
+	ldx		[%g1 + %lo(ftrace_trace_function)], %g1
+	or		%g2, %lo(ftrace_stub), %g2
+	cmp		%g1, %g2
+	be,pn		%icc, 1f
+	 mov		%i7, %o1
+	jmpl		%g1, %g0
+	 mov		%o7, %o0
+	/* not reached */
+1:
+#endif
 #endif
-1:	retl
+	retl
 	 nop
+	.size		_mcount,.-_mcount
+	.size		mcount,.-mcount
+
+#ifdef CONFIG_FTRACE
+	.globl		ftrace_stub
+	.type		ftrace_stub,#function
+ftrace_stub:
+	retl
+	 nop
+	.size		ftrace_stub,.-ftrace_stub
+#ifdef CONFIG_DYNAMIC_FTRACE
+	.globl		ftrace_caller
+	.type		ftrace_caller,#function
+ftrace_caller:
+	mov		%i7, %o1
+	mov		%o7, %o0
+	.globl		ftrace_call
+ftrace_call:
+	call		ftrace_stub
+	 mov		%o0, %o7
+	retl
+	 nop
+	.size		ftrace_caller,.-ftrace_caller
+#endif
+#endif

