Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbXE3QLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbXE3QLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXE3QKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:10:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbXE3QKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:10:54 -0400
Date: Wed, 30 May 2007 18:09:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530160913.GA14261@elte.hu>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org> <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > To echo Uli and paraphrase an ad, "it's the interface, silly."
> 
> THERE IS NO INTERFACE! You're just making that up, and glossing over 
> the most important part of the whole thing!
> 
> If you could actually point to something specific that matches what 
> everybody needs, and is architecture-neutral, it would be a different 
> issue. As is, you're just saying "memory-mapped interfaces" without 
> actually going into enough detail to show HOW MUCH IT SUCKS.
> 
> There really are very few programs that would use them. [...]

looking over the list of our new generic APIs (see further below) i 
think there are three important things that are needed for an API to 
become widely used:

 1) it should solve a real problem (ha ;-), it should be intuitive to 
    humans and it should fit into existing things naturally.

 2) it should be ubiquitous. (if it's about IO it should cover block IO,
    network IO, timers, signals and everything) Even if it might look
    silly in some of the cases, having complete, utter, no compromises,
    100% coverage for everything massively helps the uptake of an API, 
    because it allows the user-space coder to pick just one paradigm 
    that is closest to his application and stick to it and only to it.

 3) it should be end-to-end supported by glibc.

our failed API attempts so far were:

 - sendfile(). This API mainly failed on #2. It partly failed on #1 too.
   (couldnt be used in certain types of scenarios so was unintuitive.)
   splice() fixes this almost completely.

 - KAIO. It fails on #2 and #3.

our more successful new APIs:

 - futexes. After some hickups they form the base of all modern 
   user-space locking.

 - splice. (a bit too early to tell but it's looking good so far. Would
   be nice if someone did a brute-force memcpy() based vmsplice to user
   memory, just to make usage fully symmetric.)

partially successful, not yet failed new APIs:

 - epoll. It currently fails at #2 (v2.6.22 mostly fills the gaps but
   not completely). Despite the non-complete coverage of event domains a
   good number of apps are using it, and in particular a couple really
   'high end' apps with massive amounts of event sources - which apps 
   would have no chance with poll, select or threads.

 - inotify. It's being used quite happily on the desktop, despite some
   of its limitations. (Possibly integratable into epoll?)

	Ingo
