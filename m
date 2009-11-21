Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbZKUX0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbZKUX0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 18:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZKUX0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 18:26:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214AbZKUX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 18:26:45 -0500
Date: Sat, 21 Nov 2009 15:26:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilya Loginov <isloginov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Peter Horton <phorton@bitbox.co.uk>,
       "Ed L. Cashin" <ecashin@coraid.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] mtd: fix mtd_blkdevs problem with caches on some
 architectures (2.6.31)
Message-Id: <20091121152633.8c79e341.akpm@linux-foundation.org>
In-Reply-To: <20091122021128.db47e202.isloginov@gmail.com>
References: <20091118170810.2bb9cd54.isloginov@gmail.com>
	<20091120163751.731781e8.akpm@linux-foundation.org>
	<20091121170437.0839daef.isloginov@gmail.com>
	<20091121095429.1378828c.akpm@linux-foundation.org>
	<20091122021128.db47e202.isloginov@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009 02:11:28 +0300 Ilya Loginov <isloginov@gmail.com> wrote:

> I think we should select SYS_HAS_FLUSH_DCACHE_PAGE for those
> architectures which requires it(to fix the bug) (and implement empty
> flush_dcache_page throught inline like in x86(to avoid pointless do
> {} while(0))).
> 
> What do you think about this?

Well, rather that defining CONFIG_SYS_HAS_FLUSH_DCACHE_PAGE in
Kconfig (which is what I think your were thinking of), we could do:

--- a/arch/x86/include/asm/cacheflush.h~a
+++ a/arch/x86/include/asm/cacheflush.h
@@ -13,6 +13,7 @@ static inline void flush_cache_range(str
 static inline void flush_cache_page(struct vm_area_struct *vma,
 				    unsigned long vmaddr, unsigned long pfn) { }
 static inline void flush_dcache_page(struct page *page) { }
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 static inline void flush_dcache_mmap_lock(struct address_space *mapping) { }
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping) { }
 static inline void flush_icache_range(unsigned long start,
--- a/arch/arm/include/asm/cacheflush.h~a
+++ a/arch/arm/include/asm/cacheflush.h
@@ -409,6 +409,7 @@ extern void flush_ptrace_access(struct v
  * See update_mmu_cache for the user space part.
  */
 extern void flush_dcache_page(struct page *);
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 
 extern void __flush_dcache_page(struct address_space *mapping, struct page *page);
 
(etc)

And then, in a .c file:

#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
#error "you lose"
#endif

and, of course:

#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
<implement real code>
#else
<implement empty stubs>
#endif


This way

a) the definition site for ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE is
   right next to the definition site for flush_dcache_page(), instead
   of being in some random remote file and

b) people can't forget to implement ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.


Generally we prefer to avoid defining ARCH_HAS_FOO in header files and
we prefer to control the definition in Kconfig.  But it sounds like we
have a special case here..

