Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZICFft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZICFft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 01:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZICFfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 01:35:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZICFfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 01:35:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: catalin.marinas@arm.com, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mcgrof@gmail.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 2/5] kmemleak: add clear command support
Date: Thu,  3 Sep 2009 01:35:37 -0400
Message-Id: <1251956140-5499-3-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
In-Reply-To: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
References: <1251956140-5499-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In an ideal world your kmemleak output will be small,
when its not you can use the clear command to ingore previously
annotated kmemleak objects. We do this by painting them black.

You can now use 'clear'; run some critical section code you'd
like to test, and then run 'scan'.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Documentation/kmemleak.txt |   17 +++++++++++++++++
 mm/kmemleak.c              |   22 ++++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 8906803..235090b 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -27,6 +27,13 @@ To trigger an intermediate memory scan:
 
   # echo scan > /sys/kernel/debug/kmemleak
 
+To clear the list of all current possible memory leaks:
+
+  # echo clear > /sys/kernel/debug/kmemleak
+
+New leaks will then come up upon reading /sys/kernel/debug/kmemleak
+again.
+
 Note that the orphan objects are listed in the order they were allocated
 and one object at the beginning of the list may cause other subsequent
 objects to be reported as orphan.
@@ -35,6 +42,8 @@ Memory scanning parameters can be modified at run-time by writing to the
 /sys/kernel/debug/kmemleak file. The following parameters are supported:
 
   off		- disable kmemleak (irreversible)
+  clear		- clear list of current memory leak suspects, done by
+		  marking all current kmemleak objects as black.
   stack=on	- enable the task stacks scanning (default)
   stack=off	- disable the tasks stacks scanning
   scan=on	- start the automatic memory scanning thread (default)
@@ -79,6 +88,8 @@ The scanning algorithm steps:
      gray set is finished
   4. the remaining white objects are considered orphan and reported via
      /sys/kernel/debug/kmemleak
+  5. All black objects are ignored on the output of
+     /sys/kernel/debug/kmemleak
 
 Some allocated memory blocks have pointers stored in the kernel's
 internal data structures and they cannot be detected as orphans. To
@@ -86,6 +97,12 @@ avoid this, kmemleak can also store the number of values pointing to an
 address inside the block address range that need to be found so that the
 block is not considered a leak. One example is __vmalloc().
 
+Testing a sections with kmemleak
+--------------------------------
+
+You can use the 'clear' and 'scan' command over certain critical sections you
+would like to test.
+
 Kmemleak API
 ------------
 
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c6e71bb..b6bc34e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1294,10 +1294,30 @@ static int kmemleak_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
+static void kmemleak_clear(void)
+{
+	struct kmemleak_object *object;
+	unsigned long flags;
+
+	stop_scan_thread();
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(object, &object_list, object_list) {
+		spin_lock_irqsave(&object->lock, flags);
+		object->min_count = -1;
+		spin_unlock_irqrestore(&object->lock, flags);
+	}
+	rcu_read_unlock();
+
+	start_scan_thread();
+}
+
 /*
  * File write operation to configure kmemleak at run-time. The following
  * commands can be written to the /sys/kernel/debug/kmemleak file:
  *   off	- disable kmemleak (irreversible)
+ *   clear	- mark all current kmemleak objects as black to ingore
+ *		  printing them
  *   stack=on	- enable the task stacks scanning
  *   stack=off	- disable the tasks stacks scanning
  *   scan=on	- start the automatic memory scanning thread
@@ -1324,6 +1344,8 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 
 	if (strncmp(buf, "off", 3) == 0)
 		kmemleak_disable();
+	else if (strncmp(buf, "clear", 5) == 0)
+		kmemleak_clear();
 	else if (strncmp(buf, "stack=on", 8) == 0)
 		kmemleak_stack_scan = 1;
 	else if (strncmp(buf, "stack=off", 9) == 0)
-- 
1.6.3.3

