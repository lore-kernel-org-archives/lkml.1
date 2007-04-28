Return-Path: <linux-kernel-owner+w=401wt.eu-S965933AbXD1Qhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965933AbXD1Qhx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965940AbXD1Qhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:37:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60290 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965933AbXD1Qhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:37:52 -0400
Date: Sat, 28 Apr 2007 18:37:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS is under heavy write load (massive starvation)
Message-ID: <20070428163740.GA17061@elte.hu>
References: <1177660767.6567.41.camel@Homer.simpson.net> <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org> <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz> <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org>
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

> Even with a good software IO scheduler, when you have disks that do 
> tagged queueing, if you fill up the disk queue with a few dozen 
> (depends on the disk what the queue limit is) huge write requests, it 
> doesn't really matter if the _software_ queuing then gives a big 
> advantage to reads coming in. They'll _still_ be waiting for a long 
> time, especially since you don't know what the disk firmware is going 
> to do.

by far the largest advantage of tagged queueing is when we go from 1 
pending request to 2 pending requests. The rest helps too for certain 
workloads (especially benchmarks), but if the IRQ handling is fast 
enough, having just 2 is more than enough to get 80% of the advantage of 
say of hardware-queue with a depth of 64.

So perhaps if there's any privileged reads going on then we should limit 
writes to a depth of 2 at most, with some timeout mechanism that would 
gradually allow the deepening of the hardware queue, as long as no 
highprio reads come inbetween? With 2 pending requests and even assuming 
worst-case seeks the user-visible latency would be on the order of 20-30 
msecs, which is at the edge of human perception. The problem comes when 
a hardware queue of 32-64 entries starves that one highprio read which 
then results in a 2+ seconds latency.

	Ingo
