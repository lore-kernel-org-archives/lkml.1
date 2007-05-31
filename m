Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbXEaHfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbXEaHfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbXEaHf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:35:26 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42086 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbXEaHfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:35:25 -0400
Date: Thu, 31 May 2007 09:35:23 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-Id: <20070531093523.a6a62833.dada1@cosmosbay.com>
In-Reply-To: <20070531061303.GA4436@elte.hu>
References: <465CA654.5000505@garzik.org>
	<20070530072055.GA3077@elte.hu>
	<465D286E.2080807@redhat.com>
	<20070530084252.GA15708@elte.hu>
	<Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
	<alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
	<465DE992.6070803@redhat.com>
	<alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
	<Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com>
	<alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org>
	<20070531061303.GA4436@elte.hu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 08:13:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > I agree. What would be a good interface to allocate fds in such 
> > > area? We don't want to replicate syscalls, so maybe a special new 
> > > dup function?
> > 
> > I'd do it with something like "newfd = dup2(fd, NONLINEAR_FD)" or 
> > similar, and just have NONLINEAR_FD be some magic value (for example, 
> > make it be 0x40000000 - the bit that says "private, nonlinear" in the 
> > first place).
> > 
> > But what's gotten lost in the current discussion is that we probably 
> > don't actually _need_ such a private space. I'm just saying that if 
> > the *choice* is between memory-mapped interfaces and a private 
> > fd-space, we should probably go for the latter. "Everything is a file" 
> > is the UNIX way, after all. But there's little reason to introduce 
> > private fd's otherwise.
> 
> it's both a flexibility and a speedup thing as well:
> 
> flexibility: for libraries to be able to open files and keep them open 
> comes up regularly. For example currently glibc is quite wasteful in a 
> number of common networking related functions (Ulrich, please correct me 
> if i'm wrong), which could be optimized if glibc could just keep a 
> netlink channel fd open and could poll() it for changes and cache the 
> results if there are no changes (or something like that).
> 
> speedup: i suggested O_ANY 6 years ago as a speedup to Apache - 
> non-linear fds are cheaper to allocate/map:
> 
>   http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg23820.html
> 
> (i definitely remember having written code for that too, but i cannot 
> find that in the archives. hm.) In theory we could avoid _all_ fd-bitmap 
> overhead as well and use a per-process list/pool of struct file buffers 
> plus a maximum-fd field as the 'non-linear fd allocator' (at the price 
> of only deallocating them at process exit time).

Only very few apps need to open more than 100.000 files.

As these files are likely sockets, O_ANY is not a solution.

A trick is to try to keep first 64 handles freed, so that kernel wont consume
too much cpu time and cache in get_unused_fd()

http://lkml.org/lkml/2005/9/15/307

This trick is portable (not linux centric).

