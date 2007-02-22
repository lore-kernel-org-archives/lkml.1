Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXBVUoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXBVUoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXBVUoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:44:12 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:50615 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXBVUoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:44:11 -0500
To: staubach@redhat.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hugh@veritas.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-reply-to: <45DDF8F3.2020304@redhat.com> (message from Peter Staubach on
	Thu, 22 Feb 2007 15:11:31 -0500)
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu> <45DC8A47.5050900@redhat.com> <E1HJw7l-0003Tq-00@dorka.pomaz.szeredi.hu> <45DC9581.4070909@redhat.com> <E1HJwoe-0003el-00@dorka.pomaz.szeredi.hu> <45DDD498.9050202@redhat.com> <E1HKIUk-0006Sl-00@dorka.pomaz.szeredi.hu> <45DDF8F3.2020304@redhat.com>
Message-Id: <E1HKKmn-0006iw-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Feb 2007 21:43:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Take this example:
> >
> >     fd = open()
> >     addr = mmap(.., fd)
> >     write(fd, ...)
> >     close(fd)
> >     sleep(100)
> >     msync(addr,...)
> >     munmap(addr)
> >
> > The file times will be updated in write(), but with your patch, the
> > bit in the mapping will also be set.
> >
> > Then in msync() the file times will be updated again, which is wrong,
> > since the memory was _not_ modified through the mapping.
> 
> This is correct.  I have updated my proposed patch to include the clearing
> of AS_MCTIME in the routine which updates the mtime field.

That doesn't really help.  Look at __generic_file_aio_write_nolock().
file_update_time() is called before the data is written, so after the
last write, there will be nothing to clear the flag.

And even if fixed this case by moving the file_update_time() call to
the end of the function, there's no guarantee, that some filesystem
won't do something exotic and call set_page_dirty() indenpendently of
write().  Good luck auditing all the set_page_dirty() calls ;)

Thanks,
Miklos
