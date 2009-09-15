Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZIOCZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZIOCZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbZIOCZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:25:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:35908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986AbZIOCY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,386,1249282800"; 
   d="scan'208";a="187622980"
Message-Id: <20090915022328.328708489@intel.com>
References: <20090915021851.168285585@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Sep 2009 10:18:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Lameter <clameter@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] vmalloc: ignore vmalloc area holes in vwrite()
Content-Disposition: inline; filename=vwrite-ret.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Siliently ignore all vmalloc area holes in vwrite(),
and report success to the caller even if nothing is written.

CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmalloc.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- linux-mm.orig/mm/vmalloc.c	2009-09-15 10:08:33.000000000 +0800
+++ linux-mm/mm/vmalloc.c	2009-09-15 10:14:18.000000000 +0800
@@ -1805,10 +1805,8 @@ finished:
  *	@addr:		vm address.
  *	@count:		number of bytes to be read.
  *
- *	Returns # of bytes which addr and buf should be incresed.
+ *	Returns # of bytes which addr and buf should be increased.
  *	(same number to @count).
- *	If [addr...addr+count) doesn't includes any intersect with valid
- *	vmalloc area, returns 0.
  *
  *	This function checks that addr is a valid vmalloc'ed area, and
  *	copy data from a buffer to the given addr. If specified range of
@@ -1816,8 +1814,6 @@ finished:
  *	proper area of @buf. If there are memory holes, no copy to hole.
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
- *	If [addr...addr+count) doesn't includes any intersects with alive
- *	vm_struct area, returns 0.
  *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
  *	the caller should guarantee KM_USER0 is not used.
  *
@@ -1834,7 +1830,6 @@ long vwrite(char *buf, char *addr, unsig
 	struct vm_struct *tmp;
 	char *vaddr;
 	unsigned long n, buflen;
-	int copied = 0;
 
 	/* Don't allow overflow */
 	if ((unsigned long) addr + count < count)
@@ -1856,18 +1851,14 @@ long vwrite(char *buf, char *addr, unsig
 		n = vaddr + tmp->size - PAGE_SIZE - addr;
 		if (n > count)
 			n = count;
-		if (!(tmp->flags & VM_IOREMAP)) {
+		if (!(tmp->flags & VM_IOREMAP))
 			aligned_vwrite(buf, addr, n);
-			copied++;
-		}
 		buf += n;
 		addr += n;
 		count -= n;
 	}
 finished:
 	read_unlock(&vmlist_lock);
-	if (!copied)
-		return 0;
 	return buflen;
 }
 

-- 

