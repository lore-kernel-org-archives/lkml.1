Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZG2Lxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZG2Lxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbZG2Lxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:53:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55129 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZG2Lxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:53:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Jul 2009 20:51:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] vmalloc: vread vwrite avoid memory hole.
Message-Id: <20090729205123.978971b8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090729095932.GG5856@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
	<20090729173600.540878a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20090729174810.4aea1283.kamezawa.hiroyu@jp.fujitsu.com>
	<20090729095932.GG5856@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 17:59:32 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Wed, Jul 29, 2009 at 05:48:10PM +0900, KAMEZAWA Hiroyuki wrote:
> >Considering recent changes, I think this an answer to this bug.
> >
> >All get_vm_area() calls specified VM_IOREMAP before 2.6.30.
> >Now, percpu calls get_vm_area() without IOREMAP (it means kcore doesn't skip this)
> >And it seems pcpu does delayed map to pre-allocated vmalloc-area.
> >Then, now, vmalloc() area has memory holes. (I'm sorry if I misunderstand.)
> 
> 
> You mean the guard holes in vmalloc area?
> 
no, not guard hole.  memory hole in the middle of valid vmalloc area, like this

start             end
      XXXXX0XXXXXG   XXXXXXXXG  XXXXXXXXG
X= pte is present
O= pte is none
G= pte is none as guard page.


> IIRC, there are some guard holes between vmalloc areas, but I haven't
> checked the source code. ;)
> 
> 
> >Then, vread()/vwrite() should be aware of memory holes in vmalloc.
> >And yes, /proc/kcore should be.
> >
> >plz review. 
> >==
> >vread/vwrite access vmalloc area without checking there is a page or not.
> >In most case, this works well.
> >
> >After per-cpu-alloc patch, There tend to be a hole in valid vmalloc area.
> >Then, skip the hole (not mapped page) is necessary.
> >
> >/proc/kcore has the same problem, now, it uses its own code but
> >it's better to use vread().
> >
> >Question: vread() should skip IOREMAP area always ?
> >
> >Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
> Some comments below..
> 
> 
> >---
> > drivers/char/mem.c      |    3 +
> > fs/proc/kcore.c         |   32 +----------------
> > include/linux/vmalloc.h |    3 +
> > mm/vmalloc.c            |   90 +++++++++++++++++++++++++++++++++++++-----------
> > 4 files changed, 77 insertions(+), 51 deletions(-)
> >
> >Index: linux-2.6.31-rc4/mm/vmalloc.c
> >===================================================================
> >--- linux-2.6.31-rc4.orig/mm/vmalloc.c
> >+++ linux-2.6.31-rc4/mm/vmalloc.c
> >@@ -1629,7 +1629,61 @@ void *vmalloc_32_user(unsigned long size
> > }
> > EXPORT_SYMBOL(vmalloc_32_user);
> > 
> >-long vread(char *buf, char *addr, unsigned long count)
> >+/*
> >+ * small helper routine , copy contents to buf from addr.
> >+ * If the page is not present, fill zero.
> >+ */
> >+
> >+static int aligned_vread(char *buf, char *addr, unsigned long count)
> >+{
> >+	struct page *p;
> >+	int copied;
> >+
> >+	while (count) {
> >+		unsigned long offset, length;
> >+
> >+		offset = (unsinged long)addr & PAGE_MASK;
> >+		length = PAGE_SIZE - offset;
> >+		if (length > count)
> >+			length = count;
> >+		p = vmalloc_to_page(addr);
> >+		if (p)
> >+			memcpy(buf, addr, length);
> >+		else
> >+			memset(buf, 0, length);
> >+		addr += length;
> >+		buf += length;
> >+		copiled += length;
> >+		count -= length;
> >+	}
> >+	return copied;
> >+}
> >+
> >+static int aligned_vwrite(char *buf, char *addr, unsigned long count)
> >+{
> >+	struct page *p;
> >+	int copied;
> >+
> >+	while (count) {
> >+		unsigned long offset, length;
> >+
> >+		offset = (unsinged long)addr & PAGE_MASK;
> >+		length = PAGE_SIZE - offset;
> >+		if (length > count)
> >+			length = count;
> >+		/* confirm the page is present */
> >+		p = vmalloc_to_page(addr);
> >+		if (p)
> >+			memcpy(addr, buf, length);
> 
> 
> So when !p, you copy nothing, but still increase the length,
> *silently*?
Ah, thanks, it's careless bug...will fix.



> 
> This looks a bit weird for me... I am thinking if we need
> to return the number of bytes that is *actually* copied?
> 
I think it makes the caller complex.

Then, I have 2 options.
 a) skip memory hole
 b) if we find memory hole, return immediately.

Do you like b) ? 
But in old behavior, vwrite()/vread() incremetns its "addr"
(at read zero-fill).

