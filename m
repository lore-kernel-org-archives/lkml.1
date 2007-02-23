Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXBWIb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXBWIb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 03:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbXBWIb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 03:31:56 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:7971 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbXBWIby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 03:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U6aSsfkA1k2MbMtd64jJPPdxBBI289JTUlZwaBt5pztcRhb2QEpL6PfniaLcGKGBTrJrrUPxa1POd8+GkhsYvrMdnLBnVjolQ7SJSu5SaMdaEsETVf5mtgKz03jrXrttDfylS3fZiKOpoVJV1Frt24qAzdftm+gg/zE8vqshe5M=
Message-ID: <f2b55d220702230031p63287a87tab21284cd317e09d@mail.gmail.com>
Date: Fri, 23 Feb 2007 00:31:52 -0800
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
In-Reply-To: <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
	 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
	 <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223003018.0d244576@lxorguk.ukuu.org.uk>
	 <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, having skimmed through Ingo's code once now, I can already see I
have some crow to eat.  But I still have some marginally less stupid
questions.

Cachemiss threads are created with CLONE_VM | CLONE_FS | CLONE_FILES |
CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM.  Does that mean they
share thread-local storage with the userspace thread, have
thread-local storage of their own, or have no thread-local storage
until NPTL asks for it?

When the kernel zeroes the userspace stack pointer in
cachemiss_thread(), presumably the allocation of a new userspace stack
page is postponed until that thread needs to resume userspace
execution (after completion of the first I/O that missed cache).  When
do you copy the contents of the threadlet function's stack frame into
this new stack page?

Is there anything in a struct pt_regs that is expensive to restore
(perhaps because it flushes a pipeline or cache that wasn't already
flushed on syscall entry)?  Is there any reason why the FPU context
has to differ among threadlets that have blocked while executing the
same userspace function with different stacks?  If the TLS pointer
isn't in either of these, where is it, and why doesn't
move_user_context() swap it?

If you set out to cancel one of these threadlets, how are you going to
ensure that it isn't holding any locks?  Is there any reasonable way
to implement a userland finally { } block so that you can release
malloc'd memory and clean up application data structures?

If you want to migrate a threadlet to another CPU on syscall entry
and/or exit, what has to travel other than the userspace stack and the
struct pt_regs?  (I am assuming a quiesced FPU and thread(s) at the
destination with compatible FPU flags.)  Does it make sense for the
userspace stack page to have space reserved for a struct pt_regs
before the threadlet stack frame, so that the entire userspace
threadlet state migrates as one page?

I now see that an effort is already made to schedule threadlets in
bursts, grouped by PID, when several have unblocked since the last
timeslice.  What is the transition cost from one threadlet to another?
 Can that transition cost be made lower by reducing the amount of
state that belongs to the individual threadlet vs. the pool of
cachemiss threads associated with that threadlet entrypoint?

Generally, is there a "contract" that could be made between the
threadlet application programmer and the implementation which would
allow, perhaps in future hardware, the kind of invisible pipelined
coprocessing for AIO that has been so successful for FP?

I apologize for having adopted a hostile tone in a couple of previous
messages in this thread; remind me in the future not to alternate
between thinking about code and about the FSF.  :-)  I do really like
a lot of things about the threadlet model, and would rather not see it
given up on for network I/O and NUMA systems.  So I'm going to
reiterate again -- more politely this time -- the need for a
data-structure-centric threadlet pool abstraction that supports
request throttling, reprioritization, bulk cancellation, and migration
of individual threadlets to the node nearest the relevant I/O port.

I'm still not sold on syslets as anything userspace-visible, but I
could imagine them enabling a sort of functional syntax for chaining
I/O operations, with most failures handled as inline "Not-a-Pointer"
values or as "AEIOU" (asynchronously executed I/O unit?) exceptions
instead of syscall-test-branch-syscall-test-branch.  Actually working
out the semantics and getting them adopted as an IEEE standard could
even win someone a Turing award.  :-)

Cheers,
- Michael
