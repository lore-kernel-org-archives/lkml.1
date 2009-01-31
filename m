Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZAaSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZAaSf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 13:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZAaSfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 13:35:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606AbZAaSfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 13:35:14 -0500
Date: Sat, 31 Jan 2009 10:34:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh@veritas.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <Pine.LNX.4.64.0901311216250.6763@blonde.anvils>
Message-ID: <alpine.LFD.2.00.0901311010460.3150@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>  <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>  <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>  <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>  <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>  <1233345190.908.36.camel@lts-notebook>  <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>  <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
 <1233351412.908.69.camel@lts-notebook> <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain> <Pine.LNX.4.64.0901311216250.6763@blonde.anvils>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Jan 2009, Hugh Dickins wrote:
>
> We need a way to communicate not-MAP_NORESERVE to shmem.c, and we don't
> just need it in the explicit shmem_zero_setup() case, we also need it
> for the (probably rare nowadays) case when mmap() is working on file
> /dev/zero (drivers/char/mem.c mmap_zero()), rather than using MAP_ANON.

Heh. We already have that. Maybe you didn't realize. Look at VM_NORESERVE.

So shmem.c can just look at "!(vma->vm_flags & VM_NORESERVE)" if it wants 
to.

The only piece of information you don't have is that "accountable" flag, 
but that was why I was pointing out how totally _useless_ that flag 
actually is. We shouldn't pass it along, because it's always 1, except for 
one special case that we can always calculate (private hugepages).

But in fact, even leaving that untouched, we can trivially just change 
what 'VM_NORESERVE' means: we can just make it the end result of all that 
'accountable' logic, instead of having it just mirror MAP_NORESERVE 
blindly.

> Still haven't decided what's best to do about it (plenty of diversions):
> perhaps we just say my error was to overload VM_ACCOUNT, and define a
> new flag for the purpose, which can go into VM_MERGEABLE_FLAGS; but
> I'd prefer a neater solution if it crosses my mind.

How about this pretty trivial patch?

TOTALLY UNTESTED. As usual. But the concept is pretty simple, and it 
actually removes a fair chunk of hacky code.  The only reason the diffstat 
output says that it adds more lines than it deletes is that I added more 
comments and made that helper inline function rather than make a complex 
conditional.

Whaddaya think?

		Linus

---
 mm/mmap.c  |   48 +++++++++++++++++++++++++-----------------------
 mm/shmem.c |    2 +-
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index c581df1..5fcaec3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1090,6 +1090,15 @@ int vma_wants_writenotify(struct vm_area_struct *vma)
 		mapping_cap_account_dirty(vma->vm_file->f_mapping);
 }
 
+/*
+ * We account for memory if it's a private writeable mapping,
+ * and VM_NORESERVE wasn't set.
+ */
+static inline int private_accountable_mapping(unsigned int vm_flags)
+{
+	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
+}
+
 unsigned long mmap_region(struct file *file, unsigned long addr,
 			  unsigned long len, unsigned long flags,
 			  unsigned int vm_flags, unsigned long pgoff,
@@ -1117,23 +1126,24 @@ munmap_back:
 	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (flags & MAP_NORESERVE)
+	/*
+	 * Set 'VM_NORESERVE' if we should not account for the
+	 * memory use of this mapping. We only honor MAP_NORESERVE
+	 * if we're allowed to overcommit memory.
+	 */
+	if ((flags & MAP_NORESERVE) && sysctl_overcommit_memory != OVERCOMMIT_NEVER)
+		vm_flags |= VM_NORESERVE;
+	if (!accountable)
 		vm_flags |= VM_NORESERVE;
 
-	if (accountable && (!(flags & MAP_NORESERVE) ||
-			    sysctl_overcommit_memory == OVERCOMMIT_NEVER)) {
-		if (vm_flags & VM_SHARED) {
-			/* Check memory availability in shmem_file_setup? */
-			vm_flags |= VM_ACCOUNT;
-		} else if (vm_flags & VM_WRITE) {
-			/*
-			 * Private writable mapping: check memory availability
-			 */
-			charged = len >> PAGE_SHIFT;
-			if (security_vm_enough_memory(charged))
-				return -ENOMEM;
-			vm_flags |= VM_ACCOUNT;
-		}
+	/*
+	 * Private writable mapping: check memory availability
+	 */
+	if (private_accountable_mapping(vm_flags)) {
+		charged = len >> PAGE_SHIFT;
+		if (security_vm_enough_memory(charged))
+			return -ENOMEM;
+		vm_flags |= VM_ACCOUNT;
 	}
 
 	/*
@@ -1184,14 +1194,6 @@ munmap_back:
 			goto free_vma;
 	}
 
-	/* We set VM_ACCOUNT in a shared mapping's vm_flags, to inform
-	 * shmem_zero_setup (perhaps called through /dev/zero's ->mmap)
-	 * that memory reservation must be checked; but that reservation
-	 * belongs to shared memory object, not to vma: so now clear it.
-	 */
-	if ((vm_flags & (VM_SHARED|VM_ACCOUNT)) == (VM_SHARED|VM_ACCOUNT))
-		vma->vm_flags &= ~VM_ACCOUNT;
-
 	/* Can addr have changed??
 	 *
 	 * Answer: Yes, several device drivers can do it in their
diff --git a/mm/shmem.c b/mm/shmem.c
index 5d0de96..19d566c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2628,7 +2628,7 @@ struct file *shmem_file_setup(char *name, loff_t size, unsigned long flags)
 		goto close_file;
 
 #ifdef CONFIG_SHMEM
-	SHMEM_I(inode)->flags = flags & VM_ACCOUNT;
+	SHMEM_I(inode)->flags = (flags & VM_NORESERVE) ? 0 : VM_ACCOUNT;
 #endif
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
