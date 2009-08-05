Return-Path: <linux-kernel-owner+w=401wt.eu-S933048AbZHEBKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbZHEBKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 21:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932703AbZHEBKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 21:10:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56761 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524AbZHEBKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 21:10:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 5 Aug 2009 10:08:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: scgtrp@gmail.com, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH 2/3] kcore: fix vread/vwrite to be aware of
 holes.
Message-Id: <20090805100843.dbdabcfa.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090804143031.b9769a13.akpm@linux-foundation.org>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090803201418.040bb3ee.kamezawa.hiroyu@jp.fujitsu.com>
	<20090803201845.c3ae49b5.kamezawa.hiroyu@jp.fujitsu.com>
	<20090804143031.b9769a13.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 14:30:31 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 3 Aug 2009 20:18:45 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > vread/vwrite access vmalloc area without checking there is a page or not.
> > In most case, this works well.
> > 
> > In old ages, the caller of get_vm_ara() is only IOREMAP and there is no
> > memory hole within vm_struct's [addr...addr + size - PAGE_SIZE]
> > ( -PAGE_SIZE is for a guard page.)
> > 
> > After per-cpu-alloc patch, it uses get_vm_area() for reserve continuous
> > virtual address but remap _later_. There tend to be a hole in valid vmalloc
> > area in vm_struct lists.
> > Then, skip the hole (not mapped page) is necessary.
> > This patch updates vread/vwrite() for avoiding memory hole.
> > 
> > Routines which access vmalloc area without knowing for which addr is used
> > are
> >   - /proc/kcore
> >   - /dev/kmem
> > 
> > kcore checks IOREMAP, /dev/kmem doesn't. After this patch, IOREMAP is
> > checked and /dev/kmem will avoid to read/write it.
> > Fixes to /proc/kcore will be in the next patch in series.
> > 
> > Changelog v2->v3:
> >  - fixed typos.
> >  - use kmap. (if not using kmap, we have to add lock here.)
> >  - fixed PAGE_MASK miss-use.
> > Changelog v1->v2:
> >  - enhanced comments.
> >  - treat IOREMAP as hole always.
> >  - zero-fill memory hole if [addr...addr+size] includes valid pages.
> >  - returns 0 if [addr...addr+size) includes no valid pages.
> > 
> > ...
> >
> > +static int aligned_vread(char *buf, char *addr, unsigned long count)
> > +{
> > +	struct page *p;
> > +	int copied = 0;
> > +
> > +	while (count) {
> > +		unsigned long offset, length;
> > +
> > +		offset = (unsigned long)addr & ~PAGE_MASK;
> > +		length = PAGE_SIZE - offset;
> > +		if (length > count)
> > +			length = count;
> > +		p = vmalloc_to_page(addr);
> > +		/*
> > +		 * To do safe access to this _mapped_ area, we need
> > +		 * lock. But adding lock here means that we need to add
> > +		 * overhead of vmalloc()/vfree() calles for this _debug_
> > +		 * interface, rarely used. Instead of that, we'll use
> > +		 * kmap() and get small overhead in this access function.
> > +		 */
> > +		if (p) {
> > +			/* we can expect USR1 is not used */
> 
> It would be nice if the comment were to explain _why_ KM_USER1 is known
> to be free here.
> 
ok, will do. Hmm, but KM_USR0 is better ?
I'm not sure difference between KM_USR0/KM_USR1...



> 
> > +			void *map = kmap_atomic(p, KM_USER1);
> > +			memcpy(buf, map + offset, length);
> > +			kunmap_atomic(map, KM_USER1);
> 
> Can use clear_highpage().
> 
ah, "buf" is expected to be kmalloc'ed buffer. I'll explain it in Usage
or adds comment.

Thank you for review!

-Kame


> > +		} else
> > +			memset(buf, 0, length);
> > +
> > +		addr += length;
> > +		buf += length;
> > +		copied += length;
> > +		count -= length;
> > +	}
> > +	return copied;
> > +}
> > +
> > +static int aligned_vwrite(char *buf, char *addr, unsigned long count)
> > +{
> > +	struct page *p;
> > +	int copied = 0;
> > +
> > +	while (count) {
> > +		unsigned long offset, length;
> > +
> > +		offset = (unsigned long)addr & ~PAGE_MASK;
> > +		length = PAGE_SIZE - offset;
> > +		if (length > count)
> > +			length = count;
> > +		p = vmalloc_to_page(addr);
> > +		/*
> > +		 * To do safe access to this _mapped_ area, we need
> > +		 * lock. But adding lock here means that we need to add
> > +		 * overhead of vmalloc()/vfree() calles for this _debug_
> > +		 * interface, rarely used. Instead of that, we'll use
> > +		 * kmap() and get small overhead in this access function.
> > +		 */
> > +		if (p) {
> > +			/* we can expect USR1 is not used */
> > +			void *map = kmap_atomic(p, KM_USER1);
> > +			memcpy(map + offset, buf, length);
> > +			kunmap_atomic(map, KM_USER1);
> 
> clear_highpage().
> 
> > +		}
> > +		addr += length;
> > +		buf += length;
> > +		copied += length;
> > +		count -= length;
> > +	}
> > +	return copied;
> > +}
> 
> 

