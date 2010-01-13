Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461Ab0AMOAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0AMOAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438Ab0AMOAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:00:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:31684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab0AMOAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:00:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,268,1262592000"; 
   d="scan'208";a="763861833"
Message-Id: <20100113135957.985957389@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Jan 2010 21:53:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kelly Bowa <kmb@tuxedu.org>, Greg KH <greg@kroah.com>,
       Andi Kleen <andi@firstfloor.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 6/8] hwpoison: prevent /dev/kmem from accessing hwpoison pages
References: <20100113135305.013124116@intel.com>
Content-Disposition: inline; filename=hwpoison-dev-kmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /dev/kmem read()/write() encounters hwpoison page, stop it
and return the amount of work done till now, or return -EIO if
nothing have been copied.

CC: Kelly Bowa <kmb@tuxedu.org>
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
 drivers/char/mem.c |   26 ++++++++++++++++++++------
 mm/vmalloc.c       |    8 ++++++++
 2 files changed, 28 insertions(+), 6 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2010-01-11 10:32:39.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2010-01-11 10:32:42.000000000 +0800
@@ -426,6 +426,9 @@ static ssize_t read_kmem(struct file *fi
 			 */
 			kbuf = xlate_dev_kmem_ptr((char *)p);
 
+			if (unlikely(virt_addr_valid(kbuf) &&
+				     PageHWPoison(virt_to_page(kbuf))))
+				return -EIO;
 			if (copy_to_user(buf, kbuf, sz))
 				return -EFAULT;
 			buf += sz;
@@ -447,8 +450,10 @@ static ssize_t read_kmem(struct file *fi
 				break;
 			}
 			sz = vread_page(kbuf, (char *)p, sz);
-			if (!sz)
+			if (sz <= 0) {
+				err = sz;
 				break;
+			}
 			if (copy_to_user(buf, kbuf, sz)) {
 				err = -EFAULT;
 				break;
@@ -471,6 +476,7 @@ do_write_kmem(unsigned long p, const cha
 {
 	ssize_t written, sz;
 	unsigned long copied;
+	int err = 0;
 
 	written = 0;
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
@@ -497,13 +503,19 @@ do_write_kmem(unsigned long p, const cha
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
@@ -511,7 +523,7 @@ do_write_kmem(unsigned long p, const cha
 	}
 
 	*ppos += written;
-	return written;
+	return written ? written : err;
 }
 
 
@@ -555,7 +567,9 @@ static ssize_t write_kmem(struct file * 
 				err = -EFAULT;
 				break;
 			}
-			vwrite_page(kbuf, (char *)p, sz);
+			err = vwrite_page(kbuf, (char *)p, sz);
+			if (err < 0)
+				break;
 			count -= sz;
 			buf += sz;
 			virtr += sz;
--- linux-mm.orig/mm/vmalloc.c	2010-01-11 10:32:39.000000000 +0800
+++ linux-mm/mm/vmalloc.c	2010-01-11 10:33:21.000000000 +0800
@@ -1654,6 +1654,7 @@ EXPORT_SYMBOL(vmalloc_32_user);
  *
  *	Returns # of bytes copied on success.
  *	Returns 0 if @addr is not vmalloc'ed, or is mapped to non-RAM.
+ *	Returns -EIO if the mapped page is corrupted.
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
  *	copy data from that area to a given buffer. If the given memory range
@@ -1684,6 +1685,10 @@ int vread_page(char *buf, char *addr, un
 		memset(buf, 0, count);
 		return 0;
 	}
+	if (PageHWPoison(p)) {
+		memset(buf, 0, count);
+		return -EIO;
+	}
 
 	/*
 	 * To do safe access to this _mapped_ area, we need
@@ -1707,6 +1712,7 @@ int vread_page(char *buf, char *addr, un
  *
  *	Returns # of bytes copied on success.
  *	Returns 0 if @addr is not vmalloc'ed, or is mapped to non-RAM.
+ *	Returns -EIO if the mapped page is corrupted.
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
  *	copy data from a buffer to the given addr. If specified range of
@@ -1736,6 +1742,8 @@ int vwrite_page(char *buf, char *addr, u
 		return 0;
 	if (!page_is_ram(page_to_pfn(p)))
 		return 0;
+	if (PageHWPoison(p))
+		return -EIO;
 
 	map = kmap_atomic(p, KM_USER0);
 	memcpy(map + offset, buf, count);


