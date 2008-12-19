Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYLSL0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYLSL0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYLSL0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:26:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:44196 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750873AbYLSL0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:26:37 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19GeTdqUflG1ZiTcWI1glwoHU7ze4Cq6hUtN9cdZ+
	L6Vz13++qPGexb
Date: Fri, 19 Dec 2008 12:26:41 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bitmap: fix bitmap_find_free_region()
Message-ID: <Pine.LNX.4.64.0812191202130.4536@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently bitmap_find_free_region() assumes, that the requested region 
size is smaller than the entire bitmap. If this is not the case it fails 
to detect it and returns success, while pointing at a position outside of 
the region.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
It is hard to believe, that this is a bug, last time this code was touched 
in 2006... Or should the caller guarantee, that the requested region is 
not larger than the bitmap? Then dma_alloc_from_coherent() is buggy, which 
is where I hit this bug. But it seems to me bitmap_find_free_region() 
should be fixed.

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1338469..079c5e3 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -950,6 +950,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
 {
 	int pos;		/* scans bitmap by regions of size order */
 
+	if (bits < 1 << order)
+		return -ENOMEM;
+
 	for (pos = 0; pos < bits; pos += (1 << order))
 		if (__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 			break;
