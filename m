Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZIPBwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZIPBwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZIPBvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:51:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:14785 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZIPBvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:51:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="188088270"
Message-Id: <20090916014958.969524517@intel.com>
References: <20090916013939.656308742@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 09:39:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [PATCH 3/3] HWPOISON: prevent /dev/kmem users from accessing hwpoison pages
Content-Disposition: inline; filename=kmem-dev-kmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /dev/kmem read()/write() encounters hwpoison page, stop it
and return the amount of work done till now.

Vmalloc pages are not checked for now, to avoid conflicts with
ongoing vread/vwrite works.

CC: Greg KH <greg@kroah.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-16 09:25:34.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-16 09:25:43.000000000 +0800
@@ -427,6 +427,9 @@ static ssize_t read_kmem(struct file *fi
 			 */
 			kbuf = xlate_dev_kmem_ptr((char *)p);
 
+			if (unlikely(virt_addr_valid(kbuf) &&
+				     PageHWPoison(virt_to_page(kbuf))))
+				return -EIO;
 			if (copy_to_user(buf, kbuf, sz))
 				return -EFAULT;
 			buf += sz;
@@ -472,6 +475,7 @@ do_write_kmem(unsigned long p, const cha
 {
 	ssize_t written, sz;
 	unsigned long copied;
+	int err = 0;
 
 	written = 0;
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
@@ -498,13 +502,19 @@ do_write_kmem(unsigned long p, const cha
 		 */
 		ptr = xlate_dev_kmem_ptr((char *)p);
 
+		if (unlikely(virt_addr_valid(ptr) &&
+			     PageHWPoison(virt_to_page(ptr)))) {
+			err = -EIO;
+			break;
+		}
+
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
 			written += sz - copied;
-			if (written)
-				break;
-			return -EFAULT;
+			err = -EFAULT;
+			break;
 		}
+
 		buf += sz;
 		p += sz;
 		count -= sz;
@@ -512,7 +522,7 @@ do_write_kmem(unsigned long p, const cha
 	}
 
 	*ppos += written;
-	return written;
+	return written ? written : err;
 }
 
 

-- 

