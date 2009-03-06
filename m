Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZCFNed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZCFNed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZCFNa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:57 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:55390
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754027AbZCFNar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:47 -0500
X-BigFish: VPS1(zzzzzzz32i63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KG36UW-02-TL5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/18] dma-debug: add debugfs interface
Date: Fri, 6 Mar 2009 14:30:18 +0100
Message-ID: <1236346229-6618-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0245 (UTC) FILETIME=[B7F9C150:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add debugfs interface for configuring DMA-API debugging

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 2ede463..20d6cdb 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -19,6 +19,7 @@
 
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
+#include <linux/debugfs.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -61,12 +62,29 @@ static DEFINE_SPINLOCK(free_entries_lock);
 /* Global disable flag - will be set in case of an error */
 static bool global_disable __read_mostly;
 
+/* Global error count */
+static u32 error_count;
+
+/* Global error show enable*/
+static u32 show_all_errors __read_mostly;
+/* Number of errors to show */
+static u32 show_num_errors = 1;
+
 static u32 num_free_entries;
 static u32 min_free_entries;
 
 /* number of preallocated entries requested by kernel cmdline */
 static u32 req_entries;
 
+/* debugfs dentry's for the stuff above */
+static struct dentry *dma_debug_dent        __read_mostly;
+static struct dentry *global_disable_dent   __read_mostly;
+static struct dentry *error_count_dent      __read_mostly;
+static struct dentry *show_all_errors_dent  __read_mostly;
+static struct dentry *show_num_errors_dent  __read_mostly;
+static struct dentry *num_free_entries_dent __read_mostly;
+static struct dentry *min_free_entries_dent __read_mostly;
+
 /*
  * Hash related functions
  *
@@ -241,6 +259,58 @@ out_err:
 	return -ENOMEM;
 }
 
+static int dma_debug_fs_init(void)
+{
+	dma_debug_dent = debugfs_create_dir("dma-api", NULL);
+	if (!dma_debug_dent) {
+		printk(KERN_ERR "DMA-API: can not create debugfs directory\n");
+		return -ENOMEM;
+	}
+
+	global_disable_dent = debugfs_create_bool("disabled", 0444,
+			dma_debug_dent,
+			(u32 *)&global_disable);
+	if (!global_disable_dent)
+		goto out_err;
+
+	error_count_dent = debugfs_create_u32("error_count", 0444,
+			dma_debug_dent, &error_count);
+	if (!error_count_dent)
+		goto out_err;
+
+	show_all_errors_dent = debugfs_create_u32("all_errors", 0644,
+			dma_debug_dent,
+			&show_all_errors);
+	if (!show_all_errors_dent)
+		goto out_err;
+
+	show_num_errors_dent = debugfs_create_u32("num_errors", 0644,
+			dma_debug_dent,
+			&show_num_errors);
+	if (!show_num_errors_dent)
+		goto out_err;
+
+	num_free_entries_dent = debugfs_create_u32("num_free_entries", 0444,
+			dma_debug_dent,
+			&num_free_entries);
+	if (!num_free_entries_dent)
+		goto out_err;
+
+	min_free_entries_dent = debugfs_create_u32("min_free_entries", 0444,
+			dma_debug_dent,
+			&min_free_entries);
+	if (!min_free_entries_dent)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	debugfs_remove_recursive(dma_debug_dent);
+
+	return -ENOMEM;
+}
+
+
 /*
  * Let the architectures decide how many entries should be preallocated.
  */
@@ -256,6 +326,14 @@ void dma_debug_init(u32 num_entries)
 		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
 	}
 
+	if (dma_debug_fs_init() != 0) {
+		printk(KERN_ERR "DMA-API: error creating debugfs entries "
+				"- disabling\n");
+		global_disable = true;
+
+		return;
+	}
+
 	if (req_entries)
 		num_entries = req_entries;
 
-- 
1.5.6.4


