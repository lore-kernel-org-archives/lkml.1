Return-Path: <linux-kernel-owner+w=401wt.eu-S1751506AbXBNJEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbXBNJEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932149AbXBNJEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:04:40 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:35858 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbXBNJEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:04:39 -0500
Date: Wed, 14 Feb 2007 11:59:40 +0300
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
Message-ID: <20070214085939.GA4665@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain> <20070213145848.GS18311@kvack.org> <20070213165642.GB16394@elte.hu> <20070213185636.GA23987@2ka.mipt.ru> <20070213221810.GF22104@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070213221810.GF22104@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Wed, 14 Feb 2007 11:59:50 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:18:10PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > [...] it still has a problem - syscall blocks and the same thread thus 
> > is not allowed to continue execution and fill the pipe - so what if 
> > system issues thousands of requests and there are only tens of working 
> > thread at most. [...]
> 
> the same thread is allowed to continue execution even if the system call 
> blocks: take a look at async_schedule(). The blocked system-call is 'put 
> aside' (in a sleeping thread), the kernel switches the user-space 
> context (registers) to a free kernel thread and switches to it - and 
> returns to user-space as if nothing happened - allowing the user-space 
> context to 'fill the pipe' as much as it can. Or did i misunderstand 
> your point?

Let me clarify what I meant.
There is only limited number of threads, which are supposed to execute
blocking context, so when all they are used, main one will block too - I
asked about possibility to reuse the same thread to execute queue of
requests attached to it, each request can block, but if blocking issue
is removed, it would be possible to return.

What I'm asking for is how actually kevent IO state machine functions work
- each IO request is made not through usual mpage and bio allocations,
but with special kevent ones, which do not wait until completion, but
instead in destructor it is either rescheduled (if big file is
transferred, then it is split into parts for transmission) or committed
as ready (thus it becomes possible to read completion through kevent
queue or ring), so there are only several threads, each one does small
job on each request, but the same request can be rescheduled to it again
and again (from bio destructor or ->end_io callback for example).

So I asked if it is possible to extend this state machine to work not
only with blocked syscalls but with non-blocked functions with
possibility to reschedule the same item again.

-- 
	Evgeniy Polyakov
