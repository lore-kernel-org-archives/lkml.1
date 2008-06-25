Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYFYEtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYFYEtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYFYEhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:53 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37498 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754991AbYFYEhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 36 of 36] x86_64/paravirt: Make load_gs_index() a paravirt
	operation
X-Mercurial-Node: 30130237d2ea98577dd4abce1a4916f86eee7531
Message-Id: <30130237d2ea98577dd4.1214367572@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:32 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_64.S |    4 ++--
 arch/x86/kernel/paravirt.c |    3 +++
 include/asm-x86/elf.h      |    2 +-
 include/asm-x86/paravirt.h |   10 ++++++++++
 include/asm-x86/system.h   |    3 ++-
 5 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1080,7 +1080,7 @@
 	
        /* Reload gs selector with exception handling */
        /* edi:  new selector */ 
-ENTRY(load_gs_index)
+ENTRY(native_load_gs_index)
 	CFI_STARTPROC
 	pushf
 	CFI_ADJUST_CFA_OFFSET 8
@@ -1094,7 +1094,7 @@
 	CFI_ADJUST_CFA_OFFSET -8
         ret
 	CFI_ENDPROC
-ENDPROC(load_gs_index)
+ENDPROC(native_load_gs_index)
        
         .section __ex_table,"a"
         .align 8
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -331,6 +331,9 @@
 	.store_idt = native_store_idt,
 	.store_tr = native_store_tr,
 	.load_tls = native_load_tls,
+#ifdef CONFIG_X86_64
+	.load_gs_index = native_load_gs_index,
+#endif
 	.write_ldt_entry = native_write_ldt_entry,
 	.write_gdt_entry = native_write_gdt_entry,
 	.write_idt_entry = native_write_idt_entry,
diff --git a/include/asm-x86/elf.h b/include/asm-x86/elf.h
--- a/include/asm-x86/elf.h
+++ b/include/asm-x86/elf.h
@@ -83,9 +83,9 @@
 	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
 
 #include <asm/processor.h>
+#include <asm/system.h>
 
 #ifdef CONFIG_X86_32
-#include <asm/system.h>		/* for savesegment */
 #include <asm/desc.h>
 
 #define elf_check_arch(x)	elf_check_arch_ia32(x)
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -115,6 +115,9 @@
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
 	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
+#ifdef CONFIG_X86_64
+	void (*load_gs_index)(unsigned int idx);
+#endif
 	void (*write_ldt_entry)(struct desc_struct *ldt, int entrynum,
 				const void *desc);
 	void (*write_gdt_entry)(struct desc_struct *,
@@ -848,6 +851,13 @@
 	PVOP_VCALL2(pv_cpu_ops.load_tls, t, cpu);
 }
 
+#ifdef CONFIG_X86_64
+static inline void load_gs_index(unsigned int gs)
+{
+	PVOP_VCALL1(pv_cpu_ops.load_gs_index, gs);
+}
+#endif
+
 static inline void write_ldt_entry(struct desc_struct *dt, int entry,
 				   const void *desc)
 {
diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -140,7 +140,7 @@
 #define set_base(ldt, base) _set_base(((char *)&(ldt)) , (base))
 #define set_limit(ldt, limit) _set_limit(((char *)&(ldt)) , ((limit)-1))
 
-extern void load_gs_index(unsigned);
+extern void native_load_gs_index(unsigned);
 
 /*
  * Load a segment. Fall back on loading the zero
@@ -286,6 +286,7 @@
 #ifdef CONFIG_X86_64
 #define read_cr8()	(native_read_cr8())
 #define write_cr8(x)	(native_write_cr8(x))
+#define load_gs_index   native_load_gs_index
 #endif
 
 /* Clear the 'TS' bit */


