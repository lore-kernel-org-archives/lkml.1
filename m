Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXCTP4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXCTP4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 11:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXCTP4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 11:56:30 -0400
Received: from amsfep20-int.chello.nl ([62.179.120.15]:48303 "EHLO
	amsfep20-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbXCTP43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 11:56:29 -0400
Subject: Re: [PATCH 2.6.21-rc3-mm2 3/4] futex_requeue_pi optimization
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: mingo@elte.hu, drepper@redhat.com, linux-kernel@vger.kernel.org,
       Jean-Pierre Dion <jean-pierre.dion@bull.net>
In-Reply-To: <45FFFE72.6000300@bull.net>
References: <20070313095203.154246923@bull.net>
	 <20070313095548.003786249@bull.net> <1174040046.7124.27.camel@twins>
	 <45FFFE72.6000300@bull.net>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Mar 2007 16:55:34 +0100
Message-Id: <1174406134.16478.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 16:32 +0100, Pierre Peiffer wrote:
> Peter Zijlstra a écrit :
> >> +static void *get_futex_address(union futex_key *key)
> >> +{
> >> +	void *uaddr;
> >> +
> >> +	if (key->both.offset & 1) {
> >> +		/* shared mapping */
> >> +		uaddr = (void*)((key->shared.pgoff << PAGE_SHIFT)
> >> +				+ key->shared.offset - 1);
> >> +	} else {
> >> +		/* private mapping */
> >> +		uaddr = (void*)(key->private.address + key->private.offset);
> >> +	}
> >> +
> >> +	return uaddr;
> >> +}
> > 
> > This will not work for nonlinear vmas, granted, not a lot of ppl stick
> > futexes in nonlinear vmas, but the futex_key stuff handles it, this
> > doesn't.
> 
> Indeed ! Thanks for pointing me to this.
> 
> Since I'm not familiar with vmm, does this code look more correct to you ?

Unfortunately not, nonlinear vmas don't have a linear relation between
address and offset. What you would need to do is do a linear walk of the
page tables. But even that might not suffice if nonlinear vmas may form
a non-injective, surjective mapping.

/me checks..

Hmm, yes that seems valid, so in general, this reverse mapping does not
uniquely exist for non-linear vmas. :-(

What to do... disallow futexes in nonlinear mappings, store the address
in the key?

> static void *get_futex_address(union futex_key *key)
> {
> 	void *uaddr;
> 	struct vm_area_struct *vma = current->mm->mmap;
> 
> 	if (key->both.offset & 1) {
> 		/* shared mapping */
> 		struct file * vmf;
> 
> 		do {
> 			if ((vmf = vma->vm_file)
> 			    && (key->shared.inode == vmf->f_dentry->d_inode))
> 				break;
> 			vma = vma->vm_next;
> 		} while (vma);
> 
> 		if (likely(!(vma->vm_flags & VM_NONLINEAR)))
> 			uaddr = (void*)((key->shared.pgoff << PAGE_SHIFT)
> 					+ key->shared.offset - 1);
> 		else
> 			uaddr = (void*) vma->vm_start
> 				+ ((key->shared.pgoff - vma->vm_pgoff)
> 				   << PAGE_SHIFT)
> 				+ key->shared.offset - 1;
> 	} else {
> 		/* private mapping */
> 		uaddr = (void*)(key->private.address + key->private.offset);
> 	}
> 
> 	return uaddr;
> }
> 
> Or is there a more direct way to retrieve the vma corresponding to the given inode ?

the vma_prio_tree would be able to give all vmas associated with a
mapping.

