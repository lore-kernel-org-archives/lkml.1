Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbZDUWE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbZDUWE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 18:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757711AbZDUWDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 18:03:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbZDUWDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 18:03:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] PERCPU: Collect the DECLARE/DEFINE declarations together
To: torvalds@osdl.org, akpm@linux-foundation.org, mingo@elte.hu
Cc: dhowells@redhat.com, jeremy@goop.org, tglx@linutronix.de, hpa@zytor.com,
       tj@kernel.org, linux-kernel@vger.kernel.org, tony.luck@intel.com
Date: Tue, 21 Apr 2009 23:00:29 +0100
Message-ID: <20090421220029.5927.32727.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090421220024.5927.82550.stgit@warthog.procyon.org.uk>
References: <20090421220024.5927.82550.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect the DECLARE/DEFINE declarations together in linux/percpu-defs.h so
that they're in one place, and give them descriptive comments, particularly
the SHARED_ALIGNED variant.

It would be nice to collect these in linux/percpu.h, but that's not possible
without sorting out the severe #include recursion between the x86 arch headers
and the general headers (and possibly other arches too).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-generic/percpu.h |   26 +------------
 include/linux/percpu-defs.h  |   84 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/percpu.h       |   20 ----------
 3 files changed, 86 insertions(+), 44 deletions(-)
 create mode 100644 include/linux/percpu-defs.h


diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index af47b9e..d7d50d7 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -1,13 +1,9 @@
 #ifndef _ASM_GENERIC_PERCPU_H_
 #define _ASM_GENERIC_PERCPU_H_
+
 #include <linux/compiler.h>
 #include <linux/threads.h>
-
-/*
- * Determine the real variable name from the name visible in the
- * kernel sources.
- */
-#define per_cpu_var(var) per_cpu__##var
+#include <linux/percpu-defs.h>
 
 #ifdef CONFIG_SMP
 
@@ -101,22 +97,4 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_ATTRIBUTES
 #endif
 
-#define DECLARE_PER_CPU_SECTION(type, name, section)			\
-	extern \
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-
-#define DECLARE_PER_CPU(type, name)					\
-	DECLARE_PER_CPU_SECTION(type, name, "")
-
-#define DECLARE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
-	____cacheline_aligned_in_smp
-
-#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")
-
-#define DECLARE_PER_CPU_FIRST(type, name)				\
-	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
-
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
new file mode 100644
index 0000000..8f921d7
--- /dev/null
+++ b/include/linux/percpu-defs.h
@@ -0,0 +1,84 @@
+#ifndef _LINUX_PERCPU_DEFS_H
+#define _LINUX_PERCPU_DEFS_H
+
+/*
+ * Determine the real variable name from the name visible in the
+ * kernel sources.
+ */
+#define per_cpu_var(var) per_cpu__##var
+
+/*
+ * Base implementations of per-CPU variable declarations and definitions, where
+ * the section in which the variable is to be placed is provided by the
+ * 'section' argument.  This may be used to affect the parameters governing the
+ * variable's storage.
+ *
+ * NOTE!  The sections for the DECLARE and for the DEFINE must match, lest
+ * linkage errors occur due the compiler generating the wrong code to access
+ * that section.
+ */
+#define DECLARE_PER_CPU_SECTION(type, name, section)			\
+	extern								\
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+#define DEFINE_PER_CPU_SECTION(type, name, section)			\
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
+	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+
+/*
+ * Variant on the per-CPU variable declaration/definition theme used for
+ * ordinary per-CPU variables.
+ */
+#define DECLARE_PER_CPU(type, name)					\
+	DECLARE_PER_CPU_SECTION(type, name, "")
+
+#define DEFINE_PER_CPU(type, name)					\
+	DEFINE_PER_CPU_SECTION(type, name, "")
+
+/*
+ * Declaration/definition used for per-CPU variables that must come first in
+ * the set of variables.
+ */
+#define DECLARE_PER_CPU_FIRST(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
+
+/*
+ * Declaration/definition used for per-CPU variables that must be cacheline
+ * aligned under SMP conditions so that, whilst a particular instance of the
+ * data corresponds to a particular CPU, inefficiencies due to direct access by
+ * other CPUs are reduced by preventing the data from unnecessarily spanning
+ * cachelines.
+ *
+ * An example of this would be statistical data, where each CPU's set of data
+ * is updated by that CPU alone, but the data from across all CPUs is collated
+ * by a CPU processing a read from a proc file.
+ */
+#define DECLARE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
+	____cacheline_aligned_in_smp
+
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
+	____cacheline_aligned_in_smp
+
+/*
+ * Declaration/definition used for per-CPU variables that must be page aligned.
+ */
+#define DECLARE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, ".page_aligned")
+
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")
+
+/*
+ * Intermodule exports for per-CPU variables.
+ */
+#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
+#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
+
+
+#endif /* _LINUX_PERCPU_DEFS_H */
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index f052d81..1581ff2 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -9,26 +9,6 @@
 
 #include <asm/percpu.h>
 
-#define DEFINE_PER_CPU_SECTION(type, name, section)			\
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU(type, name)					\
-	DEFINE_PER_CPU_SECTION(type, name, "")
-
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
-	____cacheline_aligned_in_smp
-
-#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")
-
-#define DEFINE_PER_CPU_FIRST(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
-
-#define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
-#define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-
 /* enough to cover all DEFINE_PER_CPUs in modules */
 #ifdef CONFIG_MODULES
 #define PERCPU_MODULE_RESERVE		(8 << 10)

