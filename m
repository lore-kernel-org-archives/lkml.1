Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZHCLUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZHCLUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZHCLUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:20:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43221 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbZHCLUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:20:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Aug 2009 20:18:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: [BUGFIX][PATCH 2/3] kcore: fix vread/vwrite to be aware of holes.
Message-Id: <20090803201845.c3ae49b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

vread/vwrite access vmalloc area without checking there is a page or not.
In most case, this works well.

In old ages, the caller of get_vm_ara() is only IOREMAP and there is no
memory hole within vm_struct's [addr...addr + size - PAGE_SIZE]
( -PAGE_SIZE is for a guard page.)

After per-cpu-alloc patch, it uses get_vm_area() for reserve continuous
virtual address but remap _later_. There tend to be a hole in valid vmalloc
area in vm_struct lists.
Then, skip the hole (not mapped page) is necessary.
This patch updates vread/vwrite() for avoiding memory hole.

Routines which access vmalloc area without knowing for which addr is used
are
  - /proc/kcore
  - /dev/kmem

kcore checks IOREMAP, /dev/kmem doesn't. After this patch, IOREMAP is
checked and /dev/kmem will avoid to read/write it.
Fixes to /proc/kcore will be in the next patch in series.

Changelog v2->v3:
 - fixed typos.
 - use kmap. (if not using kmap, we have to add lock here.)
 - fixed PAGE_MASK miss-use.
Changelog v1->v2:
 - enhanced comments.
 - treat IOREMAP as hole always.
 - zero-fill memory hole if [addr...addr+size] includes valid pages.
 - returns 0 if [addr...addr+size) includes no valid pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmalloc.c |  182 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 159 insertions(+), 23 deletions(-)

Index: linux-2.6.31-rc5/mm/vmalloc.c
===================================================================
--- linux-2.6.31-rc5.orig/mm/vmalloc.c	2009-08-03 18:56:33.000000000 +0900
+++ linux-2.6.31-rc5/mm/vmalloc.c	2009-08-03 19:54:39.000000000 +0900
@@ -25,7 +25,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
-
+#include <linux/highmem.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
@@ -1629,10 +1629,109 @@
 }
 EXPORT_SYMBOL(vmalloc_32_user);
 
+/*
+ * small helper routine , copy contents to buf from addr.
+ * If the page is not present, fill zero.
+ */
+
+static int aligned_vread(char *buf, char *addr, unsigned long count)
+{
+	struct page *p;
+	int copied = 0;
+
+	while (count) {
+		unsigned long offset, length;
+
+		offset = (unsigned long)addr & ~PAGE_MASK;
+		length = PAGE_SIZE - offset;
+		if (length > count)
+			length = count;
+		p = vmalloc_to_page(addr);
+		/*
+		 * To do safe access to this _mapped_ area, we need
+		 * lock. But adding lock here means that we need to add
+		 * overhead of vmalloc()/vfree() calles for this _debug_
+		 * interface, rarely used. Instead of that, we'll use
+		 * kmap() and get small overhead in this access function.
+		 */
+		if (p) {
+			/* we can expect USR1 is not used */
+			void *map = kmap_atomic(p, KM_USER1);
+			memcpy(buf, map + offset, length);
+			kunmap_atomic(map, KM_USER1);
+		} else
+			memset(buf, 0, length);
+
+		addr += length;
+		buf += length;
+		copied += length;
+		count -= length;
+	}
+	return copied;
+}
+
+static int aligned_vwrite(char *buf, char *addr, unsigned long count)
+{
+	struct page *p;
+	int copied = 0;
+
+	while (count) {
+		unsigned long offset, length;
+
+		offset = (unsigned long)addr & ~PAGE_MASK;
+		length = PAGE_SIZE - offset;
+		if (length > count)
+			length = count;
+		p = vmalloc_to_page(addr);
+		/*
+		 * To do safe access to this _mapped_ area, we need
+		 * lock. But adding lock here means that we need to add
+		 * overhead of vmalloc()/vfree() calles for this _debug_
+		 * interface, rarely used. Instead of that, we'll use
+		 * kmap() and get small overhead in this access function.
+		 */
+		if (p) {
+			/* we can expect USR1 is not used */
+			void *map = kmap_atomic(p, KM_USER1);
+			memcpy(map + offset, buf, length);
+			kunmap_atomic(map, KM_USER1);
+		}
+		addr += length;
+		buf += length;
+		copied += length;
+		count -= length;
+	}
+	return copied;
+}
+
+/**
+ *	vread() -  read vmalloc area in a safe way.
+ *	@buf:		buffer for reading data
+ *	@addr:		vm address.
+ *	@count:		number of bytes to be read.
+ *
+ *	Returns # of bytes which addr and buf should be increased.
+ *	(same to count).
+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from that area to a given buffer. If the given memory range of
+ *	[addr...addr+count) includes some valid address, data is copied to
+ *	proper area of @buf. If there are memory holes, they'll be zero-filled.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	Note: In usual ops, vread() is never necessary because the caller should
+ *	know vmalloc() area is valid and can use memcpy(). This is for routines
+ *	which have to access vmalloc area without any informaion, as /dev/kmem.
+ *
+ *	The caller should guarantee KM_USER1 is not used.
+ */
+
 long vread(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
 	char *vaddr, *buf_start = buf;
+	unsigned long buflen = count;
 	unsigned long n;
 
 	/* Don't allow overflow */
@@ -1640,7 +1739,7 @@
 		count = -(unsigned long) addr;
 
 	read_lock(&vmlist_lock);
-	for (tmp = vmlist; tmp; tmp = tmp->next) {
+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
 			continue;
@@ -1653,32 +1752,66 @@
 			count--;
 		}
 		n = vaddr + tmp->size - PAGE_SIZE - addr;
-		do {
-			if (count == 0)
-				goto finished;
-			*buf = *addr;
-			buf++;
-			addr++;
-			count--;
-		} while (--n > 0);
+		if (n > count)
+			n = count;
+		if (!(tmp->flags & VM_IOREMAP))
+			aligned_vread(buf, addr, n);
+		else /* IOREMAP area is treated as memory hole */
+			memset(buf, 0, n);
+		buf += n;
+		addr += n;
+		count -= n;
 	}
 finished:
 	read_unlock(&vmlist_lock);
