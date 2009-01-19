Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbZASOtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbZASOtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZASOrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:23 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:3222 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZASOrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:19 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KDQ3QD-02-0BA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/16] dma-debug: add debugfs interface
Date: Mon, 19 Jan 2009 15:46:54 +0100
Message-ID: <1232376423-11067-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0922 (UTC) FILETIME=[CB04BD20:01C97A44]
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
index 66ed8b1..1e16bd4 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -19,6 +19,7 @@
 
 #include <linux/dma-debug.h>
 #include <linux/spinlock.h>
+#include <linux/debugfs.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -59,12 +60,29 @@ static DEFINE_SPINLOCK(free_entries_lock);
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
@@ -239,6 +257,58 @@ out_err:
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
@@ -254,6 +324,14 @@ void dma_debug_init(u32 num_entries)
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


