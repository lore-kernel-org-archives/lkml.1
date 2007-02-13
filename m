Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbXBMTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbXBMTI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 14:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXBMTI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 14:08:27 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58587 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbXBMTI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 14:08:26 -0500
Date: Tue, 13 Feb 2007 21:56:38 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213185636.GA23987@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org> <20070213165642.GB16394@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070213165642.GB16394@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 13 Feb 2007 21:57:03 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 05:56:42PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Benjamin LaHaise <bcrl@kvack.org> wrote:
> 
> > > > Open issues:
> > > 
> > > Let me add some more
> > 
> > Also: FPU state (especially important with the FPU and SSE memory copy 
> > variants), segment register bases on x86-64, interaction with 
> > set_fs()...
> 
> agreed - i'll fix this. But i can see no big conceptual issue here - 
> these resources are all attached to the user context, and that doesnt 
> change upon an 'async context-switch'. So it's "only" a matter of 
> properly separating the user execution context from the kernel execution 
> context. The hardest bit was getting the ptregs details right - the 
> FPU/SSE state is pretty much async already (in the hardware too) and 
> isnt even touched by any of these codepaths.

Good work, Ingo.

I have not received first mail with announcement yet, so I will place 
my thoughts here if you do not mind.

First one is per-thread data like TID. What about TLS related kernel
data (is non-exec stack property stored in TLS block or in kernel)?
Should it be copied with regs too (or better introduce new clone flag,
which would force that info copy)?

Btw, does SSE?/MMX?/call-it-yourself really saved on context switch?
As far as I can see no syscalls (and kernel at all) use that registers.

Another one is more global AIO question - while this approach IMHO
outperforms micro-thread design (Zach and Linus created really good
starting points, but they too have fundamental limiting factor), it
still has a problem - syscall blocks and the same thread thus is not
allowed to continue execution and fill the pipe - so what if system
issues thousands of requests and there are only tens of working thread
at most. What Tux did, as far as I recall, (and some other similar 
state machines do :) was to break blocking syscall issues and return
to the next execution entity (next syslet or atom). Is it possible to
extend exactly this state machine and interface to allow that (so that
some other state machine implementations would not continue its life :)?

> 	Ingo

-- 
	Evgeniy Polyakov
