Return-Path: <linux-kernel-owner+w=401wt.eu-S965047AbXCILw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965047AbXCILw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965219AbXCILw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:52:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:57250 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965047AbXCILw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:52:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d/9Y3YIxShseYbuVTOyBleQ1XoxHzAsq8fAK/Ns8KcD6f6bfzJ/Sjrmgs6GJ/ZdiQyLttBRegmV01CKWHkO5pNQRlaXFLwZ4BjjewVgDHq/CLlwdGav7dNAiJKUS3aWeahw8dk8FLCjcsE60wFPIrb6fjWNbvXhYSWEHX0G+rsQ=
Message-ID: <f2b55d220703090352x7f07e1bgc94193f500c10e12@mail.gmail.com>
Date: Fri, 9 Mar 2007 03:52:54 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45F0F644.6020705@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com>
	 <45F09F9C.4030801@cosmosbay.com>
	 <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com>
	 <45F0A71C.2000800@cosmosbay.com>
	 <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
	 <45F0F644.6020705@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Dont even try, you *cannot* do that, without breaking the standards, or
> without a performance drop.
>
> The only safe way would be to lock the file during the whole read()/write()
> syscall, and we dont want this (this would be more expensive than current)
> Dont forget 'file' may be some sockets/tty/whatever, not a regular file.

I'm not trying to provide full serialization of concurrent
multi-threaded read()/write() in all exceptional scenarios.  I am
trying to think through the semantics of pipelined I/O operations on
struct file.  In the _absence_ of an exception, something sane should
happen -- and when you start at f_pos == 1000 and write 100 bytes each
from two threads (successfully), leaving f_pos at 1100 is not sane.

> Standards are saying :
>
> If an error occurs, file pointer remains unchanged.

>From 1003.1, 2004 edition:

<standard>
This volume of IEEE Std 1003.1-2001 does not specify the value of the
file offset after an error is returned; there are too many cases. For
programming errors, such as [EBADF], the concept is meaningless since
no file is involved. For errors that are detected immediately, such as
[EAGAIN], clearly the pointer should not change. After an interrupt or
hardware error, however, an updated value would be very useful and is
the behavior of many implementations.

This volume of IEEE Std 1003.1-2001 does not specify behavior of
concurrent writes to a file from multiple processes. Applications
should use some form of concurrency control.
</standard>

The effect on f_pos of an error during concurrent writes is therefore
doubly unconstrained.  In the absence of concurrent writes, it is
quite harmless for f_pos to have transiently contained, at some point
during the execution of write(), an overestimate of the file position
after the write().  In the presence of concurrent writes (let us say
two 100-byte writes to a file whose f_pos starts at 1000), it is
conceivable that the second write will succeed at f_pos == 1100 but
the first will be short (let us say only 50 bytes are written),
leaving f_pos at 1150 and no bytes written in the range 1050 to 1099.
That would suck -- but the standard does not oblige you to avoid it
unless the destination is a pipe or FIFO with O_NONBLOCK clear, in
which case partial writes are flat out verboten.

> You cannot know for sure how many bytes will be written, since write() can
> returns a count that is different than buflen.

Of course (except in the pipe/FIFO case).  But if it does, and you're
writing concurrently to the fd, you're not obliged to do anything sane
at all.  If you're not writing concurrently, the fact that you
overshot and then fixed it up after vfs_write() returned is _totally_
invisible.  f_pos is local to the struct file.

> So you cannot update fpos before calling vfs_write()

You can speculatively update it, and in the common case you don't have
to touch it again.  That's a win.

> About your L1 'miss', dont forget that multi-threaded apps are going to
> atomic_dec_and_test(&file->f_count) anyway when fput() is done at the end of
> syscall. And you were concerned about multi-threaded apps, didnt you ?

That does indeed interfere with the optimization for multi-threaded
apps.  Which doesn't mean it isn't worth having for single-threaded
apps.  And if we get to the point that that atomic_dec_and_test is the
only thing left (in the common case) that touches the struct file
after a VFS operation completes, then we can evaluate whether f_count
ought to be split out of the struct file and put somewhere else.  In
fact, if I understand the calls inside vfs_write() correctly, f_count
is (usually?) the only member of struct file that is written to during
a call to sys_pwrite64(); so moving it out of struct file and into
some place where it has to be kept cache-coherent anyway would also
improve the performance on SMP of distributed pwrite() calls to a
process-global fd.

Cheers,
- Michael
