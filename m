Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYCMXGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYCMXGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYCMXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:06:14 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58328 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYCMXGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:06:14 -0400
Message-ID: <47D9B35C.9@tiscali.nl>
Date: Fri, 14 Mar 2008 00:06:04 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dwalker@mvista.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] change likeliness accounting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the patch below I propose some changes to the likely/unlikely accounting.
---
In struct likeliness: store __builtin_return_address in 'caller', rather than
__FILE__ and __func__, and combine 'type' and 'line' into one 'label'.

The __check_likely macro performs some functionality originally in
do_check_likely(): The first check for LP_UNSEEN bit, the increment of the
experienced likely-count. do_check_likely() looses its parameter and return
value. I added a __builtin_expect() to make use of the expectation.

The likely diplay changes: now +/- denotes whether expectation fails in less
than 0.01% of the tests rather than whether more unexpected than expected were
encountered. __FILE__ is no longer displayed in output.

struct seq_operations becomes static and corrects a typo in comment.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d6d9efc..be055de 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -53,27 +53,31 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 
 #if defined(CONFIG_PROFILE_LIKELY) && !(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
 struct likeliness {
-	const char *func;
-	char *file;
-	int line;
-	int type;
+	unsigned long caller;
+	unsigned int label;
 	unsigned int count[2];
 	struct likeliness *next;
 };
 
-extern int do_check_likely(struct likeliness *likeliness, int exp);
+extern void do_check_likely(struct likeliness *likeliness);
 
-#define LP_UNSEEN	4
+#define LP_IS_EXPECTED	1
+#define LP_UNSEEN	2
+#define LP_LINE_SHIFT	2
 
 #define __check_likely(exp, is_likely)					\
 	({								\
 		static struct likeliness likeliness = {			\
-			.func = __func__,				\
-			.file = __FILE__,				\
-			.line = __LINE__,				\
-			.type = is_likely | LP_UNSEEN,			\
+			.label = __LINE__ << LP_LINE_SHIFT |		\
+						LP_UNSEEN | is_likely,	\
 		};							\
-		do_check_likely(&likeliness, !!(exp));			\
+									\
+		if (likeliness.label & LP_UNSEEN)			\
+			do_check_likely(&likeliness);			\
+									\
+		__builtin_expect(!!(exp), is_likely) ?                  \
+				likeliness.count[1]++ || 1 :		\
+				likeliness.count[0]++ && 0;		\
 	})
 
 /*
diff --git a/lib/likely_prof.c b/lib/likely_prof.c
index 5c6d91d..06f2edb 100644
--- a/lib/likely_prof.c
+++ b/lib/likely_prof.c
@@ -15,41 +15,34 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
+#include <linux/kallsyms.h>
 
 #include <asm/bug.h>
 #include <asm/atomic.h>
 
 static struct likeliness *likeliness_head;
 
-int do_check_likely(struct likeliness *likeliness, int ret)
+void do_check_likely(struct likeliness *likeliness)
 {
 	static unsigned long likely_lock;
 
-	if (ret)
-		likeliness->count[1]++;
-	else
-		likeliness->count[0]++;
-
-	if (likeliness->type & LP_UNSEEN) {
-		/*
-		 * We don't simple use a spinlock because internally to the
-		 * spinlock there is a call to unlikely which causes recursion.
-		 * We opted for this method because we didn't need a preempt/irq
-		 * disable and it was a bit cleaner then using internal __raw
-		 * spinlock calls.
-		 */
-		if (!test_and_set_bit(0, &likely_lock)) {
-			if (likeliness->type & LP_UNSEEN) {
-				likeliness->type &= (~LP_UNSEEN);
-				likeliness->next = likeliness_head;
-				likeliness_head = likeliness;
-			}
-			smp_mb__before_clear_bit();
-			clear_bit(0, &likely_lock);
+	/*
+	 * We don't simply use a spinlock because internally to the spinlock
+	 * there is a call to unlikely which causes recursion. We opted for this
+	 * method because we didn't need a preempt/irq disable and it was a bit
+	 * cleaner then using internal __raw spinlock calls.
+	 */
+	if (!test_and_set_bit(0, &likely_lock)) {
+		if (likeliness->label & LP_UNSEEN) {
+			likeliness->label &= (~LP_UNSEEN);
+			likeliness->next = likeliness_head;
+			likeliness_head = likeliness;
+			likeliness->caller = (unsigned long)
+						__builtin_return_address(0);
 		}
+		smp_mb__before_clear_bit();
+		clear_bit(0, &likely_lock);
 	}
-
-	return ret;
 }
 EXPORT_SYMBOL(do_check_likely);
 
@@ -86,18 +79,22 @@ static void *lp_seq_next(struct seq_file *out, void *p, loff_t *pos)
 static int lp_seq_show(struct seq_file *out, void *p)
 {
 	struct likeliness *entry = p;
-	unsigned int true = entry->count[1];
-	unsigned int false = entry->count[0];
-
-	if (!entry->type) {
-		if (true > false)
+	char function[KSYM_SYMBOL_LEN];
+	unsigned int pos = entry->count[1];
+	unsigned int neg = entry->count[0];
+
+	/*
+	 * Balanced if the suggestion was false in less than 0.01% of the tests
+	 */
+	if (!(entry->label & LP_IS_EXPECTED)) {
+		if (neg != 0 && (10000 * pos) / (pos + neg) > 1)
 			seq_printf(out, "+");
 		else
 			seq_printf(out, " ");
 
 		seq_printf(out, "unlikely ");
 	} else {
-		if (true < false)
+		if (pos != 0 && (10000 * neg) / (pos + neg) > 1)
 			seq_printf(out, "-");
 		else
 			seq_printf(out, " ");
@@ -105,8 +102,9 @@ static int lp_seq_show(struct seq_file *out, void *p)
 		seq_printf(out, "likely   ");
 	}
 
-	seq_printf(out, "|%9u|%9u\t%s()@:%s@%d\n", true, false,
-			entry->func, entry->file, entry->line);
+	sprint_symbol(function, entry->caller);
+	seq_printf(out, "|%9u|%9u\t%s()@:%u\n", pos, neg, function,
+					entry->label >> LP_LINE_SHIFT);
 
 	return 0;
 }
@@ -115,7 +113,7 @@ static void lp_seq_stop(struct seq_file *m, void *p)
 {
 }
 
-struct seq_operations likely_profiling_ops = {
+static struct seq_operations likely_profiling_ops = {
 	.start  = lp_seq_start,
 	.next   = lp_seq_next,
 	.stop   = lp_seq_stop,
