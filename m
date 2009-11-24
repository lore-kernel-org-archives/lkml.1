Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZKXIea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZKXIea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbZKXIe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:34:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35801 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbZKXIe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:34:29 -0500
Date: Tue, 24 Nov 2009 09:34:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more
 statistics
Message-ID: <20091124083423.GE21991@elte.hu>
References: <4B0B6E44.6090106@cn.fujitsu.com>
 <84144f020911232315h7c8b7348u9ad97f585f54a014@mail.gmail.com>
 <20091124073426.GA21991@elte.hu>
 <4B0B937F.4080906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0B937F.4080906@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> >> Hi Li,
> >>
> >> On Tue, Nov 24, 2009 at 7:25 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >>> Pekka, do you think we can remove kmemtrace now?
> >> One more use case I forgot to mention: boot time tracing. Much of the 
> >> persistent kernel memory footprint comes from the boot process which 
> >> is why it's important to be able to trace memory allocations 
> >> immediately after kmem_cache_init() has run. Can we make "perf kmem" 
> >> do that? Eduard put most of his efforts into making that work for 
> >> kmemtrace.
> > 
> > Would be lovely if someone looked at perf from that angle (and extended 
> > it).
> > 
> > Another interesting area would be to allow a capture session without a 
> > process context running immediately. (i.e. pre-allocate all the buffers, 
> > use them, for a later 'perf save' to pick it up.)
> > 
> > The two are kind of the same thing conceptually: a boot time trace is a 
> > preallocated 'process context less' recording, to be picked up after 
> > bootup.
> > 
> > [ It also brings us 'stability/persistency of event logging' - i.e. a 
> >   capture session could be started and guaranteed by the kernel to be 
> >   underway, regardless of what user-space does. ]
> > 
> > Btw., Arjan is doing a _lot_ of boot time tracing for Moblin, and he 
> > indicated it in the past that starting a perf recording session from 
> > an initrd is a pretty practical substitute as well. (I've Cc:-ed 
> > Arjan.)
> 
> It would be great if perf can be used for boot time tracing. This 
> needs pretty big work on kernel side.

What would be needed is to open per cpu events right after perf events 
initializes, and allocate memory for output buffers to them.

They would round-robin after that point, and we could use 
perf_event_open() (with a special flag) to 'attach' to them and mmap() 
them - at which point they'd turn into regular objects with a lot of 
boot time data in them.

Perhaps it should be possible to attach/detach from events in a flexible 
way, not just during bootup. (bootup tracing is just a special case of 
it.)

For example a 'flight recorder' could be started by creating the events 
and then detaching from them. Whenever some exception is flagged the 
monitoring context (whatever task that might be at that time - at 
whatever point in the future) could attach to it and save it to a file 
(or send it over any other transport of choice).

This would IMO mix the best of ftrace with the best of perf, for these 
usecases.

[ Certainly not a feature for the faint hearted :-) ]

	Ingo
