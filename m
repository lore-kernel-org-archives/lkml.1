Return-Path: <linux-kernel-owner+w=401wt.eu-S933775AbXCZJs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775AbXCZJs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933784AbXCZJs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:48:29 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45463 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933775AbXCZJs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:48:28 -0400
To: akpm@linux-foundation.org
CC: miklos@szeredi.hu, dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <20070326013226.786e5b4e.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 26 Mar 2007 01:32:26 -0800)
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<20070325153508.10922ebd.akpm@linux-foundation.org>
	<E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu>
	<20070326010124.b4513ce2.akpm@linux-foundation.org>
	<E1HVlN5-00016C-00@dorka.pomaz.szeredi.hu> <20070326013226.786e5b4e.akpm@linux-foundation.org>
Message-Id: <E1HVlo5-0001AS-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Mar 2007 11:48:05 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, not a picture, but a sort of indented call trace:
> > 
> >   [some process, which has a fuse file writably mmaped]
> >   write fault on upper filesystem
> >     balance_dirty_pages
> >       loop...
> >         submit write requests
> 
> This, I assume, is the upper fs
> 
> >   ---------------------------------
> >   [fuse loopback fs thread 1]
> >   read request from /dev/fuse
> >   sys_write
> >     mutex_lock(i_mutex)
> >     ...
> >        copy data to page cache
> >        balance_dirty_pages
> >           loop ...
> >                 submit write requests
> >                 write requests completed ...
> >                 dirty still over limit ...
> >            ... loop forever
> > 
> >   [fuse loopback fs thread 2]
> >   read request from /dev/fuse
> >   sys_write
> >     mute_lock(i_mutex) blocks
> 
> And these, I assume, are handling what you term the lower fs.

All of this is actually the upper, fuse filesystem (maybe except the
filemap/page-writeback parts, which could be argued to belong to the
lower, ext3 filesystem).

Above the line is the kernel part, below the line is the userspace
part.

> > The lower filesystem (e.g. ext3) has completed the single write
> > request that was sent to it, and then it's just looping in
> > balance_dirty_pages.  The upper (fuse) filesystem has all the dirty
> > data (over the threshold), either still dirty or waiting in the
> > request queue as writeback.
> > 
> > Does this help?
> 
> yup.
> 
> Interesting problem.  I don't suppose that it'd be appreiated if I were to
> commend the use of O_DIRECT for handling the lower fs ;)

Not really ;)  One of the goals of fuse is to not restrict the
filesystem daemon in any way.  There are zillions of ways to work
around this deadlock, but I don't even want to make it even
theoretically possible.

> Let me think about that a bit, after I've made the latest shitpile people
> have inflicted upon me begin to look like it has a chance of compiling.

OK.

Thanks,
Miklos
