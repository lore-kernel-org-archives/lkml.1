Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXFLGWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXFLGWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 02:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbXFLGWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 02:22:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47778 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbXFLGWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 02:22:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adam Litke <agl@us.ibm.com>
Cc: dean gaudet <dean@arctic.org>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, clameter@sgi.com
Subject: Re: [shm][hugetlb] Fix get_policy for stacked shared memory files
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org>
	<20070516061259.GZ19966@holomorphy.com>
	<Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
	<1181597696.22671.2.camel@localhost.localdomain>
Date: Tue, 12 Jun 2007 00:20:52 -0600
In-Reply-To: <1181597696.22671.2.camel@localhost.localdomain> (Adam Litke's
	message of "Mon, 11 Jun 2007 16:34:54 -0500")
Message-ID: <m1odjlpubf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke <agl@us.ibm.com> writes:

> Here's another breakage as a result of shared memory stacked files :(
>
> The NUMA policy for a VMA is determined by checking the following (in the order
> given):
>
> 1) vma->vm_ops->get_policy() (if defined)
> 2) vma->vm_policy (if defined)
> 3) task->mempolicy (if defined)
> 4) Fall back to default_policy
>
> By switching to stacked files for shared memory, get_policy() is now always set
> to shm_get_policy which is a wrapper function.  This causes us to stop at step
> 1, which yields NULL for hugetlb instead of task->mempolicy which was the
> previous (and correct) result.
>
> This patch modifies the shm_get_policy() wrapper to maintain steps 1-3 for the
> wrapped vm_ops.  Andi and Christoph, does this look right to you?

I'm confused.

I agree that the behavior you describe is correct.
However I only see two code paths were get_policy is called and
both of them take a NULL result and change it to task->mempolicy:

>From mm/mempolicy.c

> long do_get_mempolicy(int *policy, nodemask_t *nmask,
> 			unsigned long addr, unsigned long flags)
> {
> 	int err;
> 	struct mm_struct *mm = current->mm;
> 	struct vm_area_struct *vma = NULL;
> 	struct mempolicy *pol = current->mempolicy;
> 
> 	cpuset_update_task_memory_state();
> 	if (flags & ~(unsigned long)(MPOL_F_NODE|MPOL_F_ADDR))
> 		return -EINVAL;
> 	if (flags & MPOL_F_ADDR) {
> 		down_read(&mm->mmap_sem);
> 		vma = find_vma_intersection(mm, addr, addr+1);
> 		if (!vma) {
> 			up_read(&mm->mmap_sem);
> 			return -EFAULT;
> 		}
> 		if (vma->vm_ops && vma->vm_ops->get_policy)
> 			pol = vma->vm_ops->get_policy(vma, addr);
> 		else
> 			pol = vma->vm_policy;
> 	} else if (addr)
> 		return -EINVAL;
> 
> 	if (!pol)
> 		pol = &default_policy;



> /* Return effective policy for a VMA */
> static struct mempolicy * get_vma_policy(struct task_struct *task,
> 		struct vm_area_struct *vma, unsigned long addr)
> {
> 	struct mempolicy *pol = task->mempolicy;
> 
> 	if (vma) {
> 		if (vma->vm_ops && vma->vm_ops->get_policy)
> 			pol = vma->vm_ops->get_policy(vma, addr);
> 		else if (vma->vm_policy &&
> 				vma->vm_policy->policy != MPOL_DEFAULT)
> 			pol = vma->vm_policy;
> 	}
> 	if (!pol)
> 		pol = &default_policy;
> 	return pol;
> }


Does this perhaps need to be:
> Signed-off-by: Adam Litke <agl@us.ibm.com>
>
> diff --git a/ipc/shm.c b/ipc/shm.c
> index 4fefbad..8d2672d 100644
> --- a/ipc/shm.c
> +++ b/ipc/shm.c
> @@ -254,8 +254,10 @@ struct mempolicy *shm_get_policy(struct vm_area_struct
> *vma, unsigned long addr)

+	pol = NULL;
>  
>  	if (sfd->vm_ops->get_policy)
>  		pol = sfd->vm_ops->get_policy(vma, addr);
> -	else
> +	else if (vma->vm_policy && vma->vm_policy->policy != MPOL_DEFAULT)
>  		pol = vma->vm_policy;
>  	return pol;
>  }
>  #endif

Sorry I'm just a little dense at the moment.

Eric

