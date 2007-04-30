Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbXD3Kar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbXD3Kar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbXD3K3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:43044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965509AbXD3K2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:14 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, ak@suse.de, rusty@rustcorp.com.au, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [38/40] x86: Jeremy Fitzhardinge <jeremy@goop.org>
Message-Id: <20070430102813.6E3B3151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
The other symbols used to delineate the alt-instructions sections have the
form __foo/__foo_end.  Rename parainstructions to match.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/i386/kernel/alternative.c   |    2 +-
 arch/i386/kernel/vmi.c           |   10 +++-------
 arch/i386/kernel/vmlinux.lds.S   |    4 ++--
 include/asm-i386/alternative.h   |    4 ++--
 include/asm-x86_64/alternative.h |    4 ++--
 5 files changed, 10 insertions(+), 14 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -399,6 +399,6 @@ void __init alternative_instructions(voi
 		alternatives_smp_switch(0);
 	}
 #endif
- 	apply_paravirt(__start_parainstructions, __stop_parainstructions);
+ 	apply_paravirt(__parainstructions, __parainstructions_end);
 	local_irq_restore(flags);
 }
Index: linux/arch/i386/kernel/vmi.c
===================================================================
--- linux.orig/arch/i386/kernel/vmi.c
+++ linux/arch/i386/kernel/vmi.c
@@ -73,10 +73,6 @@ static struct {
   	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
-/* XXX move this to alternative.h */
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
-
 /* Cached VMI operations */
 struct vmi_timer_ops vmi_timer_ops;
 
@@ -548,9 +544,9 @@ vmi_startup_ipi_hook(int phys_apicid, un
 }
 #endif
 
-static void vmi_set_lazy_mode(int mode)
+static void vmi_set_lazy_mode(enum paravirt_lazy_mode mode)
 {
-	static DEFINE_PER_CPU(int, lazy_mode);
+	static DEFINE_PER_CPU(enum paravirt_lazy_mode, lazy_mode);
 
 	if (!vmi_ops.set_lazy_mode)
 		return;
@@ -912,7 +908,7 @@ static inline int __init activate_vmi(vo
 	 * to do this before IRQs get reenabled.  Fortunately, it is
 	 * idempotent.
 	 */
-	apply_paravirt(__start_parainstructions, __stop_parainstructions);
+	apply_paravirt(__parainstructions, __parainstructions_end);
 
 	vmi_bringup();
 
Index: linux/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux/arch/i386/kernel/vmlinux.lds.S
@@ -166,9 +166,9 @@ SECTIONS
   }
   . = ALIGN(4);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
-  	__start_parainstructions = .;
+  	__parainstructions = .;
 	*(.parainstructions)
-  	__stop_parainstructions = .;
+  	__parainstructions_end = .;
   }
   /* .exit.text is discard at runtime, not link time, to deal with references
      from .altinstructions and .eh_frame */
Index: linux/include/asm-i386/alternative.h
===================================================================
--- linux.orig/include/asm-i386/alternative.h
+++ linux/include/asm-i386/alternative.h
@@ -124,8 +124,8 @@ static inline void
 apply_paravirt(struct paravirt_patch_site *start,
 	       struct paravirt_patch_site *end)
 {}
-#define __start_parainstructions NULL
-#define __stop_parainstructions NULL
+#define __parainstructions	NULL
+#define __parainstructions_end	NULL
 #endif
 
 #endif /* _I386_ALTERNATIVE_H */
Index: linux/include/asm-x86_64/alternative.h
===================================================================
--- linux.orig/include/asm-x86_64/alternative.h
+++ linux/include/asm-x86_64/alternative.h
@@ -142,8 +142,8 @@ void apply_paravirt(struct paravirt_patc
 static inline void
 apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
 {}
-#define __start_parainstructions NULL
-#define __stop_parainstructions NULL
+#define __parainstructions NULL
+#define __parainstructions_end NULL
 #endif
 
 #endif /* _X86_64_ALTERNATIVE_H */
