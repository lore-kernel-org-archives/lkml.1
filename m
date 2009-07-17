Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZGQUWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZGQUWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbZGQUWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:22:16 -0400
Received: from kroah.org ([198.145.64.141]:43110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbZGQUTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:32 2009
Message-Id: <20090717201232.491501823@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: [patch 12/24] alpha: fix percpu build breakage
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=alpha-fix-percpu-build-breakage.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit b01e8dc34379f4ba2f454390e340a025edbaaa7e upstream.

alpha percpu access requires custom SHIFT_PERCPU_PTR() definition for
modules to work around addressing range limitation.  This is done via
generating inline assembly using C preprocessing which forces the
assembler to generate external reference.  This happens behind the
compiler's back and makes the compiler think that static percpu variables
in modules are unused.

This used to be worked around by using __unused attribute for percpu
variables which prevent the compiler from omitting the variable; however,
recent declare/definition attribute unification change broke this as
__used can't be used for declaration.  Also, in the process,
PER_CPU_ATTRIBUTES definition in alpha percpu.h got broken.

This patch adds PER_CPU_DEF_ATTRIBUTES which is only used for definitions
and make alpha use it to add __used for percpu variables in modules.  This
also fixes the PER_CPU_ATTRIBUTES double definition bug.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: maximilian attems <max@stro.at>
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/include/asm/percpu.h |    6 +++---
 include/asm-generic/percpu.h    |    4 ++++
 include/linux/percpu-defs.h     |    3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -30,7 +30,7 @@ extern unsigned long __per_cpu_offset[NR
 
 #ifndef MODULE
 #define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
-#define PER_CPU_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
 #else
 /*
  * To calculate addresses of locally defined variables, GCC uses 32-bit
@@ -49,7 +49,7 @@ extern unsigned long __per_cpu_offset[NR
 		: "=&r"(__ptr), "=&r"(tmp_gp));		\
 	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
 
-#define PER_CPU_ATTRIBUTES	__used
+#define PER_CPU_DEF_ATTRIBUTES	__used
 
 #endif /* MODULE */
 
@@ -71,7 +71,7 @@ extern unsigned long __per_cpu_offset[NR
 #define __get_cpu_var(var)		per_cpu_var(var)
 #define __raw_get_cpu_var(var)		per_cpu_var(var)
 
-#define PER_CPU_ATTRIBUTES
+#define PER_CPU_DEF_ATTRIBUTES
 
 #endif /* SMP */
 
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


