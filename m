Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZILPZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZILPZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZILPYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:24:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:39984 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbZILPYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,376,1249282800"; 
   d="scan'208";a="186918803"
Message-Id: <20090912152259.123124076@intel.com>
References: <20090912152039.479536123@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:20:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>, Avi Kivity <avi@qumranet.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] devmem: make size_inside_page() logic straight
Content-Disposition: inline; filename=kmem-size_inside_page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also convert more size_inside_page() users.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-12 23:01:24.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-12 23:01:25.000000000 +0800
@@ -40,12 +40,9 @@ static inline unsigned long size_inside_
 {
 	unsigned long sz;
 
-	if (-start & (PAGE_SIZE - 1))
-		sz = -start & (PAGE_SIZE - 1);
-	else
-		sz = PAGE_SIZE;
+	sz = PAGE_SIZE - (start & (PAGE_SIZE - 1));
 
-	return min_t(unsigned long, sz, size);
+	return min(sz, size);
 }
 
 /*
@@ -137,9 +134,7 @@ static ssize_t read_mem(struct file * fi
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (p < PAGE_SIZE) {
-		sz = PAGE_SIZE - p;
-		if (sz > count) 
-			sz = count; 
+		sz = size_inside_page(p, count);
 		if (sz > 0) {
 			if (clear_user(buf, sz))
 				return -EFAULT;
@@ -202,9 +197,7 @@ static ssize_t write_mem(struct file * f
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (p < PAGE_SIZE) {
-		unsigned long sz = PAGE_SIZE - p;
-		if (sz > count)
-			sz = count;
+		sz = size_inside_page(p, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
@@ -416,15 +409,14 @@ static ssize_t read_kmem(struct file *fi
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 		/* we don't have page 0 mapped on sparc and m68k.. */
 		if (p < PAGE_SIZE && low_count > 0) {
-			size_t tmp = PAGE_SIZE - p;
-			if (tmp > low_count) tmp = low_count;
-			if (clear_user(buf, tmp))
+			sz = size_inside_page(p, low_count);
+			if (clear_user(buf, sz))
 				return -EFAULT;
-			buf += tmp;
-			p += tmp;
-			read += tmp;
-			low_count -= tmp;
-			count -= tmp;
+			buf += sz;
+			p += sz;
+			read += sz;
+			low_count -= sz;
+			count -= sz;
 		}
 #endif
 		while (low_count > 0) {
@@ -484,9 +476,7 @@ do_write_kmem(void *p, unsigned long rea
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
 	if (realp < PAGE_SIZE) {
-		unsigned long sz = PAGE_SIZE - realp;
-		if (sz > count)
-			sz = count;
+		sz = size_inside_page(realp, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;

-- 

