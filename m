Return-Path: <linux-kernel-owner+w=401wt.eu-S933295AbXBXAwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295AbXBXAwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbXBXAwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:52:03 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:27227 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbXBXAwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:52:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iqOHSwCbAIWmgLrfpJp5CN4hoW21MuKxSIAR6+Ov++vl8sz4D+dXWDm4t+HW+J9MOLiPATL9EKLuENU5gRxajsiZNaEunNGwkhYilt/JXnmV9miZp5h6tkFmDVNMZvEqdAPxif46EwyElOjTyuqh+78HfesuzZRKNln6UoyTvtU=
Message-ID: <f2b55d220702231651u2c1915b1we04de7ae41393874@mail.gmail.com>
Date: Fri, 23 Feb 2007 16:51:59 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>, "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070224010824.5cf6c0ac@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu> <20070222074044.GA4158@elte.hu>
	 <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223003018.0d244576@lxorguk.ukuu.org.uk>
	 <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
	 <20070223123718.54c9670e@lxorguk.ukuu.org.uk>
	 <f2b55d220702231549g47a648e3xd4c9d4a730f0c4ea@mail.gmail.com>
	 <20070224010824.5cf6c0ac@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for taking me at least minimally seriously, Alan.  Pretty
generous of you, all things considered.

On 2/23/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> That example touches back into user space, but doesnt involve MMU changes
> or cache flushes, or tlb flushes, or floating point.

True -- on an architecture where a change of TLS does not
substantially affect the TLB and cache, which (AIUI) it does on most
or all ARMs.  (On a pre-EABI ARM, there is even a substantial
cache-related penalty for encoding the syscall number in the syscall
opcode, because you have to peek back at the text segment to see it,
which costs you a D-cache stall.)  Now put an sprintf with a %d in it
between a couple of the syscalls, and _your_ arch is hurting.  Deny
the userspace programmer the use of the FPU in threadlets, and they
become a lot less widely applicable -- and a lot flakier in a
non-wizard's hands, given that people often cheat around the small
number of x86 integer registers by using FP registers when copying
memory in bulk.

> errno is thread specific if you use it but errno is as I said before
> entirely a C library detail that you don't have to suffer if you don't
> want to. Avoiding that saves a segment register load - which isn't too
> costly but isn't free.

On your arch, it's a segment register -- and another
who-knows-how-many pages to migrate along with the stack and pt_regs.
On ARM, it's a coprocessor register that is incorrectly emulated by
most JTAG emulators (so bye-bye JTAG-assisted debugging and
profiling), or possibly a register stolen from the general purpose
register set.  On some MIPSes I have known you probably can't
implement TLS safely without a cache flush.

If you tell people up front not to touch TLS in threadlets -- which
means not to use routines from <stdlib.h> and <stdio.h> -- then
implementors may have enough flexibility to make them perform well on
a wide range of architectures.  Alternately, if there are some things
that threadlet users will genuinely need TLS for, you can tell them
that all of the threadlets belonging to process X on CPU Y share a TLS
context, and therefore things like errno can't be trusted across a
syscall -- but then you had better make fairly sure that threadlets
aren't preempted by other threadlets in between syscalls.  Similar
arguments apply to FPU state.

IEEE 754.  Harp, harp.  :-)

Cheers,
- Michael
