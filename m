Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbXFUURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbXFUURW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759590AbXFUURF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:17:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48589 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbXFUURC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:17:02 -0400
Date: Thu, 21 Jun 2007 22:16:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Miklos Szeredi <miklos@szeredi.hu>, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070621201624.GD22303@elte.hu>
References: <20070620093612.GA1626@ff.dom.local> <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org> <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org> <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
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

> It's in fact entirely possible that the long freezes have always been 
> there, but the NOHZ option meant that we had much longer stretches of 
> time without things like timer interrupts to jumble up the timing! So 
> maybe the freezes existed before, but with timer interrupts happening 
> hundreds of times a second, they weren't noticeable to humans.

the freezes that Miklos was seeing were hardirq contexts blocking in 
task_rq_lock() - that is done with interrupts disabled. (Miklos i think 
also tried !NOHZ kernels and older kernels, with a similar result.)

plus on the ptrace side, the wait_task_inactive() code had most of its 
overhead in the atomic op, so if any timer IRQ hit _that_ core, it was 
likely while we were still holding the runqueue lock!

i think the only thing that eventually got Miklos' laptop out of the 
wedge were timer irqs hitting the ptrace CPU in exactly those 
instructions where it was not holding the runqueue lock. (or perhaps an 
asynchronous SMM event delaying it for a long time)

	Ingo
