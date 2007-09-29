Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbXI2UA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbXI2UA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXI2UAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:00:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbXI2UAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:00:14 -0400
Date: Sat, 29 Sep 2007 13:00:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Write-back from inside FS - need suggestions
Message-Id: <20070929130011.c3a11139.akpm@linux-foundation.org>
In-Reply-To: <46FEA332.9090904@yandex.ru>
References: <46FCC686.3050009@yandex.ru>
	<46FE2167.8000800@yandex.ru>
	<20070929033939.6ee65e19.akpm@linux-foundation.org>
	<46FEA332.9090904@yandex.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 22:10:42 +0300 Artem Bityutskiy <dedekind@yandex.ru> wrote:

> Andrew Morton wrote:
> > I'd have thought that a suitable wrapper around a suitably-modified
> > sync_sb_inodes() would be appropriate for both filesystems?
> 
> Ok, I've modified sync_inodes_sb() so that I can pass it my own wbc,
> where I set wcb->nr_to_write = 20. It gives me _exactly_ what I want.
> It just flushes a bit more then 20 pages and returns. I use
> WB_SYNC_ALL. Great!

ok..

> Now I would like to understand why it works :-) To my surprise, it
> does not deadlock! I call it from ->prepare_write where I'm holding
> i_mutex, and it works just fine. It calls ->writepage() without trying
> to lock i_mutex! This looks like some witchcraft for me.

writepage under i_mutex is commonly done on the
sys_write->alloc_pages->direct-reclaim path.  It absolutely has to work,
and you'll be fine relying upon that.

However ->prepare_write() is called with the page locked, so you are
vulnerable to deadlocks there.  I suspect you got lucky because the page
which you're holding the lock on is not dirty in your testing.  But in
other applications (eg: 1k blocksize ext2/3/4) the page _can_ be dirty
while we're trying to allocate more blocks for it, in which case the
lock_page() deadlock can happen.

One approach might be to add another flag to writeback_control telling
write_cache_pages() to skip locked pages.  Or even put a page* into
wrietback_control and change it to skip *this* page.

> This means that if I'm in the middle of an operation or ino #X, I own
> its i_mutex, but not I_LOCK, I can be preempted and ->writepage can
> be called for a dirty page belonging to this inode #X?

yup.  Or another CPU can do the same.

> I haven't seen
> this in practice and I do not believe this may happen. Why?

Perhaps a heavier workload is needed.

There is code in the VFS which tries to prevent lots of CPUs from getting
in and fighting with each other (see writeback_acquire()) which will have
the effect of serialising things for some extent.  But writeback_acquire()
is causing scalability problems on monster IO systems and might be removed,
and it is only a partial thing - there are other ways in which concurrent
writeout can occur (fsync, sync, page reclaim, ...)

> Could you or someone please give me a hint what exactly
> inode->i_flags & I_LOCK protects?

err, it's basically an open-coded mutex via which one thread can get
exclusive access to some parts of an inode's internals.  Perhaps it could
literally be replaced with a mutex.  Exactly what I_LOCK protects has not
been documented afaik.  That would need to be reverse engineered :(

> What is its relationship to i_mutex?

On a regular file i_mutex is used mainly for protection of the data part of
the file, although it gets borrowed for other things, like protecting f_pos
of all the inode's file*'s.  I_LOCK is used to serialise access to a few
parts of the inode itself.

