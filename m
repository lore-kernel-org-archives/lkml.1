Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZGaKc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZGaKc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZGaKc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:32:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55397 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZGaKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:32:28 -0400
Message-ID: <65d1a0e3dc0e5fa357f392f0552b4519.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090731095705.GD5048@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
    <20090728160527.1da52682.akpm@linux-foundation.org>
    <20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
    <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
    <20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
    <20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com>
    <20090731161128.347216e6.kamezawa.hiroyu@jp.fujitsu.com>
    <20090731095705.GD5048@cr0.nay.redhat.com>
Date: Fri, 31 Jul 2009 19:32:15 +0900 (JST)
Subject: Re: [BUGFIX][PATCH 1/3] fix vread/vwrite to be aware of memory hole
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Amerigo Wang" <xiyou.wangcong@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Mike Smith" <scgtrp@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       "Amerigo Wang" <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang さんは書きました：
> On Fri, Jul 31, 2009 at 04:11:28PM +0900, KAMEZAWA Hiroyuki wrote:
>>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>>vread/vwrite access vmalloc area without checking there is a page or not.
>>
>>In old ages, the caller of get_vm_ara() is only IOREMAP and there is no
>>memory hole within vm_struct's [addr...addr + size - PAGE_SIZE]
>>( -PAGE_SIZE is for a guard page.)
>>
>>After per-cpu-alloc patch, it uses get_vm_area() for reserve continuous
>>virtual address but remap _later_. There tend to be a hole in valid
>> vmalloc
>>area in vm_struct lists.
>>Then, skip the hole (not mapped page) is necessary.
>>This patch updates vread/vwrite() for avoiding memory hole.
>>
>>Routines which access vmalloc area without knowing for which addr is used
>>are
>>  - /proc/kcore
>>  - /dev/kmem
>>
>>kcore checks IOREMAP, /dev/kmem doesn't. After this patch, IOREMAP is
>>checked and /dev/kmem will avoid to read/write it.
>>Fixes to /proc/kcore will be in the next patch in series.
>>
>>And, this itself fixes the bug as
>># dd if=/dev/kmem of=/dev/null bs=1024 count=1048576 skip=3145728
>>can cause panic.
>
>
> What panic? :-) Would you mind to put it here?
>
It directly reboot ;( and no log.
plz try.


>
>>
>>
>>Changelog v1->v2:
>> - enhanced comments.
>> - treat IOREMAP as hole always.
>> - zero-fill memory hole if [addr...addr+size] includes valid pages.
>> - returns 0 if [addr...addr+size) includes no valid pages.
>>
>>Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>
> I am sorry that there are still some typos below.
>
Ouch, thanks.


>
>>---
>> mm/vmalloc.c |  157
>> +++++++++++++++++++++++++++++++++++++++++++++++++++--------
>> 1 file changed, 136 insertions(+), 21 deletions(-)
>>
>>Index: linux-2.6.31-rc4/mm/vmalloc.c
>>===================================================================
>>--- linux-2.6.31-rc4.orig/mm/vmalloc.c	2009-07-31 14:06:41.000000000
>> +0900
>>+++ linux-2.6.31-rc4/mm/vmalloc.c	2009-07-31 15:51:56.000000000 +0900
>>@@ -1625,10 +1625,89 @@
>> }
>> EXPORT_SYMBOL(vmalloc_32_user);
>>
>>+/*
>>+ * small helper routine , copy contents to buf from addr.
>>+ * If the page is not present, fill zero.
>>+ */
>>+
>>+static int aligned_vread(char *buf, char *addr, unsigned long count)
>>+{
>>+	struct page *p;
>>+	int copied;
>
>
> Forgot to initialize it??
>
Ah, yes. should be fixed.

>>+
>>+	while (count) {
>>+		unsigned long offset, length;
>>+
>>+		offset = (unsigned long)addr & PAGE_MASK;
>>+		length = PAGE_SIZE - offset;
>>+		if (length > count)
>>+			length = count;
>>+		p = vmalloc_to_page(addr);
>>+		if (p)
>>+			memcpy(buf, addr, length);
>>+		else
>>+			memset(buf, 0, length);
>>+		/* If no page, we fill 0 this area and incremetns buffer addr */
>
>
> s/incremetns/increments/
>
ok.

>
>>+		addr += length;
>>+		buf += length;
>>+		copied += length;
>>+		count -= length;
>>+	}
>>+	return copied;
>>+}
>>+
>>+static int aligned_vwrite(char *buf, char *addr, unsigned long count)
>>+{
>>+	struct page *p;
>>+	int copied;
>
>
> ditto
>
Hmm..I though I removed all warnings..but it was an illusion..
ok, will fix.

>>+
>>+	while (count) {
>>+		unsigned long offset, length;
>>+
>>+		offset = (unsigned long)addr & PAGE_MASK;
>>+		length = PAGE_SIZE - offset;
>>+		if (length > count)
>>+			length = count;
>>+		/* confirm the page is present */
>>+		p = vmalloc_to_page(addr);
>>+		if (p)
>>+			memcpy(addr, buf, length);
>>+		/* If no page, we skip this area but incremetns buffer addr */
>
>
> ditto
>
ok

>
>>+		addr += length;
>>+		buf += length;
>>+		copied += length;
>>+		count -= length;
>>+	}
>>+	return copied;
>>+}
>>+
>>+/**
>>+ *	vread() -  read vmalloc area in safe way.
>
> in _a_ safe way...
>
ok.

>
>>+ *	@buf:		buffer for reading data
>>+ *	@addr:		vm address.
>>+ *	@count:		number of bytes to be read.
>>+ *
>>+ *	Returns # of bytes which addr and buf shuld be incremented
>
> s/shuld/should/
>
> s/incremented/increased/
>
ok.

>
>>+ *	(same to count).
>>+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.
>>+ *
>>+ *	This function checks that addr is a valid vmalloc'ed area, and
>>+ *	copy data from that area to given buffer. If given memory range of
>
>
> to _a_ given buffer. If _the_ given memory...
>
ok.

>
>>+ *	[addr...addr+count) includes some valid address, data is copied to
>>+ *	proper area of @buf. If there are memory holes, they'll be
>> zero-filled.
>>+ *	IOREMAP area is treated as memory hole and no copy is done.
>>+ *
>>+ *	Note: In usual ops, vread() is never necessary because the caller
>> should
>>+ *	know vmalloc() area is valid and can use memcpy(). This is for
>> routines
>>+ *	which have to access vmalloc area without any informaion, as
>> /dev/kmem.
>>+ *
>>+ */
>>+
>> long vread(char *buf, char *addr, unsigned long count)
>> {
>> 	struct vm_struct *tmp;
>> 	char *vaddr, *buf_start = buf;
>>+	unsigned long buflen = count;
>> 	unsigned long n;
>>
>> 	/* Don't allow overflow */
>>@@ -1636,7 +1715,7 @@
>> 		count = -(unsigned long) addr;
>>
>> 	read_lock(&vmlist_lock);
>>-	for (tmp = vmlist; tmp; tmp = tmp->next) {
>>+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
>> 		vaddr = (char *) tmp->addr;
>> 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
>> 			continue;
>>@@ -1649,32 +1728,65 @@
>> 			count--;
>> 		}
>> 		n = vaddr + tmp->size - PAGE_SIZE - addr;
>>-		do {
>>-			if (count == 0)
>>-				goto finished;
>>-			*buf = *addr;
>>-			buf++;
>>-			addr++;
>>-			count--;
>>-		} while (--n > 0);
>>+		if (n > count)
>>+			n = count;
>>+		if (!(tmp->flags & VM_IOREMAP))
>>+			aligned_vread(buf, addr, n);
>>+		else /* IOREMAP area is treated as memory hole */
>>+			memset(buf, 0, n);
>>+		buf += n;
>>+		addr += n;
>>+		count -= n;
>> 	}
>> finished:
>> 	read_unlock(&vmlist_lock);
>>-	return buf - buf_start;
>>+
>>+	if (buf == buf_start)
>>+		return 0;
>>+	/* zero-fill memory holes */
>>+	if (buf != buf_start + buflen)
>>+		memset(buf, 0, buflen - (buf - buf_start));
>
>
> Is this necessary?
>
I wrote "filled by zero" and thinks it's sane, then does this.
Now, /proc/kcore allocates memory by kzalloc(), this is redundant.
/dev/kmem doesn't do that.


