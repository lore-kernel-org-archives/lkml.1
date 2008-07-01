Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbYGAUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbYGAUTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYGAUTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:19:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:45913 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYGAUTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:19:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=RANEhXCUGF6px54jd0D/SQkCXSzW3RWWF1D19Jy9Vu2T8eUkBnpCfsEdcBwsLayuaS
         HIeSxbJNdBuGu6rLIec7vO7ZI5BOi53Nm6LzcwcmQ5dwk/R9tUxLgHjYN6tuugeG/JHS
         GLfSjFywnZtvxJrggC/icuilZazKU4Wszxa2U=
Date: Tue, 1 Jul 2008 22:18:55 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [git pull] kmemcheck updates for -tip
Message-ID: <20080701201855.GA22686@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Please pull the 'for-tip' branch of

    git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip

to receive the following changes:

Vegard Nossum (3):
      kmemcheck: fix sparse warnings
      softirq: raise the right softirq
      kmemcheck: use the proper comment style

 arch/x86/mm/kmemcheck/error.c     |    1 +
 arch/x86/mm/kmemcheck/kmemcheck.c |   26 +++++++++++++++++---------
 arch/x86/mm/kmemcheck/opcode.c    |    6 ++++--
 arch/x86/mm/kmemcheck/shadow.c    |    1 +
 arch/x86/mm/kmemcheck/string.c    |   12 ++++++++----
 include/linux/kmemcheck.h         |    1 +
 kernel/softirq.c                  |    2 +-
 7 files changed, 33 insertions(+), 16 deletions(-)


Thanks,

Vegard


diff --git a/arch/x86/mm/kmemcheck/error.c b/arch/x86/mm/kmemcheck/error.c
index 9261f9c..56410c6 100644
--- a/arch/x86/mm/kmemcheck/error.c
+++ b/arch/x86/mm/kmemcheck/error.c
@@ -6,6 +6,7 @@
 #include <linux/stacktrace.h>
 #include <linux/string.h>
 
