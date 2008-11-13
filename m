Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYKMOBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYKMOBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 09:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYKMOBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 09:01:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYKMOBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 09:01:24 -0500
Date: Thu, 13 Nov 2008 15:01:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
Message-ID: <20081113140102.GA14258@elte.hu>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org> <20081113084040.GD25479@elte.hu> <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com> <20081113131939.GA2669@elte.hu> <alpine.DEB.1.10.0811130848450.7458@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811130848450.7458@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 13 Nov 2008, Ingo Molnar wrote:
> > 
> > the obvious solution is to add this to ring_buffer_resize():
> > 
> > 	if (!buffer)
> > 		return size;
> 
> Having a NULL buffer return a successful resize is a bit worrisome to me.
> 
> And looking at the code I was trying to make sure could never be called
> if there are no max_tr users:
> 
> in update_max_tr
> 
> 	buf = tr->buffer;
> 	tr->buffer = max_tr.buffer;
> 	max_tr.buffer = buf;
> 
> Should all the ring buffer API return success on NULL pointers?

well, update_max_tr() is only used from tracers which also actually 
allocate a max trace buffer: irqs/preemptoff, sched-wakeup.

So, can you tell me any way how the patch below could be broken?

	Ingo

------------->
>From ee51a1de7e3837577412be269e0100038068e691 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 13 Nov 2008 14:58:31 +0100
Subject: [PATCH] tracing: fix mmiotrace resizing crash

Pekka reported a crash when resizing the mmiotrace tracer (if only
mmiotrace is enabled).

This happens because in that case we do not allocate the max buffer,
but we try to use it.

Make ring_buffer_resize() idempotent against NULL buffers.

Reported-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ring_buffer.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 231db20..036456c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -538,6 +538,12 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 	LIST_HEAD(pages);
 	int i, cpu;
 
+	/*
+	 * Always succeed at resizing a non-existent buffer:
+	 */
+	if (!buffer)
+		return size;
+
 	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	size *= BUF_PAGE_SIZE;
 	buffer_size = buffer->pages * BUF_PAGE_SIZE;
