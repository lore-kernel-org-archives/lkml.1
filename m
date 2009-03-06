Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZCFNcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZCFNcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbZCFNax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:30:53 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:51468 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754021AbZCFNar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:30:47 -0500
X-BigFish: VPS1(zzzzzzz32i65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KG36UW-01-JL2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/18] dma-debug: add kernel command line parameters
Date: Fri, 6 Mar 2009 14:30:17 +0100
Message-ID: <1236346229-6618-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 06 Mar 2009 13:30:30.0120 (UTC) FILETIME=[B7E6AE80:01C99E5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: add dma_debug= and dma_debug_entries= kernel parameters

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/kernel-parameters.txt |   10 +++++++++
 lib/dma-debug.c                     |   38 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..0fa3c05 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -491,6 +491,16 @@ and is between 256 and 4096 characters. It is defined in the file
 			Range: 0 - 8192
 			Default: 64
 
+	dma_debug=off	If the kernel is compiled with DMA_API_DEBUG support
+			this option disables the debugging code at boot.
+
+	dma_debug_entries=<number>
+			This option allows to tune the number of preallocated
+			entries for DMA-API debugging code. One entry is
+			required per DMA-API allocation. Use this if the
+			DMA-API debugging code disables itself because the
+			architectural default is too low.
+
 	hpet=		[X86-32,HPET] option to control HPET usage
 			Format: { enable (default) | disable | force }
 			disable: disable HPET and use PIT instead
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 5b50bb3..2ede463 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -64,6 +64,9 @@ static bool global_disable __read_mostly;
 static u32 num_free_entries;
 static u32 min_free_entries;
 
+/* number of preallocated entries requested by kernel cmdline */
+static u32 req_entries;
+
 /*
  * Hash related functions
  *
@@ -253,6 +256,9 @@ void dma_debug_init(u32 num_entries)
 		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
 	}
 
+	if (req_entries)
+		num_entries = req_entries;
+
 	if (prealloc_memory(num_entries) != 0) {
 		printk(KERN_ERR "DMA-API: debugging out of memory error "
 				"- disabled\n");
@@ -264,3 +270,35 @@ void dma_debug_init(u32 num_entries)
 	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
 }
 
+static __init int dma_debug_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (strncmp(str, "off", 3) == 0) {
+		printk(KERN_INFO "DMA-API: debugging disabled on kernel "
+				 "command line\n");
+		global_disable = true;
+	}
+
+	return 0;
+}
+
+static __init int dma_debug_entries_cmdline(char *str)
+{
+	int res;
+
+	if (!str)
+		return -EINVAL;
+
+	res = get_option(&str, &req_entries);
+
+	if (!res)
+		req_entries = 0;
+
+	return 0;
+}
+
+__setup("dma_debug=", dma_debug_cmdline);
+__setup("dma_debug_entries=", dma_debug_entries_cmdline);
+
-- 
1.5.6.4


