Return-Path: <linux-kernel-owner+w=401wt.eu-S965052AbXBYRvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbXBYRvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 12:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965049AbXBYRvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 12:51:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48558 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965052AbXBYRvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 12:51:51 -0500
Date: Sun, 25 Feb 2007 18:45:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
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
Message-ID: <20070225174505.GA7048@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru> <20070223115152.GA2565@elte.hu> <20070223122224.GB5392@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223122224.GB5392@2ka.mipt.ru>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> My main concern was only about the situation, when we ends up with 
> truly bloking context (like network), and this results in having 
> thousands of threads doing the work - even having most of them 
> sleeping, there is a problem with memory overhead and context 
> switching, although it is usable situation, but when all of them are 
> ready immediately - context switching will kill a machine even with 
> O(1) scheduler which made situation damn better than before, but it is 
> not a cure for the problem.

yes. This is why in the original fibril discussion i concentrated so 
much on scheduling performance.

to me the picture is this: conceptually the scheduler runqueue is a 
queue of work. You get items queued upon certain events, and they can 
unqueue themselves. (there is also register context but that is already 
optimized to death by hardware) So whatever scheduling overhead we have, 
it's a pure software thing. It's because we have priorities attached. 
It's because we have some legacies. Etc., etc. - it's all stuff /we/ 
wanted to add, but nothing truly fundamental on top of the basic 'work 
queueing' model.

now look at kevents as the queueing model. It does not queue 'tasks', it 
lets user-space queue requests in essence, in various states. But it's 
still the same conceptual thing: a memory buffer with some state 
associated to it. Yes, it has no legacies, it has no priorities and 
other queueing concepts attached to it ... yet. If kevents got 
mainstream, it would get the same kind of pressure to grow 'more 
advanced' event queueing and event scheduling capabilities. 
Prioritization would be needed, etc.

So my fundamental claim is: a kernel thread /is/ our main request 
structure. We've got tons of really good system calls that queue these 
'requests' around the place and offer functionality around this concept. 
Plus there's a 1.2+ billion lines of Linux userspace code that works 
well with this abstraction - while there's nary a few thousand lines of 
event-based user-space code.

I also say that you'll likely get kevents outperform threadlets. Maybe 
even significantly so under the right conditions. But i very much 
believe we want to get similar kind of performance out of thread/task 
scheduling, and not introduce a parallel framework to do request 
scheduling the hard way ... just because our task concept and scheduling 
implementation got too fat. For the same reason i didnt really like 
fibrils: they are nice, and Zach's core idea i think nicely survived in 
the syslet/threadlet model too, but they are more limited than true 
threads. So doing that parallel infrastructure, which really just 
implements the same, and is only faster because it skips features, would 
just be hiding the problem with our primary abstraction. Ok?

	Ingo
