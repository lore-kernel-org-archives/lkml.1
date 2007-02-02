Return-Path: <linux-kernel-owner+w=401wt.eu-S1423208AbXBBT6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423208AbXBBT6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 14:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423207AbXBBT6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 14:58:55 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:52654 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423206AbXBBT6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 14:58:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZMZY6ZkPKNo53TdcvSWH3PaEn4ZjYJsIj+ylYex+R9rT4ZliQxCTN4Nz6jK9qUKZjqnN/UqbyOQ/iErsxK0gz3sFEtU2NGAuLAHCqre64Qod29j2jNJRdfFxTJm4f1S45SJ554iSIXeNdFA7hT1hWgBQUmXIZefxBOIM1Mb/HBc=
Message-ID: <f2b55d220702021158k7e0ce690xaba95394ee01e4e4@mail.gmail.com>
Date: Fri, 2 Feb 2007 11:58:53 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Should io(read|write)(8|16|32)_rep take (const|) volatile u(8|16|32) __iomem *addr?
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Linux Kernel List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45C31B86.6070009@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220702011624v6cb13c8ct1d70863a661d2227@mail.gmail.com>
	 <f2b55d220702011635s5b338a6ct861645ea7892f732@mail.gmail.com>
	 <45C2D47A.9080001@garzik.org> <45C2DA8D.4050007@zytor.com>
	 <45C31B86.6070009@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Preface: I am aware that other people here know far more that I do
about the details of C semantics.  If the inconsistency is deliberate,
please just point me to the previous LKML thread.

On 2/2/07, Jeff Garzik <jeff@garzik.org> wrote:
> H. Peter Anvin wrote:
> > Jeff Garzik wrote:
> >> Volatile is usually reserved for a specific need on a specific arch.
> >> I doubt it is correct to force it on all arches.
> >
> > They already are volatile; the issue is adding "const".

No, const is already there on the ioread.*_rep declarations.  But
since you mention it, it's missing from ioread(8|16|32) on some
(most?) arches (it's present at least on ixp4xx).  It would probably
be good to add it, so that a driver writer can declare that some
registers are read-only (ideally as const members of a struct; does
GCC support that?) and catch accidental iowrites to them at compile
time.

> > All io(read|write)* pointers are volatile, IIRC.
>
> No, none are volatile, hence my comment.

My concern is the lack of volatile's in the io(read|write).*_rep
declarations, by comparison to memcpy_(from|to)io.  I'm willing to be
convinced that the volatile should be in the implementation, not the
interface; and indeed, that's how the individual
io(read|write)(8|16|32) functions are declared (on arches where they
don't boil down to macros that cast with __force).  But that's not how
memcpy_(from|to)io or ALSA's copy_(from|to)_user_(to|from)io are
declared.  Which is right?

I also lean towards u8/u16/u32 for consistency with the normalization
of the length parameters (and possibly for catching alignment issues
at compile time), but that's separate.

> > [jgarzik@pretzel linux-2.6]$ grep volatile lib/iomap.c include/asm-generic/iomap.h
> > [jgarzik@pretzel linux-2.6]$
>
> Maybe you were thinking about writel() and friends, whose implementation
> (not prototype!) includes use of volatile.

Doubtless this is on purpose, but it's not clear to me why that should
be true for these particular functions/macros.  I shouldn't have to
cast away the volatile on a pointer to hardware registers in order to
pass it into writel(), should I?  And it shouldn't be forbidden for
the caller to declare the pointer volatile so that the compiler
catches attempts to pass it into non-volatile interfaces, should it?

My naive opinion is that the semantics of const and volatile ought to
be "you can add it but you can't take it away"; and IIRC this is their
actual semantics in ANSI C.  When writing a driver, I ought to be able
to say, "don't ever write to here (const), and don't ever reorder or
optimize away writes to or reads from there (volatile)".  (I am not
talking about reordering reads and writes to _different_ locations;
I'm aware that hardware support and memory barriers may be needed to
deal with that, and as far as I am concerned the compiler shouldn't
pretend to guarantee that reading *p will happen after writing *q.)

An interface that's declared without "volatile" on its pointers is
implicitly saying that it's not necessarily safe for use on pointers
to volatile data.  It could get inlined and then some access could get
optimized away based on the non-use of the result.  An interface
that's declared with "volatile" on its pointers is saying that it's
going to access them once for each time its source code says it
should, irrespective of inlining and optimization, and won't generate
extra accesses or reorder accesses through the _same_ pointer either.
(C semantics may be that it won't reorder accesses through different
volatile pointers either; I haven't checked, and wouldn't rely on that
because the hardware may do it anway.)

It seems to me that if you want a volatile implementation for volatile
arguments and an optimal implementation for non-volatile arguments you
need to implement as a macro, not an inline function.

Cheers,
- Michael
