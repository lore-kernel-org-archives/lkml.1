Return-Path: <linux-kernel-owner+w=401wt.eu-S932605AbXBNWff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbXBNWff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932625AbXBNWff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:35:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbXBNWfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:35:34 -0500
Date: Wed, 14 Feb 2007 23:32:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070214223216.GA7616@elte.hu>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org> <20070214210251.GA15025@elte.hu> <Pine.LNX.4.64.0702141321200.20368@woody.linux-foundation.org> <20070214215613.56d76257@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214215613.56d76257@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3855]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan <alan@lxorguk.ukuu.org.uk> wrote:

> >    this "AIO atom" in the first place, WHICH WE KNOW IS INCORRECT, 
> >    since current users use "aio_read()" that simply doesn't have 
> >    that and doesn't build up any such data structures.
> 
> Do current users do this because that is all they have, because it is 
> hard, or because the current option is all that makes sense ?
> 
> The ability to avoid asynchronous completion waits and 
> complete/wake/despatch cycles is a good thing of itself. [...]

yeah, that's another key thing. I do plan to provide a sys_upcall() 
syscall as well which calls a 5-parameter user-space function with a 
special stack. (it's like a lightweight signal/event handler, without 
any of the signal handler legacies and overhead - it's like a reverse 
system call - a "user call". Obviously pure userspace would never use 
sys_upcall(), unless as an act of sheer masochism.)

[ that way say a full HTTP request could be done by an asynchronous
  context, because the HTTP parser could be done as a sys_upcall(). ]

so if it's simpler/easier for a syslet to do a step in user-space - as 
long as it's an 'atom' of processing - it can be done.

or if processing is so heavily in user-space that most of the logic 
lives there then just use plain pthreads. There's just no point in 
moving complex user-space code to the syslet side if it's easier/faster 
to do it in user-space. Syslets are there for asynchronous /kernel/ 
execution, and is centered around how the kernel does stuff: system 
calls.

besides sys_upcall() i also plan two other extensions:

 - a CLONE_ASYNC_WORKER for user-space to be able use its pthread as an
   optional worker thread in the async engine. A thread executing
   user-space code qualifies as a 'busy' thread - it has to call into
   sys_async_cachemiss_thread() to 'offer' itself as a ready thread that
   the 'head' could switch to anytime.

 - support for multiple heads sharing the async context pool. All the
   locking logic is there already (because cachemiss threads can already
   access the queue), it only needs a refcount in struct async_head
   (only accessed during fork/exit), and an update to the teardown logic
   (that too is a slowpath).

	Ingo