+#include "error.h"
 #include "shadow.h"
 
 enum kmemcheck_error_type {
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index 0c0201b..37949c3 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -39,8 +39,10 @@ void __init kmemcheck_init(void)
 	kmemcheck_smp_init();
 
 #if defined(CONFIG_SMP) && !defined(CONFIG_KMEMCHECK_USE_SMP)
-	/* Limit SMP to use a single CPU. We rely on the fact that this code
-	* runs before SMP is set up. */
+	/*
+	 * Limit SMP to use a single CPU. We rely on the fact that this code
+	 * runs before SMP is set up.
+	 */
 	if (setup_max_cpus > 1) {
 		printk(KERN_INFO
 			"kmemcheck: Limiting number of CPUs to 1.\n");
@@ -144,8 +146,10 @@ void kmemcheck_show(struct pt_regs *regs)
 	n += kmemcheck_show_addr(data->addr1);
 	n += kmemcheck_show_addr(data->addr2);
 
-	/* None of the addresses actually belonged to kmemcheck. Note that
-	 * this is not an error. */
+	/*
+	 * None of the addresses actually belonged to kmemcheck. Note that
+	 * this is not an error.
+	 */
 	if (n == 0) {
 		kmemcheck_resume();
 		return;
@@ -348,7 +352,7 @@ enum kmemcheck_method {
 	KMEMCHECK_WRITE,
 };
 
-void kmemcheck_access(struct pt_regs *regs,
+static void kmemcheck_access(struct pt_regs *regs,
 	unsigned long fallback_address, enum kmemcheck_method fallback_method)
 {
 	const uint8_t *insn;
@@ -414,8 +418,10 @@ void kmemcheck_access(struct pt_regs *regs,
 		/* MOVS, MOVSB, MOVSW, MOVSD */
 	case 0xa4:
 	case 0xa5:
-		/* These instructions are special because they take two
-		 * addresses, but we only get one page fault. */
+		/*
+		 * These instructions are special because they take two
+		 * addresses, but we only get one page fault.
+		 */
 		kmemcheck_read(regs, regs->si, size);
 		kmemcheck_write(regs, regs->di, size);
 		data->addr1 = regs->si;
@@ -434,9 +440,11 @@ void kmemcheck_access(struct pt_regs *regs,
 		return;
 	}
 
-	/* If the opcode isn't special in any way, we use the data from the
+	/*
+	 * If the opcode isn't special in any way, we use the data from the
 	 * page fault handler to determine the address and type of memory
-	 * access. */
+	 * access.
+	 */
 	switch (fallback_method) {
 	case KMEMCHECK_READ:
 		kmemcheck_read(regs, fallback_address, size);
diff --git a/arch/x86/mm/kmemcheck/opcode.c b/arch/x86/mm/kmemcheck/opcode.c
index be0c8b7..194aeee 100644
--- a/arch/x86/mm/kmemcheck/opcode.c
+++ b/arch/x86/mm/kmemcheck/opcode.c
@@ -21,10 +21,12 @@ static bool opcode_is_rex_prefix(uint8_t b)
 	return (b & 0xf0) == 0x40;
 }
 
-/* This is a VERY crude opcode decoder. We only need to find the size of the
+/*
+ * This is a VERY crude opcode decoder. We only need to find the size of the
  * load/store that caused our #PF and this should work for all the opcodes
  * that we care about. Moreover, the ones who invented this instruction set
- * should be shot. */
+ * should be shot.
+ */
 unsigned int kmemcheck_opcode_get_size(const uint8_t *op)
 {
 	/* Default operand size */
diff --git a/arch/x86/mm/kmemcheck/shadow.c b/arch/x86/mm/kmemcheck/shadow.c
index 07ed3d6..0cb144f 100644
--- a/arch/x86/mm/kmemcheck/shadow.c
+++ b/arch/x86/mm/kmemcheck/shadow.c
@@ -1,3 +1,4 @@
+#include <linux/kmemcheck.h>
 #include <linux/mm.h>
 
 #include <asm/page.h>
diff --git a/arch/x86/mm/kmemcheck/string.c b/arch/x86/mm/kmemcheck/string.c
index 0d21d22..1a62bf0 100644
--- a/arch/x86/mm/kmemcheck/string.c
+++ b/arch/x86/mm/kmemcheck/string.c
@@ -27,8 +27,10 @@ static void memset_one_page(void *s, int c, size_t n)
 		return;
 	}
 
-	/* While we are not guarding the page in question, nobody else
-	 * should be able to change them. */
+	/*
+	 * While we are not guarding the page in question, nobody else
+	 * should be able to change them.
+	 */
 	local_irq_save(flags);
 
 	kmemcheck_pause_allbutself();
@@ -68,8 +70,10 @@ void *kmemcheck_memset(void *s, int c, size_t n)
 	end_page = (addr + n) & PAGE_MASK;
 
 	if (start_page == end_page) {
-		/* The entire area is within the same page. Good, we only
-		 * need one memset(). */
+		/*
+		 * The entire area is within the same page. Good, we only
+		 * need one memset().
+		 */
 		memset_one_page(s, c, n);
 		return s;
 	}
diff --git a/include/linux/kmemcheck.h b/include/linux/kmemcheck.h
index bc02c3f..b2d83ef 100644
--- a/include/linux/kmemcheck.h
+++ b/include/linux/kmemcheck.h
@@ -1,6 +1,7 @@
 #ifndef LINUX_KMEMCHECK_H
 #define LINUX_KMEMCHECK_H
 
+#include <linux/mm_types.h>
 #include <linux/types.h>
 
 #ifdef CONFIG_KMEMCHECK
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 44cf21f..23dc889 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -399,7 +399,7 @@ void __tasklet_hi_schedule_first(struct tasklet_struct *t)
 
 	t->next = __get_cpu_var(tasklet_hi_vec).head;
 	__get_cpu_var(tasklet_hi_vec).head = t;
-	__raise_softirq_irqoff(TASKLET_SOFTIRQ);
+	__raise_softirq_irqoff(HI_SOFTIRQ);
 }
 
 EXPORT_SYMBOL(__tasklet_hi_schedule_first);
