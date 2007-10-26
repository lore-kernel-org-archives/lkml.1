Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXJZT02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXJZT02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762908AbXJZTZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:25:57 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52769 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762227AbXJZTZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:25:55 -0400
Date: Fri, 26 Oct 2007 15:25:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [RFC PATCH 0/2] Fix linux/swap.h build wart
Message-ID: <20071026192548.GA9174@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For some time, there has been a problem of linux/swap.h using
page_cache_release and release_pages without declaring them by
including linux/pagemap.h.  pagemap.h isn't included because that
breaks the sparc build.

The full details are in the next post, but the short story is that
sparc's pgtable.h includes linux/swap.h, creating a mm.h -> mm.h
recursion.  The current tree breaks that recursion by removing the
swap.h -> pagemap.h inclusion.  This breaks builds on a regular basis
(references also in the next post).

These patches propose to break the recursion instead by removing the
linux/pagemap.h -> linux/highmem.h inclusion.  I'd like to know
whether there are any fundamental reasons that this include should be
preserved.

The reason for choosing this include is that pagemap.h doesn't use
anything exported by highmem.h.  The downside is that a bunch of
things now need to include highmem.h.  These are mostly filesystems,
plus a good amount of arch code and a few drivers.  I would argue that
if you use something from a header, you should include it, regardless
of whether you already get the header indirectly, so this isn't too
much of a downside as far as I'm concerned.

The one thing I'm uncertain about is whether pagemap.h and highmem.h
have some basic relationship that implies that you can assume you get
highmem when you include pagemap.

The two patches that follow do the following:
	remove highmem.h from pagemap.h and add includes of highmem.h
to a number of files that now need them
	include pagemap.h in swap.h

These are for comment only, not for mainline, so there's no S-o-b
right yet.

At this point, I haven't confirmed that the following files, which use
stuff from highmem.h but don't include it, still build:

	./arch/x86/kernel/crash_dump_64.c
	./arch/frv/mm/fault.c
	./arch/frv/mm/kmap.c
	./arch/h8300/mm/kmap.c
	./arch/ia64/kernel/crash_dump.c
	./arch/m68k/mm/kmap.c
	./arch/m68knommu/mm/kmap.c
	./arch/powerpc/kernel/crash_dump.c
	./arch/sh/kernel/crash_dump.c
	./arch/xtensa/mm/pgtable.c
	./drivers/block/ps3disk.c
	./drivers/infiniband/hw/ipath/ipath_verbs.h
	./drivers/mmc/host/at91_mci.c
	./drivers/mmc/host/mmci.h
	./drivers/mmc/host/mmc_spi.c
	./drivers/s390/block/xpram.c
	./drivers/s390/char/tape_34xx.c
	./drivers/kvm/paging_tmpl.h
	./fs/hfsplus/hfsplus_fs.h
	./include/asm-arm/cacheflush.h
	./include/asm-frv/pgtable.h
	./include/asm-x86/kexec_32.h
	./include/asm-x86/kexec_64.h
	./include/asm-x86/pgtable_32.h
	./include/asm-m68k/motorola_pgalloc.h
	./include/asm-m68k/sun3_pgalloc.h
	./include/asm-m68k/sun3_pgtable.h
	./include/asm-mips/cacheflush.h
	./include/asm-mips/page.h
	./include/asm-parisc/cacheflush.h
	./include/asm-powerpc/pgtable-ppc32.h
	./include/asm-ppc/pgtable.h
	./include/asm-s390/kexec.h
	./include/asm-sh/kexec.h
	./mm/migrate.c

				Jeff

-- 
Work email - jdike at linux dot intel dot com
