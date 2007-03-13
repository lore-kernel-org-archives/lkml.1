Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbXCMAqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbXCMAqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 20:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXCMAqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 20:46:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:46750 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbXCMAqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 20:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZitZa0uS/fYbh26A+Vub+L8m2B+473wQ7yL/zdksXKmWkB8VKS2xifeIR+Tf2yQ+I+9lgqnoauNWlpfrJkVZnycPzD1E0geL5gq5H9qu0FD0QUlMNZMmHb5XuRiY7aBu9EQVYPk0LHo62jBHtfiSeUUh/CUR3U6CZaiCNiwPhA4=
Message-ID: <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
Date: Mon, 12 Mar 2007 16:46:13 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Bodo Eggert" <7eggert@gmx.de>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0703121803450.2313@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WAx2-2pg-21@gated-at.bofh.it>
	 <7WAGF-2Bx-9@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it>
	 <7WBt7-3SZ-23@gated-at.bofh.it> <E1HQfLX-0000fk-68@be1.lrz>
	 <f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	 <Pine.LNX.4.58.0703121803450.2313@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Bodo Eggert <7eggert@gmx.de> wrote:
> On Mon, 12 Mar 2007, Michael K. Edwards wrote:
> > That's fine when you're doing integration test, and should probably be
> > the default during development.  But if the race is first exposed in
> > the field, or if the developer is trying to concentrate on a different
> > problem, "spectacular crash and burn" may do more harm than good.
> > It's easy enough to refactor the f_pos handling in the kernel so that
> > it all goes through three or four inline accessor functions, at which
> > point you can choose your trade-off between speed and idiot-proofness
> > -- at _kernel_ compile time, or (given future hardware that supports
> > standardized optionally-atomic-based-on-runtime-flag operations) per
> > process at run-time.
>
> CONFIG_WOMBAT
>
> Waste memory, brain and time in order to grant an atomic write which is
> neither guaranteed by the standard nor expected by any sane programmer,
> just in case some idiot tries to write to one file from multiple
> processes.
>
> Warning: Programs expecting this behaviour are buggy and non-portable.

OK, I laughed out loud at this.  But I think you're missing my point,
which is that there's a time to be hard-core about code quality and
there's a time to be hard-core about _product_ quality.  Face it, all
products containing software more or less suck.  This is because most
programmers write crap code most of the time.  The only way to cope
with this, outside the confines of the European defense industry and
other niches insulated from economic reality, is to make the
production environment gentler on _application_ code than the
development environment is.  Hence CONFIG_WOMBAT.  (I like that name.
I'm going to use it in my patch, with your permission.  :-)

Writing to a file from multiple processes is not usually the problem.
Writing to a common "struct file" from multiple threads is.  99.999%
of the time it will work, because you're only writing as far as VFS
cache and then bumping f_pos, and your threads are probably on the
same processor anyway.  0.001% of the time the second thread will see
a stale f_pos and clobber the first write.  This is true even on file
types that can never return a short write.  If you remember to open
with O_APPEND so the pos argument to vfs_write is silently ignored, or
if the implementation underlying vfs_write effectively ignores the pos
argument irrespective of flags, you're OK.  If the pos argument isn't
ignored, or if you ever look at the result of a relative seek on any
fd that maps to that struct file, you're screwed.

(Note to the alert reader:  yes, this means shell scripts should
always use >> rather than > when routing stdout and/or stderr to a
file.  You're just as vulnerable to interleaving due to stdio
buffering issues as you are when stdio and stderr are sent to the tty,
and short writes may still be a problem if you are so foolish as to
use a filesystem that generates them on anything short of a
catastrophic error, but at least you get O_APPEND and sane behavior on
ftruncate().)

> > Frankly, I think that unless application programmers poke at some sort
> > of magic "I promise to handle short writes correctly" bit, write()
> > should always return either the full number of bytes requested or an
> > error code.
>
> If you asume that you won't have short writes, your programs may fail on
> e.g. solaris. There may be reasons for linux to use the same semantics at
> some time in the future, you never know.

So what?  My products are shipping _now_.  Future kernels are
guaranteed to break them anyway because sysfs is a moving target.
Solaris is so not in the game for my kind of embedded work, it's not
even funny.  If POSIX mandates stupid shit, and application
programmers don't read that part of the manual anyway (and don't code
on that assumption in practice), to hell with POSIX.  On many file
descriptors, short writes simply can't happen -- and code that
purports to handle short writes but has never been exercised is
arguably worse than code that simply bombs on short write.  So if I
can't shim in an induce-short-writes-randomly-on-purpose mechanism
during development, I don't want short writes in production, period.

In my world, GNU/Linux is not a crappy imitation Solaris that you get
to pay out the wazoo for to Red Hat (and get no documentation and
lousy tech support that doesn't even cover your hardware).  It's a
full-source-code platform on which you can engineer robust industrial
and consumer products, because you can control the freeze and release
schedule component-by-component, and you can point fix anything in the
system at any time.  If, that is, you understand that the source code
is not the software, and that you can't retrofit stability and
security overnight onto code that was written with no thought of
anything but performance.

> If you asume you *may* have short writes, you have no problem.

Sure -- until the one code path in a hundred that handles the "short
write" case incorrectly gets traversed in production, after having
gone untested in a development environment that used a different
filesystem that never happened to trigger it.

> >  If they do poke at that bit, the (development) kernel
> > should deliberately split writes a few percent of the time, just to
> > exercise the short-write code paths.  And in order to find out where
> > that magic bit is, they should have to read the kernel code or ask on
> > LKML (and get the "standard lecture").
>
> I think it may be well-hidden in menuconfig.
>
> > Really very IEEE754-like, actually.  (Harp, harp.)
>
> -EYOULOSTME

I have been harping in other threads on the desirability of an AIO
model that resembles IEEE754 floating point in some key respects that
would make it practical to implement AEIOUs (asynchronously executed
I/O units) in future hardware.  That means revamping the calling
conventions and exception semantics to reflect what latitude the
implementors of pipelined AIO coprocessors are likely to need, not the
designed-by-committee, implemented-by-accretion POSIX heritage.  My
advocacy in mere human language has so far resulted in -ENOPATCH, so
I'm having the alternate joy and misery of rewriting fs/read_write.c
and all its friends.  I'm learning quite a lot about Linux internals
in the process, too -- at multiple levels, coding and design and
community dynamics.

Cheers,
- Michael
