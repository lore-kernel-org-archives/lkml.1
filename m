Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbYGCOPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbYGCOPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYGCOPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:15:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbYGCOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:15:24 -0400
Message-ID: <486CDEC2.5030803@linux-foundation.org>
Date: Thu, 03 Jul 2008 09:14:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Matt Mackall <mpm@selenic.com>, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
Subject: slub: Do not use 192 byte sized cache if minimum alignment is 128
 byte
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 192 byte cache is not necessary if we have a basic alignment of 128
byte. If it would be used then the 192 would be aligned to the next 128 byte
boundary which would result in another 256 byte cache. Two 256 kmalloc caches
cause sysfs to complain about a duplicate entry.

MIPS needs 128 byte aligned kmalloc caches and spits out warnings on boot without
this patch.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2008-07-02 13:57:29.000000000 -0500
+++ linux-2.6/include/linux/slub_def.h	2008-07-02 13:58:00.000000000 -0500
@@ -137,10 +137,12 @@
 	if (size <= KMALLOC_MIN_SIZE)
 		return KMALLOC_SHIFT_LOW;
 
+#if KMALLOC_MIN_SIZE <= 64
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
 		return 2;
+#endif
 	if (size <=          8) return 3;
 	if (size <=         16) return 4;
 	if (size <=         32) return 5;
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-07-02 13:57:29.000000000 -0500
+++ linux-2.6/mm/slub.c	2008-07-02 13:58:07.000000000 -0500
@@ -2995,8 +2995,6 @@
 		create_kmalloc_cache(&kmalloc_caches[1],
 				"kmalloc-96", 96, GFP_KERNEL);
 		caches++;
-	}
-	if (KMALLOC_MIN_SIZE <= 128) {
 		create_kmalloc_cache(&kmalloc_caches[2],
 				"kmalloc-192", 192, GFP_KERNEL);
 		caches++;
@@ -3026,6 +3024,16 @@
 	for (i = 8; i < KMALLOC_MIN_SIZE; i += 8)
 		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;
 
+	if (KMALLOC_MIN_SIZE == 128) {
+		/*
+		 * The 192 byte sized cache is not used if the alignment
+		 * is 128 byte. Redirect kmalloc to use the 256 byte cache
+		 * instead.
+		 */
+		for (i = 128 + 8; i <= 192; i += 8)
+			size_index[(i - 1) / 8] = 8;
+	}
+
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
