Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGEH6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGEH6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 03:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZGEH6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 03:58:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:33660 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZGEH6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 03:58:32 -0400
Date: Sun, 5 Jul 2009 07:57:57 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703164225.GA21447@elte.hu>
Subject: [tip:x86/cleanups] x86: Further clean up of mtrr/generic.c
Message-ID: <tip-e3d0e69268dffb9676bf0800a60fb3573a723480@git.kernel.org>
Git-Commit-ID: e3d0e69268dffb9676bf0800a60fb3573a723480
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 05 Jul 2009 07:58:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3d0e69268dffb9676bf0800a60fb3573a723480
Gitweb:     http://git.kernel.org/tip/e3d0e69268dffb9676bf0800a60fb3573a723480
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 5 Jul 2009 09:44:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Jul 2009 09:46:10 +0200

x86: Further clean up of mtrr/generic.c

Yinghai noticed that i defined BIOS_BUG_MSG but added no
usage for it. The usage is to clean up this turd in generic.c:

			printk(KERN_WARNING "WARNING: BIOS bug: VAR MTRR %d "
				"contains strange UC entry under 1M, check "
				"with your system vendor!\n", i);

Breaking printk lines in the middle looks ugly, is hard to read
and breaks 'git grep'. Use the BIOS_BUG_MSG instead.

Also complete the moving of structure definitions and variables
to the top of the file.

Reported-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/cleanup.c |   56 +++++++++++++++++------------------
 1 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index b8aba81..315738c 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -34,14 +34,37 @@
 
 #include "mtrr.h"
 
-/* Should be related to MTRR_VAR_RANGES nums */
-#define RANGE_NUM 256
-
 struct res_range {
 	unsigned long	start;
 	unsigned long	end;
 };
 
+struct var_mtrr_range_state {
+	unsigned long	base_pfn;
+	unsigned long	size_pfn;
+	mtrr_type	type;
+};
+
+struct var_mtrr_state {
+	unsigned long	range_startk;
+	unsigned long	range_sizek;
+	unsigned long	chunk_sizek;
+	unsigned long	gran_sizek;
+	unsigned int	reg;
+};
+
+/* Should be related to MTRR_VAR_RANGES nums */
+#define RANGE_NUM				256
+
+static struct res_range __initdata		range[RANGE_NUM];
+static int __initdata				nr_range;
+
+static struct var_mtrr_range_state __initdata	range_state[RANGE_NUM];
+
+static int __initdata debug_print;
+#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
+
+
 static int __init
 add_range(struct res_range *range, int nr_range,
 	  unsigned long start, unsigned long end)
@@ -147,18 +170,6 @@ static int __init cmp_range(const void *x1, const void *x2)
 	return start1 - start2;
 }
 
-struct var_mtrr_range_state {
-	unsigned long	base_pfn;
-	unsigned long	size_pfn;
-	mtrr_type	type;
-};
-
-static struct var_mtrr_range_state __initdata range_state[RANGE_NUM];
-
-static int __initdata debug_print;
-#define Dprintk(x...) do { if (debug_print) printk(KERN_DEBUG x); } while (0)
-
-
 #define BIOS_BUG_MSG KERN_WARNING \
 	"WARNING: BIOS bug: VAR MTRR %d contains strange UC entry under 1M, check with your system vendor!\n"
 
@@ -200,9 +211,7 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 		if (base < (1<<(20-PAGE_SHIFT)) && mtrr_state.have_fixed &&
 		    (mtrr_state.enabled & 1)) {
 			/* Var MTRR contains UC entry below 1M? Skip it: */
-			printk(KERN_WARNING "WARNING: BIOS bug: VAR MTRR %d "
-				"contains strange UC entry under 1M, check "
-				"with your system vendor!\n", i);
+			printk(BIOS_BUG_MSG, i);
 			if (base + size <= (1<<(20-PAGE_SHIFT)))
 				continue;
 			size -= (1<<(20-PAGE_SHIFT)) - base;
@@ -244,9 +253,6 @@ x86_get_mtrr_mem_range(struct res_range *range, int nr_range,
 	return nr_range;
 }
 
-static struct res_range __initdata range[RANGE_NUM];
-static int __initdata nr_range;
-
 #ifdef CONFIG_MTRR_SANITIZER
 
 static unsigned long __init sum_ranges(struct res_range *range, int nr_range)
@@ -284,14 +290,6 @@ static int __init mtrr_cleanup_debug_setup(char *str)
 }
 early_param("mtrr_cleanup_debug", mtrr_cleanup_debug_setup);
 
-struct var_mtrr_state {
-	unsigned long	range_startk;
-	unsigned long	range_sizek;
-	unsigned long	chunk_sizek;
-	unsigned long	gran_sizek;
-	unsigned int	reg;
-};
-
 static void __init
 set_var_mtrr(unsigned int reg, unsigned long basek, unsigned long sizek,
 	     unsigned char type, unsigned int address_bits)
