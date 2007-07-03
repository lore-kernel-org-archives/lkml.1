Return-Path: <linux-kernel-owner+w=401wt.eu-S1760268AbXGCPtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268AbXGCPtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbXGCPte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:49:34 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:21571 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbXGCPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:49:32 -0400
Date: Tue, 3 Jul 2007 16:48:48 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Stas Sergeev <stsp@aknet.ru>
cc: William Tambe <tambewilliam@gmail.com>,
       "Rohland, Hans-Christoph" <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
In-Reply-To: <46893F97.7080200@aknet.ru>
Message-ID: <Pine.LNX.4.64.0707031606370.16965@blonde.wat.veritas.com>
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com>
 <46893F97.7080200@aknet.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAaGFucy1jaHJpc3RvcGgucm9obGFuZEBzYXAuY29tAHRhbWJld2lsbGlhbUBnbWFpbC5jb20Ac3RzcEBha25ldC5ydQA=
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Stas Sergeev wrote:
> Hugh Dickins wrote:
> > You've answered your own question: we did not make the change Stas
> > suggested, IIRC because I remained a little uneasy with that change
> > in behaviour, and nobody else spoke up for it.
> IIRC your argument, that made sense to me,
> was that with such an approach, you can only
> expand the backing-store, but never shrink.
> I agree this is a problem from some point of
> view. I have no idea whether it is important
> or not, but it definitely _looks_ not very good.

You were gracious enough to accept my arguments back then, but after
mulling this over overnight, I've come to think I was just too timid
back then, and gave too much weight to the issue of there being no
shrink, and to the issue that child might expand the object without
parent knowing (that surplus remaining allocated until both exited).

I've come right around to your original view, Stas, and William's:
if that mmap creates such an object, then the expanding mremap really
ought to be useful, and allow the underlying object to be expanded.
The shared anonymous object is already anomalous: expanding it on
fault makes it more consistent with its own nature, not less.

> 
> > >         //why does this failed. I am well in the interval [4096, 8192]
> > >         *(unsigned int *)(ptr + 4096 + 8)= 10;
> >> }
> Well, this generates a bus error, while, for
> example, doing the same trick with having a
> /dev/mem as a backing-store, simply maps the
> "enlarged" space with the anonymous memory,
> and so does not generate a SIGBUS (not producing
> a desired effect either, of course).
> Why do we have it both ways? Shouldn't they
> (i.e. /dev/zero and /dev/mem mapping) behave
> the same after expanding with mremap?

They've very different: mapping /dev/mem maps an existing object;
whereas mapping /dev/zero is a convention by which a new object
is created - and we can't afford the memory to make it of infinite
extent, so have limited it to the mapped size.

> 
> > I haven't given it any thought since then:
> I was thinking about it a bit, and I imagined
> we need something like
>    int mopen(void *addr, size_t len, unsigned int flags);
> which will give you an fd for the memory area,
> which you can then ftruncate() and mmap() (and
> mremap).

Ah, if we added an mopen(), there's no end to the discussions
we could have about what it can do.  It may be a great idea:
but it's really not needed to solve this particular little
problem.  As last time around, you were suggesting .mremap
callouts; but I much prefer your original shmem_zero_nopage,
which is a solution of the scale appropriate to the problem.

> Such a thing could solve that mremap() problem
> that me and William Tambe have.

If you're thinking of going that way, for this problem it
would be better just to stick with POSIX shm_open, as Christoph
suggested before, and you suggest to William in other mail.

But I now accept your view, that the shared anonymous object
is not behaving consistently in response to mremap, and would
like to put in a patch for that.  This isn't a particularly good
time for such a patch - it's unclear right now whether 2.6.23 will
have shmem_nopage like 2.6.22 or shmem_fault like 2.6.22-rc-mm;
but we can easily adjust to whichever.

Here's a patch against 2.6.22-rc7: would you, Stas, put your
Signed-off-by into this, and accept authorship - although I'm
sending this back to you, it's very much your idea, and only
trivially modified from your three-year-old patch by me.  If
you're agreeable, I can then forward it or its shmem_zero_fault
equivalent to Andrew when we see which way 2.6.23 is going.

[I'll fill in the patch comment later]

Signed-off-by: Hugh Dickins <hugh@veritas.com>
----

 mm/shmem.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

--- 2.6.22-rc7/mm/shmem.c	2007-06-17 10:51:02.000000000 +0100
+++ linux/mm/shmem.c	2007-07-03 15:35:32.000000000 +0100
@@ -1320,6 +1320,36 @@ static struct page *shmem_nopage(struct 
 	return page;
 }
 
+struct page *shmem_zero_nopage(struct vm_area_struct *vma,
+				unsigned long address, int *type)
+{
+	struct page *page;
+
+	page = shmem_nopage(vma, address, type);
+	if (unlikely(page == NOPAGE_SIGBUS)) {
+		struct inode *inode = vma->vm_file->f_dentry->d_inode;
+		struct shmem_inode_info *info = SHMEM_I(inode);
+		loff_t vm_size, i_size;
+
+		/*
+		 * If mremap has been used to extend the vma,
+		 * now extend the underlying object to include this page.
+		 */
+		vm_size = (PAGE_ALIGN(address) - vma->vm_start) +
+				((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+		spin_lock(&info->lock);
+		i_size = i_size_read(inode);
+		if (i_size < vm_size && vm_size <= SHMEM_MAX_BYTES &&
+		    !shmem_acct_size(info->flags, vm_size - i_size)) {
+			i_size_write(inode, vm_size);
+			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+		}
+		spin_unlock(&info->lock);
+		page = shmem_nopage(vma, address, type);
+	}
+	return page;
+}
+
 static int shmem_populate(struct vm_area_struct *vma,
 	unsigned long addr, unsigned long len,
 	pgprot_t prot, unsigned long pgoff, int nonblock)
@@ -2471,6 +2501,14 @@ static struct vm_operations_struct shmem
 #endif
 };
 
+static struct vm_operations_struct shmem_zero_vm_ops = {
+	.nopage		= shmem_zero_nopage,
+	.populate	= shmem_populate,
+#ifdef CONFIG_NUMA
+	.set_policy     = shmem_set_policy,
+	.get_policy     = shmem_get_policy,
+#endif
+};
 
 static int shmem_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
@@ -2599,6 +2637,7 @@ int shmem_zero_setup(struct vm_area_stru
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vma->vm_file = file;
-	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_ops = &shmem_zero_vm_ops;
+	vma->vm_pgoff = 0;
 	return 0;
 }