>>+
>>+	return buflen;
>> }
>>
>>+/**
>>+ *	vwrite() -  write vmalloc area in safe way.
>>+ *	@buf:		buffer for source data
>>+ *	@addr:		vm address.
>>+ *	@count:		number of bytes to be read.
>>+ *
>>+ *	Returns # of bytes which addr and buf shuld be incremented
>>+ *	(same to count).
>>+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.
>>+ *
>>+ *	This function checks that addr is a valid vmalloc'ed area, and
>>+ *	copy data from that buffer to there. If given memory range of
>>+ *	[addr...addr+count) includes some valid address, data is copied from
>>+ *	proper area of @buf. If there are memory holes, no copy. just skip.
>>+ *	IOREMAP area is treated as memory hole and no copy is done.
>>+ *
>>+ *	Note: In usual ops, vwrite() is never necessary because the caller
>>+ *	should know vmalloc() area is valid and can use memcpy().
>>+ *	This is for routines which have to access vmalloc area without
>>+ *	any informaion, as /dev/kmem.
>>+ */
>
>
> ditto
>
ouch..

Thank you for review.
I'm sorry that new version will not appear until next week.
I can't access x86-32 in the weekend.

Regards,
-Kame


>>+
>> long vwrite(char *buf, char *addr, unsigned long count)
>> {
>> 	struct vm_struct *tmp;
>>-	char *vaddr, *buf_start = buf;
>>+	char *vaddr;
>>+	unsigned long buflen;
>> 	unsigned long n;
>>+	int copied = 0;
>>
>> 	/* Don't allow overflow */
>> 	if ((unsigned long) addr + count < count)
>> 		count = -(unsigned long) addr;
>>+	buflen = count;
>>
>> 	read_lock(&vmlist_lock);
>>-	for (tmp = vmlist; tmp; tmp = tmp->next) {
>>+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
>> 		vaddr = (char *) tmp->addr;
>> 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
>> 			continue;
>>@@ -1686,18 +1798,21 @@
>> 			count--;
>> 		}
>> 		n = vaddr + tmp->size - PAGE_SIZE - addr;
>>-		do {
>>-			if (count == 0)
>>-				goto finished;
>>-			*addr = *buf;
>>-			buf++;
>>-			addr++;
>>-			count--;
>>-		} while (--n > 0);
>>+		if (n > count)
>>+			n = count;
>>+		if (!(tmp->flags & VM_IOREMAP)) {
>>+			aligned_vwrite(buf, addr, n);
>>+			copied++;
>>+		}
>>+		buf += n;
>>+		addr += n;
>>+		count -= n;
>> 	}
>> finished:
>> 	read_unlock(&vmlist_lock);
>>-	return buf - buf_start;
>>+	if (!copied)
>>+		return 0;
>>+	return buflen;
>> }
>>
>> /**
>>
>


