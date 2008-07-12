Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYGLSPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYGLSPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 14:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYGLSPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 14:15:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:49024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYGLSPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 14:15:34 -0400
Date: Sat, 12 Jul 2008 11:15:01 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
Message-ID: <20080712111501.30b91f58@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0807121044000.2875@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain>
	<20080711054605.GA17851@elte.hu>
	<alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org>
	<alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org>
	<4878883F.10004@gmail.com>
	<4878B4B5.5060007@gmail.com>
	<20080712075532.13483b21@infradead.org>
	<alpine.LFD.1.10.0807121044000.2875@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 11:00:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sat, 12 Jul 2008, Arjan van de Ven wrote:
> > 
> > I see really bad delays on 32 bit as well, but they go away for me
> > if I do
> > echo 4096 > /sys/block/sda/queue/nr_requests
> 
> Hmm. I think the default is 128, and in many cases latencies should 
> actually go up with bigger requests queues - especially if it means
> that you can have a lot more writes in front of the read. You see the
> opposite behaviour.

well... so far my assumption on this has been this:
CFQ is good at fairness, and manages to control latency between
processes in some fair way (eg if one guy is slamming the disk and
someone else needs to page in a 4Kb page but is otherwise not doing
IO... CFQ will let the pagefault skip ahead to a large degree) .
However... the 128 limit happens BEFORE CFQ gets involved and suddenly
the 4kb pagefault has to wait for everything that's pending


> Look at block/blk-core.c: get_request(). It starts throttling and
> batching requests when it gets
> 
> 	if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {
> 
> and notice how this is independent of whether it's a read or a write
> (but it does count them separately). But on the wakeup path, it uses
> different limits for reads than for writes.
> 
> That batching looks pretty bogus for reads to begin with, and then 
> behaving similarly on throttling but differently on wakup sounds
> bogus.
> 
> The blk_alloc_request() also ends up allocating all requests from one 
> mempool, so if that mempool runs out (due to writes having used them
> all up), then those writes will block reads too, even though reads
> should have much higher priority.
> 
> I dunno. But there _has_ been a lot of churn in the different block
> queues over the last few months. I wouldn't be surprised at all if
> something got broken in the process. And as with filesystems, almost
> all performance tests are for throughput, not "bad latency" in the
> presense of other heavy IO.

what I'm seeing is not super new; even 2.6.25 has the behavior already
(and with latencytop it's very visible behavior; before changing the
tunable I see 2+ second delays in user apps, after the tunable change
they're down significantly)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
