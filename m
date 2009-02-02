Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbZBBSdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbZBBSdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZBBSdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:33:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53484 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZBBSdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:33:07 -0500
Date: Mon, 2 Feb 2009 18:33:04 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
	VM_LOCKED file segments
Message-ID: <20090202183304.GB9840@csn.ul.ie>
References: <Pine.LNX.4.64.0901311216250.6763@blonde.anvils> <alpine.LFD.2.00.0901311010460.3150@localhost.localdomain> <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com> <Pine.LNX.4.64.0902021215060.18750@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902021215060.18750@blonde.anvils>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 12:54:15PM +0000, Hugh Dickins wrote:
> On Mon, 2 Feb 2009, KOSAKI Motohiro wrote:
> > >  
> > > -	if (flags & MAP_NORESERVE)
> > > +	/*
> > > +	 * Set 'VM_NORESERVE' if we should not account for the
> > > +	 * memory use of this mapping. We only honor MAP_NORESERVE
> > > +	 * if we're allowed to overcommit memory.
> > > +	 */
> > > +	if ((flags & MAP_NORESERVE) && sysctl_overcommit_memory != OVERCOMMIT_NEVER)
> > 
> > I afraid this line a bit.
> > if following scenario happend, we can lost VM_NORESERVE?
> > 
> > 1. admin set overcommit_memory to "never"
> > 2. mmap
> > 3. admin set overcommit_memory to "guess"
> 
> I still haven't reviewed it fully myself (and note that what
> Linus put in his tree is not identical to this posted patch),
> but I do believe this is okay.
> 
> When admin changes overcommit_memory, we don't make a pass across
> every vma of every mm in the system, to adjust all the accounting
> of VM_NORESERVE areas; so I think it's quite reasonable to take
> VM_NORESERVE as reflecting the policy in force when that vma was
> created.  And nothing is displaying the VM_NORESERVE flag.
> 
> Ah, you're actually thinking of
> 4. mprotect
> with the original flags (!VM_WRITE) such that no VM_ACCOUNT was done,
> and now VM_WRITE is added and the accounting is done despite it having
> been mapped MAP_NORESERVE originally.  Whereas before Linus's change,
> VM_NORESERVE would have still exempted it.
> 
> Well... I don't think I care!
> 
> But I wonder what the hugetlb situation is: that
> 	if (!accountable)
> 		vm_flags |= VM_NORESERVE;
> looks suspicious to me, they look as if they're exempting all
> the hugetlb pages from its accounting, whereas !accountable was
> only supposed to exempt them from mmap_region()'s own accounting.
> 

Am playing a bit of catch-up here and just reading the patch for the first
time. Whatever about the rest of it, I can comment on the hugetlb aspects
at least.  Glancing through commit fc8744adc870a8d4366908221508bb113d8b72ee
looked like it would break hugetlb accounting and sure enough, a test set
off an OOM storm killing almost everything in sight.

Any opinions on the patch below? As a bonus, it gets rid of this "accountable"
parameter altogether and figures out everything needed from the file and
flags.

================
Do not account for the address space used by hugetlbfs

hugetlb always applies strict overcommit semantics to shared and private
mappings regardless of the value in /proc/sys/vm/overcommit_memory.
mm/hugetlb.c has reservation counters that are checked and updated
during mmap() to ensure that hugepages exist in the future when faults
occurs. Otherwise, it is too easy to applications to be SIGKILLed. It
uses VM_NORESERVE to track whether MAP_NORESERVE was set at mmap() time.
If an application application fails with MAP_NORESERVE, they get to keep both
pieces. The core VM does not handle VM_ACCOUNT correctly for hugetlbfs-backed
mappings so it should not be set.

With commit fc8744adc870a8d4366908221508bb113d8b72ee, VM_NORESERVE and
VM_ACCOUNT are getting set for hugetlbfs-backed mappings resulting in a
lot of oddness and processes getting killed. Special-case hugetlbfs as
it handles its own accounting.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 include/linux/mm.h |    3 +--
 mm/fremap.c        |    2 +-
 mm/mmap.c          |   30 ++++++++++++++++++++----------
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index e8ddc98..3235615 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1129,8 +1129,7 @@ extern unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long flag, unsigned long pgoff);
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long flags,
-	unsigned int vm_flags, unsigned long pgoff,
-	int accountable);
+	unsigned int vm_flags, unsigned long pgoff);
 
 static inline unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
diff --git a/mm/fremap.c b/mm/fremap.c
index 736ba7f..b6ec85a 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -198,7 +198,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 			flags &= MAP_NONBLOCK;
 			get_file(file);
 			addr = mmap_region(file, start, size,
-					flags, vma->vm_flags, pgoff, 1);
+					flags, vma->vm_flags, pgoff);
 			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
diff --git a/mm/mmap.c b/mm/mmap.c
index 214b6a2..c4f3321 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -918,7 +918,6 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	struct inode *inode;
 	unsigned int vm_flags;
 	int error;
-	int accountable = 1;
 	unsigned long reqprot = prot;
 
 	/*
@@ -1019,8 +1018,6 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 					return -EPERM;
 				vm_flags &= ~VM_MAYEXEC;
 			}
-			if (is_file_hugepages(file))
-				accountable = 0;
 
 			if (!file->f_op || !file->f_op->mmap)
 				return -ENODEV;
@@ -1053,8 +1050,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	if (error)
 		return error;
 
-	return mmap_region(file, addr, len, flags, vm_flags, pgoff,
-			   accountable);
+	return mmap_region(file, addr, len, flags, vm_flags, pgoff);
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
 
@@ -1096,13 +1092,29 @@ int vma_wants_writenotify(struct vm_area_struct *vma)
  */
 static inline int accountable_mapping(unsigned int vm_flags)
 {
+	/* hugetlbfs does its own accounting */
+	if (vm_flags & VM_HUGETLB)
+		return 0;
+
 	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
 }
 
+static inline int should_overcommit(struct file *file)
+{
+	/* Check if the sysctl allows overcommit */
+	if (sysctl_overcommit_memory != OVERCOMMIT_NEVER)
+		return 1;
+
+	/* hugetlbfs does its own accounting */
+	if (file && is_file_hugepages(file))
+		return 1;
+
+	return 0;
+}
+
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
-			  unsigned int vm_flags, unsigned long pgoff,
-			  int accountable)
+			  unsigned int vm_flags, unsigned long pgoff)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
@@ -1131,9 +1143,7 @@ munmap_back:
 	 * memory use of this mapping. We only honor MAP_NORESERVE
 	 * if we're allowed to overcommit memory.
 	 */
-	if ((flags & MAP_NORESERVE) && sysctl_overcommit_memory != OVERCOMMIT_NEVER)
-		vm_flags |= VM_NORESERVE;
-	if (!accountable)
+	if ((flags & MAP_NORESERVE) && should_overcommit(file))
 		vm_flags |= VM_NORESERVE;
 
 	/*
