Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZIPDHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZIPDHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZIPDHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:07:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:26612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZIPDHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="188105384"
Message-Id: <20090916030604.185127557@intel.com>
References: <20090916030009.585103525@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 11:00:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 2/4] devmem: check vmalloc address on kmem read/write
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
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-16 10:48:16.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-16 10:57:13.000000000 +0800
@@ -396,6 +396,7 @@ static ssize_t read_kmem(struct file *fi
 	unsigned long p = *ppos;
 	ssize_t low_count, read, sz;
 	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
+	int err = 0;
 
 	read = 0;
 	if (p < (unsigned long) high_memory) {
@@ -442,12 +443,16 @@ static ssize_t read_kmem(struct file *fi
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
@@ -457,7 +462,7 @@ static ssize_t read_kmem(struct file *fi
 		free_page((unsigned long)kbuf);
 	}
  	*ppos = p;
- 	return read;
+ 	return read ? read : err;
 }
 
 
@@ -521,6 +526,7 @@ static ssize_t write_kmem(struct file * 
 	ssize_t wrote = 0;
 	ssize_t virtr = 0;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
+	int err = 0;
 
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
@@ -541,12 +547,14 @@ static ssize_t write_kmem(struct file * 
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
 			vwrite(kbuf, (char *)p, sz);
 			count -= sz;
@@ -558,7 +566,7 @@ static ssize_t write_kmem(struct file * 
 	}
 
  	*ppos = p;
- 	return virtr + wrote;
+ 	return virtr + wrote ? : err;
 }
 #endif
 

-- 

