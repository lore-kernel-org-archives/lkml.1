Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbXJCRhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbXJCRhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXJCRg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:36:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:49715 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbXJCRg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fNTVAsnbVr1/oiQhysC48zU25Sh54BT/Ndx+cZqcc+zZAL4j7XfvXkotXmJp9k7Eun2Bma+PUOYdV1RwORGdzWjKbIgRc8piMGxciuWyiaBmdR9lJm0qmz6L8TdjU/caF8nAjSdBJfTSUZFQTQdysThyEYjHv3I4yWjOhppyUmw=
Message-ID: <64bb37e0710031036q228b63a8nf03d030b7d97b27f@mail.gmail.com>
Date: Wed, 3 Oct 2007 19:36:55 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20071003163804.GR19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FC1104.8080105@gmail.com>
	 <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <46FFB412.20202@gmail.com>
	 <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Matt Mackall <mpm@selenic.com> wrote:
> On Wed, Oct 03, 2007 at 05:55:10PM +0200, Torsten Kaiser wrote:
> > This patch removes clear_refs_smap() from fs/proc/task_mmu.c by moving
> > its code to a new function. But during the move the main for-loop from
> > clear_refs_smap was changed:
> >
> > old:
> >       for (vma = mm->mmap; vma; vma = vma->vm_next)
> >               if (vma->vm_mm && !is_vm_hugetlb_page(vma))
> >                       walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
> >                                       &clear_refs_walk, vma);
> >
> > new:
> >       for (vma = mm->mmap; vma; vma = vma->vm_next)
> >               if (!is_vm_hugetlb_page(vma))
> >                       walk_page_range(mm, vma->vm_start, vma->vm_end,
> >                                       &clear_refs_walk, vma);
> >
> > The walk_page_range() is no longer called on vma->vm_mm, but on mm directly.
> > I don't know how this can kill the sata_sil24-driver, but at least it
> > looks suspicious.
>
> That code should be fine. Further, it's pretty unlikely that this code
> ever gets invoked. This whole interface was only recently added by
> Google folks and its usage is pretty obscure.
>
> Oh wait - you're _at_ Google, aren't you? Perhaps you're actually
> using clear_refs.

No. I'm just using Google Mail.

And I'm not using any additional patches apart from what is in the mm-patchset.

> Well I can see no reason why the vma we just got to by the mm->mmap
> would have a vm_mm != mm, but I've certainly been wrong before.
>
> Try changing it to:
>
>         for (vma = mm->mmap; vma; vma = vma->vm_next)
>                 if (!is_vm_hugetlb_page(vma)) {
>                         if (vma->vm_mm != mm)
>                                 printk("WTF: vma->vm_mm %p mm %p\n",
>                                         vma->vm_mm, mm);
>                         walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
>                                         &clear_refs_walk, vma);
>         }

Will try this, but as the error only seems to trigger, if I leave the
pc powered off for more then a hour, you will need to wait until
tomorrow.

Of note might be, that at the time of this error init has not been
started. I'm using a program from initramfs to start the RAID.
The initramfs was primarily build using the genkernel package from
gentoo, but I have removed some parts of it (kernel modules and some
other part I no longer remember)

Torsten
