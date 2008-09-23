Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYIWFco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYIWFco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYIWFcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:32:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYIWFcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:32:35 -0400
Date: Tue, 23 Sep 2008 07:32:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Message-ID: <20080923053228.GA5825@wotan.suse.de>
References: <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org> <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz> <13787.1222095249@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13787.1222095249@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 03:54:09PM +0100, David Howells wrote:
> 
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > But now looking into it further, I see this is all a red herring,
> > your rearrangement is not the significant difference: before that
> > there was David Howells' Jan 2006 commit
> > b0e15190ead07056ab0c3844a499ff35e66d27cc
> > [PATCH] NOMMU: Make SYSV IPC SHM use ramfs facilities on NOMMU
> > which is the one which adds do_truncate() into tiny-shmem.c's
> > shmem_file_setup() but not into shmem.c's - presumably because
> > config SHMEM depends on MMU so it was irrelevant in shmem.c.
> >
> > *That* is the relevant commit, which introduced the bad i_mutex
> > within mmap_sem lock ordering, and it seems that Nick's current
> > patch is wrong just to remove that do_truncate(), a significant
> > change hidden inside his restoration of the original arrangement.
> 
> That would break SYSV IPC SHM under CONFIG_MMU=n conditions.

The code how it is breaks tiny-shmem under all conditions. We have lock
ordering pretty well documented in mm/filemap.c and mm/rmap.c

 
> The truncate is necessary as I explained in my patch:
> 
>      (2) ramfs files now need resizing using do_truncate() rather than by
>          modifying the inode size directly (see shmem_file_setup()). This
>          causes ramfs to attempt to bind a block of pages of sufficient size to
>          the inode.

OK what about the following patch? Either way, the shmem_zero_setup is
somewhat of a hack in the mmap code.

What really should happen is that the shmem zero setup should happen
before the get_unmapped_area, so the correct get_unmapped_area for
the file gets called to allocate contiguous pages. This could also
lift the whole file creation out from under mmap_sem (not that you would
need to call do_truncate there *anyway* in that case, but it still makes
the code cleaner).

For the ipc setup code, we do need something, though.


> What I didn't belabour in the patch, and perhaps I should have, is that to do
> SYSV IPC SHM under NOMMU conditions, it is necessary to allocate a *contiguous*
> set of pages - something that ramfs has been taught to do under NOMMU when
> truncating a file upwards from zero size.  This makes POSIX SHM on ramfs files
> viable also.

RFC Quick patch to fix nommu anonymous shared memory without breaking
locking...

---

Index: linux-2.6/include/linux/ramfs.h
===================================================================
--- linux-2.6.orig/include/linux/ramfs.h
+++ linux-2.6/include/linux/ramfs.h
@@ -6,6 +6,7 @@ extern int ramfs_get_sb(struct file_syst
 	 int flags, const char *dev_name, void *data, struct vfsmount *mnt);
 
 #ifndef CONFIG_MMU
+extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize);
 extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 						   unsigned long addr,
 						   unsigned long len,
Index: linux-2.6/mm/tiny-shmem.c
===================================================================
--- linux-2.6.orig/mm/tiny-shmem.c
+++ linux-2.6/mm/tiny-shmem.c
@@ -80,6 +80,12 @@ struct file *shmem_file_setup(char *name
         inode->i_nlink = 0;     /* It is unlinked */
         init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
                         &ramfs_file_operations);
+
+#ifndef CONFIG_MMU
+	error = ramfs_nommu_expand_for_mapping(inode, size);
+	if (error)
+		goto close_file;
+#endif
 	return file;
 
 close_file:
Index: linux-2.6/fs/ramfs/file-nommu.c
===================================================================
--- linux-2.6.orig/fs/ramfs/file-nommu.c
+++ linux-2.6/fs/ramfs/file-nommu.c
@@ -58,7 +58,7 @@ const struct inode_operations ramfs_file
  * size 0 on the assumption that it's going to be used for an mmap of shared
  * memory
  */
-static int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
+int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 {
 	struct pagevec lru_pvec;
 	unsigned long npages, xpages, loop, limit;
