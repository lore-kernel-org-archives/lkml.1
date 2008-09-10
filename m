Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbYIJPAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbYIJPAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYIJPAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:00:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36442 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbYIJPAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:00:30 -0400
Date: Wed, 10 Sep 2008 10:00:19 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v4][PATCH 5/9] Memory managemnet (restore)
Message-ID: <20080910150019.GA17478@us.ibm.com>
References: <1220946154-15174-1-git-send-email-orenl@cs.columbia.edu> <1220946154-15174-6-git-send-email-orenl@cs.columbia.edu> <20080909160724.GA23397@us.ibm.com> <48C7082A.1050608@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C7082A.1050608@cs.columbia.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> 
> Serge E. Hallyn wrote:
> > Quoting Oren Laadan (orenl@cs.columbia.edu):
> 
> [...]
> 
> >> +/* change the protection of an address range to be writable/non-writable.
> >> + * this is useful when restoring the memory of a read-only vma */
> >> +static int cr_vma_set_writable(struct mm_struct *mm, unsigned long start,
> >> +			       unsigned long end, int writable)
> >> +{
> >> +	struct vm_area_struct *vma, *prev;
> >> +	unsigned long flags = 0;
> >> +	int ret = -EINVAL;
> >> +
> >> +	cr_debug("vma %#lx-%#lx writable %d\n", start, end, writable);
> >> +
> >> +	down_write(&mm->mmap_sem);
> >> +	vma = find_vma_prev(mm, start, &prev);
> >> +	if (!vma || vma->vm_start > end || vma->vm_end < start)
> >> +		goto out;
> >> +	if (writable && !(vma->vm_flags & VM_WRITE))
> >> +		flags = vma->vm_flags | VM_WRITE;
> >> +	else if (!writable && (vma->vm_flags & VM_WRITE))
> >> +		flags = vma->vm_flags & ~VM_WRITE;
> >> +	cr_debug("flags %#lx\n", flags);
> >> +	if (flags)
> >> +		ret = mprotect_fixup(vma, &prev, vma->vm_start,
> >> +				     vma->vm_end, flags);
> > 
> > As Dave has pointed out, this appears to be a security problem.  I think
> 
> As I replied to Dave, I don't see why this would be a security problem.
> 
> This handles private memory only. In particular, the uncommon case of a
> read-only VMA tha has modified contents. This _cannot_ affect the file
> from which this VMA may have been mapped.
> 
> Shared memory (not file-mapped) will be handled differently: since it is
> always backed up by an inode in shmfs, the restart will populate the
> relevant pages directly. Besides, non-file-mapped shared memory is again
> not a security concern.
> 
> Finally, shared memory that maps to a file is simply _not saved_ at all;
> it is part of the file system, and belongs to the (future) file system
> snapshot capability. Since the contents are always available in the file
> system, we don't need to save it (like we don't save shared libraries).
> 
> That said, it is necessary that the code ensures that the vm_flags that
> belong to a VMA of a private type, e.g. CR_VMA_ANON/CR_VMA_FILE, indeed
> match it (ie, don't have VM_MAY_SHARE/VM_SHARED). I'll add that.

Cool.  That sounds good and I'll look for that in the next version.

There still may be objections about bypassing selinux execmem/execheap
permission checks, but I think that's ok for now.  Long-term I expect
we'll want the security_file_mprotect checks there, and selinux users
will have to use a policy where restart is started in a privileged
restart_t domain or somesuch (and eventually transitions back to the
checkpointed selinux type if possible).

thanks,
-serge

> > what you need to do is create a new helper mprotect_fixup_withchecks(),
> > which does all the DAC+MAC checks which are done in the sys_mprotect()
> > loop starting with "for (nstart = start ; ; ) {...  Otherwise an
> > unprivileged user can create a checkpoint image of a program which has
> > done a ro shared file mmap, edit the checkpoint, then restart it and (i
> > assume) cause the modified contents to be written to the file.  This
> > could violate both DAC checks and selinux checks.
> > 
> > So create that helper which does the security checks, and use it
> > both here and in the sys_mprotect() loop, please.
> > 
> 
> [...]
> 
> Oren.
