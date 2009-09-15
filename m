Return-Path: <linux-kernel-owner+w=401wt.eu-S1751647AbZIOJBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbZIOJBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZIOJBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:01:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:22695 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbZIOJBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:01:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,388,1249282800"; 
   d="scan'208";a="187728933"
Date: Tue, 15 Sep 2009 17:01:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] devmem: handle partial kmem write/read
Message-ID: <20090915090130.GA4970@localhost>
References: <20090915021851.168285585@intel.com> <20090915022328.460943370@intel.com> <20090915113811.6b44877c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915113811.6b44877c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 10:38:11AM +0800, KAMEZAWA Hiroyuki wrote:
> On Tue, 15 Sep 2009 10:18:53 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Return early on partial read/write, which may happen in future.
> > (eg. hit hwpoison pages)
> > 
> Hmm, please modify vread() as you did in vwrite() and
> 
> ==
>                kbuf = (char *)__get_free_page(GFP_KERNEL);
>                 if (!kbuf)
>                         return -ENOMEM;
> ==
> Add __GFP_ZERO to kbuf allocation, and just ignore vread()'s return value.
> Then, this will be much simpler.

Thanks, here is the updated patch, which
- updates vread/vwrite prototype to return 0 (or error code in future).
- do zero fill in the callers
Comment updates are ignored for now.

Thanks,
Fengguang
---

vmalloc: ignore vmalloc area holes in vread()/vwrite()

Siliently ignore all vmalloc area holes in vread()/vwrite(),
and report success (or error code in future) to the caller.

When /dev/kmem read()/write() encounters hwpoison page, stop it
and return the amount of work done till now.


CC: Andi Kleen <andi@firstfloor.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>
CC: Nick Piggin <npiggin@suse.de>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c      |   16 ++++++++++------
 include/linux/vmalloc.h |    6 +++---
 mm/vmalloc.c            |   31 +++++++------------------------
 3 files changed, 20 insertions(+), 33 deletions(-)

--- linux-mm.orig/mm/vmalloc.c	2009-09-15 16:38:49.000000000 +0800
+++ linux-mm/mm/vmalloc.c	2009-09-15 16:39:31.000000000 +0800
@@ -1752,11 +1752,10 @@ static int aligned_vwrite(char *buf, cha
  *
  */
 
-long vread(char *buf, char *addr, unsigned long count)
+int vread(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
 	char *vaddr, *buf_start = buf;
-	unsigned long buflen = count;
 	unsigned long n;
 
 	/* Don't allow overflow */
@@ -1790,13 +1789,7 @@ long vread(char *buf, char *addr, unsign
 finished:
 	read_unlock(&vmlist_lock);
 
-	if (buf == buf_start)
-		return 0;
-	/* zero-fill memory holes */
-	if (buf != buf_start + buflen)
-		memset(buf, 0, buflen - (buf - buf_start));
-
-	return buflen;
+	return 0;
 }
 
 /**
@@ -1805,10 +1798,8 @@ finished:
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
@@ -1816,8 +1807,6 @@ finished:
  *	proper area of @buf. If there are memory holes, no copy to hole.
  *	IOREMAP area is treated as memory hole and no copy is done.
  *
- *	If [addr...addr+count) doesn't includes any intersects with alive
- *	vm_struct area, returns 0.
  *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
  *	the caller should guarantee KM_USER0 is not used.
  *
@@ -1829,17 +1818,15 @@ finished:
  *	The caller should guarantee KM_USER1 is not used.
  */
 
-long vwrite(char *buf, char *addr, unsigned long count)
+int vwrite(char *buf, char *addr, unsigned long count)
 {
 	struct vm_struct *tmp;
 	char *vaddr;
-	unsigned long n, buflen;
-	int copied = 0;
+	unsigned long n;
 
 	/* Don't allow overflow */
 	if ((unsigned long) addr + count < count)
 		count = -(unsigned long) addr;
-	buflen = count;
 
 	read_lock(&vmlist_lock);
 	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
@@ -1856,19 +1843,15 @@ long vwrite(char *buf, char *addr, unsig
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
-	return buflen;
+	return 0;
 }
 
 /**
--- linux-mm.orig/include/linux/vmalloc.h	2009-09-15 16:38:49.000000000 +0800
+++ linux-mm/include/linux/vmalloc.h	2009-09-15 16:39:31.000000000 +0800
@@ -104,9 +104,9 @@ extern void unmap_kernel_range(unsigned 
 extern struct vm_struct *alloc_vm_area(size_t size);
 extern void free_vm_area(struct vm_struct *area);
 
-/* for /dev/kmem */
-extern long vread(char *buf, char *addr, unsigned long count);
-extern long vwrite(char *buf, char *addr, unsigned long count);
+/* for /dev/kmem and /dev/kcore */
+extern int vread(char *buf, char *addr, unsigned long count);
+extern int vwrite(char *buf, char *addr, unsigned long count);
 
 /*
  *	Internals.  Dont't use..
--- linux-mm.orig/drivers/char/mem.c	2009-09-15 15:26:11.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-15 17:00:45.000000000 +0800
@@ -399,6 +399,7 @@ static ssize_t read_kmem(struct file *fi
 	unsigned long p = *ppos;
 	ssize_t low_count, read, sz;
 	char * kbuf; /* k-addr because vread() takes vmlist_lock rwlock */
+	int ret = 0;
 
 	read = 0;
 	if (p < (unsigned long) high_memory) {
@@ -440,13 +441,13 @@ static ssize_t read_kmem(struct file *fi
 	}
 
 	if (count > 0) {
-		kbuf = (char *)__get_free_page(GFP_KERNEL);
+		kbuf = (char *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 		if (!kbuf)
 			return -ENOMEM;
 		while (count > 0) {
 			sz = size_inside_page(p, count);
-			sz = vread(kbuf, (char *)p, sz);
-			if (!sz)
+			ret = vread(kbuf, (char *)p, sz);
+			if (ret)
 				break;
 			if (copy_to_user(buf, kbuf, sz)) {
 				free_page((unsigned long)kbuf);
@@ -460,7 +461,7 @@ static ssize_t read_kmem(struct file *fi
 		free_page((unsigned long)kbuf);
 	}
  	*ppos = p;
- 	return read;
+ 	return read ? read : ret;
 }
 
 
@@ -524,6 +525,7 @@ static ssize_t write_kmem(struct file * 
 	ssize_t wrote = 0;
 	ssize_t virtr = 0;
 	char * kbuf; /* k-addr because vwrite() takes vmlist_lock rwlock */
+	int ret = 0;
 
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
@@ -551,7 +553,9 @@ static ssize_t write_kmem(struct file * 
 				free_page((unsigned long)kbuf);
 				return -EFAULT;
 			}
-			sz = vwrite(kbuf, (char *)p, sz);
+			ret = vwrite(kbuf, (char *)p, sz);
+			if (ret)
+				break;
 			count -= sz;
 			buf += sz;
 			virtr += sz;
@@ -561,7 +565,7 @@ static ssize_t write_kmem(struct file * 
 	}
 
  	*ppos = p;
- 	return virtr + wrote;
+ 	return virtr + wrote ? virtr + wrote : ret;
 }
 #endif
 
