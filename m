Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbXEUHgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbXEUHgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbXEUHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:36:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbXEUHgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:36:11 -0400
Date: Mon, 21 May 2007 09:36:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Lee Revell <rlrevell@joe-job.com>,
       Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Preempt of BKL and with tickless systems
Message-ID: <20070521073602.GC3915@elte.hu>
References: <4640E64D.3070304@tmr.com> <75b66ecd0705081701n414c29f7r74b0e4836798393a@mail.gmail.com> <46438C54.20101@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46438C54.20101@tmr.com>
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


* Bill Davidsen <davidsen@tmr.com> wrote:

> > This was introduced by Ingo to solve a real problem that I found, 
> > where some codepath would hold the BKL for long enough to introduce 
> > excessive scheduling latencies - search list archive for details.  
> > But I don't remember the code path (scrolling the FB console?  VT 
> > switching? reiser3?  misc. ioctl()s?).  Basically, taking the BKL 
> > disabled preemption which caused long latencies.
> >
> > It's certainly possible that whatever issue led to this was solved 
> > in another way since.
>
> Anything is possible. I feel that using voluntary + bkl is probably 
> good for most servers, forced preempt for desktop, although it really 
> doesn't seem to do much beyond voluntary.

yeah - we default to PREEMPT_BKL on plain SMP kernels, so it's enabled 
on the majority of enterprise distros and it's working pretty well in 
practice.

even today there are a couple of bad BKL latencies still: Lee mentioned 
ioctls and reiser3 - neither has been fixed since i wrote 
CONFIG_PREEMPT_BKL two years ago. Turning the BKL into a semaphore does 
not reduce BKL latencies itself, but it makes all _other_ workloads 
schedule sanely and without delay. With PREEMPT_BKL disabled (which 
turns on the big kernel spinlock again) any big BKL delay is immediately 
felt by other tasks too, because we waste that CPU time spinning on the 
big kernel spinlock.

	Ingo
