Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbXGCS2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbXGCS2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbXGCS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:28:37 -0400
Received: from 241-226.umostel.ru ([77.246.241.226]:58314 "EHLO mail.aknet.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbXGCS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:28:36 -0400
Message-ID: <468A9575.60409@aknet.ru>
Date: Tue, 03 Jul 2007 22:29:09 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: William Tambe <tambewilliam@gmail.com>,
       "Rohland, Hans-Christoph" <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com> <46893F97.7080200@aknet.ru> <Pine.LNX.4.64.0707031606370.16965@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0707031606370.16965@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Hugh Dickins wrote:
> You were gracious enough to accept my arguments back then, but after
> mulling this over overnight, I've come to think I was just too timid
> back then, and gave too much weight to the issue of there being no
> shrink, and to the issue that child might expand the object without
> parent knowing (that surplus remaining allocated until both exited).
I simply think that the anonymous shared mapping
is a bit of an ad-hoc interface. The result is that
whenever you extend it in some way, you get a problem
elsewhere. So I just stopped using it.

> The shared anonymous object is already anomalous:
Exactly.

> expanding it on
> fault makes it more consistent with its own nature, not less.
That's certainly true, you were agree with this even in
the past. It is more consistent to have it that way. The
only question is whether the side-effects you outlined,
do outweight the benefit, or not. But since it was you
who outlined the problems, I guess you have the right to
say that they, while being valid, do not outweight the benefit. :)
I am not going to oppose my own patch, of course.

> They've very different: mapping /dev/mem maps an existing object;
> whereas mapping /dev/zero is a convention by which a new object
> is created - and we can't afford the memory to make it of infinite
> extent, so have limited it to the mapped size.
OK. And I guess comparing /dev/mem mapping with
/dev/shm/xxx mapping is not valid too, since the
/dev/mem perhaps doesn't permit ftruncate().
So do you say, silently mapping the private anonymous
pages for /dev/mem is a correct behaveour, even though
the /proc/pid/maps shows that the mapping is shared?

> Ah, if we added an mopen(), there's no end to the discussions
> we could have about what it can do.  It may be a great idea:
> but it's really not needed to solve this particular little
> problem.
Well, I simply thought that something like this is
needed anyway, not only for that problem. But then
vmsplice() appeared, so of course such an mopen() is
no longer much relevant. I am just puzzled as to why
the pipe was used for vmsplice() and can't find an
answer, but I am probably missing something obvious...

>> Such a thing could solve that mremap() problem
>> that me and William Tambe have.
> If you're thinking of going that way, for this problem it
No, of course not, at least, not any more.
Back in 2004 it was a good idea, but now there is no
longer a vacant place for this wonderfull syscall. :)

> would be better just to stick with POSIX shm_open, as Christoph
> suggested before, and you suggest to William in other mail.
The only scenario I can image where you would prefer
the anonymous mmaps over the Posix SHM, is when you want
to manage many small memory areas separately, and do not
want to track them back to their fd's. But even then this
probably doesn't save more than a few dozens of code lines. :)

> But I now accept your view, that the shared anonymous object
> is not behaving consistently in response to mremap,
IIRC this view was never under any doubts. The discussion
was only whether or not to count a few problems you pointed.

> Here's a patch against 2.6.22-rc7: would you, Stas, put your
> Signed-off-by into this, and accept authorship - although I'm
> sending this back to you, it's very much your idea, and only
> trivially modified from your three-year-old patch by me.  If
> you're agreeable, I can then forward it or its shmem_zero_fault
> equivalent to Andrew when we see which way 2.6.23 is going.
OK, no problems. Except that I've already forgotten the
details, and pretty much lost the need for that patch.
So let's assume the authorship is yours. :)

> Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Stas Sergeev <stsp@aknet.ru>


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


