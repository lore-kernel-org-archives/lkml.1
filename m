Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYKTLcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYKTLcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYKTLbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:31:12 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47386 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396AbYKTLbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:31:11 -0500
Subject: [PATCH 2.6.28-rc5 07/11] kmemleak: Remove some of the kmemleak false
	positives
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 20 Nov 2008 11:31:07 +0000
Message-ID: <20081120113107.16607.76990.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.286.g8983
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 11:31:08.0134 (UTC) FILETIME=[7B3CD860:01C94B03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are allocations for which the main pointer cannot be found but
they are not memory leaks. This patch fixes some of them. For more
information on false positives, see Documentation/kmemleak.txt.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/char/vt.c      |    5 +++++
 include/linux/percpu.h |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index a5af607..179960b 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
+#include <linux/memleak.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -2882,6 +2883,10 @@ static int __init con_init(void)
 	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		/* kmemleak does not track the memory allocated via
+		 * alloc_bootmem() but this block contains pointers to
+		 * other blocks allocated via kmalloc */
+		memleak_alloc(vc, sizeof(struct vc_data), 1);
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = (unsigned short *)alloc_bootmem(vc->vc_screenbuf_size);
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9f2a375..4d1ce18 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -69,7 +69,12 @@ struct percpu_data {
 	void *ptrs[1];
 };
 
+/* pointer disguising messes up the kmemleak objects tracking */
+#ifndef CONFIG_DEBUG_MEMLEAK
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
+#else
+#define __percpu_disguise(pdata) (struct percpu_data *)(pdata)
+#endif
 /* 
  * Use this to get to a cpu's version of the per-cpu object dynamically
  * allocated. Non-atomic access to the current CPU's version should

