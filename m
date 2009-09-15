Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZIOCZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZIOCZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 22:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbZIOCZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 22:25:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:35908 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994AbZIOCY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 22:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,386,1249282800"; 
   d="scan'208";a="187622987"
Message-Id: <20090915022328.460943370@intel.com>
References: <20090915021851.168285585@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Sep 2009 10:18:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Lameter <clameter@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] devmem: handle partial kmem write/read
Content-Disposition: inline; filename=kmem-vwrite-ret.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return early on partial read/write, which may happen in future.
(eg. hit hwpoison pages)

CC: Greg KH <greg@kroah.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   30 ++++++++++++++++++------------
 mm/vmalloc.c       |   10 +---------
 2 files changed, 19 insertions(+), 21 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-15 09:44:49.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-15 09:44:55.000000000 +0800
@@ -444,18 +444,22 @@ static ssize_t read_kmem(struct file *fi
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
+			unsigned long n;
+
 			sz = size_inside_page(p, count);
-			sz = vread(kbuf, (char *)p, sz);
-			if (!sz)
+			n = vread(kbuf, (char *)p, sz);
+			if (!n)
 				break;
-			if (copy_to_user(buf, kbuf, sz)) {
+			if (copy_to_user(buf, kbuf, n)) {
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			count -= sz;
-			buf += sz;
-			read += sz;
-			p += sz;
+			count -= n;
+			buf += n;
+			read += n;
+			p += n;
+			if (n < sz)
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}
@@ -551,11 +555,13 @@ static ssize_t write_kmem(struct file * 
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			sz = vwrite(kbuf, (char *)p, sz);
-			count -= sz;
-			buf += sz;
-			virtr += sz;
-			p += sz;
+			n = vwrite(kbuf, (char *)p, sz);
+			count -= n;
+			buf += n;
+			virtr += n;
+			p += n;
+			if (n < sz)
+				break;
 		}
 		free_page((unsigned long)kbuf);
 	}

-- 

