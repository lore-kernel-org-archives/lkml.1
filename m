Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZILPYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZILPYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbZILPYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:24:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:44692 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbZILPYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:24:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,376,1249282800"; 
   d="scan'208";a="186918799"
Message-Id: <20090912152259.257329119@intel.com>
References: <20090912152039.479536123@intel.com>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:20:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@linux.intel.com>, Avi Kivity <avi@qumranet.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] devmem: remove the "written" variable in write_kmem()
Content-Disposition: inline; filename=kmem-remove-written.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also rename "len" to "sz". No behavior change.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   48 ++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-12 23:03:41.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-12 23:14:33.000000000 +0800
@@ -444,19 +444,18 @@ static ssize_t read_kmem(struct file *fi
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
-			int len = size_inside_page(p, count);
-
-			len = vread(kbuf, (char *)p, len);
-			if (!len)
+			sz = size_inside_page(p, count);
+			sz = vread(kbuf, (char *)p, sz);
+			if (!sz)
 				break;
-			if (copy_to_user(buf, kbuf, len)) {
+			if (copy_to_user(buf, kbuf, sz)) {
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			count -= len;
-			buf += len;
-			read += len;
-			p += len;
+			count -= sz;
+			buf += sz;
+			read += sz;
+			p += sz;
 		}
 		free_page((unsigned long)kbuf);
 	}
@@ -526,19 +525,14 @@ static ssize_t write_kmem(struct file * 
 	unsigned long p = *ppos;
 	ssize_t wrote = 0;
 	ssize_t virtr = 0;
-	ssize_t written;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
 
 	if (p < (unsigned long) high_memory) {
-
-		wrote = count;
-		if (count > (unsigned long) high_memory - p)
-			wrote = (unsigned long) high_memory - p;
-
-		written = do_write_kmem((void*)p, p, buf, wrote, ppos);
-		if (written != wrote)
-			return written;
-		wrote = written;
+		unsigned long to_write = min_t(unsigned long, count,
+					       (unsigned long)high_memory - p);
+		wrote = do_write_kmem((void *)p, p, buf, to_write, ppos);
+		if (wrote != to_write)
+			return wrote;
 		p += wrote;
 		buf += wrote;
 		count -= wrote;
@@ -549,20 +543,20 @@ static ssize_t write_kmem(struct file * 
 		if (!kbuf)
 			return wrote ? wrote : -ENOMEM;
 		while (count > 0) {
-			int len = size_inside_page(p, count);
+			unsigned long sz = size_inside_page(p, count);
 
-			written = copy_from_user(kbuf, buf, len);
-			if (written) {
+			sz = copy_from_user(kbuf, buf, sz);
+			if (sz) {
 				if (wrote + virtr)
 					break;
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			len = vwrite(kbuf, (char *)p, len);
-			count -= len;
-			buf += len;
-			virtr += len;
-			p += len;
+			sz = vwrite(kbuf, (char *)p, sz);
+			count -= sz;
+			buf += sz;
+			virtr += sz;
+			p += sz;
 		}
 		free_page((unsigned long)kbuf);
 	}

-- 

