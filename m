Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZCZE6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZCZE6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 00:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZCZE6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 00:58:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:30258 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbZCZE6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 00:58:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903252017100.3032@localhost.localdomain>
References: <20090324093245.GA22483@elte.hu> <20090325185824.GO32307@mit.edu>
	 <20090325194851.GA1617@infradead.org> <20090325215016.GP32307@mit.edu>
	 <20090326021034.GA26559@srcf.ucam.org>
	 <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
	 <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>
	 <49CAEDA7.1080902@garzik.org>
	 <f73f7ab80903252003j248b416ewe52b613c5b53066c@mail.gmail.com>
	 <alpine.LFD.2.00.0903252017100.3032@localhost.localdomain>
Date: Thu, 26 Mar 2009 00:58:28 -0400
Message-ID: <f73f7ab80903252158o1d722068j117b4e9933f67589@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Kyle Moffett <kyle@moffetthome.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 11:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, 25 Mar 2009, Kyle Moffett wrote:
>> To be honest I think we could provide much better data consistency
>> guarantees and remove a lot of fsync() calls with just a basic
>> per-filesystem barrier() call.
>
> The problem is not that we have a lot of fsync() calls. Quite the reverse.
> fsync() is really really rare. So is being careful in general. The number
> of applications that do even the _minimal_ safety-net of "create new file,
> rename it atomically over an old one" is basically zero. Almost everybody
> ends up rewriting files with something like
>
>        open(name, O_CREAT | O_TRUNC, 0666)
>        write();
>        close();
>
> where there isn't an fsync in sight, nor any "create temp file", nor
> likely even any real error checking on the write(), much less the
> close().

Really, I think virtually all of the database programs would be
perfectly happy with an "fsbarrier(fd, flags)" syscall, where if "fd"
points to a regular file or directory then it instructs the underlying
filesystem to do whatever internal barrier it supports, and if not
just fail with -ENOTSUPP (so you can fall back to fdatasync(), etc).
Perhaps "flags" would allow a "data" or "metadata" barrier, but if not
it's not a big issue.

I've ended up having to write a fair amount of high-performance
filesystem library code which almost never ends up using fsync() quite
simply because the performance on it sucks so badly.  This is one of
the big reasons why so many critical database programs use O_DIRECT
and reinvent the the wheel^H^H^H^H^H^H pagecache.  The only way you
can actually use it in high-bandwidth transaction applications is by
doing your own IO-thread and buffering system.

You have to have your own buffer ordering dependencies and call
fdatasync() or fsync() from individual threads in-between specific
ordered IOs.  The threading helps you keep other IO in flight while
waiting for the flush to finish.  For big databases on spinning media
(SSDs don't work precisely because they are small and your databases
are big) the overhead of a full flush may still be too large.  Even
with SSDs, with multiple processes vying for IO bandwidth you still
want some kind of application-level barrier to avoid introducing
bubbles in your IO pipeline.

It all comes down to a trivial calculation: if you can't get
(bandwidth * latency-to-stable-storage) bytes of data queued *behind*
a flush then your disk is going to sit idle waiting for more data
after completing it.  If a user-level tool needs to enforce ordering
between IOs the only tool right now is is a full flush; when
database-oriented tools can use a barrier()-ish call instead, they can
issue the op and immediately resume keeping the IO queues full.

Cheers,
Kyle Moffett
