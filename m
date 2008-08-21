Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbYHUNUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbYHUNUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbYHUNUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:20:17 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:37569 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYHUNUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:20:15 -0400
Message-ID: <48AD6B4A.1020803@csr.com>
Date: Thu, 21 Aug 2008 14:19:06 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: [patch] bitmap: add bitmap_copy_le()
References: <48AD6AF0.3050504@csr.com>
In-Reply-To: <48AD6AF0.3050504@csr.com>
Content-Type: multipart/mixed;
 boundary="------------090104030106020003020508"
X-OriginalArrivalTime: 21 Aug 2008 13:19:06.0421 (UTC) FILETIME=[7D01BE50:01C90390]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090104030106020003020508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/

--------------090104030106020003020508
Content-Type: text/x-diff;
 name="bitmap-add-bitmap_copy_le.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bitmap-add-bitmap_copy_le.patch"

bitmap: add bitmap_copy_le()

From: David Vrabel <david.vrabel@csr.com>

bitmap_copy_le() copies a bitmap, putting the bits into little-endian
order (i.e., each unsigned long word in the bitmap is put into
little-endian order).

The UWB stack used bitmaps to manage Medium Access Slot availability,
and these bitmaps need to be written to the hardware in LE order.

Signed-off-by: David Vrabel <david.vrabel@csr.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/bitmap.h |    1 +
 lib/bitmap.c           |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

Index: linux-git/include/linux/bitmap.h
===================================================================
--- linux-git.orig/include/linux/bitmap.h	2008-08-12 14:51:02.000000000 +0100
+++ linux-git/include/linux/bitmap.h	2008-08-12 14:51:07.000000000 +0100
@@ -129,6 +129,7 @@
 extern int bitmap_find_free_region(unsigned long *bitmap, int bits, int order);
 extern void bitmap_release_region(unsigned long *bitmap, int pos, int order);
 extern int bitmap_allocate_region(unsigned long *bitmap, int pos, int order);
+extern void bitmap_copy_le(void *dst, const unsigned long *src, int nbits);
 
 #define BITMAP_LAST_WORD_MASK(nbits)					\
 (									\
Index: linux-git/lib/bitmap.c
===================================================================
--- linux-git.orig/lib/bitmap.c	2008-08-12 14:51:02.000000000 +0100
+++ linux-git/lib/bitmap.c	2008-08-12 14:51:07.000000000 +0100
@@ -996,3 +996,25 @@
 	return 0;
 }
 EXPORT_SYMBOL(bitmap_allocate_region);
+
+/**
+ * bitmap_copy_le - copy a bitmap, putting the bits into little-endian order.
+ * @dst:   destination buffer
+ * @src:   bitmap to copy
+ * @nbits: number of bits in the bitmap
+ *
+ * Require nbits % BITS_PER_LONG == 0.
+ */
+void bitmap_copy_le(void *dst, const unsigned long *src, int nbits)
+{
+	unsigned long *d = dst;
+	int i;
+
+	for (i = 0; i < nbits/BITS_PER_LONG; i++) {
+		if (BITS_PER_LONG == 64)
+			d[i] = cpu_to_le64(src[i]);
+		else
+			d[i] = cpu_to_le32(src[i]);
+	}
+}
+EXPORT_SYMBOL(bitmap_copy_le);

--------------090104030106020003020508--
