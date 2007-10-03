Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXJCQik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXJCQik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbXJCQid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:38:33 -0400
Received: from waste.org ([66.93.16.53]:51138 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbXJCQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:38:32 -0400
Date: Wed, 3 Oct 2007 11:38:04 -0500
From: Matt Mackall <mpm@selenic.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Message-ID: <20071003163804.GR19691@waste.org>
References: <46FC1104.8080105@gmail.com> <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com> <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com> <46FFB412.20202@gmail.com> <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com> <46FFDF64.1080005@gmail.com> <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com> <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com> <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com> <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 05:55:10PM +0200, Torsten Kaiser wrote:
> [CC added to author of the bad patch]
> 
> Short recap:
> Since 2.6.23-rc4-mm1 all mm-kernel randomly fail one of two drives on
> my Silicon Image 3132. This failure happens when my initramfs wants to
> start the RAID that is on these drives.
> 
> The first error libata throws is:
> Oct  3 16:56:46 treogen [   63.320000] ata2.00: exception Emask 0x0
> SAct 0x1 SErr 0x0 action 0x6 frozen
> Oct  3 16:56:46 treogen [   63.320000] ata2.00: cmd
> 61/08:00:09:d6:42/00:00:25:00:00/40 tag 0 cdb 0x0 data 4096 out
> Oct  3 16:56:46 treogen [   63.320000]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Oct  3 16:56:46 treogen [   63.320000] ata2.00: status: {DRDY }
> 
> Resetting the sata link fails, the drive is no longer reachable until a reboot.
> 
> I then bisected the mm-patches from 2.6.23-rc4-mm1 with the following result:
> 
> On 10/3/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > I'm now finished with bisecting, still 2 patches, but I don't want to
> > spend another two hours waiting...
> >
> > And the winners are: (from broken-out patchset of 2.6.23-rc4-mm1)
> > maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
> > maps2-move-clear_refs-code-to-task_mmuc.patch
> >
> > Before these patches I have never seen the bug, with these I only got
> > two good boots when trying to recreate the problem. But even the
> > kernels that did one good boot failed on the second try.
> 
> The simplify-patch just seems to move some code around, but I see a
> real change in the other one:
> This patch removes clear_refs_smap() from fs/proc/task_mmu.c by moving
> its code to a new function. But during the move the main for-loop from
> clear_refs_smap was changed:
> 
> old:
> 	for (vma = mm->mmap; vma; vma = vma->vm_next)
> 		if (vma->vm_mm && !is_vm_hugetlb_page(vma))
> 			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
> 					&clear_refs_walk, vma);
> 
> new:
> 	for (vma = mm->mmap; vma; vma = vma->vm_next)
> 		if (!is_vm_hugetlb_page(vma))
> 			walk_page_range(mm, vma->vm_start, vma->vm_end,
> 					&clear_refs_walk, vma);
> 
> The walk_page_range() is no longer called on vma->vm_mm, but on mm directly.
> I don't know how this can kill the sata_sil24-driver, but at least it
> looks suspicious.

That code should be fine. Further, it's pretty unlikely that this code
ever gets invoked. This whole interface was only recently added by
Google folks and its usage is pretty obscure. 

Oh wait - you're _at_ Google, aren't you? Perhaps you're actually
using clear_refs.

Well I can see no reason why the vma we just got to by the mm->mmap
would have a vm_mm != mm, but I've certainly been wrong before.

Try changing it to:

 	for (vma = mm->mmap; vma; vma = vma->vm_next)
 		if (!is_vm_hugetlb_page(vma)) {
			if (vma->vm_mm != mm)
				printk("WTF: vma->vm_mm %p mm %p\n",
					vma->vm_mm, mm);
 			walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
 					&clear_refs_walk, vma);
	}

-- 
Mathematics is the supreme nostalgia of our time.
