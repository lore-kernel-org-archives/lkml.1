Return-Path: <linux-kernel-owner+w=401wt.eu-S1764199AbXHWUFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764199AbXHWUFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 16:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbXHWUFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 16:05:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761595AbXHWUFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 16:05:35 -0400
Date: Thu, 23 Aug 2007 22:05:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] s390 related scheduler patches and questions
Message-ID: <20070823200526.GA8486@elte.hu>
References: <200708232126.36475.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708232126.36475.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Another question:
> 
> nanosecond resolution seems not ideal for 64bit values, at least if an 
> architecture has to do calculations. For example our cpu timer is 
> signed 64bit and bit 51 (63=LSB) steps by one each microsecond. To 
> create a nanosecond based timer we need: nsecs= clock*125/512 or nsecs 
> = clock/512*125. The first variant overflows in a time frame that is 
> still reasonable to be seen in practice (about 2 years if I made no 
> errors), the second variant introduces a stepping rate of 125ns. Of 
> course we could use nsec = (((((((clock/8)*5)/4)*5)/4)*5)/4), to have 
> a long overflow period and a 1.25ns stepping rate but this looks quite 
> ugly. Are you going to stick with nanosecond resolution? If yes, do 
> you think a stepping rate of 125ns is ok? Any chance to change the 
> scheduler resolution to microseconds? ;-)

there are noticeable accounting artifacts on fast boxes that do 
sub-microsecond scheduling, so getting the best sched_clock() resolution 
is certainly handy. (Also, nanoseconds gives us some rounding-error 
room.) But 0.125 usecs should still be fine.

the 2 years overflow is not an issue: you could solve that by only using 
the first 55 bits of the clock. This means the clock would wrap around 
every 1.14 years - the effects of that are that the "dont let time go 
backwards" code in the scheduler will ignore a very small interval 
(which happens at the wraparound) and will continue with the 
wrapped-around clock from that point on. The rq->clock itself is a true, 
monotonic 64-bit clock that wraps every 584.9 years.

[ and even after 584.9 years it should have no serious failure mode, as 
  the timestamps are used in a relative manner. The only, minimal effect 
  is on tasks that sleep for more than 584 years - which could get a few 
  millisecs less sleeper fairness share. I am not overly worried about
  getting bugreports about that in my lifetime though =B-) (unless
  someone gets serious about bio-cryogenics R&D, real soon.) ]

	Ingo
