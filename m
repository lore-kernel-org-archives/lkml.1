Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbZDXQpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbZDXQpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760117AbZDXQmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:42:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41681 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760148AbZDXQmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:42:45 -0400
Subject: [PATCH 11/14] kmemleak: Remove some of the kmemleak false positives
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Apr 2009 17:42:00 +0100
Message-ID: <20090424164159.4476.74762.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
References: <20090424163500.4476.62146.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.369.gbbd9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Apr 2009 16:42:44.0438 (UTC) FILETIME=[B121AF60:01C9C4FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are allocations for which the main pointer cannot be found but
they are not memory leaks. This patch fixes some of them. For more
information on false positives, see Documentation/kmemleak.txt.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/char/vt.c      |    7 +++++++
 fs/block_dev.c         |    6 ++++++
 include/linux/percpu.h |    5 +++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 08151d4..961c1a7 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
+#include <linux/kmemleak.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -2880,6 +2881,12 @@ static int __init con_init(void)
 	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		/*
+		 * Kmemleak does not track the memory allocated via
+		 * alloc_bootmem() but this block contains pointers to
+		 * other blocks allocated via kmalloc.
+		 */
+		kmemleak_alloc(vc, sizeof(struct vc_data), 1, GFP_ATOMIC);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index f45dbc1..d250f80 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -25,6 +25,7 @@
 #include <linux/uio.h>
 #include <linux/namei.h>
 #include <linux/log2.h>
+#include <linux/kmemleak.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -492,6 +493,11 @@ void __init bdev_cache_init(void)
 	bd_mnt = kern_mount(&bd_type);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
+	/*
+	 * This vfsmount structure is only used to obtain the
+	 * blockdev_superblock, so tell kmemleak not to report it.
+	 */
+	kmemleak_not_leak(bd_mnt);
 	blockdev_superblock = bd_mnt->mnt_sb;	/* For writeback */
 }
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index cfda2d5..7040a32 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -130,7 +130,12 @@ struct percpu_data {
 	void *ptrs[1];
 };
 
+/* pointer disguising messes up the kmemleak objects tracking */
+#ifndef CONFIG_DEBUG_KMEMLEAK
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
+#else
+#define __percpu_disguise(pdata) (struct percpu_data *)(pdata)
+#endif
 
 #define per_cpu_ptr(ptr, cpu)						\
 ({									\

