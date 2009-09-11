Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZIKCcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZIKCcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 22:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZIKCcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 22:32:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:2578 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZIKCcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 22:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,367,1249282800"; 
   d="scan'208";a="186432880"
Message-Id: <20090911023200.649862599@intel.com>
References: <20090911022333.324128054@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 11 Sep 2009 10:23:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Avi Kivity <avi@qumranet.com>, Wu Fengguang <fengguang.wu@intel.com>
cc: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] devmem: introduce size_inside_page()
Content-Disposition: inline; filename=kmem-round-to-page-size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce size_inside_page() to replace duplicate /dev/mem code.

Also apply it to /dev/kmem, whose alignment logic was buggy.


CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: Avi Kivity <avi@qumranet.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   60 +++++++++++++------------------------------
 1 file changed, 19 insertions(+), 41 deletions(-)

--- linux.orig/drivers/char/mem.c
+++ linux/drivers/char/mem.c
@@ -35,6 +35,19 @@
 # include <linux/efi.h>
 #endif
 
+static inline unsigned long size_inside_page(unsigned long start,
+					     unsigned long size)
+{
+	unsigned long sz;
+
+	if (-start & (PAGE_SIZE - 1))
+		sz = -start & (PAGE_SIZE - 1);
+	else
+		sz = PAGE_SIZE;
+
+	return min_t(unsigned long, sz, size);
+}
+
 /*
  * Architectures vary in how they handle caching for addresses
  * outside of main memory.
@@ -142,15 +155,7 @@ static ssize_t read_mem(struct file * fi
 #endif
 
 	while (count > 0) {
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-p & (PAGE_SIZE - 1))
-			sz = -p & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
-
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, count))
 			return -EPERM;
@@ -209,15 +214,7 @@ static ssize_t write_mem(struct file * f
 #endif
 
 	while (count > 0) {
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-p & (PAGE_SIZE - 1))
-			sz = -p & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
-
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(p, count);
 
 		if (!range_is_allowed(p >> PAGE_SHIFT, sz))
 			return -EPERM;
@@ -430,15 +427,7 @@ static ssize_t read_kmem(struct file *fi
 		}
 #endif
 		while (low_count > 0) {
-			/*
-			 * Handle first page in case it's not aligned
-			 */
-			if (-p & (PAGE_SIZE - 1))
-				sz = -p & (PAGE_SIZE - 1);
-			else
-				sz = PAGE_SIZE;
-
-			sz = min_t(unsigned long, sz, low_count);
+			sz = size_inside_page(p, low_count);
 
 			/*
 			 * On ia64 if a page has been mapped somewhere as
@@ -462,10 +451,8 @@ static ssize_t read_kmem(struct file *fi
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
-			int len = count;
+			int len = size_inside_page(p, count);
 
-			if (len > PAGE_SIZE)
-				len = PAGE_SIZE;
 			len = vread(kbuf, (char *)p, len);
 			if (!len)
 				break;
@@ -510,15 +497,8 @@ do_write_kmem(void *p, unsigned long rea
 
 	while (count > 0) {
 		char *ptr;
-		/*
-		 * Handle first page in case it's not aligned
-		 */
-		if (-realp & (PAGE_SIZE - 1))
-			sz = -realp & (PAGE_SIZE - 1);
-		else
-			sz = PAGE_SIZE;
 
-		sz = min_t(unsigned long, sz, count);
+		sz = size_inside_page(realp, count);
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
@@ -578,10 +558,8 @@ static ssize_t write_kmem(struct file * 
 		if (!kbuf)
 			return wrote ? wrote : -ENOMEM;
 		while (count > 0) {
-			int len = count;
+			int len = size_inside_page(p, count);
 
-			if (len > PAGE_SIZE)
-				len = PAGE_SIZE;
 			written = copy_from_user(kbuf, buf, len);
 			if (written) {
 				if (wrote + virtr)

-- 

