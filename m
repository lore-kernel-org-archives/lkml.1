Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXB1UgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXB1UgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXB1UgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:36:04 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45472 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbXB1UgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:36:01 -0500
To: staubach@redhat.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <45E5DF8E.80109@redhat.com> (message from Peter Staubach on Wed,
	28 Feb 2007 15:01:18 -0500)
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com> <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu> <45E5BA2E.8060003@redhat.com> <E1HMSy2-0008F6-00@dorka.pomaz.szeredi.hu> <45E5DF8E.80109@redhat.com>
Message-Id: <E1HMVWJ-00009K-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Feb 2007 21:35:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> While these entry points do not actually modify the file itself,
> >> as was pointed out, they are handy points at which the kernel gains
> >> control and could actually notice that the contents of the file are
> >> no longer the same as they were, ie. modified.
> >>
> >>  From the operating system viewpoint, this is where the semantics of
> >> modification to file contents via mmap differs from the semantics of
> >> modification to file contents via write(2).
> >>
> >> It is desirable for the file times to be updated as quickly as
> >> possible after the actual modification has occurred.
> >>     
> >
> > I disagree.
> >
> > You don't worry about the timestamp being updated _during_ a large
> > write() call, even though the file is constantly being modified.
> >
> >   
> 
> No, but you do worry about the timestamps being updated after
> every write() call, no matter how large or small.

Right.  All I'm saying is that just writing to a shared mapping
without calling msync() is similar to a write() which hasn't yet
finished.  In both cases, you have a modified file, without a modified
timestamp.

> > You think of write() as something instantaneous, while you think of
> > writing to a shared mapping, then doing msync() as something taking a
> > long time.  In actual fact both of these are basically equivalent
> > operations, the differences being, that you can easily modify
> > non-contiguous parts of a file with mmap, while you can't do that with
> > write.  The disadvantage from mmap comes from the cost of setting up
> > the page tables and handling the faults.
> >
> > Think of it this way:
> >
> >   shared mmap write + msync(MS_ASYNC)  ==  write()
> >   msync(MS_ASYNC) + fsync()  ==  msync(MS_SYNC)
> >
> >   
> 
> I don't believe that this is a valid characterization because the
> changes to the contents of the file, made through the mmap'd region,
> are immediately visible to any and all other applications accessing
> the file.  Since the contents of the file are changing, then so
> should the timestamps to reflect this.

Same case with a large write().  Nothing prevents you from reading a
file, while a huge write is taking place to it, and yet, the
modification time isn't updated.

> I think that we are going to have to agree to disagree because
> I don't agree either with your characterizations of the desirable
> semantics associated with shared mmap or that maintaining the
> correctness in the system is a waste of CPU.

I didn't quite say _that_ in so many words :).  I said that updating
the timestamp on a per-page first dirtying base, or per-inode first
dirtying base is a waste of effort.  Why?

What happens if the application overwrites what it had written some
time later?  Nothing.  The page is already read-write, the pte dirty,
so even though the file was clearly modified, there's absolutely no
way in which this can be used to force an update to the timestamp.

Is there anything special about the _first_ modification?  I don't
think so.  From an external application's point of view it doesn't
matter one whit, whether a modification was through write() or after a
page-fault, or on an already present read-write page.

So what exactly _are_ the semantics we are trying to achieve?

> I view mmap as a way for an application to treat the contents of a
> file as another segment in its address space.  This allows it to
> manipulate the contents of a file without incurring the overhead of
> the read and write system calls and the double buffering that
> naturally occurs with those system calls.  I think that:
> 
>     char *p = mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>     *p = 1;
>     *(p + 4096) = 2;
> 
> should have the same effect as:
> 
>     char c = 1;
>     pwrite(fd, &c, 1, 0);
>     c = 2;
>     pwrite(fd, &c, 1, 4096);

Not necessarily.  This is the equivalent _portable_ call sequence:

     char *p = mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
     *p = 1;
     *(p + 4096) = 2;
     msync(p, 4097, MS_ASYNC);

Yes, on linux the prior would work too, but there's really no point in
allowing applications to be lax and not do it properly.  But we've
been over this.

Miklos
