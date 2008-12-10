Return-Path: <linux-kernel-owner+w=401wt.eu-S1756109AbYLJSbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbYLJSbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYLJS2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:28:03 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33244 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbYLJS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:27:57 -0500
Subject: [PATCH 11/15] kmemleak: Remove some of the kmemleak false positives
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 10 Dec 2008 18:27:55 +0000
Message-ID: <20081210182755.30323.94918.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:27:55.0480 (UTC) FILETIME=[050A0580:01C95AF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are allocations for which the main pointer cannot be found but
they are not memory leaks. This patch fixes some of them. For more
information on false positives, see Documentation/kmemleak.txt.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/char/vt.c      |    7 +++++++
 include/linux/percpu.h |    5 +++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index a5af607..a36221b 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
+#include <linux/memleak.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -2882,6 +2883,12 @@ static int __init con_init(void)
 	 */
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = alloc_bootmem(sizeof(struct vc_data));
+		/*
+		 * Kmemleak does not track the memory allocated via
+		 * alloc_bootmem() but this block contains pointers to
+		 * other blocks allocated via kmalloc.
+		 */
+		memleak_alloc(vc, sizeof(struct vc_data), 1, GFP_ATOMIC);
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

