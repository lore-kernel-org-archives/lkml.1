Return-Path: <linux-kernel-owner+w=401wt.eu-S1762221AbXHJWNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762221AbXHJWNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbXHJWBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:01:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760309AbXHJWBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:34 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 25/25 -v2] add paravirtualization support for x86_64
Date: Fri, 10 Aug 2007 16:12:37 -0300
Message-Id: <11867732811935-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867732763070-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com> <11867731882768-git-send-email-gcosta@redhat.com> <11867731932688-git-send-email-gcosta@redhat.com> <11867731981891-git-send-email-gcosta@redhat.com> <1186773203887-git-send-email-gcosta@redhat.com> <11867732082735-git-send-email-gcosta@redhat.com> <11867732121974-git-send-email-gcosta@redhat.com> <1186773217875-git-send-email-gcosta@redhat.com> <11867732221652-git-send-email-gcosta@redhat.com> <11867732273108-git-send-email-gcosta@redhat.com> <11867732323106-git-send-email-gcosta@redhat.com> <11867732373232-git-send-email-gcosta@redhat.com> <11867732424024-git-send-email-gcosta@redhat.com> <11867732461037-git-send-email-gcosta@redhat.com> <11867732511513-git-send-email!
 -gcosta@redhat.com> <11867732562020-git-send-email-gcosta@redhat.com> <1186773261537-git-send-email-gcosta@redhat.com> <11867732661840-git-send-email-gcosta@redhat.com> <11867732713519-git-send-email-gcosta@redhat.com> <11867732763070-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is finally, the patch we were all looking for. This
patch adds a paravirt.h header with the definition of paravirt_ops
struct. Also, it defines a bunch of inline functions that will
replace, or hook, the other calls. Every one of those functions
adds an entry in the parainstructions section (see vmlinux.lds.S).
Those entries can then be used to runtime-patch the paravirt_ops
functions.

paravirt.c contains implementations of paravirt functions that
are used natively, such as the native_patch. It also fill the
paravirt_ops structure with the whole lot of functions that
were (re)defined throughout this patch set.

There are also changes in asm-offsets.c. paravirt.h needs it
to find out the offsets into the structure of functions
such as irq_enable, used in assembly files.

[  updates from v1
   * make PARAVIRT hidden in Kconfig (Andi Kleen)
   * cleanups in paravirt.h (Andi Kleen)
   * modifications needed to accomodate other parts of the
   patch that changed, such as getting rid of ebda_info
   * put the integers at struct paravirt_ops at the end
   (Jeremy)
]
Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/Kconfig              |   11 +++++++++++
 arch/x86_64/kernel/Makefile      |    1 +
 arch/x86_64/kernel/asm-offsets.c |   14 ++++++++++++++
 arch/x86_64/kernel/vmlinux.lds.S |    6 ++++++
 include/asm-x86_64/smp.h         |    2 +-
 5 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index ffa0364..00b2fc9 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -373,6 +373,17 @@ config NODES_SHIFT
 
 # Dummy CONFIG option to select ACPI_NUMA from drivers/acpi/Kconfig.
 
+config PARAVIRT
+       bool
+       depends on EXPERIMENTAL
+       help
+         Paravirtualization is a way of running multiple instances of
+         Linux on the same machine, under a hypervisor.  This option
+         changes the kernel so it can modify itself when it is run
+         under a hypervisor, improving performance significantly.
+         However, when run without a hypervisor the kernel is
+         theoretically slower.  If in doubt, say N.
+
 config X86_64_ACPI_NUMA
        bool "ACPI NUMA detection"
        depends on NUMA
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index ff5d8c9..120467f 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_X86_VSMP)		+= vsmp.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
 
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
diff --git a/arch/x86_64/kernel/asm-offsets.c b/arch/x86_64/kernel/asm-offsets.c
index 778953b..f5eff70 100644
--- a/arch/x86_64/kernel/asm-offsets.c
+++ b/arch/x86_64/kernel/asm-offsets.c
@@ -15,6 +15,9 @@
 #include <asm/segment.h>
 #include <asm/thread_info.h>
 #include <asm/ia32.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -72,6 +75,17 @@ int main(void)
 	       offsetof (struct rt_sigframe32, uc.uc_mcontext));
 	BLANK();
 #endif
+#ifdef CONFIG_PARAVIRT
+#define ENTRY(entry) DEFINE(PARAVIRT_ ## entry, offsetof(struct paravirt_ops, entry))
+	ENTRY(paravirt_enabled);
+	ENTRY(irq_disable);
+	ENTRY(irq_enable);
+	ENTRY(syscall_return);
+	ENTRY(iret);
+	ENTRY(read_cr2);
+	ENTRY(swapgs);
+	BLANK();
+#endif
 	DEFINE(pbe_address, offsetof(struct pbe, address));
 	DEFINE(pbe_orig_address, offsetof(struct pbe, orig_address));
 	DEFINE(pbe_next, offsetof(struct pbe, next));
diff --git a/arch/x86_64/kernel/vmlinux.lds.S b/arch/x86_64/kernel/vmlinux.lds.S
index ba8ea97..c3fce85 100644
--- a/arch/x86_64/kernel/vmlinux.lds.S
+++ b/arch/x86_64/kernel/vmlinux.lds.S
@@ -185,6 +185,12 @@ SECTIONS
   .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 	*(.altinstr_replacement)
   }
+  . = ALIGN(8);
+  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
+  __parainstructions = .;
+	*(.parainstructions)
+  __parainstructions_end = .;
+  }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
   .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) { *(.exit.text) }
diff --git a/include/asm-x86_64/smp.h b/include/asm-x86_64/smp.h
index 6b11114..403901b 100644
--- a/include/asm-x86_64/smp.h
+++ b/include/asm-x86_64/smp.h
@@ -22,7 +22,7 @@ extern int disable_apic;
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 void native_flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
-						unsigned long va);
+							unsigned long va);
 #else
 #define startup_ipi_hook(apicid, rip, rsp) do { } while (0)
 #endif
-- 
1.4.4.2

