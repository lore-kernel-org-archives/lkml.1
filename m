Return-Path: <linux-kernel-owner+w=401wt.eu-S1030212AbXBFWpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212AbXBFWpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030218AbXBFWpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:45:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:47238 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212AbXBFWpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:45:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j8jIumnc/9LjfSue+WbyfMIw0HtaMNjpvowS3e0n0LWpvFGjwCQGDONiEYqmr+AolQ9lJh82T9MtTR3ygtQGuki/FdmgJziGIZz94aMYdN4SHGF0Ud5drtRJUkndWionDtyfnvq+eNhd6ujbdu1bjTbEopEjOHHGdiVevevwqDY=
Message-ID: <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
Date: Tue, 6 Feb 2007 13:45:50 -0900
From: "Kent Overstreet" <kent.overstreet@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	 <20070203082308.GA6748@elte.hu>
	 <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
	 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
	 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
	 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
	 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
	 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, 5 Feb 2007, Kent Overstreet wrote:
> >
> > struct asys_ret {
> >     int ret;
> >     struct thread *p;
> > };
> >
> > struct asys_ret r;
> > r.p = me;
> >
> > async_read(fd, buf, nbytes, &r);
>
> That's horrible. It means that "r" cannot have automatic linkage (since
> the stack will be *gone* by the time we need to fill in "ret"), so now you
> need to track *two* pointers: "me" and "&r".

You'd only allocate r on the stack if that stack is going to be around
later; i.e. if you're using user threads. Otherwise, you just allocate
it in some struct containing your aiocb or whatever.

> And for user space, it means that we pass the _one_ thing around that we
> need for both identifying the async operation to the kernel (the "cookie")
> for wait or cancel, and the place where we expect the return value to be
> found (which in turn can _easily_ represent a whole "struct aiocb *",
> since the return value obviously has to be embedded in there anyway).
>
>                 Linus

The "struct aiocb" isn't something you have to or necessarily want to
keep around. It's the way the current aio interface works (which I've
coded to), but I don't really see the point. All it really contains is
the syscall arguments, but once the syscall's in progress there's no
reason the kernel has to refer back to it; similarly for userspace,
it's just another struct that userspace has to keep track of and free
at some later time.

In fact, that's the only sane way you can have a ring for submitted
system calls, as otherwise elements of the ring are getting freed in
essentially random order.

I don't see the point in having a ring for completed events, since
it's at most two pointers per completion; quite a bit less data being
sent back than for submissions.

-----

The trouble with differentiating between calls that block and calls
that don't is you completely loose the ability to batch syscalls
together; this is potentially a major win of an asynchronous
interface.

An app can have a bunch of cheap, fast user space threads servicing
whatever; as they run, they can push their system calls onto a global
stack. When no more can run, it does a giant asys_submit (something
similar to io_submit), then the io_getevents equivilant, running the
user threads that had their syscalls complete.

This doesn't mean you can't run synchronously the syscalls that
wouldn't block, or that you have to allocate a fibril for every
syscall - but for servers that care more about throughput than
latency, this is potentially a big win, in cache effects if nothing
else.

(And this doesn't prevent you from having a different syscall that
submits an asynchronous syscall, but runs it right away if it was able
to without blocking).
