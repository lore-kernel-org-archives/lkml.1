Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0BDCmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 21:42:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:19897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0BDCmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 21:42:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,402,1262592000"; 
   d="scan'208";a="537566163"
Date: Thu, 4 Feb 2010 10:42:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [stable] [PATCH] devmem: check vmalloc address on kmem read/write
Message-ID: <20100204024202.GD6343@localhost>
References: <20100122045914.993668874@intel.com> <20100203234724.GA23902@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203234724.GA23902@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 325fda71d0badc1073dc59f12a948f24ff05796a upstream.

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

--- linux-2.6.32.orig/drivers/char/mem.c	2010-02-04 10:28:19.000000000 +0800
+++ linux-2.6.32/drivers/char/mem.c	2010-02-04 10:37:55.000000000 +0800
@@ -408,6 +408,7 @@ static ssize_t read_kmem(struct file *fi
 	unsigned long p = *ppos;
 	ssize_t low_count, read, sz;
 	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
+	int err = 0;
 
 	read = 0;
 	if (p < (unsigned long) high_memory) {
@@ -464,14 +465,18 @@ static ssize_t read_kmem(struct file *fi
 		while (count > 0) {
 			int len = count;
 
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			if (len > PAGE_SIZE)
 				len = PAGE_SIZE;
 			len = vread(kbuf, (char *)p, len);
 			if (!len)
 				break;
 			if (copy_to_user(buf, kbuf, len)) {
-				free_page((unsigned long)kbuf);
-				return -EFAULT;
+				err = -EFAULT;
+				break;
 			}
 			count -= len;
 			buf += len;
@@ -480,8 +485,8 @@ static ssize_t read_kmem(struct file *fi
 		}
 		free_page((unsigned long)kbuf);
 	}
- 	*ppos = p;
- 	return read;
+	*ppos = p;
+	return read ? read : err;
 }
 
 
@@ -557,6 +562,7 @@ static ssize_t write_kmem(struct file * 
 	ssize_t virtr = 0;
 	ssize_t written;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
+	int err = 0;
 
 	if (p < (unsigned long) high_memory) {
 
@@ -580,15 +586,17 @@ static ssize_t write_kmem(struct file * 
 		while (count > 0) {
 			int len = count;
 
+			if (!is_vmalloc_or_module_addr((void *)p)) {
+				err = -ENXIO;
+				break;
+			}
 			if (len > PAGE_SIZE)
 				len = PAGE_SIZE;
 			if (len) {
 				written = copy_from_user(kbuf, buf, len);
 				if (written) {
-					if (wrote + virtr)
-						break;
-					free_page((unsigned long)kbuf);
-					return -EFAULT;
+					err = -EFAULT;
+					break;
 				}
 			}
 			len = vwrite(kbuf, (char *)p, len);
@@ -600,8 +608,8 @@ static ssize_t write_kmem(struct file * 
 		free_page((unsigned long)kbuf);
 	}
 
- 	*ppos = p;
- 	return virtr + wrote;
+	*ppos = p;
+	return virtr + wrote ? : err;
 }
 #endif
 
