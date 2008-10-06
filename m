Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbYJFHlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbYJFHlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 03:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYJFHlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 03:41:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54544 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbYJFHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 03:41:08 -0400
Date: Mon, 6 Oct 2008 09:40:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tom Zanussi <zanussi@comcast.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
Subject: Re: [RFC PATCH 1/1] relay revamp v5
Message-ID: <20081006074039.GE19428@kernel.dk>
References: <1222666828.7637.180.camel@charm-linux> <20080929162743.GA15472@Krystal> <1222751080.8703.133.camel@charm-linux> <1223270572.7054.76.camel@charm-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223270572.7054.76.camel@charm-linux>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06 2008, Tom Zanussi wrote:
> The full relay patch.
> 
> Basically it includes the changes from the previous 11 that I posted and
> in addition completely separates the reading part of relay from the
> writing part.  With the new changes, relay really does become just what
> its name says and and nothing more - it accepts pages from tracers, and
> relays the data to userspace via read(2) or splice(2) (and therefore
> sendfile(2)).  It doesn't allocate any buffer space and provides no
> write functions - those are expected to be supplied by some other
> component such as the unified ring-buffer or any other tracer that might
> want relay pages of trace data to userspace.
> 
> Includes original relay write functions and buffers (the no-vmap
> page-based versions of the previous patchset), which have been split out
> into a new file called relay_pagewriter.c and provide one means of
> writing into pages and feeding them into relay.  blktrace and kvmtrace
> have been 'ported' over to using pagewriter instead of relay directly.
> 
> Signed-off-by: Tom Zanussi <zanussi@comcast.net>
> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index eb9651c..8ba7094 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -35,7 +35,7 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
>  {
>  	struct blk_io_trace *t;
>  
> -	t = relay_reserve(bt->rchan, sizeof(*t) + len);
> +	t = kmalloc(sizeof(*t) + len, GFP_KERNEL);
>  	if (t) {
>  		const int cpu = smp_processor_id();
>  

Ugh, that's no good - it's both way too expensive, and also requires an
atomic allocation.

> @@ -166,7 +168,7 @@ void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  	if (unlikely(tsk->btrace_seq != blktrace_seq))
>  		trace_note_tsk(bt, tsk);
>  
> -	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
> +	t = kmalloc(sizeof(*t) + pdu_len, GFP_KERNEL);
>  	if (t) {
>  		cpu = smp_processor_id();
>  		sequence = per_cpu_ptr(bt->sequence, cpu);

Ditto - I don't think this approach is viable at all, sorry!

-- 
Jens Axboe

