Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbXBVSRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbXBVSRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 13:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXBVSRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 13:17:20 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:45970 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXBVSRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 13:17:19 -0500
To: staubach@redhat.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hugh@veritas.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-reply-to: <45DDD498.9050202@redhat.com> (message from Peter Staubach on
	Thu, 22 Feb 2007 12:36:24 -0500)
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu> <45DC8A47.5050900@redhat.com> <E1HJw7l-0003Tq-00@dorka.pomaz.szeredi.hu> <45DC9581.4070909@redhat.com> <E1HJwoe-0003el-00@dorka.pomaz.szeredi.hu> <45DDD498.9050202@redhat.com>
Message-Id: <E1HKIUk-0006Sl-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Feb 2007 19:16:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> +int set_page_dirty_mapping(struct page *page);
> >>>>>   
> >>>>>       
> >>>>>           
> >>>> This aspect of the design seems intrusive to me.  I didn't see a strong
> >>>> reason to introduce new versions of many of the routines just to handle
> >>>> these semantics.  What motivated this part of your design?  Why the new
> >>>> _mapping versions of routines?
> >>>>     
> >>>>         
> >>> Because there's no way to know inside the set_page_dirty() functions
> >>> if the dirtying comes from a memory mapping or from a modification
> >>> through a normal write().  And they have different semantics, for
> >>> write() the modification times are updated immediately.
> >>>       
> >> Perhaps I didn't understand what page_mapped() does, but it does seem to
> >> have the right semantics as far as I could see.
> >>     
> >
> > The problems will start, when you have a file that is both mapped and
> > modified with write().  Then the dirying from the write() will set the
> > flag, and that will have undesirable consequences.
> 
> I don't think that I quite follow the logic.  The dirtying from write()
> will set the flag, but then the mtime will get updated and the flag will
> be cleared by the hook in file_update_time().  Right?

Take this example:

    fd = open()
    addr = mmap(.., fd)
    write(fd, ...)
    close(fd)
    sleep(100)
    msync(addr,...)
    munmap(addr)

The file times will be updated in write(), but with your patch, the
bit in the mapping will also be set.

Then in msync() the file times will be updated again, which is wrong,
since the memory was _not_ modified through the mapping.

Thanks,
Miklos
