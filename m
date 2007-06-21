Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbXFUUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbXFUUK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbXFUUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:10:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbXFUUKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:10:19 -0400
Date: Thu, 21 Jun 2007 22:09:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621200941.GB22303@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org>
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

> If somebody can actually come up with a sequence where we have 
> spinlock starvation, and it's not about an example of bad locking, and 
> nobody really can come up with any other way to fix it, we may 
> eventually have to add the notion of "fair spinlocks".

there was one bad case i can remember: the spinlock debugging code had a 
trylock open-coded loop and on certain Opterons CPUs were starving each 
other. This used to trigger with the ->tree_lock rwlock i think, on 
heavy MM loads. The starvation got so bad that the NMI watchdog started 
triggering ...

interestingly, this only triggered for certain rwlocks. Thus we, after a 
few failed attempts to pacify this open-coded loop, currently have that 
code disabled in lib/spinlock_debug.c:

 #if 0           /* This can cause lockups */
 static void __write_lock_debug(rwlock_t *lock)
 {
         u64 i;
         u64 loops = loops_per_jiffy * HZ;
         int print_once = 1;

         for (;;) {
                 for (i = 0; i < loops; i++) {
                         if (__raw_write_trylock(&lock->raw_lock))
                                 return;
                         __delay(1);
                 }

the weird thing is that we still have the _very same_ construct in 
__spin_lock_debug():

                 for (i = 0; i < loops; i++) {
                         if (__raw_spin_trylock(&lock->raw_lock))
                                 return;
                         __delay(1);
                 }

if there are any problems with this then people are not complaining loud 
enough :-)

note that because this is a trylock based loop, the acquire+release 
sequence problem should not apply to this problem.

	Ingo
