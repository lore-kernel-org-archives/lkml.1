Return-Path: <linux-kernel-owner+w=401wt.eu-S1945949AbXBVHtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945949AbXBVHtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945946AbXBVHtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:49:49 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:39387 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbXBVHtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:49:49 -0500
To: akpm@linux-foundation.org
CC: staubach@redhat.com, hugh@veritas.com, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-reply-to: <20070221202615.a0a167f4.akpm@linux-foundation.org> (message from
	Andrew Morton on Wed, 21 Feb 2007 20:26:15 -0800)
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu> <20070221202615.a0a167f4.akpm@linux-foundation.org>
Message-Id: <E1HK8hU-0005Mq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Feb 2007 08:49:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 21 Feb 2007 18:51:52 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > This patch makes writing to shared memory mappings update st_ctime and
> > st_mtime as defined by SUSv3:
> > 
> >    The st_ctime and st_mtime fields of a file that is mapped with
> >    MAP_SHARED and PROT_WRITE shall be marked for update at some point
> >    in the interval between a write reference to the mapped region and
> >    the next call to msync() with MS_ASYNC or MS_SYNC for that portion
> >    of the file by any process. If there is no such call and if the
> >    underlying file is modified as a result of a write reference, then
> >    these fields shall be marked for update at some time after the
> >    write reference.
> > 
> > A new address_space flag is introduced: AS_CMTIME.  This is set each
> > time a page is dirtied through a userspace memory mapping.  This
> > includes write accesses via get_user_pages().
> > 
> > Note, the flag is set unconditionally, even if the page is already
> > dirty.  This is important, because the page might have been dirtied
> > earlier by a non-mmap write.
> > 
> > This flag is checked in msync() and __fput(), and if set, the file
> > times are updated and the flag is cleared
> > 
> > The flag is also cleared, if the time update is triggered by a normal
> > write.  This is not mandated by the standard, but seems to be a sane
> > thing to do.
> 
> Why is the flag checked in __fput()?

It's because of this bit in the standard:

    If there is no such call and if the underlying file is modified
    as a result of a write reference, then these fields shall be
    marked for update at some time after the write reference.

It could be done in munmap/mremap, but it seemed more difficult to
track down all the places where the vma is removed.  But yes, that may
be a nicer solution.

Miklos
