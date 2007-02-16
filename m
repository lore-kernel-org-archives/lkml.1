Return-Path: <linux-kernel-owner+w=401wt.eu-S1945939AbXBPPrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945939AbXBPPrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945941AbXBPPrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:47:25 -0500
Received: from raven.upol.cz ([158.194.120.4]:60800 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945939AbXBPPrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:47:24 -0500
Date: Fri, 16 Feb 2007 16:55:27 +0100
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, olecom@flower.upol.cz
Subject: [pp] kbuild: lguest with private asm-offsets (and some bloat)
Message-ID: <20070216155527.GA14687@flower.upol.cz>
References: <1171012296.2718.26.camel@localhost.localdomain> <1171012761.2718.40.camel@localhost.localdomain> <1171012827.2718.42.camel@localhost.localdomain> <200702091109.20061.ak@muc.de> <1171024771.2718.129.camel@localhost.localdomain> <20070209141728.GA26749@uranus.ravnborg.org> <1171034599.2718.190.camel@localhost.localdomain> <E1HGbJz-0003Lc-6h@flower> <1171323696.19842.29.camel@localhost.localdomain> <20070213031044.GA17046@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213031044.GA17046@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 04:10:44AM +0100, Oleg Verych wrote:
[]
> 
> Proposition will follow.
> 
[]

[patch proposition] kbuild: lguest with private asm-offsets

 * added some bloat to lguest's Makefile:
   - lguest doesn't rebuild, if not changed (due to FORCED implicit %o:%S),
   - support of kbuild's queit/nonquiet commands,
   - (hopefully) more readable and clear build process,
   - private asm-offsets,

 * some whitespace was killed,

 * needs "asm-offsets magic demystified, generalized".

Done on top of first lkml post of lguest.

pp-by: Oleg Verych
---
 arch/i386/kernel/asm-offsets.c |  23 +-----------------
 arch/i386/lguest/Makefile      |  40 +++++++++++++++++++++++++++++---
 arch/i386/lguest/asm-offsets.c |  31 +++++++++++++++++++++++++
 arch/i386/lguest/hypervisor.S  |   8 +++---
 
 4 files changed, 73 insertions(+), 29 deletions(-)

Index: linux-2.6.20/arch/i386/lguest/Makefile
===================================================================
--- linux-2.6.20.orig/arch/i386/lguest/Makefile	2007-02-16 15:32:51.665149000 +0100
+++ linux-2.6.20/arch/i386/lguest/Makefile	2007-02-16 16:16:48.525942500 +0100
@@ -1,2 +1,6 @@
+#
+# i386/lguest/Makefile
+#
+
 # Guest requires the paravirt_ops replacement and the bus driver.
 obj-$(CONFIG_LGUEST_GUEST) += lguest.o lguest_bus.o
@@ -7,4 +11,6 @@ lg-objs := core.o hypercalls.o page_tabl
 	segments.o io.o lguest_user.o
 
+asm-offsets-lg := $(objtree)/include/asm/asm-offsets-lg.h
+
 # We use top 4MB for guest traps page, then hypervisor. */
 HYPE_ADDR := (0xFFC00000+4096)
@@ -13,10 +19,36 @@ HYPE_DATA_SIZE := 1024
 CFLAGS += -DHYPE_ADDR="$(HYPE_ADDR)" -DHYPE_DATA_SIZE="$(HYPE_DATA_SIZE)"
 
+LD_HYPE_DATA := $(shell printf %\#x $$(($(HYPE_ADDR))))
+LD_HYPE_TEXT := $(shell printf %\#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE))))
+
+quiet_cmd_ld_hyber = LD [H]  $@
+      cmd_ld_hyber = $(LD) -static -Tdata=$(LD_HYPE_DATA) \
+				   -Ttext=$(LD_HYPE_TEXT) -o $@ $<
+cmd_objcopy = $(OBJCOPY) -O binary $@
+
+quiet_cmd_blob = BLOB    $@
+      cmd_blob = od -tx1 -An -v $< | sed -e 's/^ /0x/' \
+					 -e 's/$$/,/' -e 's/ /,0x/g' > $@
+quiet_cmd_offsets = GEN     $@
+      cmd_offsets = $(srctree)/scripts/mkCconstants $< $@
+
 $(obj)/core.o: $(obj)/hypervisor-blob.c
+
+$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
+	$(call cmd,blob)
+
 # This links the hypervisor in the right place and turns it into a C array.
 $(obj)/hypervisor-raw: $(obj)/hypervisor.o
-	@$(LD) -static -Tdata=`printf %#x $$(($(HYPE_ADDR)))` -Ttext=`printf %#x $$(($(HYPE_ADDR)+$(HYPE_DATA_SIZE)))` -o $@ $< && $(OBJCOPY) -O binary $@
-$(obj)/hypervisor-blob.c: $(obj)/hypervisor-raw
-	@od -tx1 -An -v $< | sed -e 's/^ /0x/' -e 's/$$/,/' -e 's/ /,0x/g' > $@
+	$(call if_changed,ld_hyber)
+	$(call cmd,objcopy)
+
+$(obj)/hypervisor.o: $(src)/hypervisor.S $(asm-offsets-lg)
+	$(call if_changed_dep,as_o_S)
+
+$(asm-offsets-lg): $(obj)/asm-offsets.s
+	$(call cmd,offsets)
+
+$(obj)/asm-offsets.s: $(src)/asm-offsets.c
+	$(call if_changed_dep,cc_s_c)
 
-clean-files := hypervisor-blob.c hypervisor-raw
+clean-files := $(asm-offsets-lg) hypervisor-blob.c hypervisor-raw
Index: linux-2.6.20/arch/i386/lguest/asm-offsets.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.20/arch/i386/lguest/asm-offsets.c	2007-02-16 16:03:10.410813500 +0100
@@ -0,0 +1,31 @@
+/*
+ * lguest's "private"
+ */
+
+#include <linux/sched.h>
+#include <asm/lguest.h>
+#include "../lguest/lg.h"
+
+#define DEFINE(sym, val) \
+	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+
+#define BLANK() asm volatile("\n->" : : )
+
+#define OFFSET(sym, str, mem) \
+	DEFINE(sym, offsetof(struct str, mem));
+
+void fell_lguest(void)
+{
+	BLANK();
+	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
+	OFFSET(LGUEST_STATE_host_stackptr, lguest_state, host.stackptr);
+	OFFSET(LGUEST_STATE_host_pgdir, lguest_state, host.pgdir);
+	OFFSET(LGUEST_STATE_host_gdt, lguest_state, host.gdt);
+	OFFSET(LGUEST_STATE_host_idt, lguest_state, host.idt);
+	OFFSET(LGUEST_STATE_regs, lguest_state, regs);
+	OFFSET(LGUEST_STATE_gdt, lguest_state, gdt);
+	OFFSET(LGUEST_STATE_idt, lguest_state, idt);
+	OFFSET(LGUEST_STATE_gdt_table, lguest_state, gdt_table);
+	OFFSET(LGUEST_STATE_trapnum, lguest_state, regs.trapnum);
+	OFFSET(LGUEST_STATE_errcode, lguest_state, regs.errcode);
+}

Index: linux-2.6.20/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux-2.6.20.orig/arch/i386/kernel/asm-offsets.c	2007-02-16 16:02:11.155110250 +0100
+++ linux-2.6.20/arch/i386/kernel/asm-offsets.c	2007-02-16 16:03:52.697456250 +0100
@@ -17,11 +17,7 @@
 #include <asm/elf.h>
 #include <asm/pda.h>
-#ifdef CONFIG_LGUEST_GUEST
-#include <asm/lguest.h>
-#include "../lguest/lg.h"
-#endif
 
 #define DEFINE(sym, val) \
-        asm volatile("\n->" #sym " %0 " #val : : "i" (val))
+	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
 
 #define BLANK() asm volatile("\n->" : : )
@@ -104,5 +100,5 @@ void foo(void)
 
 	BLANK();
- 	OFFSET(PDA_cpu, i386_pda, cpu_number);
+	OFFSET(PDA_cpu, i386_pda, cpu_number);
 	OFFSET(PDA_pcurrent, i386_pda, pcurrent);
 
@@ -116,18 +112,3 @@ void foo(void)
 	OFFSET(PARAVIRT_read_cr0, paravirt_ops, read_cr0);
 #endif
-
-#ifdef CONFIG_LGUEST_GUEST
-	BLANK();
-	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
-	OFFSET(LGUEST_STATE_host_stackptr, lguest_state, host.stackptr);
-	OFFSET(LGUEST_STATE_host_pgdir, lguest_state, host.pgdir);
-	OFFSET(LGUEST_STATE_host_gdt, lguest_state, host.gdt);
-	OFFSET(LGUEST_STATE_host_idt, lguest_state, host.idt);
-	OFFSET(LGUEST_STATE_regs, lguest_state, regs);
-	OFFSET(LGUEST_STATE_gdt, lguest_state, gdt);
-	OFFSET(LGUEST_STATE_idt, lguest_state, idt);
-	OFFSET(LGUEST_STATE_gdt_table, lguest_state, gdt_table);
-	OFFSET(LGUEST_STATE_trapnum, lguest_state, regs.trapnum);
-	OFFSET(LGUEST_STATE_errcode, lguest_state, regs.errcode);
-#endif
 }
Index: linux-2.6.20/arch/i386/lguest/hypervisor.S
===================================================================
--- linux-2.6.20.orig/arch/i386/lguest/hypervisor.S	2007-02-16 16:09:02.620825250 +0100
+++ linux-2.6.20/arch/i386/lguest/hypervisor.S	2007-02-16 16:13:19.548882250 +0100
@@ -2,5 +2,5 @@
    Layout is: default_idt_entries (1k), then switch_to_guest entry point. */
 #include <linux/linkage.h>
-#include <asm/asm-offsets.h>
+#include <asm/asm-offsets-lg.h>
 #include "lg.h"
 
@@ -104,5 +104,5 @@ switch_to_guest:
 	popl	%es;							\
 	popl	%ss
-	
+
 /* Return to run_guest_once. */
 return_to_host:
@@ -151,5 +151,5 @@ deliver_to_host_with_errcode:
  .endr
 .endm
-	
+
 /* We intercept every interrupt, because we may need to switch back to
  * host.  Unfortunately we can't tell them apart except by entry
@@ -158,5 +158,5 @@ deliver_to_host_with_errcode:
 irq_stubs:
 .data
-default_idt_entries:	
+default_idt_entries:
 .text
 	IRQ_STUBS 0 1 return_to_host		/* First two traps */
