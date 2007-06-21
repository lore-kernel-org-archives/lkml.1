Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbXFUUbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbXFUUbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbXFUUau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:30:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080AbXFUUat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:30:49 -0400
Date: Thu, 21 Jun 2007 22:30:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621203013.GA466@elte.hu>
References: <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org> <20070621200941.GB22303@elte.hu> <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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

> >          for (;;) {
> >                  for (i = 0; i < loops; i++) {
> >                          if (__raw_write_trylock(&lock->raw_lock))
> >                                  return;
> >                          __delay(1);
> >                  }
> 
> What a piece of crap. 
> 
> Anybody who ever waits for a lock by busy-looping over it is BUGGY, 
> dammit!
> 
> The only correct way to wait for a lock is:
> 
>   (a) try it *once* with an atomic r-m-w 
>   (b) loop over just _reading_ it (and something that implies a memory 
>       barrier, _not_ "__delay()". Use "cpu_relax()" or "smp_rmb()")
>   (c) rinse and repeat.

damn, i first wrote up an explanation about why that ugly __delay(1) is 
there (it almost hurts my eyes when i look at it!) but then deleted it 
as superfluous :-/

really, it's not because i'm stupid (although i might still be stupid 
for other resons ;-), it wasnt there in earlier spin-debug versions. We 
even had an inner spin_is_locked() loop at a stage (and should add it 
again).

the reason for the __delay(1) was really mundane: to be able to figure 
out when to print a 'we locked up' message to the user. If it's 1 
second, it causes false positive on some systems. If it's 10 minutes, 
people press reset before we print out any useful data. It used to be 
just a loop of rep_nop()s, but that was hard to calibrate: on certain 
newer hardware it was triggering as fast as in 2 seconds, causing many 
false positives. We cannot use jiffies nor any other clocksource in this 
debug code.

so i settled for the butt-ugly but working __delay(1) thing, to be able 
to time the debug messages.

	Ingo
