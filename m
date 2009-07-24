Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZGXQMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZGXQMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZGXQMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51202 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbZGXQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:47 -0400
Subject: [PATCH 8/8] kmemleak: Always scan the task stacks
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Jul 2009 17:12:46 +0100
Message-ID: <20090724161246.5752.19794.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:46.0986 (UTC) FILETIME=[955B86A0:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the stack scanning on/off run-time configuration. The
thread stacks are now automatically scanned as any other allocated
object (and avoid many false positives).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/kmemleak.txt |   11 +++++------
 mm/kmemleak.c              |   22 ----------------------
 2 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index c223785..fa93249 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -35,8 +35,6 @@ Memory scanning parameters can be modified at run-time by writing to the
 /sys/kernel/debug/kmemleak file. The following parameters are supported:
 
   off		- disable kmemleak (irreversible)
-  stack=on	- enable the task stacks scanning (default)
-  stack=off	- disable the tasks stacks scanning
   scan=on	- start the automatic memory scanning thread (default)
   scan=off	- stop the automatic memory scanning thread
   scan=<secs>	- set the automatic memory scanning period in seconds
@@ -111,7 +109,8 @@ reported by kmemleak because values found during the memory scanning
 point to such objects. To reduce the number of false negatives, kmemleak
 provides the kmemleak_ignore, kmemleak_scan_area, kmemleak_no_scan and
 kmemleak_erase functions (see above). The task stacks also increase the
-amount of false negatives and their scanning is not enabled by default.
+amount of false negatives (enabling CONFIG_DEBUG_STACK_USAGE would help
+by zeroing newly allocated stacks).
 
 The false positives are objects wrongly reported as being memory leaks
 (orphan). For objects known not to be leaks, kmemleak provides the
@@ -120,9 +119,9 @@ the memory block is known not to contain other pointers and it will no
 longer be scanned.
 
 Some of the reported leaks are only transient, especially on SMP
-systems, because of pointers temporarily stored in CPU registers or
-stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
-the minimum age of an object to be reported as a memory leak.
+systems, because of pointers temporarily stored in CPU registers.
+Kmemleak defines MSECS_MIN_AGE (defaulting to 5000) representing the
+minimum age of an object to be reported as a memory leak.
 
 Limitations and Drawbacks
 -------------------------
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 983f3f6..752a276 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -203,8 +203,6 @@ static unsigned long jiffies_min_age;
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
 static signed long jiffies_scan_wait;
-/* enables or disables the task stacks scanning */
-static int kmemleak_stack_scan = 1;
 /* protects the memory scanning, parameters and debug/kmemleak file access */
 static DEFINE_MUTEX(scan_mutex);
 
@@ -1064,7 +1062,6 @@ static void kmemleak_scan(void)
 {
 	unsigned long flags;
 	struct kmemleak_object *object, *tmp;
-	struct task_struct *task;
 	int i;
 	int new_leaks = 0;
 	int gray_list_pass = 0;
@@ -1131,19 +1128,6 @@ static void kmemleak_scan(void)
 	}
 
 	/*
-	 * Scanning the task stacks may introduce false negatives and it is
-	 * not enabled by default.
-	 */
-	if (kmemleak_stack_scan) {
-		read_lock(&tasklist_lock);
-		for_each_process(task)
-			scan_block(task_stack_page(task),
-				   task_stack_page(task) + THREAD_SIZE,
-				   NULL, 0);
-		read_unlock(&tasklist_lock);
-	}
-
-	/*
 	 * Scan the objects already referenced from the sections scanned
 	 * above. More objects will be referenced and, if there are no memory
 	 * leaks, all the objects will be scanned. The list traversal is safe
@@ -1413,8 +1397,6 @@ static int dump_str_object_info(const char *str)
  * File write operation to configure kmemleak at run-time. The following
  * commands can be written to the /sys/kernel/debug/kmemleak file:
  *   off	- disable kmemleak (irreversible)
- *   stack=on	- enable the task stacks scanning
- *   stack=off	- disable the tasks stacks scanning
  *   scan=on	- start the automatic memory scanning thread
  *   scan=off	- stop the automatic memory scanning thread
  *   scan=...	- set the automatic memory scanning period in seconds (0 to
@@ -1440,10 +1422,6 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 
 	if (strncmp(buf, "off", 3) == 0)
 		kmemleak_disable();
-	else if (strncmp(buf, "stack=on", 8) == 0)
-		kmemleak_stack_scan = 1;
-	else if (strncmp(buf, "stack=off", 9) == 0)
-		kmemleak_stack_scan = 0;
 	else if (strncmp(buf, "scan=on", 7) == 0)
 		start_scan_thread();
 	else if (strncmp(buf, "scan=off", 8) == 0)

