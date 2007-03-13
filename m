Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXCMHZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXCMHZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 03:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbXCMHZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 03:25:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:11461 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbXCMHZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 03:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z4gU4yPbg2crQVN60T6UtrNKAMuOpYTJ+pgi/Dz7BK7Del8e12lbyqxO/Ebao+7Q1Udhju5dwMw5hTP/f0Ou9hcTN5NhV2v424jrpgNL760TCtDmaSi/EuWs5uQV1rTK4sLeFRY+1t9kN+4aGWcmXXgdSDi2I+91PghGfF1lHFM=
Message-ID: <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
Date: Mon, 12 Mar 2007 23:25:48 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070313022430.57503b08@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WAx2-2pg-21@gated-at.bofh.it>
	 <7WAGF-2Bx-9@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it>
	 <7WBt7-3SZ-23@gated-at.bofh.it> <E1HQfLX-0000fk-68@be1.lrz>
	 <f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	 <Pine.LNX.4.58.0703121803450.2313@be1.lrz>
	 <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	 <20070313022430.57503b08@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Writing to a file from multiple processes is not usually the problem.
> > Writing to a common "struct file" from multiple threads is.
>
> Not normally because POSIX sensibly invented pread/pwrite. Forgot
> preadv/pwritev but they did the basics and end of problem

pread/pwrite address a miniscule fraction of lseek+read(v)/write(v)
use cases -- a fraction that someone cared about strongly enough to
get into X/Open CAE Spec Issue 5 Version 2 (1997), from which it
propagated into UNIX98 and thence into POSIX.2 2001.  The fact that no
one has bothered to implement preadv/pwritev in the decade since
pread/pwrite entered the Single UNIX standard reflects the rarity with
which they appear in general code.  Life is too short to spend it
rewriting application code that uses readv/writev systematically,
especially when that code is going to ship inside a widget whose
kernel you control.

> > So what?  My products are shipping _now_.
>
> That doesn't inspire confidence.

Oh, please.  Like _your_ employer is the poster child for code
quality.  The cheap shot is also irrelevant to the point that I was
making, which is that sometimes portability simply doesn't matter and
the right thing to do is to firm up the semantics of the filesystem
primitives from underneath.

> > even funny.  If POSIX mandates stupid shit, and application
> > programmers don't read that part of the manual anyway (and don't code
> > on that assumption in practice), to hell with POSIX.  On many file
>
> Thats funny, you were talking about quality a moment ago.

Quality means the devices you ship now keep working in the field, and
the probable cost of later rework if the requirements change does not
exceed the opportunity cost of over-engineering up front.  Economy
gets a look-in too, and says that it's pointless to delay shipment and
bloat the application coding for cases that can't happen.  If POSIX
says that any and all writes (except small pipe/FIFO writes, whatever)
can return a short byte count -- but you know damn well you're writing
to a device driver that never, ever writes short, and if it did you'd
miss a timing budget recovering from it anyway -- to hell with POSIX.
And if you want to build a test jig for this code that uses pipes or
dummy files in place of the device driver, that test jig should never,
ever write short either.

> > descriptors, short writes simply can't happen -- and code that
>
> There is almost no descriptor this is true for. Any file I/O can and will
> end up short on disk full or resource limit exceeded or quota exceeded or
> NFS server exploded or ...

Not on a properly engineered widget, it won't.  And if it does, and
the application isn't coded to cope in some way totally different from
an infinite retry loop, then you might as well signal the exception
condition using whatever mechanism is appropriate to the API
(-EWHATEVER, SIGCRISIS, or block until some other process makes room).
 And in any case files on disk are the least interesting kind of file
descriptor in an embedded scenario -- devices and pipes and pollfds
and netlink sockets are far more frequent read/write targets.

> And on the device side about the only thing with the vaguest guarantees
> is pipe().

Guaranteed by the standard, sure.  Guaranteed by the implementation,
as long as you write in the size blocks that the device is expecting?
Lots of devices -- ALSA's OSS PCM emulation, most AF_LOCAL and
AF_NETLINK sockets, almost any "character" device with a
record-structured format.  A short write to any of these almost
certainly means the framing is screwed and you need to close and
reopen the device.  Not all of these are exclusively O_APPEND
situations, and there's no reason on earth not to thread-safe the
f_pos handling so that an application and filesystem/driver can agree
on useful lseek() semantics.

> > purports to handle short writes but has never been exercised is
> > arguably worse than code that simply bombs on short write.  So if I
> > can't shim in an induce-short-writes-randomly-on-purpose mechanism
> > during development, I don't want short writes in production, period.
>
> Easy enough to do and gcov plus dejagnu or similar tools will let you
> coverage analyse the resulting test set and replay it.

Here we agree.  Except that I've rarely seen embedded application code
that wouldn't explode in my face if I tried it.  Databases yes, and
the better class of mail and web servers, and relatively mature
scripting languages and bytecode interpreters; but the vast majority
of working programmers in these latter days do not exercise this level
of discipline.

> > Sure -- until the one code path in a hundred that handles the "short
> > write" case incorrectly gets traversed in production, after having
> > gone untested in a development environment that used a different
> > filesystem that never happened to trigger it.
>
> Competent QA and testing people test all the returns in the manual as
> well as all the returns they can find in the code. See ptrace(2) if you
> don't want to do a lot of relinking and strace for some useful worked
> examples of syscall hooking.

Even in the "enterprise" space, most of the QA and testing people I
have dealt with couldn't hook a syscall if their children were
starving and the fish were only biting on syscalls.  The embedded
situation is even worse.  ltrace didn't work on ARM for years and
hardly anyone _noticed_, let alone did anything about it.  (I posted a
fix to ltrace-devel a month ago, but evidently the few fish left in
that river don't bite on hooked syscalls.)  strace maintenance doesn't
seem too healthy either, judging by what I had to do it in order to
get it to recognize ALSA ioctls and the quasi-syscalls involved in ARM
TLS.

But on that note -- do you have any idea how one might get ltrace to
work on a multi-threaded program, or how one might enhance it to
instrument function calls from one shared library to another?  Or
better yet, can you advise me on how to induce gdbserver to stream
traces of library/syscall entry/exits for all the threads in a
process?  And then how to cram it down into the kernel so I don't take
the hit for an MMU context switch every time I hit a syscall or
breakpoint in the process under test?  That would be a really useful
tool for failure analysis in embedded Linux, doubly so on multi-core
chips, especially if it could be made minimally intrusive on the
CPU(s) where the application is running.

Cheers,
- Michael
