Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYGLSBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYGLSBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 14:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYGLSBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 14:01:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYGLSBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 14:01:15 -0400
Date: Sat, 12 Jul 2008 11:00:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080712075532.13483b21@infradead.org>
Message-ID: <alpine.LFD.1.10.0807121044000.2875@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org> <4878883F.10004@gmail.com> <4878B4B5.5060007@gmail.com> <20080712075532.13483b21@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Arjan van de Ven wrote:
> 
> I see really bad delays on 32 bit as well, but they go away for me if I
> do
> echo 4096 > /sys/block/sda/queue/nr_requests

Hmm. I think the default is 128, and in many cases latencies should 
actually go up with bigger requests queues - especially if it means that 
you can have a lot more writes in front of the read. You see the opposite 
behaviour.

That could easily happen if the scheduler is crazy and lets writes use up 
all of the request queue, or if the limited queue means that it cannot 
effectively merge requests. But request merging should happen trivially 
for the contiguous 'dd' case almost regardless of queue size, so I wonder 
if something else is going on.

Ahh.. I see something _very_ suspicious.

Look at block/blk-core.c: get_request(). It starts throttling and batching 
requests when it gets

	if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {

and notice how this is independent of whether it's a read or a write (but 
it does count them separately). But on the wakeup path, it uses different 
limits for reads than for writes.

That batching looks pretty bogus for reads to begin with, and then 
behaving similarly on throttling but differently on wakup sounds bogus.

The blk_alloc_request() also ends up allocating all requests from one 
mempool, so if that mempool runs out (due to writes having used them all 
up), then those writes will block reads too, even though reads should have 
much higher priority.

I dunno. But there _has_ been a lot of churn in the different block queues 
over the last few months. I wouldn't be surprised at all if something got 
broken in the process. And as with filesystems, almost all performance 
tests are for throughput, not "bad latency" in the presense of other 
heavy IO.

		Linus
