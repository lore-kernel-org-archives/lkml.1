Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZKUXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZKUXL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 18:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZKUXL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 18:11:26 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59810 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZKUXLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 18:11:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=GUMEMotgQwsI01SQIxr9brdlIOPVoBVBBDGQnC4PqdftIrIrv7Ebnt+a1JNyZCTMSl
         MA88aS2v7EoN5fsUTphonM858tUQoOKgjxqAOfxkDvoCKatStmqVU/q4qisUFzvLhv1q
         jbP6cOmCJOdqtevkQwRde+kCHmQpcnwcxmyuI=
Date: Sun, 22 Nov 2009 02:11:28 +0300
From: Ilya Loginov <isloginov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091122021128.db47e202.isloginov@gmail.com>
In-Reply-To: <20091121095429.1378828c.akpm@linux-foundation.org>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The one somewhat fragile thing is that we'll end up in a situation
> where an architecture could implement a real flush_dcache_page(), but
> would forget to set SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS.  Or
> vice versa.  To make things reliable it would be good to cause a
> compilation failure in that case.

Yes, I do understand this.

> One way of addressing this is to
> 
> - change every arch/*/include/asm/cacheflush.h to include
> asm-generic/cacheflush.h
> 
> - put #ifndef SOMETHING_LIKE_CONFIG_CPU_HAS_DCACHE_ALIAS wrappers
> around all content in asm-generic/cacheflush
> 
> So it the above mistake happens, we'll get lots of duplicated
> definitions, or no definitions at all (I think).

Actually I don't think that it is the best solution. Let me explain.

1) The problem is that flush_dcache_page is defined for a bunch of
different architectures. (x86, ia64, etc). But in most of the cases
flush_dcache_page is empty, but should be defined anyway. Just see the
review:

	h8300 -- empty. All cache defines like asm-generic, but worse
(without do {} while(0)).
	blackfin -- empty for architectures which do not define
CONFIG_BFIN_EXTMEM_WRITEBACK or CONFIG_BFIN_L2_WRITEBACK.
	frv
	x86 -- empty. All cache defines like asm-generic, but it was
implemented throught inline.
	ia64
	sh -- in case if ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE was defined
most flash operations are empty, but there no this define anywhere in
kernel. 
	alpha -- empty, like most cache operations.
	avr32 -- empty. But many other operations are defined.
	arm
	sparc
	powerpc
	m32r -- empty for all chips, like most kernel operations.
	microblaze -- empty.
	cris -- empty. cacheflush is equal to asm-generic, except
define change_page_attr function.
	s390 -- empty. cacheflush is equal to asm-generic, except
define kernel_map_pages function if CONFIG_DEBUG_PAGEALLOC was defined.
	mips -- different for different boards and architectures.
	parisc 
	mn10300 -- empty. But there are functions like
mn10300_dcache_flush_page. I think this is bad.
	m68k -- empty if __uClinux__ is using.
	xtensa -- empty if DCACHE_WAY_SIZE < PAGE_SIZE

So you see, it is a real mess. Only in 8 of 20 architectures
this call don't empty! 


2) In the asm-generic/cacheflush.h also was defined a lot of functions
that could have a conflict and we don't want to have this conflict
anyway. So we will meet here the same problem that was described in you
letter:

> we'll get lots of duplicated
> definitions, or no definitions at all

3) I want to mention that flush_dcache_page depends on the type of
process and chipset as well, so in order to make such things workable
developers usually set different flags in Kconfig. For example
SYS_HAS_EARLY_PRINTK or DMA_NONCOHERENT. And this is the most effective
way of doing this, as far as I see this.

I've just checked most of the places in the kernel where
flush_dcache_page is used. See the summary:

1)
drivers/staging/rspiusb/rspiusb.c

for (i = 0; i < pdx->maplist_numPagesMapped[frameInfo]; i++)
	flush_dcache_page(maplist_p[i]);

2)(is equal to 3))
fs/reiserfs/super.c
fs/reiserfs/inode.c
fs/ufs/super.c
fs/ext2/super.c
fs/nilfs2/mdt.c
fs/jfs/super.c
fs/ocfs2/quota_global.c
fs/ext3/super.c
fs/ext4/super.c

This operation is executed into a loop (big enought).
flush_dcache_page(bh->b_page);

3)
in all other cases there is

flush_dcache_page(page);

4)*
fs/bio.c
mm/bounce.c
net/sunrpc/xprtrdma/rpc_rdma.c

These files call flush_dcache_page in bio_for_each_segment. But
there are another work. So we have no pointless empty loops.

I think we should select SYS_HAS_FLUSH_DCACHE_PAGE for those
architectures which requires it(to fix the bug) (and implement empty
flush_dcache_page throught inline like in x86(to avoid pointless do
{} while(0))).

What do you think about this?


-- 
Ilya Loginov <isloginov@gmail.com>
