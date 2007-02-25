Return-Path: <linux-kernel-owner+w=401wt.eu-S932792AbXBYSNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932792AbXBYSNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbXBYSNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:13:45 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:32844 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792AbXBYSNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:13:44 -0500
Date: Sun, 25 Feb 2007 21:09:11 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070225180910.GA29821@2ka.mipt.ru>
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru> <20070225174505.GA7048@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070225174505.GA7048@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sun, 25 Feb 2007 21:10:41 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 06:45:05PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > My main concern was only about the situation, when we ends up with 
> > truly bloking context (like network), and this results in having 
> > thousands of threads doing the work - even having most of them 
> > sleeping, there is a problem with memory overhead and context 
> > switching, although it is usable situation, but when all of them are 
> > ready immediately - context switching will kill a machine even with 
> > O(1) scheduler which made situation damn better than before, but it is 
> > not a cure for the problem.
> 
> yes. This is why in the original fibril discussion i concentrated so 
> much on scheduling performance.
> 
> to me the picture is this: conceptually the scheduler runqueue is a 
> queue of work. You get items queued upon certain events, and they can 
> unqueue themselves. (there is also register context but that is already 
> optimized to death by hardware) So whatever scheduling overhead we have, 
> it's a pure software thing. It's because we have priorities attached. 
> It's because we have some legacies. Etc., etc. - it's all stuff /we/ 
> wanted to add, but nothing truly fundamental on top of the basic 'work 
> queueing' model.
> 
> now look at kevents as the queueing model. It does not queue 'tasks', it 
> lets user-space queue requests in essence, in various states. But it's 
> still the same conceptual thing: a memory buffer with some state 
> associated to it. Yes, it has no legacies, it has no priorities and 
> other queueing concepts attached to it ... yet. If kevents got 
> mainstream, it would get the same kind of pressure to grow 'more 
> advanced' event queueing and event scheduling capabilities. 
> Prioritization would be needed, etc.
> 
> So my fundamental claim is: a kernel thread /is/ our main request 
> structure. We've got tons of really good system calls that queue these 
> 'requests' around the place and offer functionality around this concept. 
> Plus there's a 1.2+ billion lines of Linux userspace code that works 
> well with this abstraction - while there's nary a few thousand lines of 
> event-based user-space code.
> 
> I also say that you'll likely get kevents outperform threadlets. Maybe 
> even significantly so under the right conditions. But i very much 
> believe we want to get similar kind of performance out of thread/task 
> scheduling, and not introduce a parallel framework to do request 
> scheduling the hard way ... just because our task concept and scheduling 
> implementation got too fat. For the same reason i didnt really like 
> fibrils: they are nice, and Zach's core idea i think nicely survived in 
> the syslet/threadlet model too, but they are more limited than true 
> threads. So doing that parallel infrastructure, which really just 
> implements the same, and is only faster because it skips features, would 
> just be hiding the problem with our primary abstraction. Ok?

Kevent is a _very_ small entity and there is _no_ cost of requeueing
(well, there is list_add guarded by lock) - after it is done, process
can start real work. With rescheduling there are _too_ many things to be
done before we can start new work. We have to change registers, change
address space, various tlb bits and so on - we have to do it, since task
describes very heavy entity - the whole process.
IO in turn is a very small subset of what process is (can do), so there 
is no need to change the whole picture, so it is enough to have one 
process, which does the work.

Threads are a bit smaller than process, but still it is too heavy to
have it per IO - so we have pools - this decreases rescheduling
overhead, but limits parallelism.

I think it is _too_ heavy to have such a monster structure like
task(thread/process) and related overhead just to do an IO.

> 	Ingo

-- 
	Evgeniy Polyakov
