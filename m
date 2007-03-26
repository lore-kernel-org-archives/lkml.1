Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbXCZJVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbXCZJVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbXCZJVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:21:06 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:37086 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933766AbXCZJVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:21:05 -0400
To: akpm@linux-foundation.org
CC: dgc@sgi.com, linux-kernel@vger.kernel.org
In-reply-to: <20070326010124.b4513ce2.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 26 Mar 2007 01:01:24 -0800)
Subject: Re: [patch 1/3] fix illogical behavior in balance_dirty_pages()
References: <E1HVECv-0006bU-00@dorka.pomaz.szeredi.hu>
	<20070325153508.10922ebd.akpm@linux-foundation.org>
	<E1HVkWw-0000yj-00@dorka.pomaz.szeredi.hu> <20070326010124.b4513ce2.akpm@linux-foundation.org>
Message-Id: <E1HVlN5-00016C-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 26 Mar 2007 11:20:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > It also makes a deadlock possible when one filesystem is writing data
> > > > through another, and the balance_dirty_pages() for the lower
> > > > filesystem is stalling the writeback for the upper filesystem's
> > > > data (*).
> > > 
> > > I still don't understand this one.  I got lost when belatedly told that
> > > i_mutex had something to do with it.
> > 
> > This deadlock only happens, if there's some bottleneck for writing
> > data to the lower filesystem.   This bottleneck could be 
> > 
> >   - i_mutex, preventing parallel writes to the same inode
> >   - limited number of filesystem threads
> >   - limited request queue length in the upper filesystem
> > 
> > Imagine it this way: balance_dirty_pages() for the lower filesystem is
> > stalling a write() because dirty pages in the upper filesystem are
> > over the limit.  Because there's a bottleneck for writing to the lower
> > filesystem, this is stalling _other_ writes from completing.  So
> > there's no progress in writing back pages from the upper filesystem.
> 
> You mean that someone is stuck in balance_dirty_pages() against the lower
> fs while holding locks which prevent writes into the upper fs from
> succeeding?
> 
> Draw us a picture ;)

Well, not a picture, but a sort of indented call trace:

  [some process, which has a fuse file writably mmaped]
  write fault on upper filesystem
    balance_dirty_pages
      loop...
        submit write requests

  ---------------------------------
  [fuse loopback fs thread 1]
  read request from /dev/fuse
  sys_write
    mutex_lock(i_mutex)
    ...
       copy data to page cache
       balance_dirty_pages
          loop ...
                submit write requests
                write requests completed ...
                dirty still over limit ...
           ... loop forever

  [fuse loopback fs thread 2]
  read request from /dev/fuse
  sys_write
    mute_lock(i_mutex) blocks


The lower filesystem (e.g. ext3) has completed the single write
request that was sent to it, and then it's just looping in
balance_dirty_pages.  The upper (fuse) filesystem has all the dirty
data (over the threshold), either still dirty or waiting in the
request queue as writeback.

Does this help?

Miklos
