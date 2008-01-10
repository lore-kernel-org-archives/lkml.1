Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbYAJAkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbYAJAkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYAJAkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:40:09 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:28775 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbYAJAkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IE6P0blKU3v48EMBNQW8Fjd+E7bY9mPx5WnKt5feXTa57Tcwbftdyh0uh+sdRlLWz/QqCi0S1oX1y5xOW9WPt9bezmiDV6Tuhm4Th/8eDz+QFLThp5y/U6m8QZsdmEHledcckX9izvF7IsiC0qi5ki4PUt9ufXHwhUO02SbMe9s=
Message-ID: <4df4ef0c0801091640g2404c217rd7d48022e13be73b@mail.gmail.com>
Date: Thu, 10 Jan 2008 03:40:06 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080109155015.4d2d4c1d@cuia.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199728459.26463.11.camel@codedot>
	 <20080109155015.4d2d4c1d@cuia.boston.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/9, Rik van Riel <riel@redhat.com>:
> On Mon, 07 Jan 2008 20:54:19 +0300
> Anton Salikhmetov <salikhmetov@gmail.com> wrote:
>
> > This program showed that the msync() function had a bug:
> > it did not update the st_mtime and st_ctime fields.
> >
> > The program shows appropriate behavior of the msync()
> > function using the kernel with the proposed patch applied.
> > Specifically, the ctime and mtime time stamps do change
> > when modifying the mapped memory and do not change when
> > there have been no write references between the mmap()
> > and msync() system calls.
>
> As long as the ctime and mtime stamps change when the memory is
> written to, what exactly is the problem?
>
> Is it that the ctime and mtime does not change again when the memory
> is written to again?
>
> Is there a way for backup programs to miss file modification times?
>
> Could you explain (using short words and simple sentences) what the
> exact problem is?
>
> Eg.
>
> 1) program mmaps file
> 2) program writes to mmaped area
> 3) ???                   <=== this part, in equally simple words :)
> 4) data loss
>
> An explanation like that will help people understand exactly what the
> bug is, and why the patch should be applied ASAP.
>
> > The patch adds a call to the file_update_time() function to change
> > the file metadata before syncing. The patch also contains
> > substantial code cleanup: consolidated error check
> > for function parameters, using the PAGE_ALIGN() macro instead of
> > "manual" alignment, improved readability of the loop,
> > which traverses the process memory regions, updated comments.
>
> Due to the various cleanups all being in one file, it took me a while
> to understand the patch.  In an area of code this subtle, it may be
> better to submit the cleanups in (a) separate patch(es) from the patch
> that adds the call to file_update_time().

Now I'm working on my next solution for this bug. It will probably
modify more than one file and be split into several parts.

>
> > -                             (vma->vm_flags & VM_SHARED)) {
> > +             if (file && (vma->vm_flags & VM_SHARED)) {
> >                       get_file(file);
> > -                     up_read(&mm->mmap_sem);
> > -                     error = do_fsync(file, 0);
> > -                     fput(file);
> > -                     if (error || start >= end)
> > -                             goto out;
> > -                     down_read(&mm->mmap_sem);
> > -                     vma = find_vma(mm, start);
> > -             } else {
> > -                     if (start >= end) {
> > -                             error = 0;
> > -                             goto out_unlock;
> > +                     if (file->f_mapping->host->i_state & I_DIRTY_PAGES)
> > +                             file_update_time(file);
>
> I wonder if calling file_update_time() from inside the loop is the
> best idea.  Why not call that function just once, after msync breaks
> from the loop?

That function should be called inside of the loop because the memory
region, which msync() is called with, may contain pages mapped for
different files.

>
> thanks,
>
> Rik
> --
> All Rights Reversed
>
