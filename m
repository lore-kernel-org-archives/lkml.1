Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXK0AQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXK0AQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936AbXK0AOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:37 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49132 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756956AbXK0AOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:31 -0500
Message-Id: <20071127001431.001048414@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:15 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       ak@suse.de
Subject: [patch 08/14] x86_32: Use generic percpu.h
Content-Disposition: inline; filename=x86_32_use_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_32 only provides a special way to obtain the local per cpu area offset
via x86_read_percpu. Otherwise it can fully use the generic handling.

Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: ak@suse.de
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/percpu_32.h |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

Index: linux-2.6/include/asm-x86/percpu_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_32.h	2007-11-22 17:33:35.194455426 -0800
+++ linux-2.6/include/asm-x86/percpu_32.h	2007-11-22 17:39:20.472955100 -0800
@@ -42,34 +42,22 @@
  */
 #ifdef CONFIG_SMP
 
-/* This is used for other cpus to find our section. */
-extern unsigned long __per_cpu_offset[];
-
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-/* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
-
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_indentifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]); }))
-
-#define __raw_get_cpu_var(var) (*({					\
-	extern int simple_indentifier_##var(void);			\
-	RELOC_HIDE(&per_cpu__##var, x86_read_percpu(this_cpu_off));	\
-}))
-
-#define __get_cpu_var(var) __raw_get_cpu_var(var)
+#define __my_cpu_offset x86_read_percpu(this_cpu_off)
 
 /* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
+
 #else  /* !SMP */
-#include <asm-generic/percpu.h>
+
 #define __percpu_seg ""
+
 #endif	/* SMP */
 
+#include <asm-generic/percpu.h>
+
+/* We can use this directly for local CPU (faster). */
+DECLARE_PER_CPU(unsigned long, this_cpu_off);
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);

-- 
