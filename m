Return-Path: <linux-kernel-owner+w=401wt.eu-S2993193AbXECPMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993193AbXECPMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993207AbXECPMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:12:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993193AbXECPMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:12:19 -0400
Date: Thu, 3 May 2007 16:12:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503151201.GA27281@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	rusty@rustcorp.com.au, wfg@ustc.edu
References: <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org> <20070502231104.GA26045@Krystal> <20070502162135.f949e371.akpm@linux-foundation.org> <20070503150415.GC26864@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503150415.GC26864@Krystal>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 11:04:15AM -0400, Mathieu Desnoyers wrote:
> -	blk_add_trace_rq(q, rq, BLK_TA_INSERT);
> +	MARK(blk_request_insert, "%p %p", q, rq);

I don't really like the shouting MARK name very much.  Can we have
a less-generic, less shouting name, e.g. trace_marker?  The aboe would then
be:

	trace_mark(blk_request_insert, "%p %p", q, rq);

> +#define NUM_PROBES ARRAY_SIZE(probe_array)

just get rid of this and use ARRAY_SIZE diretly below.

> +int blk_probe_connect(void)
> +{
> +	int result;
> +	uint8_t i;

just use an int for for loops.  it's easy to read and probably faster
on most systems (it the compiler isn't smart enough and promotes it
to int anyway during code generation)

> +void blk_probe_disconnect(void)
> +{
> +	uint8_t i;
> +
> +	for (i = 0; i < NUM_PROBES; i++) {
> +		marker_remove_probe(probe_array[i].name);
> +	}
> +	synchronize_sched();	/* Wait for probes to finish */

kprobes does this kind of synchronization internally, so the marker
wrapper should probabl aswell.

> +static int blk_probes_ref = 0;

no need to initialize this.

>  /*
>   * Send out a notify message.
>   */
> @@ -229,6 +233,12 @@
>  	blk_remove_tree(bt->dir);
>  	free_percpu(bt->sequence);
>  	kfree(bt);
> +	mutex_lock(&blk_probe_mutex);
> +	if (blk_probes_ref == 1) {
> +		blk_probe_disconnect();
> +		blk_probes_ref--;
> +	}

	if (--blk_probes_ref == 0)
		blk_probe_disconnect();

would probably be a tad cleaner.

> +	if (!blk_probes_ref) {
> +		blk_probe_connect();
> +		blk_probes_ref++;
> +	}

Dito here with a:

	if (!blk_probes_ref++)
		blk_probe_connect();

also the connect in the name seems rather add, what about arm/disarm instead?

>  static __init int blk_trace_init(void)
>  {
>  	mutex_init(&blk_tree_mutex);
> +	mutex_init(&blk_probe_mutex);

both should use DEFINE_MUTEX for compile-time initialization isntead.


Also it's probably better to put the trace points into blktrace.c,
that means all blktrace code can be static and self-contained.  And we
can probably do some additional cleanups by simplifying things later on.