-	return buf - buf_start;
+
+	if (buf == buf_start)
+		return 0;
+	/* zero-fill memory holes */
+	if (buf != buf_start + buflen)
+		memset(buf, 0, buflen - (buf - buf_start));
+
+	return buflen;
 }
 
+/**
+ *	vwrite() -  write vmalloc area in a safe way.
+ *	@buf:		buffer for source data
+ *	@addr:		vm address.
+ *	@count:		number of bytes to be read.
+ *
+ *	Returns # of bytes which addr and buf should be incresed.
+ *	(same to count).
+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from a buffer to the given addr. If specified range of
+ *	[addr...addr+count) includes some valid address, data is copied from
+ *	proper area of @buf. If there are memory holes, no copy to hole.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	Note: In usual ops, vwrite() is never necessary because the caller
+ *	should know vmalloc() area is valid and can use memcpy().
+ *	This is for routines which have to access vmalloc area without
+ *	any informaion, as /dev/kmem.
+ *
+ *	The caller should guarantee KM_USER1 is not used.
+ */
+
 long vwrite(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
-	char *vaddr, *buf_start = buf;
-	unsigned long n;
+	char *vaddr;
+	unsigned long n, buflen;
+	int copied = 0;
 
 	/* Don't allow overflow */
 	if ((unsigned long) addr + count < count)
 		count = -(unsigned long) addr;
+	buflen = count;
 
 	read_lock(&vmlist_lock);
-	for (tmp = vmlist; tmp; tmp = tmp->next) {
+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
 			continue;
@@ -1690,18 +1823,21 @@
 			count--;
 		}
 		n = vaddr + tmp->size - PAGE_SIZE - addr;
-		do {
-			if (count == 0)
-				goto finished;
-			*addr = *buf;
-			buf++;
-			addr++;
-			count--;
-		} while (--n > 0);
+		if (n > count)
+			n = count;
+		if (!(tmp->flags & VM_IOREMAP)) {
+			aligned_vwrite(buf, addr, n);
+			copied++;
+		}
+		buf += n;
+		addr += n;
+		count -= n;
 	}
 finished:
 	read_unlock(&vmlist_lock);
-	return buf - buf_start;
+	if (!copied)
+		return 0;
+	return buflen;
 }
 
 /**

