Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbZHDJVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbZHDJVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932650AbZHDJVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:21:05 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:48268 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbZHDJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P2qGSnR9r5AlwNPK6jmOpJItH49UUHngsqKZxnNQKodqtYULBiucAClBNcWStPetUD
         HCn2PWiV3RSYkqjvHMi8Y85frmaohzvpejKssbD5gW37r1FBzwRX/4Uj7TsP9+MnVQZ8
         umuem4IOx3c2ZMCMz4cKsCJcX1OG42W/xyPxg=
Date: Tue, 4 Aug 2009 17:23:16 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH 2/3] kcore: fix vread/vwrite to be aware of
	holes.
Message-ID: <20090804092316.GB6451@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/> <20090728160527.1da52682.akpm@linux-foundation.org> <20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com> <525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com> <20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com> <20090803201845.c3ae49b5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803201845.c3ae49b5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 08:18:45PM +0900, KAMEZAWA Hiroyuki wrote:
>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>vread/vwrite access vmalloc area without checking there is a page or not.
>In most case, this works well.
>
>In old ages, the caller of get_vm_ara() is only IOREMAP and there is no
>memory hole within vm_struct's [addr...addr + size - PAGE_SIZE]
>( -PAGE_SIZE is for a guard page.)
>
>After per-cpu-alloc patch, it uses get_vm_area() for reserve continuous
>virtual address but remap _later_. There tend to be a hole in valid vmalloc
>area in vm_struct lists.
>Then, skip the hole (not mapped page) is necessary.
>This patch updates vread/vwrite() for avoiding memory hole.
>
>Routines which access vmalloc area without knowing for which addr is used
>are
>  - /proc/kcore
>  - /dev/kmem
>
>kcore checks IOREMAP, /dev/kmem doesn't. After this patch, IOREMAP is
>checked and /dev/kmem will avoid to read/write it.
>Fixes to /proc/kcore will be in the next patch in series.
>
>Changelog v2->v3:
> - fixed typos.
> - use kmap. (if not using kmap, we have to add lock here.)


Hmm.. I missed this.


> - fixed PAGE_MASK miss-use.
>Changelog v1->v2:
> - enhanced comments.
> - treat IOREMAP as hole always.
> - zero-fill memory hole if [addr...addr+size] includes valid pages.
> - returns 0 if [addr...addr+size) includes no valid pages.
>
>Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


This time it looks much better now, but it still has a small problem.
Please check it below.


>---
> mm/vmalloc.c |  182 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
> 1 file changed, 159 insertions(+), 23 deletions(-)
>

<snip>


>+
>+/**
>+ *	vread() -  read vmalloc area in a safe way.
>+ *	@buf:		buffer for reading data
>+ *	@addr:		vm address.
>+ *	@count:		number of bytes to be read.
>+ *
>+ *	Returns # of bytes which addr and buf should be increased.
>+ *	(same to count).
>+ *	If [addr...addr+count) doesn't includes any valid area, returns 0.


If I read it correctly, your code doesn't do what you described here,
it doesn't return 0 when there is no valid area.


>+ *
>+ *	This function checks that addr is a valid vmalloc'ed area, and
>+ *	copy data from that area to a given buffer. If the given memory range of
>+ *	[addr...addr+count) includes some valid address, data is copied to
>+ *	proper area of @buf. If there are memory holes, they'll be zero-filled.
>+ *	IOREMAP area is treated as memory hole and no copy is done.
>+ *
>+ *	Note: In usual ops, vread() is never necessary because the caller should
>+ *	know vmalloc() area is valid and can use memcpy(). This is for routines
>+ *	which have to access vmalloc area without any informaion, as /dev/kmem.
>+ *
>+ *	The caller should guarantee KM_USER1 is not used.
>+ */
>+
> long vread(char *buf, char *addr, unsigned long count)
> {
> 	struct vm_struct *tmp;
> 	char *vaddr, *buf_start = buf;
>+	unsigned long buflen = count;
> 	unsigned long n;
> 
> 	/* Don't allow overflow */
>@@ -1640,7 +1739,7 @@
> 		count = -(unsigned long) addr;
> 
> 	read_lock(&vmlist_lock);
>-	for (tmp = vmlist; tmp; tmp = tmp->next) {
>+	for (tmp = vmlist; count && tmp; tmp = tmp->next) {
> 		vaddr = (char *) tmp->addr;
> 		if (addr >= vaddr + tmp->size - PAGE_SIZE)
> 			continue;
>@@ -1653,32 +1752,66 @@
> 			count--;
> 		}
> 		n = vaddr + tmp->size - PAGE_SIZE - addr;
>-		do {
>-			if (count == 0)
>-				goto finished;
>-			*buf = *addr;
>-			buf++;
>-			addr++;
>-			count--;
>-		} while (--n > 0);
>+		if (n > count)
>+			n = count;
>+		if (!(tmp->flags & VM_IOREMAP))
>+			aligned_vread(buf, addr, n);
>+		else /* IOREMAP area is treated as memory hole */
>+			memset(buf, 0, n);
>+		buf += n;
>+		addr += n;
>+		count -= n;
> 	}
> finished:
> 	read_unlock(&vmlist_lock);
>-	return buf - buf_start;
>+
>+	if (buf == buf_start)
>+		return 0;
>+	/* zero-fill memory holes */
>+	if (buf != buf_start + buflen)
>+		memset(buf, 0, buflen - (buf - buf_start));
>+
>+	return buflen;
> }
