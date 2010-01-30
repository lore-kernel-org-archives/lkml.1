Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327Ab0A3JjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0A3JjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214Ab0A3JjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:39:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:23468 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab0A3Jik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:38:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="238540078"
Message-Id: <20100130093703.718660392@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:25:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
to: Andi Kleen <andi@firstfloor.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Greg KH <greg@kroah.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 1/4] hwpoison: prevent /dev/kmem from accessing hwpoison pages
References: <20100130092509.793222613@intel.com>
Content-Disposition: inline; filename=hwpoison-dev-kmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /dev/kmem read()/write() encounters hwpoison page, stop it
and return the amount of work done till now, or return -EIO if
nothing have been copied.

For simplicity, hwpoison pages accessed by vmalloc address are
siliently skipped, instead of returning -EIO.

CC: Greg KH <greg@kroah.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   18 ++++++++++++++----
 mm/vmalloc.c       |    4 ++--
 2 files changed, 16 insertions(+), 6 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2010-01-30 17:14:12.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2010-01-30 17:20:18.000000000 +0800
@@ -426,6 +426,9 @@ static ssize_t read_kmem(struct file *fi
 			 */
 			kbuf = xlate_dev_kmem_ptr((char *)p);
 
+			if (unlikely(virt_addr_valid(kbuf) &&
+				     PageHWPoison(virt_to_page(kbuf))))
+				return -EIO;
 			if (copy_to_user(buf, kbuf, sz))
 				return -EFAULT;
 			buf += sz;
@@ -471,6 +474,7 @@ do_write_kmem(unsigned long p, const cha
 {
 	ssize_t written, sz;
 	unsigned long copied;
+	int err = 0;
 
 	written = 0;
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
@@ -497,13 +501,19 @@ do_write_kmem(unsigned long p, const cha
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
@@ -511,7 +521,7 @@ do_write_kmem(unsigned long p, const cha
 	}
 
 	*ppos += written;
-	return written;
+	return written ? written : err;
 }
 
 
--- linux-mm.orig/mm/vmalloc.c	2010-01-30 17:14:15.000000000 +0800
+++ linux-mm/mm/vmalloc.c	2010-01-30 17:20:18.000000000 +0800
@@ -1669,7 +1669,7 @@ static int aligned_vread(char *buf, char
 		 * interface, rarely used. Instead of that, we'll use
 		 * kmap() and get small overhead in this access function.
 		 */
-		if (p) {
+		if (p && !PageHWPoison(p)) {
 			/*
 			 * we can expect USER0 is not used (see vread/vwrite's
 			 * function description)
@@ -1708,7 +1708,7 @@ static int aligned_vwrite(char *buf, cha
 		 * interface, rarely used. Instead of that, we'll use
 		 * kmap() and get small overhead in this access function.
 		 */
-		if (p) {
+		if (p && !PageHWPoison(p)) {
 			/*
 			 * we can expect USER0 is not used (see vread/vwrite's
 			 * function description)


