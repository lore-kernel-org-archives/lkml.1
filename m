Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbZHEHki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbZHEHki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932849AbZHEHkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:40:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44383 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773AbZHEHkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:40:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 5 Aug 2009 16:38:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: nickpiggin@yahoo.com.au, scgtrp@gmail.com, xiyou.wangcong@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + kcore-fix-vread-vwrite-to-be-aware-of-holes.patch added to
 -mm tree
Message-Id: <20090805163846.25caf6ea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200908042130.n74LUxr8027929@imap1.linux-foundation.org>
References: <200908042130.n74LUxr8027929@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Aug 2009 14:30:58 -0700
akpm@linux-foundation.org wrote:

> 
> The patch titled
>      kcore: fix vread/vwrite to be aware of holes
> has been added to the -mm tree.  Its filename is
>      kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
> 
This is a replacement. Fixed comments where concerns are pointed out.

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

vread/vwrite access vmalloc area without checking there is a page or not.
In most case, this works well.

In old ages, the caller of get_vm_area() is only IOREMAP and there is no
memory hole within vm_struct's [addr...addr + size - PAGE_SIZE]
( -PAGE_SIZE is for a guard page.) if IOREMAP is not set.

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

Changelov v3->v3.1
 - fixed comments. (mainly vread/vwrite description is updated.)
 - use KM_USER0 instead of KM_USER1
Changelog v2->v3:
 - fixed typos.
 - added explaination of purge_lock.
Changelog v1->v2:
 - enhanced comments.
 - treat IOREMAP as hole always.
 - zero-fill memory hole if [addr...addr+size] includes valid pages.
 - returns 0 if [addr...addr+size) includes no valid pages.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmalloc.c |  199 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 176 insertions(+), 23 deletions(-)

Index: linux-2.6.31-rc5/mm/vmalloc.c
===================================================================
--- linux-2.6.31-rc5.orig/mm/vmalloc.c	2009-08-03 18:56:33.000000000 +0900
+++ linux-2.6.31-rc5/mm/vmalloc.c	2009-08-05 16:31:18.000000000 +0900
@@ -25,7 +25,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
-
+#include <linux/highmem.h>
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
@@ -1629,10 +1629,120 @@
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
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
+			memcpy(buf, map + offset, length);
+			kunmap_atomic(map, KM_USER0);
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
+			/*
+			 * we can expect USER0 is not used (see vread/vwrite's
+			 * function description)
+			 */
+			void *map = kmap_atomic(p, KM_USER0);
+			memcpy(map + offset, buf, length);
+			kunmap_atomic(map, KM_USER0);
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
+ *	(same number to @count). Returns 0 if [addr...addr+count) doesn't
+ *	includes any intersect with alive vmalloc area.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from that area to a given buffer. If the given memory range
+ *	of [addr...addr+count) includes some valid address, data is copied to
+ *	proper area of @buf. If there are memory holes, they'll be zero-filled.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
+ *
+ *	Note: In usual ops, vread() is never necessary because the caller
+ *	should know vmalloc() area is valid and can use memcpy().
+ *	This is for routines which have to access vmalloc area without
+ *	any informaion, as /dev/kmem.
+ *
+ */
+
 long vread(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
 	char *vaddr, *buf_start = buf;
+	unsigned long buflen = count;
 	unsigned long n;
 
 	/* Don't allow overflow */
@@ -1640,7 +1750,7 @@
 		count = -(unsigned long) addr;
 
 	read_lock(&vmlist_lock);
-	for (tmp = vmlist; tmp; tmp = tmp->next) {
+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
 		vaddr = (char *) tmp->addr;
 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
 			continue;
@@ -1653,32 +1763,72 @@
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
+ *	(same number to @count).
+ *	If [addr...addr+count) doesn't includes any intersect with valid
+ *	vmalloc area, returns 0.
+ *
+ *	This function checks that addr is a valid vmalloc'ed area, and
+ *	copy data from a buffer to the given addr. If specified range of
+ *	[addr...addr+count) includes some valid address, data is copied from
+ *	proper area of @buf. If there are memory holes, no copy to hole.
+ *	IOREMAP area is treated as memory hole and no copy is done.
+ *
+ *	If [addr...addr+count) doesn't includes any intersects with alive
+ *	vm_struct area, returns 0.
+ *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
+ *	the caller should guarantee KM_USER0 is not used.
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
@@ -1690,18 +1840,21 @@
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

