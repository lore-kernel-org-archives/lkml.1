Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXJCRvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXJCRvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbXJCRvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:51:32 -0400
Received: from waste.org ([66.93.16.53]:45918 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbXJCRvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:51:31 -0400
Date: Wed, 3 Oct 2007 12:51:05 -0500
From: Matt Mackall <mpm@selenic.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Message-ID: <20071003175105.GT19691@waste.org>
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com> <46FFB412.20202@gmail.com> <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com> <46FFDF64.1080005@gmail.com> <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com> <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com> <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com> <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com> <20071003163804.GR19691@waste.org> <64bb37e0710031036q228b63a8nf03d030b7d97b27f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0710031036q228b63a8nf03d030b7d97b27f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 07:36:55PM +0200, Torsten Kaiser wrote:
> On 10/3/07, Matt Mackall <mpm@selenic.com> wrote:
> > On Wed, Oct 03, 2007 at 05:55:10PM +0200, Torsten Kaiser wrote:
> > > This patch removes clear_refs_smap() from fs/proc/task_mmu.c by moving
> > > its code to a new function. But during the move the main for-loop from
> > > clear_refs_smap was changed:
> > >
> > > old:
> > >       for (vma = mm->mmap; vma; vma = vma->vm_next)
> > >               if (vma->vm_mm && !is_vm_hugetlb_page(vma))
> > >                       walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
> > >                                       &clear_refs_walk, vma);
> > >
> > > new:
> > >       for (vma = mm->mmap; vma; vma = vma->vm_next)
> > >               if (!is_vm_hugetlb_page(vma))
> > >                       walk_page_range(mm, vma->vm_start, vma->vm_end,
> > >                                       &clear_refs_walk, vma);
> > >
> > > The walk_page_range() is no longer called on vma->vm_mm, but on mm directly.
> > > I don't know how this can kill the sata_sil24-driver, but at least it
> > > looks suspicious.
> >
> > That code should be fine. Further, it's pretty unlikely that this code
> > ever gets invoked. This whole interface was only recently added by
> > Google folks and its usage is pretty obscure.
> >
> > Oh wait - you're _at_ Google, aren't you? Perhaps you're actually
> > using clear_refs.
> 
> No. I'm just using Google Mail.

Ahh, I see. Wasn't aware of the trademark dispute..

> Of note might be, that at the time of this error init has not been
> started. I'm using a program from initramfs to start the RAID.
> The initramfs was primarily build using the genkernel package from
> gentoo, but I have removed some parts of it (kernel modules and some
> other part I no longer remember)

Then I really don't see how these patches can have anything to do with
your problem. They only affect some currently obscure files in /proc
and it's unlikely to have any impact at init time. It's more likely
that there's some code alignment Heisenbug or you got a false negative
somewhere in your bisection.

-- 
Mathematics is the supreme nostalgia of our time.
