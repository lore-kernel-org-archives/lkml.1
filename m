Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZFXGsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZFXGsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZFXGqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:46:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:57117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbZFXGqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:46:34 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 07/10] percpu: implement optional weak percpu definitions
Date: Wed, 24 Jun 2009 15:45:21 +0900
Message-Id: <1245825924-30412-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245825924-30412-1-git-send-email-tj@kernel.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 06:45:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some archs (alpha and s390) need to use weak definitions for percpu
variables in modules so that the compiler generates external
references for them.

This patch implements weak percpu definitions which arch can enable by
defining ARCH_NEEDS_WEAK_PER_CPU in arch percpu header file.  This
weak definition adds the following two restrictions on percpu variable
definitions.

  1. percpu symbols must be unique whether static or not
  2. percpu variables can't be defined inside a function

To ensure that these restrictions are observed in generic code, config
option DEBUG_FORCE_WEAK_PER_CPU enables weak percpu definitions for
all cases.

This patch is inspired by Ivan Kokshaysky's alpha percpu patch.

[ Impact: stricter rules for percpu variables, one more debug config option ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 include/linux/percpu-defs.h |   65 +++++++++++++++++++++++++++++++++++++------
 lib/Kconfig.debug           |   15 ++++++++++
 2 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 8f921d7..cf32838 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -10,21 +10,68 @@
 /*
  * Base implementations of per-CPU variable declarations and definitions, where
  * the section in which the variable is to be placed is provided by the
- * 'section' argument.  This may be used to affect the parameters governing the
+ * 'sec' argument.  This may be used to affect the parameters governing the
  * variable's storage.
  *
  * NOTE!  The sections for the DECLARE and for the DEFINE must match, lest
  * linkage errors occur due the compiler generating the wrong code to access
  * that section.
  */
-#define DECLARE_PER_CPU_SECTION(type, name, section)			\
-	extern								\
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SECTION(type, name, section)			\
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+#define __PCPU_ATTRS(sec)						\
+	__attribute__((section(PER_CPU_BASE_SECTION sec)))		\
+	PER_CPU_ATTRIBUTES
+
+#define __PCPU_DUMMY_ATTRS						\
+	__attribute__((section(".discard"), unused))
+
+/*
+ * s390 and alpha modules require percpu variables to be defined as
+ * weak to force the compiler to generate GOT based external
+ * references for them.  This is necessary because percpu sections
+ * will be located outside of the usually addressable area.
+ *
+ * This definition puts the following two extra restrictions when
+ * defining percpu variables.
+ *
+ * 1. The symbol must be globally unique, even the static ones.
+ * 2. Static percpu variables cannot be defined inside a function.
+ *
+ * Archs which need weak percpu definitions should define
+ * ARCH_NEEDS_WEAK_PER_CPU in asm/percpu.h when necessary.
+ *
+ * To ensure that the generic code observes the above two
+ * restrictions, if CONFIG_DEBUG_FORCE_WEAK_PER_CPU is set weak
+ * definition is used for all cases.
+ */
+#if defined(ARCH_NEEDS_WEAK_PER_CPU) || defined(CONFIG_DEBUG_FORCE_WEAK_PER_CPU)
+/*
+ * __pcpu_scope_* dummy variable is used to enforce scope.  It
+ * receives the static modifier when it's used in front of
+ * DEFINE_PER_CPU() and will trigger build failure if
+ * DECLARE_PER_CPU() is used for the same variable.
+ *
+ * __pcpu_unique_* dummy variable is used to enforce symbol uniqueness
+ * such that hidden weak symbol collision, which will cause unrelated
+ * variables to share the same address, can be detected during build.
+ */
+#define DECLARE_PER_CPU_SECTION(type, name, sec)			\
+	extern __PCPU_DUMMY_ATTRS char __pcpu_scope_##name;		\
+	extern __PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name
+
+#define DEFINE_PER_CPU_SECTION(type, name, sec)				\
+	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\
+	__PCPU_DUMMY_ATTRS char __pcpu_unique_##name;			\
+	__PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name
+#else
+/*
+ * Normal declaration and definition macros.
+ */
+#define DECLARE_PER_CPU_SECTION(type, name, sec)			\
+	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
+
+#define DEFINE_PER_CPU_SECTION(type, name, sec)				\
+	__PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
+#endif
 
 /*
  * Variant on the per-CPU variable declaration/definition theme used for
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 23067ab..77e0d8b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -777,6 +777,21 @@ config DEBUG_BLOCK_EXT_DEVT
 
 	  Say N if you are unsure.
 
+config DEBUG_FORCE_WEAK_PER_CPU
+	bool "Force weak per-cpu definitions"
+	depends on DEBUG_KERNEL
+	help
+	  s390 and alpha require percpu variables in modules to be
+	  defined weak to work around addressing range issue which
+	  puts the following two restrictions on percpu variable
+	  definitions.
+
+	  1. percpu symbols must be unique whether static or not
+	  2. percpu variables can't be defined inside a function
+
+	  To ensure that generic code follows the above rules, this
+	  option forces all percpu variables to be defined as weak.
+
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_KERNEL
-- 
1.6.0.2

