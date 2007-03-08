Return-Path: <linux-kernel-owner+w=401wt.eu-S2992820AbXCHBZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992820AbXCHBZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992818AbXCHBZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:25:19 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:48507 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992819AbXCHBZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:25:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J9B8u1dicNQ8DB59fNNWpc4zlAprY897kwFkgDD51x0Y1IexcY1el3VG4tWxxQDyVIXys87bo/I545iecV+F4FsrDrv3M/vBtvdWp4tTD34Z8uEJBZJHx9SE9R2DqaxrhnGwJa3iB86ibgl19DwRR91EAktXNJTmhp1Gb8UEw3Q=
Message-ID: <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com>
Date: Wed, 7 Mar 2007 17:25:14 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch] epoll use a single inode ...
Cc: "Anton Blanchard" <anton@samba.org>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Avi Kivity" <avi@argo.co.il>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED1A3C.6030707@argo.co.il>
	 <200703071906.58405.dada1@cosmosbay.com>
	 <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org>
	 <200703071952.13219.dada1@cosmosbay.com>
	 <20070307221401.GA16938@kryten>
	 <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Linus Torvalds <torvalds@linux-foundation.org> wrote
> Yeah, I'm not at all surprised. Any implementation of "prefetch" that
> doesn't just turn into a no-op if the TLB entry doesn't exist (which makes
> them weaker for *actual* prefetching) will generally have a hard time with
> a NULL pointer. Exactly because it will try to do a totally unnecessary
> TLB fill - and since most CPU's will not cache negative TLB entries, that
> unnecessary TLB fill will be done over and over and over again..

Data prefetch instructions should indeed avoid page table walks.
(Instruction prefetch mechanisms often do induce table walks on ITLB
miss.)  Not just because of the null pointer case, but because it's
quite normal to run off the end of an array in a loop with an embedded
prefetch instruction.  If you have an extra instruction issue unit
that shares the same DTLB, and you know you will really want that
data, you can sometimes use it to force DTLB preloads by doing an
actual data fetch from the foreseeable page.  This is potentially one
of the best uses of chip multi-threading on an architecture like Sun's
Niagara.

(I don't think Intel's hyper-threading works for this purpose; the
DTLB is shared but the entries are marked as owned by one thread or
the other.  HT can be used for L2 cache prefetching, although the
results so far seem to be mixed:
http://www.cgo.org/cgo2004/papers/02_80_Kim_D_REVISED.pdf)

> In general, using software prefetching is just a stupid idea, unless
>
>  - the prefetch really is very strict (ie for a linked list you do exactly
>    the above kinds of things to make sure that you don't try to prefetch
>    the non-existent end entry)
> AND
>  - the CPU is stupid (in-order in particular).
>
> I think Intel even suggests in their optimization manuals to *not* do
> software prefetching, because hw can usually simply do better without it.

Not the XScale -- it performs quite poorly without prefetch, as people
who have run ARMv5-optimized binaries on it can testify.  From the
XScale Core Developer's Manual:

<quote>
The Intel XScale(r) core has a true prefetch load instruction (PLD).
The purpose of this instruction is to preload data into the data and
mini-data caches. Data prefetching allows hiding of memory transfer
latency while the processor continues to execute instructions. The
prefetch is important to compiler and assembly code because judicious
use of the prefetch instruction can enormously improve throughput
performance of the core. Data prefetch can be applied not only to
loops but also to any data references within a block of code. Prefetch
also applies to data writing when the memory type is enabled as write
allocate

The Intel XScale(r) core prefetch load instruction is a true prefetch
instruction because the load destination is the data or mini-data
cache and not a register. Compilers for processors which have data
caches, but do not support prefetch, sometimes use a load instruction
to preload the data cache. This technique has the disadvantages of
using a register to load data and requiring additional registers for
subsequent preloads and thus increasing register pressure. By
contrast, the prefetch can be used to reduce register pressure instead
of increasing it.

The prefetch load is a hint instruction and does not guarantee that
the data will be loaded. Whenever the load would cause a fault or a
table walk, then the processor will ignore the prefetch instruction,
the fault or table walk, and continue processing the next instruction.
This is particularly advantageous in the case where a linked list or
recursive data structure is terminated by a NULL pointer. Prefetching
the NULL pointer will not fault program flow.
</quote>

People's prejudices against prefetch instructions are sometimes
traceable to the 3DNow! prefetch(w) botch, which some processors
"support" as no-ops and others are too aggressive about (Opteron
prefetches are reputed to be "strong", i. e., not dropped on DTLB
miss).  XScale gets it right.  So do most Pentium 4's using the SSE
prefetches, according to the IA-32 optimization manual.  (Oddly,
Prescott seems to have initiated a page table walk on DTLB miss during
software prefetch -- just one of many weird Prescott flaws.)  I'm
guessing Pentium M and its descendants (Core Solo and Duo) get it
right but I'm having a hell of a time finding out for sure.  Can any
of the x86 experts answer this?

Cheers,
- Michael
