Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZASOsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZASOsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZASOrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:47:18 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:38662 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZASOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:47:17 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KDQ3QE-04-LPU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
CC: fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/16] dma-debug: add kernel command line parameters
Date: Mon, 19 Jan 2009 15:46:53 +0100
Message-ID: <1232376423-11067-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jan 2009 14:47:03.0876 (UTC) FILETIME=[CAFDB840:01C97A44]
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
index 8511d35..fef67ed 100644
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
index d46c76e..66ed8b1 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -62,6 +62,9 @@ static bool global_disable __read_mostly;
 static u32 num_free_entries;
 static u32 min_free_entries;
 
+/* number of preallocated entries requested by kernel cmdline */
+static u32 req_entries;
+
 /*
  * Hash related functions
  *
@@ -251,6 +254,9 @@ void dma_debug_init(u32 num_entries)
 		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
 	}
 
+	if (req_entries)
+		num_entries = req_entries;
+
 	if (prealloc_memory(num_entries) != 0) {
 		printk(KERN_ERR "DMA-API: debugging out of memory error "
 				"- disabled\n");
@@ -262,3 +268,35 @@ void dma_debug_init(u32 num_entries)
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


