Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZJFEjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZJFEjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZJFEjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:39:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:36024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZJFEjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:39:39 -0400
Subject: Re: userspace firmware loader, vmap, and nommu
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
In-Reply-To: <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com>
References: <8bd0f97a0910052125m4327fef3i47e3b549938802f9@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 05:38:59 +0100
Message-Id: <1254803939.14541.49.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 00:25 -0400, Mike Frysinger wrote:
> semi-recently (9 Apr 2009), the userspace firmware code was rewritten
> to use vmap().  this causes problems for nommu systems as it isnt
> possible to create a virtually contiguous map with physically
> discontiguous pages. 

Oops, sorry.

>  the firmware loader used to work before this
> change because it would handle the realloc steps itself (allocate
> larger contiguous memory, copy over older data, release older memory)
> and vmalloc() on nommu is simply kmalloc().
> 
> this could be handled transparently on nommu systems by moving this
> scatter gathering of pages into vmap:
> void *vmap(struct page **pages, unsigned int count, unsigned long
> flags, pgprot_t prot)
> {
>     unsigned int i;
>     void *new_map, *page_data;
> 
>     new_map = kmalloc(count << PAGE_SHIFT, GFP_KERNEL);
>     if (!new_map)
>         return NULL;
> 
>     for (i = 0; i < count; ++i) {
>         page_data = kmap(pages[i]);
>         memcpy(new_map + (i << PAGE_SHIFT), page_data, PAGE_SIZE);
>         kunmap(page_data);
>     }
> 
>     return new_map;

I wouldn't necessarily want to do that for _all_ vmap() calls, but doing
it just for the firmware loader might make some sense. It does mean you
have to have _twice_ as much memory available as the size of the
firmware in question. And you have to have a contiguous chunk even
_after_ allocating it once piecemeal.

> void vunmap(const void *addr)
> {
>     kfree(addr);
> }
> 
> or we could add nommu-specific code to the firmware loader to not use
> vmap().  how would you like to go David (Howells) ?

Or we could add _generic_ code not to use vmap(). Just teach the users
that you don't get a virtually contiguous blob back from
request_firmware(); you get an array of pages instead.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

