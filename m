Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822Ab0AVFUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0AVFUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 00:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982Ab0AVFT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 00:19:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:25128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0AVFT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 00:19:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="533525968"
Message-Id: <20100122051517.259910264@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 12:59:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, <stable@kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 1/4] devmem: check vmalloc address on kmem read/write
References: <20100122045914.993668874@intel.com>
Content-Disposition: inline; filename=vmalloc-addr-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Otherwise vmalloc_to_page() will BUG().

This also makes the kmem read/write implementation aligned with mem(4):
"References to nonexistent locations cause errors to be returned." Here
we return -ENXIO (inspired by Hugh) if no bytes have been transfered
to/from user space, otherwise return partial read/write results.

CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: <stable@kernel.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2010-01-11 10:22:35.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2010-01-11 10:32:32.000000000 +0800
@@ -395,6 +395,7 @@ static ssize_t read_kmem(struct file *fi
 	unsigned long p = *ppos;
 	ssize_t low_count, read, sz;
 	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
+	int err = 0;
 
 	read = 0;
 	if (p < (unsigned long) high_memory) {
@@ -441,12 +442,16 @@ static ssize_t read_kmem(struct file *fi
 			return -ENOMEM;
 		while (count > 0) {
 			sz = size_inside_page(p, count);
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			sz = vread(kbuf, (char *)p, sz);
 			if (!sz)
 				break;
 			if (copy_to_user(buf, kbuf, sz)) {
-				free_page((unsigned long)kbuf);
-				return -EFAULT;
+				err = -EFAULT;
+				break;
 			}
 			count -= sz;
 			buf += sz;
@@ -455,8 +460,8 @@ static ssize_t read_kmem(struct file *fi
 		}
 		free_page((unsigned long)kbuf);
 	}
- 	*ppos = p;
- 	return read;
+	*ppos = p;
+	return read ? read : err;
 }
 
 
@@ -520,6 +525,7 @@ static ssize_t write_kmem(struct file * 
 	ssize_t wrote = 0;
 	ssize_t virtr = 0;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
+	int err = 0;
 
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
@@ -540,12 +546,14 @@ static ssize_t write_kmem(struct file * 
 			unsigned long sz = size_inside_page(p, count);
 			unsigned long n;
 
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			n = copy_from_user(kbuf, buf, sz);
 			if (n) {
-				if (wrote + virtr)
-					break;
-				free_page((unsigned long)kbuf);
-				return -EFAULT;
+				err = -EFAULT;
+				break;
 			}
 			sz = vwrite(kbuf, (char *)p, sz);
 			count -= sz;
@@ -556,8 +564,8 @@ static ssize_t write_kmem(struct file * 
 		free_page((unsigned long)kbuf);
 	}
 
- 	*ppos = p;
- 	return virtr + wrote;
+	*ppos = p;
+	return virtr + wrote ? : err;
 }
 #endif
 


