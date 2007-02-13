Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXBMWN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXBMWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXBMWN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:13:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXBMWN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:13:28 -0500
Date: Tue, 13 Feb 2007 23:10:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213221052.GE22104@elte.hu>
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702131320450.32055@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702131320450.32055@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > If this is going to be a generic AIO subsystem:
> > 
> > - Cancellation of peding request
> 
> What about the busy_async_threads list becoming a hash/rb_tree indexed 
> by syslet_atom ptr. A cancel would lookup the thread and send a signal 
> (of course, signal handling of the async threads should be set 
> properly)?

well, each async syslet has a separate TID at the moment, so if we want 
a submitted syslet to be cancellable then we could return the TID of the 
syslet handler (instead of the NULL) in sys_async_exec(). Then 
user-space could send a signal the old-fashioned way, via sys_tkill(), 
if it so wishes.

the TID could also be used in a sys_async_wait_on() API. I.e. it would 
be a natural, readily accessible 'cookie' for the pending work. TIDs can 
be looked up lockless via RCU, so it's reasonably fast as well.

( Note that there's already a way to 'signal' pending syslets: do_exit() 
  in the user context will signal all async contexts (which results in 
  -EINTR of currently executing syscalls, wherever possible) and will 
  tear them down. But that's too crude for aio_cancel() i guess. )

	Ingo
