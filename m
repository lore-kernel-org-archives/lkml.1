Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXBOTes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXBOTes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161028AbXBOTes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:34:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58807 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161029AbXBOTeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:34:46 -0500
Date: Thu, 15 Feb 2007 11:28:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070215190413.GA23953@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org>
 <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org>
 <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org>
 <20070215190413.GA23953@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Feb 2007, Evgeniy Polyakov wrote:
> > 
> > See? The example you tried to use to show how "simple" the interface iswas 
> > actually EXACTLY THE REVERSE. It shows how subtle bugs can creep in!
> 
> So describe what are the requirements (constraints)?
> 
> Above example has exactly one syscall in the chain, so it is ok, but
> generally it is not correct.

Well, it *could* be correct. It depends on the semantics of the atom 
fetching. If we make the semantics be that the first atom is fetched 
entirely synchronously, then we could make the rule be that single-syscall 
async things can do their job with a temporary allocation.

So that wasn't my point. My point was that a complicated interface that 
uses indirection actually has subtle issues. You *thought* you were doing 
something simple, and you didn't even realize the subtle assumptions you 
made.

THAT was the point. Interfaces are really really subtle and important. 
It's absolutely not a case of "we can just write wrappers to fix up any 
library issues".

> So instead there will be 
> s = atom_create_and_add(__NR_stat, path, stat, NULL, NULL, NULL, NULL);
> atom then can be freed in the glibc_async_wait() wrapper just before
> returning data to userspace.

So now you add some kind of allocation/dealloction thing. In user space or 
in the kernel?

> There are millions of possible ways to do that, but what exactly one
> should be used from your point of view? Describe _your_ vision of that path.

My vision is that we should be able to do the simple things *easily* and 
without any extra overhead.

And doing wrappers in user space is almost entirely unacceptable, becasue 
a lot of the wrapping needs to be done at release time (for example: 
de-allocating memory), and that means that you no longer can do simple 
system calls that don't even need release notification AT ALL.

> Currently generic example is following:
> allocate mem
> setup complex structure
> submit syscall
> wait syscall
> free mem

And that "allocate mem" and "free mem" is a problem. It's not just a 
performance problem, it is a _complexity_ problem. It means that people 
have to track things that they are NOT AT ALL INTERESTED IN!

> So, describe how exactly _you_ think it should be implemented with its
> pros and cons, so that systemn could be adopted without trying to
> mind-read of what is simple and good or complex and really bad.

So I think that a good implementation just does everything up-front, and 
doesn't _need_ a user buffer that is live over longer periods, except for 
the actual results. Exactly because the whole alloc/teardown is nasty.

And I think a good implementation doesn't need wrapping in user space to 
be useful - at *least* not wrapping at completion time, which is the 
really difficult one (since, by definition, in an async world completion 
is separated from the initial submit() event, and with kernel-only threads 
you actually want to *avoid* having to do user code after the operation 
completed).

I suspect Ingo's thing can do that. But I also suspect (nay, _know_, from 
this discussion), that you didn't even think of the problems.

		Linus
