Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbXKNLuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbXKNLuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbXKNLtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:49:50 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:25292 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXKNLtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:49:49 -0500
Subject: Re: [patch 3/3] arch_rebalance_pgtables call
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: benh@kernel.crashing.org
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1195034796.28865.36.camel@pasglop>
References: <20071112143009.425807965@de.ibm.com>
	 <20071112144010.052155135@de.ibm.com>
	 <200711132333.38086.nickpiggin@yahoo.com.au>
	 <1195032394.9446.6.camel@localhost>  <1195034796.28865.36.camel@pasglop>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 14 Nov 2007 12:49:46 +0100
Message-Id: <1195040986.9446.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-14 at 21:06 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2007-11-14 at 10:26 +0100, Martin Schwidefsky wrote:
> > That patch allows processes to have different number of page table
> > levels, 31 bit processes have 2 levels (2GB), normal 64 bit processes
> > have 3 levels (4TB) and really big 64 bit processes can have 4 levels
> > (8PB). The downgrade of a page table to use less levels than the
> > parent
> > process is done in arch_pick_mmap_layout. The upgrade is done by using
> > the arch_rebalance_pgtables call. I've considered using the
> > arch_get_unmapped_area but got scared by the indirection in
> > get_unmapped_area:
> > 
> >         get_area = current->mm->get_unmapped_area;
> >         if (file && file->f_op && file->f_op->get_unmapped_area)
> >                 get_area = file->f_op->get_unmapped_area;
> >         addr = get_area(file, addr, len, pgoff, flags);
> 
> Don't be, it's really only hugetlb and other arch specific stuff that
> hook in here on platforms with an MMU (It's also used by /dev/mem etc...
> for mmu-less platforms but you don't care).

I find 8 places where a get_unmapped_area function pointer is used:
ipc/shm.c: shm_get_unmapped_area / shm_file_operations
drivers/char/mem.c: get_unmapped_area_mem / mem_fops & kmem_fops
drivers/video/fbmem.c: get_fb_unmapped_area / fb_fops
drivers/pci/proc.c: get_pci_unmapped_area / proc_bus_pci_operations
fs/hugetlbfs/inode.c: hugetlb_get_unmapped_area / hugetlbfs_file_operations
fs/bad_inode.c: bad_file_get_unmapped_area / bad_file_ops
fs/ramfs/file-nommu.c: ramfs_nommu_get_unmapped_area / ramfs_file_operations
arch/powerpc/platforms/cell/spufs/file.c:
				spufs_get_unmapped_area / spufs_mem_fops

They all either have an arch override, call get_unmapped_area again or
are not relevant. So it should be possible to do the upgrade in
arch_get_unmapped_area. I still have my doubts though, all future uses
of the get_unmapped_area pointer have to be checked and I feel it is
easier to understand to do the upgrade / rebalance of the page table at
the end of get_unmapped_area where every caller of mmap is guaranteed to
pass through.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


