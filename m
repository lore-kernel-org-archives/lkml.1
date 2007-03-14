Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXCNUJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXCNUJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXCNUJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:09:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45109 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055AbXCNUJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CIz+2dyb4jnK0jKX/RFkQ1Kl/Gjs1Si9RrSMxl7UAZ4S+mzPJ9i1GdOhECcdustkDTAJgSJ2Qre+1ypIdOWpXZZAPxWyUlPL4yuFTN7t9F5aPIsE5Sz5orjbV3dSGuhMEzRzwqqEWYUYHkxmhpkczTi3ouAl8AX77IPrj1a5Gqw=
Message-ID: <f2b55d220703141309l20f907c4t6d0bb7dcef724947@mail.gmail.com>
Date: Wed, 14 Mar 2007 13:09:46 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: "Bodo Eggert" <7eggert@gmx.de>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070313131533.1ec468c3@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it>
	 <7WBt7-3SZ-23@gated-at.bofh.it> <E1HQfLX-0000fk-68@be1.lrz>
	 <f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	 <Pine.LNX.4.58.0703121803450.2313@be1.lrz>
	 <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	 <20070313022430.57503b08@lxorguk.ukuu.org.uk>
	 <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
	 <20070313131533.1ec468c3@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Alan, this is really helpful -- I'll see if I can figure out
kprobes.  It is not immediately obvious to me how to use them to trace
function calls in userspace, but I'll read up.

On 3/13/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > But on that note -- do you have any idea how one might get ltrace to
> > work on a multi-threaded program, or how one might enhance it to
> > instrument function calls from one shared library to another?  Or
>
> I don't know a vast amount about ARM ELF user space so no.

This isn't ARM-specific, although it's certainly an ELF issue.  ltrace
uses libelf to inspect the program binary and replace calls to shared
library functions with breakpoints.  When the program hits one of
these breakpoints, ltrace inspects the function arguments, puts the
function call back in place of the breakpoint, single steps through
it, puts the breakpoint back, does some sort of sleight of hand to
ensure that it will break again on function return, and continues.
When it breaks again on function return, ltrace inspects the return
value and then continues.

I suppose I should wrap my head around the kwatch stuff and see if
there's a way of doing this without intrusive manipulation of the text
segment, which seems to be the thing preventing ltrace from being
extensible to multi-threaded programs.  The ELF handling code in
ltrace is sufficiently opaque to me that I doubt I could make it work
on function calls inside shared libraries without completely rewriting
it -- at which point I'd rather go the extra mile with kprobes, I
think.

> > better yet, can you advise me on how to induce gdbserver to stream
> > traces of library/syscall entry/exits for all the threads in a
> > process?  And then how to cram it down into the kernel so I don't take
>
> One way to do this is to use kprobes which will do exactly what you want
> as it builds a kernel module. Doesn't currently run on ARM afaik.

There doesn't seem to be an arch/arm/kernel/kprobes.c, and I'm not
sure I have the skill to write one.  On the other hand, ltrace manages
something similar (through libelf), and I can trace ltrace's ptrace
activity with strace, so maybe I can clone that.  :-)

> > the hit for an MMU context switch every time I hit a syscall or
>
> Not easily with gdbstubs as you've got to talk to something to decide how
> to log the data and proceed. If you stick it kernel side its a lot of
> ugly new code and easier to port kprobes over, if you do it remotely as
> gdbstubs intends it adds latencies and screws all your timings.

Sure does.  I do have gdbserver working remotely but it's not as
useful as I hoped because real-world multi-threaded code is so full of
latent races that it dies instantly under gdb.  Unless, of course,
that multi-threaded code was systematically developed using gdb and
qemu and other techniques of flushing out racy designs before their
implementation is entrenched.  Not typical of the embedded world, I'm
sorry to say.

> gdbstubs is also not terribly SMP aware and for low level work its
> sometimes easier to have on gdb per processor if you can get your brain
> around it.

That's a trick I don't know.  What do you do, fire up the target
process, put the whole thing to sleep with a SIGSTOP, and then attach
a separate gdb to each thread after they've been migrated and locked
down to the destination CPU?

Cheers,
- Michael
