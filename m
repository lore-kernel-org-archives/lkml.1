Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYFLPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYFLPaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYFLP3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:29:51 -0400
Received: from www.tglx.de ([62.245.132.106]:42606 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYFLP3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:29:50 -0400
Date: Thu, 12 Jun 2008 17:24:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
In-Reply-To: <1213278286.16459.29.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0806121636380.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>  <20080611204917.523866467@mvista.com>  <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>  <1213277402.16459.25.camel@localhost.localdomain>  <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
 <1213278286.16459.29.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008, Daniel Walker wrote:
> On Thu, 2008-06-12 at 15:33 +0200, Thomas Gleixner wrote:
> > On Thu, 12 Jun 2008, Daniel Walker wrote:
> > > On Thu, 2008-06-12 at 10:56 +0200, Thomas Gleixner wrote:
> > > > Please stop wasting everyone's time with that.
> > > 
> > > It achieves correct ordering of the futex waiters inside the kernel,
> > > that is in fact _something_ ..
> > 
> > Yeah, just something _useless_
> 
> Just because you don't use it, doesn't make it useless .. At least
> there's enough people asking for this that it warrants me writing it..

Which is not really a good technical reason to merge such a
patch. Your handwaving about "enough people" is just irrelevant. Are
you going to implement a root hole as well when enough people ask for
it ?

But there is also a Real Good technical reason why these patches are
going nowhere else than into /dev/null:

 your approach of hijacking blocked_on is fundamentaly wrong as it
 mixes kernel internal state with user space state.

 It will break in preempt-rt at the point when this state is set and
 the code blocks on a spinlock, which uses the rtmutex based sleeping
 spinlock implementation and overwrites blocked_on.

 If it can acquire the spinlock in the fast path without modifying
 blocked_on it will cause trouble with the priority boosting chain
 when a higher priority task becomes blocked on the spinlock.


If there would be a real good technical reason to fix this priority
ordering it could be done with less than 20 lines of code without
extra locking and wreckage waiting left and right, but I have not yet
seen a single convincing technical argument or a relevant use case
which might justify that.

Thanks,

	tglx
