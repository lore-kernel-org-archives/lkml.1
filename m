Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYAOTDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYAOTDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYAOTC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:02:56 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:52952 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYAOTCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:02:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aJlfyb9ewp4KW6F4snb9dKozXQODKmobyIrL1Mt9y0TZWhLy5gQ9m424SbI4RXwwWhdICUZ5nnWHXATlc/vy/Z3sEuy35e0YNff5ap+d6WaY0W3cEutYGcJgpM7reCqrkYxnrQGNZFyRoWmeVWYtkVSe2I0xRA71e6fANf2cXFU=
Message-ID: <4df4ef0c0801151102l4d72b6b5j702e21beb1ebe459@mail.gmail.com>
Date: Tue, 15 Jan 2008 22:02:54 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 1/2] Massive code cleanup of sys_msync()
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu
In-Reply-To: <20080115175705.GA21557@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	 <12004129734126-git-send-email-salikhmetov@gmail.com>
	 <20080115175705.GA21557@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/15, Christoph Hellwig <hch@infradead.org>:
> On Tue, Jan 15, 2008 at 07:02:44PM +0300, Anton Salikhmetov wrote:
> > +++ b/mm/msync.c
> > @@ -1,24 +1,25 @@
> >  /*
> >   *   linux/mm/msync.c
> >   *
> > + * The msync() system call.
> >   * Copyright (C) 1994-1999  Linus Torvalds
> > + *
> > + * Massive code cleanup.
> > + * Copyright (C) 2008 Anton Salikhmetov <salikhmetov@gmail.com>
>
> Please don't put the changelog in here, that's what the log in the SCM
> is for.  And while you're at it remove the confusing file name comment.
> This should now look something like:
>
> /*
>  * The msync() system call.
>  *
>  * Copyright (C) 1994-1999  Linus Torvalds
>  * Copyright (C) 2008 Anton Salikhmetov <salikhmetov@gmail.com>
>  */

Thanks!

I'll take into account your recommendation.

>
> > @@ -33,71 +34,65 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
> >       unsigned long end;
> >       struct mm_struct *mm = current->mm;
> >       struct vm_area_struct *vma;
> > -     int unmapped_error = 0;
> > -     int error = -EINVAL;
> > +     int error = 0, unmapped_error = 0;
> >
> >       if (flags & ~(MS_ASYNC | MS_INVALIDATE | MS_SYNC))
> > -             goto out;
> > +             return -EINVAL;
> >       if (start & ~PAGE_MASK)
> > -             goto out;
> > +             return -EINVAL;
>
> The goto out for a simple return style is used quite commonly in kernel
> code to have a single return statement which makes code maintaince, e.g.
> adding locks or allocations simpler.  Not sure that getting rid of it
> makes a lot of sense.

Sorry, I can't agree. That's what is written in the CodingStyle document:

The goto statement comes in handy when a function exits from multiple
locations and some common work such as cleanup has to be done.

The second part of requirement does not hold true for the sys_msync() routine.

>
> > +             file = vma->vm_file;
> > +             if ((flags & MS_SYNC) && file && (vma->vm_flags & VM_SHARED)) {
>
> Given that file is assigned just above it would be more readable to test
> it first.

The second part of my solution changes this code, anyway.

>
> > +                     if (error)
> > +                             return error;
>
> This should be an goto out, returns out of the middle of the function
> make reading and maintaining the code not so nice.

Sorry, I don't think so. No "common cleanup" is needed here.

>
> >       return error ? : unmapped_error;
>
> Care to get rid of this odd GNU extension while you're at it and use
> the proper

I do also think that this GNU extension is not readable,
so I'll take your recommentation into account.

>
>         return error ? error : unmapped_error;
>
> ?
>
>
