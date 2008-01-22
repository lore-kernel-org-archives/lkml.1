Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbYAVBve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbYAVBve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYAVBvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:51:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:29185 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYAVBvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:51:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y7ry+GDnJ6Ng7CgnyLv9cXh4Nz90INFa1MxYA943nulnf1gMI+X5bC/nni4WKcxilnRnCo0pUIJAXtgTCQ+Hb2xll8lgUNfJbIbZvxmqTodAGqGgbgk1aUUVHMRDh9CscyA9NyG6lAsb7cwtUJ6G2GJD1HY6t43+rkTUJoGfJ0o=
Message-ID: <4df4ef0c0801211751w39d7b9e5ne2e8b788051d3e3a@mail.gmail.com>
Date: Tue, 22 Jan 2008 04:51:23 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH -v7 2/2] Update ctime and mtime for memory-mapped files
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, protasnb@gmail.com,
       miklos@szeredi.hu, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <9a8748490801211740r5c764f6ev9c331479f63ef362@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12009619562023-git-send-email-salikhmetov@gmail.com>
	 <12009619584168-git-send-email-salikhmetov@gmail.com>
	 <9a8748490801211740r5c764f6ev9c331479f63ef362@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/22, Jesper Juhl <jesper.juhl@gmail.com>:
> Some very pedantic nitpicking below;
>
> On 22/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=2645#c40
> >
> > Update file times at write references to memory-mapped files.
> > Force file times update at the next write reference after
> > calling the msync() system call with the MS_ASYNC flag.
> >
> > Signed-off-by: Anton Salikhmetov <salikhmetov@gmail.com>
> > ---
> >  mm/memory.c |    6 ++++++
> >  mm/msync.c  |   57 ++++++++++++++++++++++++++++++++++++++++++++-------------
> >  2 files changed, 50 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 6dd1cd8..4b0144b 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1670,6 +1670,9 @@ gotten:
> >  unlock:
> >         pte_unmap_unlock(page_table, ptl);
> >         if (dirty_page) {
> > +               if (vma->vm_file)
> > +                       file_update_time(vma->vm_file);
> > +
> >                 /*
> >                  * Yes, Virginia, this is actually required to prevent a race
> >                  * with clear_page_dirty_for_io() from clearing the page dirty
> > @@ -2343,6 +2346,9 @@ out_unlocked:
> >         if (anon)
> >                 page_cache_release(vmf.page);
> >         else if (dirty_page) {
> > +               if (vma->vm_file)
> > +                       file_update_time(vma->vm_file);
> > +
> >                 set_page_dirty_balance(dirty_page, page_mkwrite);
> >                 put_page(dirty_page);
> >         }
> > diff --git a/mm/msync.c b/mm/msync.c
> > index a4de868..394130d 100644
> > --- a/mm/msync.c
> > +++ b/mm/msync.c
> > @@ -5,6 +5,7 @@
> >   * Copyright (C) 2008 Anton Salikhmetov <salikhmetov@gmail.com>
> >   */
> >
> > +#include <asm/tlbflush.h>
> >  #include <linux/file.h>
> >  #include <linux/fs.h>
> >  #include <linux/mm.h>
> > @@ -13,11 +14,37 @@
> >  #include <linux/syscalls.h>
> >
> >  /*
> > + * Scan the PTEs for pages belonging to the VMA and mark them read-only.
> > + * It will force a pagefault on the next write access.
> > + */
> > +static void vma_wrprotect(struct vm_area_struct *vma)
> > +{
> > +       unsigned long addr;
> > +
> > +       for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
>
> I know it's not the common "Linux Kernel way", but 'addr' could be
> made to have just 'for' scope here according to C99;

I believe that the C89 style is more common for the Linux kernel, so
I've used the out-of-scope variable declaration.

>
>        for (unsigned long addr = vma->vm_start; addr < vma->vm_end;
> addr += PAGE_SIZE) {
>
>
> > +               spinlock_t *ptl;
> > +               pgd_t *pgd = pgd_offset(vma->vm_mm, addr);
> > +               pud_t *pud = pud_offset(pgd, addr);
> > +               pmd_t *pmd = pmd_offset(pud, addr);
> > +               pte_t *pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> > +
> > +               if (pte_dirty(*pte) && pte_write(*pte)) {
> > +                       pte_t entry = ptep_clear_flush(vma, addr, pte);
> > +
> > +                       entry = pte_wrprotect(entry);
> > +                       set_pte_at(vma->vm_mm, addr, pte, entry);
> > +               }
> > +               pte_unmap_unlock(pte, ptl);
> > +       }
> > +}
> > +
> > +/*
> >   * MS_SYNC syncs the entire file - including mappings.
> >   *
> > - * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
> > - * Nor does it mark the relevant pages dirty (it used to up to 2.6.17).
> > - * Now it doesn't do anything, since dirty pages are properly tracked.
>
> I think keeping some version of the "up to ..." comments makes sense.
> It documents that we previously had different behaviour.

Earlier I had a request to remove any "changelog-style" comments from the code.

>
> > + * MS_ASYNC does not start I/O. Instead, it marks the relevant pages
> > + * read-only by calling vma_wrprotect(). This is needed to catch the next
> > + * write reference to the mapped region and update the file times
> > + * accordingly.
> >   *
> >   * The application may now run fsync() to write out the dirty pages and
> >   * wait on the writeout and check the result. Or the application may run
> > @@ -77,16 +104,20 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
> >                 error = 0;
> >                 start = vma->vm_end;
> >                 file = vma->vm_file;
> > -               if (file && (vma->vm_flags & VM_SHARED) && (flags & MS_SYNC)) {
> > -                       get_file(file);
> > -                       up_read(&mm->mmap_sem);
> > -                       error = do_fsync(file, 0);
> > -                       fput(file);
> > -                       if (error || start >= end)
> > -                               goto out;
> > -                       down_read(&mm->mmap_sem);
> > -                       vma = find_vma(mm, start);
> > -                       continue;
> > +               if (file && (vma->vm_flags & VM_SHARED)) {
> > +                       if (flags & MS_ASYNC)
> > +                               vma_wrprotect(vma);
> > +                       if (flags & MS_SYNC) {
>
> "else if" ??

The MS_ASYNC and MS_SYNC flags are mutually exclusive, that is why I
did not use the "else-if" here. Moreover, this function itself checks
that they never come together.

>
> > +                               get_file(file);
> > +                               up_read(&mm->mmap_sem);
> > +                               error = do_fsync(file, 0);
> > +                               fput(file);
> > +                               if (error || start >= end)
> > +                                       goto out;
> > +                               down_read(&mm->mmap_sem);
> > +                               vma = find_vma(mm, start);
> > +                               continue;
> > +                       }
> >                 }
> >
> >                 vma = vma->vm_next;
>
> --
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
>
