Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbXKTB0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbXKTB0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXKTBOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:17 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36905 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756238AbXKTBNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:41 -0500
Message-Id: <20071120011341.276721351@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:12 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 40/45] x86_64: Provide per_cpu_var definition
Content-Disposition: inline; filename=transit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There needs to be a way to determine the offset for the CPU ops of per cpu
variables. The offset is simply the address of the variable. But we do not
want to code ugly things like

 	CPU_READ(per_cpu__statistics)

in the core. So define a new helper per_cpu_var(var) that simply adds
the per_cpu__ prefix.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/percpu_64.h |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-19 16:17:21.477639855 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-19 16:17:23.942140438 -0800
@@ -14,29 +14,35 @@
 /* Legacy: lockdep in the core kernel uses this */
 #define per_cpu_offset(cpu) CPU_OFFSET(cpu)
 
+/*
+ * Needed in order to be able to pass per cpu variables to CPU_xx
+ * macros. Another solution may be to simply drop the prefix?
+ */
+#define per_cpu_var(var) per_cpu__##var
+
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name) \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
+    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu_var(name)
 
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		\
     __attribute__((__section__(".data.percpu.shared_aligned"))) \
-    __typeof__(type) per_cpu__##name				\
+    __typeof__(type) per_cpu_var(name)				\
     ____cacheline_internodealigned_in_smp
 
 #define DEFINE_PER_CPU_FIRST(type, name)			\
     __attribute__((__section__(".data.percpu.first")))		\
-    __typeof__(type) per_cpu__##name
+    __typeof__(type) per_cpu_var(name)
 
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
-	CPU_PTR(&per_cpu__##var, (cpu)); }))
+	CPU_PTR(&per_cpu_var(var), (cpu)); }))
 #define __get_cpu_var(var) (*({				\
 	extern int simple_identifier_##var(void);	\
-	THIS_CPU(&per_cpu__##var); }))
+	THIS_CPU(&per_cpu_var(var)); }))
 #define __raw_get_cpu_var(var) (*({			\
 	extern int simple_identifier_##var(void);	\
-	__THIS_CPU(&per_cpu__##var); }))
+	__THIS_CPU(&per_cpu_var(var)); }))
 
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\

-- 