Then, I used a).


> 
> >+		addr += length;
> >+		buf += length;
> >+		copiled += length;
> >+		count -= length;
> >+	}
> >+	return copied;
> >+}
> >+
> >+long vread(char *buf, char *addr, unsigned long count, bool skip_ioremap)
> > {
> > 	struct vm_struct *tmp;
> > 	char *vaddr, *buf_start = buf;
> >@@ -1640,10 +1694,11 @@ long vread(char *buf, char *addr, unsign
> > 		count = -(unsigned long) addr;
> > 
> > 	read_lock(&vmlist_lock);
> >-	for (tmp = vmlist; tmp; tmp = tmp->next) {
> >+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
> > 		vaddr = (char *) tmp->addr;
> > 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
> > 			continue;
> >+
> > 		while (addr < vaddr) {
> > 			if (count == 0)
> > 				goto finished;
> >@@ -1653,14 +1708,15 @@ long vread(char *buf, char *addr, unsign
> > 			count--;
> > 		}
> > 		n = vaddr + tmp->size - PAGE_SIZE - addr;
> >-		do {
> >-			if (count == 0)
> >-				goto finished;
> >-			*buf = *addr;
> >-			buf++;
> >-			addr++;
> >-			count--;
> >-		} while (--n > 0);
> >+		if (n > count)
> >+			n = count;
> >+		if (!(tmp->flags & VM_IOREMAP) || !skip_ioremap)
> >+			aligned_vread(buf, addr, n);
> >+		else
> >+			memset(buf, 0, n);
> >+		buf += n;
> >+		addr += n;
> >+		count -= n;
> 
> 
> If I set 'skip_ioremap' true, I want the return value can be
> what it _actually_ copies, i.e. kick out the bytes counted
> for VM_IOREMAP. What do you think?
> 

One one od the reasons is The same reason to above. 
(adjusted to old behavior)

IIUC, In following kind of codes,

	len = vread(buf,addr,xxx);
	bud += len;
	addr += len

len should be the length that the caller should increment buffer address.
So, I just skipped hole.



> 
> > 	}
> > finished:
> > 	read_unlock(&vmlist_lock);
> >@@ -1678,7 +1734,7 @@ long vwrite(char *buf, char *addr, unsig
> > 		count = -(unsigned long) addr;
> > 
> > 	read_lock(&vmlist_lock);
> >-	for (tmp = vmlist; tmp; tmp = tmp->next) {
> >+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
> > 		vaddr = (char *) tmp->addr;
> > 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
> > 			continue;
> >@@ -1690,14 +1746,10 @@ long vwrite(char *buf, char *addr, unsig
> > 			count--;
> > 		}
> > 		n = vaddr + tmp->size - PAGE_SIZE - addr;
> >-		do {
> >-			if (count == 0)
> >-				goto finished;
> >-			*addr = *buf;
> >-			buf++;
> >-			addr++;
> >-			count--;
> >-		} while (--n > 0);
> >+		copied = aligned_vwrite(buf, addr, n);
> >+		buf += n;
> >+		addr += n;
> >+		count -= n;
> > 	}
> > finished:
> > 	read_unlock(&vmlist_lock);
> >Index: linux-2.6.31-rc4/drivers/char/mem.c
> >===================================================================
> >--- linux-2.6.31-rc4.orig/drivers/char/mem.c
> >+++ linux-2.6.31-rc4/drivers/char/mem.c
> >@@ -466,7 +466,8 @@ static ssize_t read_kmem(struct file *fi
> > 
> > 			if (len > PAGE_SIZE)
> > 				len = PAGE_SIZE;
> >-			len = vread(kbuf, (char *)p, len);
> >+			/* we read memory even if ioremap...*/
> >+			len = vread(kbuf, (char *)p, len, false);
> > 			if (!len)
> > 				break;
> > 			if (copy_to_user(buf, kbuf, len)) {
> >Index: linux-2.6.31-rc4/fs/proc/kcore.c
> >===================================================================
> >--- linux-2.6.31-rc4.orig/fs/proc/kcore.c
> >+++ linux-2.6.31-rc4/fs/proc/kcore.c
> >@@ -331,40 +331,12 @@ read_kcore(struct file *file, char __use
> > 			struct vm_struct *m;
> > 			unsigned long curstart = start;
> > 			unsigned long cursize = tsz;
> >-
> >+			
> 
> 
> I am sure this change, a line only has spaces, is not what you want. :-)
> 
yes ;(


Thank you for review. I'll fix vwrite_aligned().


-Kame

> 
> 
> > 			elf_buf = kzalloc(tsz, GFP_KERNEL);
> > 			if (!elf_buf)
> > 				return -ENOMEM;
> > 
> >-			read_lock(&vmlist_lock);
> >-			for (m=vmlist; m && cursize; m=m->next) {
> >-				unsigned long vmstart;
> >-				unsigned long vmsize;
> >-				unsigned long msize = m->size - PAGE_SIZE;
> >-
> >-				if (((unsigned long)m->addr + msize) < 
> >-								curstart)
> >-					continue;
> >-				if ((unsigned long)m->addr > (curstart + 
> >-								cursize))
> >-					break;
> >-				vmstart = (curstart < (unsigned long)m->addr ? 
> >-					(unsigned long)m->addr : curstart);
> >-				if (((unsigned long)m->addr + msize) > 
> >-							(curstart + cursize))
> >-					vmsize = curstart + cursize - vmstart;
> >-				else
> >-					vmsize = (unsigned long)m->addr + 
> >-							msize - vmstart;
> >-				curstart = vmstart + vmsize;
> >-				cursize -= vmsize;
> >-				/* don't dump ioremap'd stuff! (TA) */
> >-				if (m->flags & VM_IOREMAP)
> >-					continue;
> >-				memcpy(elf_buf + (vmstart - start),
> >-					(char *)vmstart, vmsize);
> >-			}
> >-			read_unlock(&vmlist_lock);
> >+			vread(elf_buf, start, tsz, true);
> > 			if (copy_to_user(buffer, elf_buf, tsz)) {
> > 				kfree(elf_buf);
> > 				return -EFAULT;
> >Index: linux-2.6.31-rc4/include/linux/vmalloc.h
> >===================================================================
> >--- linux-2.6.31-rc4.orig/include/linux/vmalloc.h
> >+++ linux-2.6.31-rc4/include/linux/vmalloc.h
> >@@ -105,7 +105,8 @@ extern struct vm_struct *alloc_vm_area(s
> > extern void free_vm_area(struct vm_struct *area);
> > 
> > /* for /dev/kmem */
> >-extern long vread(char *buf, char *addr, unsigned long count);
> >+extern long vread(char *buf, char *addr, unsigned long count,
> >+		  bool skip_ioremap);
> > extern long vwrite(char *buf, char *addr, unsigned long count);
> > 
> > /*
> >
> 

