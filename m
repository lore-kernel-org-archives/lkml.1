Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXB1XUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXB1XUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXB1XUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:20:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbXB1XUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:20:22 -0500
Date: Thu, 1 Mar 2007 00:12:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070228231228.GA12328@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I would repeat my call for getting rid of the atoms, and instead 
> just do a "single submission" at a time. Do the linking by running a 
> threadlet that has user space code (and the stack overhead), which is 
> MUCH more flexible. And do nonlinked single system calls without 
> *either* atoms *or* a user-space stack footprint.

I agree that threadlets are much more flexible - and they might in fact 
win in the long run due to that.

i'll add a one-shot syscall API in v6 and then we'll be able to see them 
side by side. (wanted to do that in v5 but it got delayed by x86_64 
issues, x86_64's entry code is certainly ... tricky wrt. ptregs saving)

wrt. one-shot syscalls, the user-space stack footprint would still 
probably be there, because even async contexts that only do single-shot 
processing need to drop out of kernel mode to handle signals. We could 
probably hack the signal routing code to never deliver to such threads 
(but bounce it over to the head context, which is always available) but 
i think that would be a bit messy. (i dont exclude it though)

I think syslets might also act as a prototyping platform for new system 
calls. If any particular syslet atom string comes up more frequently 
(and we could even automate the profiling of that within the kernel), 
then it's a good candidate for a standalone syscall. Currently we dont 
have such information in any structured way: the connection between 
streams of syscalls done by applications is totally opaque to the 
kernel.

Also, i genuinely believe that to be competitive (performance-wise) with 
fully in-kernel queueing solutions, we need syslets - the syslet NULL 
overhead is 20 cycles (this includes copying, engine overhead, etc.), 
the syscall NULL overhead is 280-300 cycles. It could probably be made 
more capable by providing more special system calls like sys_upcall() to 
execute a user-space function. (that way a syslet could still execute 
user-space code without having to exit out of kernel mode too 
frequently) Or perhaps a sys_x86_bytecode() call, that would execute a 
pre-verified, kernel-stored sequence of simplified x86 bytecode, using 
the kernel stack.

My fear is that if we force all these things over to one-shot syscalls 
or threadlets then this will become another second-tier mechanism. By 
providing syslets we give the message: "sure, come on and play within 
the kernel if you want to, but it's not easy".

	Ingo
