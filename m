Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZGXQMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZGXQMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZGXQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:12:11 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51157 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752410AbZGXQMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:08 -0400
Subject: [PATCH 1/8] kmemleak: Dump object information on request
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Jul 2009 17:12:07 +0100
Message-ID: <20090724161207.5752.32572.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:07.0908 (UTC) FILETIME=[7E10B240:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By writing dump=<addr> to the kmemleak file, kmemleak will look up an
object with that address and dump the information it has about it to
syslog. This is useful in debugging memory leaks.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/kmemleak.txt |    1 +
 mm/kmemleak.c              |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index 8906803..c223785 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -42,6 +42,7 @@ Memory scanning parameters can be modified at run-time by writing to the
   scan=<secs>	- set the automatic memory scanning period in seconds
 		  (default 600, 0 to stop the automatic scanning)
   scan		- trigger a memory scan
+  dump=<addr>	- dump information about the object found at <addr>
 
 Kmemleak can also be disabled at boot-time by passing "kmemleak=off" on
 the kernel command line.
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 4872673..7e8e4b0 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -330,6 +330,7 @@ static void dump_object_info(struct kmemleak_object *object)
 		  object->comm, object->pid, object->jiffies);
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
+	pr_notice("  flags = 0x%lx\n", object->flags);
 	pr_notice("  backtrace:\n");
 	print_stack_trace(&trace, 4);
 }
@@ -1294,6 +1295,27 @@ static int kmemleak_release(struct inode *inode, struct file *file)
 	return seq_release(inode, file);
 }
 
+static int dump_str_object_info(const char *str)
+{
+	unsigned long flags;
+	struct kmemleak_object *object;
+	unsigned long addr;
+
+	addr= simple_strtoul(str, NULL, 0);
+	object = find_and_get_object(addr, 0);
+	if (!object) {
+		pr_info("Unknown object at 0x%08lx\n", addr);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&object->lock, flags);
+	dump_object_info(object);
+	spin_unlock_irqrestore(&object->lock, flags);
+
+	put_object(object);
+	return 0;
+}
+
 /*
  * File write operation to configure kmemleak at run-time. The following
  * commands can be written to the /sys/kernel/debug/kmemleak file:
@@ -1305,6 +1327,7 @@ static int kmemleak_release(struct inode *inode, struct file *file)
  *   scan=...	- set the automatic memory scanning period in seconds (0 to
  *		  disable it)
  *   scan	- trigger a memory scan
+ *   dump=...	- dump information about the object found at the given address
  */
 static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 			      size_t size, loff_t *ppos)
@@ -1345,6 +1368,8 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 		}
 	} else if (strncmp(buf, "scan", 4) == 0)
 		kmemleak_scan();
+	else if (strncmp(buf, "dump=", 5) == 0)
+		ret = dump_str_object_info(buf + 5);
 	else
 		ret = -EINVAL;
 

