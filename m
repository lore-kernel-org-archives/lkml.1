Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbZJSOte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbZJSOte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbZJSOtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:49:32 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36934 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131AbZJSOtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:49:31 -0400
Subject: [PATCH 3/4] kmemleak: Store object reverse references for debugging
	purposes
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 19 Oct 2009 15:49:34 +0100
Message-ID: <20091019144934.14221.31614.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
References: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 14:49:35.0117 (UTC) FILETIME=[5FE903D0:01CA50CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some memory leak reports which come and go but are hard to
identify whether they are false positives or not. This patch stores up
to 4 reverse references in an object so that once a leak disappeared,
using "echo dump=<ptr> > debug/kmemleak" would list where an object is
referenced from.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 9610635..998162f 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -110,6 +110,7 @@
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define GRAY_LIST_PASSES	25	/* maximum number of gray list scans */
 #define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */
+#define MAX_REV_REF		4	/* number of reverse references */
 
 #define BYTES_PER_POINTER	sizeof(void *)
 
@@ -156,6 +157,7 @@ struct kmemleak_object {
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
 	char comm[TASK_COMM_LEN];	/* executable name */
+	void *rev_ref[MAX_REV_REF];	/* reverse references */
 };
 
 /* flag representing the memory block allocation status */
@@ -379,6 +381,13 @@ static void dump_object_info(struct kmemleak_object *object)
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%lx\n", object->flags);
+	if (object->count) {
+		int i;
+		pr_notice("  referred from:");
+		for (i = 0; i < object->count; i++)
+			printk(" 0x%p", object->rev_ref[i]);
+		printk("\n");
+	}
 	pr_notice("  backtrace:\n");
 	print_stack_trace(&trace, 4);
 }
@@ -1011,8 +1020,12 @@ static void scan_block(void *_start, void *_end,
 		 */
 		spin_lock_irqsave_nested(&object->lock, flags,
 					 SINGLE_DEPTH_NESTING);
+		if (object->count < MAX_REV_REF)
+			object->rev_ref[object->count] = ptr;
+
 		if (!color_white(object)) {
 			/* non-orphan, ignored or new */
+			object->count++;
 			spin_unlock_irqrestore(&object->lock, flags);
 			put_object(object);
 			continue;
@@ -1416,7 +1429,7 @@ static int dump_str_object_info(const char *str)
 	unsigned long addr;
 
 	addr= simple_strtoul(str, NULL, 0);
-	object = find_and_get_object(addr, 0);
+	object = find_and_get_object(addr, 1);
 	if (!object) {
 		pr_info("Unknown object at 0x%08lx\n", addr);
 		return -EINVAL;

