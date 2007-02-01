Return-Path: <linux-kernel-owner+w=401wt.eu-S1422844AbXBANEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422844AbXBANEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422849AbXBANEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:04:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48716 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422844AbXBANEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:04:38 -0500
Date: Thu, 1 Feb 2007 14:02:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070201130234.GA15257@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201083611.GC18233@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.3 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Zach Brown <zach.brown@oracle.com> wrote:
> 
> > This patch introduces the notion of a 'fibril'.  It's meant to be a 
> > lighter kernel thread. [...]
> 
> as per my other email, i dont really like this concept. This is the 
> killer:

let me clarify this: i very much like your AIO patchset in general, in 
the sense that it 'completes' the AIO implementation: finally everything 
can be done via it, greatly increasing its utility and hopefully its 
penetration. This is the most important step, by far.

what i dont really like /the particular/ concept above - the 
introduction of 'fibrils' as a hard distinction of kernel threads. They 
are /almost/ kernel threads, but still by being different they create 
alot of duplication and miss out on a good deal of features that kernel 
threads have naturally.

It kind of hurts to say this because i'm usually quite concept-happy - 
one can easily get addicted to the introduction of new core kernel 
concepts :-) But i really, really think we dont want to do fibrils but 
we want to do kernel threads, and i havent really seen a discussion 
about why they shouldnt be done via kernel threads.

Nor have i seen a discussion that whatever threading concept we use for 
AIO within the kernel, it is really a fallback thing, not the primary 
goal of "native" KAIO design. The primary goal of KAIO design is to 
arrive at a state machine - and for one of the most important IO 
disciplines, networking, that is reality already. (For filesystem events 
i doubt we will ever be able to build an IO state machine - but there 
are lots of crazy folks out there so it's not fundamentally impossible, 
just very, very hard.)

so my suggestions center around the notion of extending kernel threads 
to support the features you find important in fibrils:

> would it be hard to redo your AIO patches based on a pool of plain 
> simple kernel threads?
> 
> We could even extend the scheduling properties of kernel threads so 
> that they could also be 'companion threads' of any given user-space 
> task. (i.e. they'd always schedule on the same CPu as that user-space 
> task)
> 
> I bet most of the real benefit would come from co-scheduling them on 
> the same CPU. But this should be a performance property, not a basic 
> design property. (And i also think that having a limited per-CPU pool 
> of AIO threads works better than having a per-user-thread pool - but 
> again this is a detail that can be easily changed, not a fundamental 
> design property.)

but i'm willing to be convinced of the opposite as well, as always. (I'm 
real good at quickly changing my mind, especially when i'm embarrasingly 
wrong about something. So please fire away and dont hold back.)

	Ingo
