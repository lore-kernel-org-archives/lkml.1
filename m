Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZFZONk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZFZONk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759086AbZFZONS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:13:18 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61936 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758592AbZFZONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:13:17 -0400
Subject: [PATCH 2/4] kmemleak: Simplify the reports logged by the scanning
	thread
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date: Fri, 26 Jun 2009 15:12:46 +0100
Message-ID: <20090626141246.31504.74477.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
References: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 14:12:47.0425 (UTC) FILETIME=[2E84B310:01C9F668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of false positives, the memory scanning thread may print too
much information. This patch changes the scanning thread to only print
the number of newly suspected leaks. Further information can be read
from the /sys/kernel/debug/kmemleak file.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/kmemleak.txt |    6 ++--
 mm/kmemleak.c              |   61 ++++++++++++--------------------------------
 2 files changed, 19 insertions(+), 48 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 9426e94..c06f7ba 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -16,9 +16,9 @@ Usage
 -----
 
 CONFIG_DEBUG_KMEMLEAK in "Kernel hacking" has to be enabled. A kernel
-thread scans the memory every 10 minutes (by default) and prints any new
-unreferenced objects found. To trigger an intermediate scan and display
-all the possible memory leaks:
+thread scans the memory every 10 minutes (by default) and prints the
+number of new unreferenced objects found. To trigger an intermediate
+scan and display the details of all the possible memory leaks:
 
   # mount -t debugfs nodev /sys/kernel/debug/
   # cat /sys/kernel/debug/kmemleak
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index a38418a..4130a48 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -279,15 +279,6 @@ static int color_gray(const struct kmemleak_object *object)
 }
 
 /*
- * Objects are considered referenced if their color is gray and they have not
- * been deleted.
- */
-static int referenced_object(struct kmemleak_object *object)
-{
-	return (object->flags & OBJECT_ALLOCATED) && color_gray(object);
-}
-
-/*
  * Objects are considered unreferenced only if their color is white, they have
  * not be deleted and have a minimum age to avoid false positives caused by
  * pointers temporarily stored in CPU registers.
@@ -299,38 +290,23 @@ static int unreferenced_object(struct kmemleak_object *object)
 }
 
 /*
- * Printing of the (un)referenced objects information, either to the seq file
- * or to the kernel log. The print_referenced/print_unreferenced functions
- * must be called with the object->lock held.
+ * Printing of the unreferenced objects information to the seq file. The
+ * print_unreferenced function must be called with the object->lock held.
  */
-#define print_helper(seq, x...)	do {	\
-	struct seq_file *s = (seq);	\
-	if (s)				\
-		seq_printf(s, x);	\
-	else				\
-		pr_info(x);		\
-} while (0)
-
-static void print_referenced(struct kmemleak_object *object)
-{
-	pr_info("referenced object 0x%08lx (size %zu)\n",
-		object->pointer, object->size);
-}
-
 static void print_unreferenced(struct seq_file *seq,
 			       struct kmemleak_object *object)
 {
 	int i;
 
-	print_helper(seq, "unreferenced object 0x%08lx (size %zu):\n",
-		     object->pointer, object->size);
-	print_helper(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
-		     object->comm, object->pid, object->jiffies);
-	print_helper(seq, "  backtrace:\n");
+	seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
+		   object->pointer, object->size);
+	seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu\n",
+		   object->comm, object->pid, object->jiffies);
+	seq_printf(seq, "  backtrace:\n");
 
 	for (i = 0; i < object->trace_len; i++) {
 		void *ptr = (void *)object->trace[i];
-		print_helper(seq, "    [<%p>] %pS\n", ptr, ptr);
+		seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
 	}
 }
 
@@ -571,8 +547,6 @@ static void delete_object(unsigned long ptr)
 	 * cannot be freed when it is being scanned.
 	 */
 	spin_lock_irqsave(&object->lock, flags);
-	if (object->flags & OBJECT_REPORTED)
-		print_referenced(object);
 	object->flags &= ~OBJECT_ALLOCATED;
 	spin_unlock_irqrestore(&object->lock, flags);
 	put_object(object);
@@ -1073,33 +1047,30 @@ static int kmemleak_scan_thread(void *arg)
 	while (!kthread_should_stop()) {
 		struct kmemleak_object *object;
 		signed long timeout = jiffies_scan_wait;
+		int new_leaks = 0;
 
 		mutex_lock(&scan_mutex);
 
 		kmemleak_scan();
-		reported_leaks = 0;
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(object, &object_list, object_list) {
 			unsigned long flags;
 
-			if (reported_leaks >= REPORTS_NR)
-				break;
 			spin_lock_irqsave(&object->lock, flags);
-			if (!(object->flags & OBJECT_REPORTED) &&
-			    unreferenced_object(object)) {
-				print_unreferenced(NULL, object);
+			if (unreferenced_object(object) &&
+			    !(object->flags & OBJECT_REPORTED)) {
 				object->flags |= OBJECT_REPORTED;
-				reported_leaks++;
-			} else if ((object->flags & OBJECT_REPORTED) &&
-				   referenced_object(object)) {
-				print_referenced(object);
-				object->flags &= ~OBJECT_REPORTED;
+				new_leaks++;
 			}
 			spin_unlock_irqrestore(&object->lock, flags);
 		}
 		rcu_read_unlock();
 
+		if (new_leaks)
+			pr_info("%d new suspected memory leaks (see "
+				"/sys/kernel/debug/kmemleak)\n", new_leaks);
+
 		mutex_unlock(&scan_mutex);
 		/* wait before the next scan */
 		while (timeout && !kthread_should_stop())

