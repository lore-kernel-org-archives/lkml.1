Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab0CEBjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:39:51 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4365 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0CEBju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:39:50 -0500
Message-ID: <4B9060DE.4080104@gmail.com>
Date: Fri, 05 Mar 2010 02:39:42 +0100
From: M vd S <mvds.00@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK is NOOP on block devices
References: <4B904D98.50602@gmail.com>
In-Reply-To: <4B904D98.50602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > > If O_NONBLOCK is meaningful whatsoever (see man page docs for
> > > semantics) against block devices, one would expect a nonblocking io
> >
> > It isn't...
>
> Thanks for the reply. It's good to get confirmation that I am not all
> alone in an alternate non blocking universe. The linux man pages
> actually had me convinced O_NONBLOCK would actually keep a process
> from blocking on device io :-)
>

You're even less alone, I'm running into the same issue just now. But I 
think I've found a way around it, see below.

> > The manual page says "When possible, the file is opened in non-blocking
> > mode" . Your write is probably not blocking - but the memory allocation
> > for it is forcing other data to disk to make room. ie it didn't 
> block it
> > was just "slow".
>
> Even though I know quit well what blocking is, I am not sure how we
> define "slowness". Perhaps when we do define it, we can also define
> "immediately" to mean anything less than five seconds ;-)
>
> You are correct that io to the disk is precisely what must happen to
> complete, and last time I checked, that was the very definition of
> blocking. Not only are writes blocking, even reads are blocking. The
> docs for read(2) also says it will return EAGAIN if "Non-blocking I/O
> has been selected using O_NONBLOCK and no data was immediately
> available for reading."
>

The read(2) manpage reads, under NOTES:

"Many file systems and disks were considered to be fast enough that the 
implementation of O_NONBLOCK was deemed unnecessary.  So, O_NONBLOCK may 
not be available on files and/or disks."

The statement ("fast enough") maybe only reflects the state of affairs 
at that time - 10 ms seek time takes an eternity at 3 GHz, and times 
100k it takes an eternity IRL as well. I would define "immediately" if 
the data is available from kernel (or disk) buffers.

I need to do vast amounts (100k+) of scattered and unordered small reads 
from harddisk and want to keep my seeks short through sorting them. I 
have done some measurements and it seems perfectly possible to derive 
the physical disk layout from statistics on some 10-100k random seeks, 
so I can solve everything in userland. But before writing my own I/O 
scheduler I'd thought to give the kernel and/or SATA's NCQ tricks a shot.

Now the problem is how to tell the kernel/disk which data I want without 
blocking. readv(2) appearantly reads the requests in array order. 
Multithreading doesn't sound too good for just this purpose.

posix_fadvise(2) sounds like something: "POSIX_FADV_WILLNEED initiates a 
non-blocking read of the specified region into the page cache."
But there's appearantly no signalling to the process that an actual 
read() will indeed not block.

readahead(2) blocks until the specified data has been read.

aio_read(2) appearantly doesn't issue a real non blocking read request, 
so you will get the unneeded overhead of one thread per outstanding request.


mmap(2) / madvise(2) / mincore(2) may be a way around things (although 
non-atomic), but I haven't tested it yet. It might also solve the 
problem that started this thread, at least for the reading part of it. 
Writing a small read() like function that operates through mmap() 
doesn't seem too complicated. As for writing, you could use msync() with 
MS_ASYNC to initiate a write. I'm not sure how to find out if a write 
has indeed taken place, but at least initiating a non-blocking write is 
possible. munmap() might then still block.

Maybe some guru here can tell beforehand if such an approach would work?

Cheers,
M.

