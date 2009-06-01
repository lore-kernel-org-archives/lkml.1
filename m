Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZFAW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZFAW17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZFAW1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:27:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbZFAW1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:27:48 -0400
Date: Mon, 1 Jun 2009 15:25:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       hch@infradead.org, ebiederm@xmission.com, ebiederm@aristanetworks.com
Subject: Re: [PATCH 01/23] mm: Introduce revoke_file_mappings.
Message-Id: <20090601152553.b2de027a.akpm@linux-foundation.org>
In-Reply-To: <1243893048-17031-1-git-send-email-ebiederm@xmission.com>
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-1-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Jun 2009 14:50:26 -0700
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> +static void revoke_vma(struct vm_area_struct *vma)

This looks odd.

> +{
> +	struct file *file = vma->vm_file;
> +	struct address_space *mapping = file->f_mapping;
> +	unsigned long start_addr, end_addr, size;
> +	struct mm_struct *mm;
> +
> +	start_addr = vma->vm_start;
> +	end_addr = vma->vm_end;

We take a copy of start_addr/end_addr (and this end_addr value is never used)

> +	/* Switch out the locks so I can maninuplate this under the mm sem.
> +	 * Needed so I can call vm_ops->close.
> +	 */
> +	mm = vma->vm_mm;
> +	atomic_inc(&mm->mm_users);
> +	spin_unlock(&mapping->i_mmap_lock);
> +
> +	/* Block page faults and other code modifying the mm. */
> +	down_write(&mm->mmap_sem);
> +
> +	/* Lookup a vma for my file address */
> +	vma = find_vma(mm, start_addr);

Then we look up a vma.  Is there reason to believe that this will
differ from the incoming arg which we just overwrote?  Maybe the code
is attempting to handle racing concurrent mmap/munmap activity?  If so,
what are the implications of this?

I _think_ that what the function is attempting to do is "unmap the vma
which covers the address at vma->start_addr".  If so, why not just pass
it that virtual address?

Anyway, it's all a bit obscure and I do think that the semantics and
behaviour should be carefully explained in a comment, no?

> +	if (vma->vm_file != file)
> +		goto out;

This strengthens the theory that some sort of race-management is
happening here.

> +	start_addr = vma->vm_start;
> +	end_addr   = vma->vm_end;
> +	size	   = end_addr - start_addr;
> +
> +	/* Unlock the pages */
> +	if (mm->locked_vm && (vma->vm_flags & VM_LOCKED)) {
> +		mm->locked_vm -= vma_pages(vma);
> +		vma->vm_flags &= ~VM_LOCKED;
> +	}
> +
> +	/* Unmap the vma */
> +	zap_page_range(vma, start_addr, size, NULL);
> +
> +	/* Unlink the vma from the file */
> +	unlink_file_vma(vma);
> +
> +	/* Close the vma */
> +	if (vma->vm_ops && vma->vm_ops->close)
> +		vma->vm_ops->close(vma);
> +	fput(vma->vm_file);
> +	vma->vm_file = NULL;
> +	if (vma->vm_flags & VM_EXECUTABLE)
> +		removed_exe_file_vma(vma->vm_mm);
> +
> +	/* Repurpose the vma  */
> +	vma->vm_private_data = NULL;
> +	vma->vm_ops = &revoked_vm_ops;
> +	vma->vm_flags &= ~(VM_NONLINEAR | VM_CAN_NONLINEAR);
> +out:
> +	up_write(&mm->mmap_sem);
> +	spin_lock(&mapping->i_mmap_lock);
> +}

Also, I'm not a bit fan of the practice of overwriting the value of a
formal argument, especially in a function which is this large and
complex.  It makes the code harder to follow, because the one variable
holds two conceptually different things within the span of the same
function.  And it adds risk that someone will will later access a field
of *vma and it will be the wrong vma.  Worse, the bug is only exposed
under exeedingly rare conditions.

So..  Use a new local, please.


