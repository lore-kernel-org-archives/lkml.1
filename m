Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031816Ab0B1K7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:59:14 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:51694 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031807Ab0B1K7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XtblkmBz60R+uSrYGTmJ9vTfbmylDVX2k8h1y7bhWiewgM5Ut8vh38Nq1a+94z5nE7
         iyeBhz3PN4qiLFpMzz+MnISXWHSkZT/4vSS+b1V423aS/SQpBzuoJx3AX1FYy4P8by1J
         obGIFecyJ/SmKMBdC50Pw49tG6v4Bmd4h1AVI=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc: use __ratelimit
Date: Sun, 28 Feb 2010 19:58:16 +0900
Message-Id: <1267354697-6456-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded rate limiting logic with __ratelimit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/platforms/iseries/pci.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/iseries/pci.c b/arch/powerpc/platforms/iseries/pci.c
index 175aac8..5873a47 100644
--- a/arch/powerpc/platforms/iseries/pci.c
+++ b/arch/powerpc/platforms/iseries/pci.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <linux/ratelimit.h>
 
 #include <asm/types.h>
 #include <asm/io.h>
@@ -583,14 +584,9 @@ static inline struct device_node *xlate_iomm_address(
 
 	orig_addr = (unsigned long __force)addr;
 	if ((orig_addr < BASE_IO_MEMORY) || (orig_addr >= max_io_memory)) {
-		static unsigned long last_jiffies;
-		static int num_printed;
+		static DEFINE_RATELIMIT_STATE(ratelimit, 60 * HZ, 10);
 
-		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
-			last_jiffies = jiffies;
-			num_printed = 0;
-		}
-		if (num_printed++ < 10)
+		if (__ratelimit(&ratelimit))
 			printk(KERN_ERR
 				"iSeries_%s: invalid access at IO address %p\n",
 				func, addr);
-- 
1.6.0.6

