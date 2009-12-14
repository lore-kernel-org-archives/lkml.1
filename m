Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZLNDjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZLNDjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZLNDjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:39:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49845 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZLNDjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:39:22 -0500
Date: Mon, 14 Dec 2009 14:39:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the limits tree with Linus' tree
Message-Id: <20091214143920.df92c810.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the limits tree got a conflict in mm/mremap.c
between commit 54f5de709984bae0d31d823ff03de755f9dcac54 ("untangling
do_mremap(), part 1") from Linus' tree and commit
518b0eb18cb50901611d5365d657e11ff0b4931f ("MM: use helpers for rlimits")
from the limits tree.

The former moved the code changed in the latter.  I fixed it up (see
below) and can carry the fix for a while.  Again, a merge with Linus'
tree will fix this up.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/mremap.c
index 8451908,d6740a1..0000000
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@@ -261,137 -261,6 +261,137 @@@ static unsigned long move_vma(struct vm
  	return new_addr;
  }
  
 +static struct vm_area_struct *vma_to_resize(unsigned long addr,
 +	unsigned long old_len, unsigned long new_len, unsigned long *p)
 +{
 +	struct mm_struct *mm = current->mm;
 +	struct vm_area_struct *vma = find_vma(mm, addr);
 +
 +	if (!vma || vma->vm_start > addr)
 +		goto Efault;
 +
 +	if (is_vm_hugetlb_page(vma))
 +		goto Einval;
 +
 +	/* We can't remap across vm area boundaries */
 +	if (old_len > vma->vm_end - addr)
 +		goto Efault;
 +
 +	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP)) {
 +		if (new_len > old_len)
 +			goto Efault;
 +	}
 +
 +	if (vma->vm_flags & VM_LOCKED) {
 +		unsigned long locked, lock_limit;
 +		locked = mm->locked_vm << PAGE_SHIFT;
- 		lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
++		lock_limit = rlimit(RLIMIT_MEMLOCK);
 +		locked += new_len - old_len;
 +		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
 +			goto Eagain;
 +	}
 +
 +	if (!may_expand_vm(mm, (new_len - old_len) >> PAGE_SHIFT))
 +		goto Enomem;
 +
 +	if (vma->vm_flags & VM_ACCOUNT) {
 +		unsigned long charged = (new_len - old_len) >> PAGE_SHIFT;
 +		if (security_vm_enough_memory(charged))
 +			goto Efault;
 +		*p = charged;
 +	}
 +
 +	return vma;
 +
 +Efault:	/* very odd choice for most of the cases, but... */
 +	return ERR_PTR(-EFAULT);
 +Einval:
 +	return ERR_PTR(-EINVAL);
 +Enomem:
 +	return ERR_PTR(-ENOMEM);
 +Eagain:
 +	return ERR_PTR(-EAGAIN);
 +}
 +
 +static unsigned long mremap_to(unsigned long addr,
 +	unsigned long old_len, unsigned long new_addr,
 +	unsigned long new_len)
 +{
 +	struct mm_struct *mm = current->mm;
 +	struct vm_area_struct *vma;
 +	unsigned long ret = -EINVAL;
 +	unsigned long charged = 0;
 +	unsigned long map_flags;
 +
 +	if (new_addr & ~PAGE_MASK)
 +		goto out;
 +
 +	if (new_len > TASK_SIZE || new_addr > TASK_SIZE - new_len)
 +		goto out;
 +
 +	/* Check if the location we're moving into overlaps the
 +	 * old location at all, and fail if it does.
 +	 */
 +	if ((new_addr <= addr) && (new_addr+new_len) > addr)
 +		goto out;
 +
 +	if ((addr <= new_addr) && (addr+old_len) > new_addr)
 +		goto out;
 +
 +	ret = security_file_mmap(NULL, 0, 0, 0, new_addr, 1);
 +	if (ret)
 +		goto out;
 +
 +	ret = do_munmap(mm, new_addr, new_len);
 +	if (ret)
 +		goto out;
 +
 +	if (old_len >= new_len) {
 +		ret = do_munmap(mm, addr+new_len, old_len - new_len);
 +		if (ret && old_len != new_len)
 +			goto out;
 +		old_len = new_len;
 +	}
 +
 +	vma = vma_to_resize(addr, old_len, new_len, &charged);
 +	if (IS_ERR(vma)) {
 +		ret = PTR_ERR(vma);
 +		goto out;
 +	}
 +
 +	map_flags = MAP_FIXED;
 +	if (vma->vm_flags & VM_MAYSHARE)
 +		map_flags |= MAP_SHARED;
 +
 +	ret = get_unmapped_area(vma->vm_file, new_addr, new_len, vma->vm_pgoff +
 +				((addr - vma->vm_start) >> PAGE_SHIFT),
 +				map_flags);
 +	if (ret & ~PAGE_MASK)
 +		goto out1;
 +
 +	ret = move_vma(vma, addr, old_len, new_len, new_addr);
 +	if (!(ret & ~PAGE_MASK))
 +		goto out;
 +out1:
 +	vm_unacct_memory(charged);
 +
 +out:
 +	return ret;
 +}
 +
 +static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
 +{
 +	unsigned long end = vma->vm_end + delta;
 +	if (end < vma->vm_end) /* overflow */
 +		return 0;
 +	if (vma->vm_next && vma->vm_next->vm_start < end) /* intersection */
 +		return 0;
 +	if (get_unmapped_area(NULL, vma->vm_start, end - vma->vm_start,
 +			      0, MAP_FIXED) & ~PAGE_MASK)
 +		return 0;
 +	return 1;
 +}
 +
  /*
   * Expand (or shrink) an existing mapping, potentially moving it at the
   * same time (controlled by the MREMAP_MAYMOVE flag and available VM space)
