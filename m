Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbXCZJcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbXCZJcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXCZJci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:32:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50691 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbXCZJci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:32:38 -0400
Date: Mon, 26 Mar 2007 01:32:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
Message-Id: <20070326013226.786e5b4e.akpm@linux-foundation.org>
In-Reply-To: <E1HVlN5-00016C-00@dorka.pomaz.szeredi.hu>
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<20070325153508.10922ebd.akpm@linux-foundation.org>
	<E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu>
	<20070326010124.b4513ce2.akpm@linux-foundation.org>
	<E1HVlN5-00016C-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 11:20:11 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > > > > It also makes a deadlock possible when one filesystem is writing data
> > > > > through another, and the balance_dirty_pages() for the lower
> > > > > filesystem is stalling the writeback for the upper filesystem's
> > > > > data (*).
> > > > 
> > > > I still don't understand this one.  I got lost when belatedly told that
> > > > i_mutex had something to do with it.
> > > 
> > > This deadlock only happens, if there's some bottleneck for writing
> > > data to the lower filesystem.   This bottleneck could be 
> > > 
> > >   - i_mutex, preventing parallel writes to the same inode
> > >   - limited number of filesystem threads
> > >   - limited request queue length in the upper filesystem
> > > 
> > > Imagine it this way: balance_dirty_pages() for the lower filesystem is
> > > stalling a write() because dirty pages in the upper filesystem are
> > > over the limit.  Because there's a bottleneck for writing to the lower
> > > filesystem, this is stalling _other_ writes from completing.  So
> > > there's no progress in writing back pages from the upper filesystem.
> > 
> > You mean that someone is stuck in balance_dirty_pages() against the lower
> > fs while holding locks which prevent writes into the upper fs from
> > succeeding?
> > 
> > Draw us a picture ;)
> 
> Well, not a picture, but a sort of indented call trace:
> 
>   [some process, which has a fuse file writably mmaped]
>   write fault on upper filesystem
>     balance_dirty_pages
>       loop...
>         submit write requests

This, I assume, is the upper fs

>   ---------------------------------
>   [fuse loopback fs thread 1]
>   read request from /dev/fuse
>   sys_write
>     mutex_lock(i_mutex)
>     ...
>        copy data to page cache
>        balance_dirty_pages
>           loop ...
>                 submit write requests
>                 write requests completed ...
>                 dirty still over limit ...
>            ... loop forever
> 
>   [fuse loopback fs thread 2]
>   read request from /dev/fuse
>   sys_write
>     mute_lock(i_mutex) blocks

And these, I assume, are handling what you term the lower fs.

> 
> The lower filesystem (e.g. ext3) has completed the single write
> request that was sent to it, and then it's just looping in
> balance_dirty_pages.  The upper (fuse) filesystem has all the dirty
> data (over the threshold), either still dirty or waiting in the
> request queue as writeback.
> 
> Does this help?

yup.

Interesting problem.  I don't suppose that it'd be appreiated if I were to
commend the use of O_DIRECT for handling the lower fs ;)

Let me think about that a bit, after I've made the latest shitpile people
have inflicted upon me begin to look like it has a chance of compiling.

