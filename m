Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbXFUVHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbXFUVHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXFUVHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:07:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbXFUVHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:07:07 -0400
Date: Thu, 21 Jun 2007 23:06:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621210630.GA7521@elte.hu>
References: <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org> <20070621200941.GB22303@elte.hu> <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org> <20070621203013.GA466@elte.hu> <alpine.LFD.0.98.0706211342230.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211342230.3593@woody.linux-foundation.org>
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

> On Thu, 21 Jun 2007, Ingo Molnar wrote:
> > 
> > damn, i first wrote up an explanation about why that ugly __delay(1) is 
> > there (it almost hurts my eyes when i look at it!) but then deleted it 
> > as superfluous :-/
> 
> I'm fine with a delay, but the __delay(1) is simply not "correct". It 
> doesn't do anything.

it's a bit trickier than that. Yes, it's a simple 1-entry loop and thus 
makes little sense to call. But it's a loop that got boot-time 
calibrated, so we can do this in the spinlock-debug code:

        u64 loops = loops_per_jiffy * HZ;

this guarantees that we will loop for _at least_ 1 second before 
printing a message. (in practice it's much longer, especially with the 
current naive trylock approach)

Why? Because as part of the activities that the spin-loop does, we also 
do everything that an mdelay(1000) would do. We do it 'piecemail-wise', 
and we do it very inefficiently, but the lower time-bound should be 
guaranteed. This is done because most of the problems were caused by too 
short looping and bogus debug printouts. So this is basically an 
open-coded udelay implementation.

Furthermore, with the spin_is_locked() fix i just sent, the __loop(1) 
solution should actually be quite close to a real udelay() thing, 
without the delay effect. It would probably more accurate to increase it 
to loops_per_jiffy*10*HZ/16 and to call a __loop(16) thing, to get 
closer timings. (but then some people would argue 'why dont you take the 
lock as soon as it's released'.)

	Ingo
