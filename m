Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZF1AvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZF1AvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 20:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZF1AvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 20:51:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:40023 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbZF1AvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 20:51:04 -0400
Message-ID: <4A46BE34.7040806@kernel.org>
Date: Sun, 28 Jun 2009 09:49:56 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ink@jurassic.park.msu.ru, max@stro.at, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: [PATCH] alpha: fix percpu build breakage
References: <20090625090842.GA17936@stro.at>	<20090625115423.6a31b49c.akpm@linux-foundation.org>	<4A4419AA.2040400@kernel.org>	<20090626124705.GA25147@jurassic.park.msu.ru>	<20090626115746.09314757.akpm@linux-foundation.org> <20090626122152.e124254b.akpm@linux-foundation.org>
In-Reply-To: <20090626122152.e124254b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 28 Jun 2009 00:50:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alpha percpu access requires custom SHIFT_PERCPU_PTR() definition for
modules to work around addressing range limitation.  This is done via
generating inline assembly using C preprocessing which forces the
assembler to generate external reference.  This happens behind the
compiler's back and makes the compiler think that static percpu
variables in modules are unused.

This used to be worked around by using __unused attribute for percpu
variables which prevent the compiler from omitting the variable;
however, recent declare/definition attribute unification change broke
this as __used can't be used for declaration.  Also, in the process,
PER_CPU_ATTRIBUTES definition in alpha percpu.h got broken.

This patch adds PER_CPU_DEF_ATTRIBUTES which is only used for
definitions and make alpha use it to add __used for percpu variables
in modules.  This also fixes the PER_CPU_ATTRIBUTES double definition
bug.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/alpha/include/asm/percpu.h |    6 +++---
 include/asm-generic/percpu.h    |    4 ++++
 include/linux/percpu-defs.h     |    3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 06c5c7a..b663f1f 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -30,7 +30,7 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 
 #ifndef MODULE
 #define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
-#define PER_CPU_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
 #else
 /*
  * To calculate addresses of locally defined variables, GCC uses 32-bit
@@ -49,7 +49,7 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
-#define PER_CPU_ATTRIBUTES	__used
+#define PER_CPU_DEF_ATTRIBUTES	__used
 
 #endif /* MODULE */
 
@@ -71,7 +71,7 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define __get_cpu_var(var)		per_cpu_var(var)
 #define __raw_get_cpu_var(var)		per_cpu_var(var)
 
-#define PER_CPU_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
 
 #endif /* SMP */
 
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index d7d50d7..aa00800 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -97,4 +97,8 @@ extern void setup_per_cpu_areas(void);
 #define PER_CPU_ATTRIBUTES
 #endif
 
+#ifndef PER_CPU_DEF_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
+#endif
+
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 8f921d7..68438e1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -24,7 +24,8 @@
 
 #define DEFINE_PER_CPU_SECTION(type, name, section)			\
 	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+	PER_CPU_ATTRIBUTES PER_CPU_DEF_ATTRIBUTES			\
+	__typeof__(type) per_cpu__##name
 
 /*
  * Variant on the per-CPU variable declaration/definition theme used for
