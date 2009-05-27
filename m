Return-Path: <linux-kernel-owner+w=401wt.eu-S1761181AbZE0HS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761181AbZE0HS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbZE0HQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:16:56 -0400
Received: from claw.goop.org ([74.207.240.146]:41409 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759950AbZE0HQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:16:54 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/16] xen mtrr: Add mtrr_ops support for Xen mtrr
Date: Wed, 27 May 2009 00:15:27 -0700
Message-Id: <1243408538-21100-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243408538-21100-1-git-send-email-jeremy@goop.org>
References: <1243408538-21100-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Tweedie <sct@redhat.com>

Add a Xen mtrr type, and reorganise mtrr initialisation slightly to
allow the mtrr driver to set up num_var_ranges (Xen needs to do this by
querying the hypervisor itself.)

Only the boot path is handled for now: we set up a xen-specific mtrr_if
and set up the mtrr tables based on hypervisor information, but we don't
yet handle mtrr entry add/delete.

[ Impact: add basic MTRR support (enough to get started) ]

Signed-off-by: Stephen Tweedie <sct@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/mtrr/Makefile  |    1 +
 arch/x86/kernel/cpu/mtrr/amd.c     |    1 +
 arch/x86/kernel/cpu/mtrr/centaur.c |    1 +
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    1 +
 arch/x86/kernel/cpu/mtrr/generic.c |    1 +
 arch/x86/kernel/cpu/mtrr/main.c    |   11 +++++--
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    5 +++
 arch/x86/kernel/cpu/mtrr/xen.c     |   56 ++++++++++++++++++++++++++++++++++++
 8 files changed, 74 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mtrr/xen.c

diff --git a/arch/x86/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
index f4361b5..404e458 100644
--- a/arch/x86/kernel/cpu/mtrr/Makefile
+++ b/arch/x86/kernel/cpu/mtrr/Makefile
@@ -1,3 +1,4 @@
 obj-y		:= main.o if.o generic.o state.o cleanup.o
 obj-$(CONFIG_X86_32) += amd.o cyrix.o centaur.o
+obj-$(CONFIG_XEN_DOM0) += xen.o
 
diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index ee2331b..7bf23de 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -108,6 +108,7 @@ static struct mtrr_ops amd_mtrr_ops = {
 	.get_free_region   = generic_get_free_region,
 	.validate_add_page = amd_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
+	.num_var_ranges	   = common_num_var_ranges,
 };
 
 int __init amd_init_mtrr(void)
diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index cb9aa3a..7e3f74f 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -213,6 +213,7 @@ static struct mtrr_ops centaur_mtrr_ops = {
 	.get_free_region   = centaur_get_free_region,
 	.validate_add_page = centaur_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
+	.num_var_ranges	   = common_num_var_ranges,
 };
 
 int __init centaur_init_mtrr(void)
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index ff14c32..c7bb5e3 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -263,6 +263,7 @@ static struct mtrr_ops cyrix_mtrr_ops = {
 	.get_free_region   = cyrix_get_free_region,
 	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
+	.num_var_ranges	   = common_num_var_ranges,
 };
 
 int __init cyrix_init_mtrr(void)
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0b776c0..c66dda1 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -722,4 +722,5 @@ struct mtrr_ops generic_mtrr_ops = {
 	.set               = generic_set_mtrr,
 	.validate_add_page = generic_validate_add_page,
 	.have_wrcomb       = generic_have_wrcomb,
+	.num_var_ranges	   = common_num_var_ranges,
 };
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 03cda01..fd5ac04 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -99,7 +99,7 @@ static int have_wrcomb(void)
 }
 
 /*  This function returns the number of variable MTRRs  */
