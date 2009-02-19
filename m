Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZBSJYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZBSJYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZBSJX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:23:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56134 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbZBSJX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:23:57 -0500
Date: Thu, 19 Feb 2009 10:23:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][git pull] tracing: limit the number of loops the ring
	buffer self test can make
Message-ID: <20090219092348.GD2354@elte.hu>
References: <alpine.DEB.1.10.0902182254570.30122@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902182254570.30122@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> I added one more fix. Thinking about the solution, although 
> the disabling of the ring buffer is good enough to prevent the 
> bug you hit. I became worried about a corrupted ring buffer 
> that can cause an inifinite loop. This patch adds a fix for 
> that too.

yes, that's a good idea too:

> @@ -23,10 +23,20 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
>  {
>  	struct ring_buffer_event *event;
>  	struct trace_entry *entry;
> +	unsigned int loops = 0;
>  
>  	while ((event = ring_buffer_consume(tr->buffer, cpu, NULL))) {
>  		entry = ring_buffer_event_data(event);
>  
> +		/*
> +		 * The ring buffer is a size of trace_buf_size, if
> +		 * we loop more than the size, there's something wrong
> +		 * with the ring buffer.
> +		 */
> +		if (loops++ > trace_buf_size) {
> +			printk(KERN_CONT ".. bad ring buffer ");
> +			goto failed;
> +		}

Would be nice to also emit a WARN_ONCE() message about the test 
failure, to make sure automated tests like mine pick even 
soft-failures up.

	Ingo