-static void __init set_num_var_ranges(void)
+int __init common_num_var_ranges(void)
 {
 	unsigned long config = 0, dummy;
 
@@ -109,7 +109,7 @@ static void __init set_num_var_ranges(void)
 		config = 2;
 	else if (is_cpu(CYRIX) || is_cpu(CENTAUR))
 		config = 8;
-	num_var_ranges = config & 0xff;
+	return config & 0xff;
 }
 
 static void __init init_table(void)
@@ -622,12 +622,17 @@ int __initdata changed_by_mtrr_cleanup;
 void __init mtrr_bp_init(void)
 {
 	u32 phys_addr;
+
 	init_ifs();
 
 	phys_addr = 32;
 
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
+#ifdef CONFIG_XEN_DOM0
+		xen_init_mtrr();
+#endif
+
 		size_or_mask = 0xff000000;	/* 36 bits */
 		size_and_mask = 0x00f00000;
 		phys_addr = 36;
@@ -685,7 +690,7 @@ void __init mtrr_bp_init(void)
 	}
 
 	if (mtrr_if) {
-		set_num_var_ranges();
+		num_var_ranges = mtrr_if->num_var_ranges();
 		init_table();
 		if (use_intel()) {
 			get_mtrr_state();
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 77f67f7..3502f6c 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -41,6 +41,8 @@ struct mtrr_ops {
 	int	(*validate_add_page)(unsigned long base, unsigned long size,
 				     unsigned int type);
 	int	(*have_wrcomb)(void);
+
+	int	(*num_var_ranges)(void);
 };
 
 extern int generic_get_free_region(unsigned long base, unsigned long size,
@@ -52,6 +54,8 @@ extern struct mtrr_ops generic_mtrr_ops;
 
 extern int positive_have_wrcomb(void);
 
+extern int __init common_num_var_ranges(void);
+
 /* library functions for processor-specific routines */
 struct set_mtrr_context {
 	unsigned long flags;
@@ -89,6 +93,7 @@ void mtrr_wrmsr(unsigned, unsigned, unsigned);
 int amd_init_mtrr(void);
 int cyrix_init_mtrr(void);
 int centaur_init_mtrr(void);
+void xen_init_mtrr(void);
 
 extern int changed_by_mtrr_cleanup;
 extern int mtrr_cleanup(unsigned address_bits);
diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
new file mode 100644
index 0000000..6760907
--- /dev/null
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -0,0 +1,56 @@
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <asm/uaccess.h>
+#include <linux/mutex.h>
+
+#include <asm/mtrr.h>
+#include "mtrr.h"
+
+#include <xen/interface/platform.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+static int __init xen_num_var_ranges(void);
+
+/* DOM0 TODO: Need to fill in the remaining mtrr methods to have full
+ * working userland mtrr support. */
+static struct mtrr_ops xen_mtrr_ops = {
+	.vendor            = X86_VENDOR_UNKNOWN,
+	.get_free_region   = generic_get_free_region,
+	.have_wrcomb       = positive_have_wrcomb,
+	.use_intel_if	   = 0,
+	.num_var_ranges	   = xen_num_var_ranges,
+};
+
+static int __init xen_num_var_ranges(void)
+{
+	int ranges;
+	struct xen_platform_op op;
+
+	for (ranges = 0; ; ranges++) {
+		op.cmd = XENPF_read_memtype;
+		op.u.read_memtype.reg = ranges;
+		if (HYPERVISOR_dom0_op(&op) != 0)
+			break;
+	}
+	return ranges;
+}
+
+void __init xen_init_mtrr(void)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	if (!xen_initial_domain())
+		return;
+
+	if ((!cpu_has(c, X86_FEATURE_MTRR)) &&
+	    (!cpu_has(c, X86_FEATURE_K6_MTRR)) &&
+	    (!cpu_has(c, X86_FEATURE_CYRIX_ARR)) &&
+	    (!cpu_has(c, X86_FEATURE_CENTAUR_MCR)))
+		return;
+
+	mtrr_if = &xen_mtrr_ops;
+}
-- 
1.6.0.6

