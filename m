Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbZBIJFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbZBIJFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZBIJEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:04:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36284 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbZBIJEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:04:47 -0500
Date: Mon, 9 Feb 2009 10:04:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: fweisbec@gmail.com, penberg@cs.helsinki.fi, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] trace: splice support for tracing_pipe
Message-ID: <20090209090433.GB31890@elte.hu>
References: <cover.1234159200.git.eduard.munteanu@linux360.ro> <da7111334b2e95966758bf982a7bcf3b31ccba9c.1234159200.git.eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da7111334b2e95966758bf982a7bcf3b31ccba9c.1234159200.git.eduard.munteanu@linux360.ro>
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


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> Added and implemented tracing_pipe_fops->splice_read(). This allows
> userspace programs to get tracing data more efficiently.

Cool!

The structure of the splice state machine looks good - havent tested it yet.

A few comments:

> +static struct pipe_buf_operations tracing_pipe_buf_ops = {
> +	.can_merge = 0,
> +	.map = generic_pipe_buf_map,
> +	.unmap = generic_pipe_buf_unmap,
> +	.confirm = generic_pipe_buf_confirm,
> +	.release = tracing_pipe_buf_release,
> +	.steal = generic_pipe_buf_steal,
> +	.get = generic_pipe_buf_get,
> +};

this looks nicer:

 static struct pipe_buf_operations tracing_pipe_buf_ops = {
	.can_merge	= 0,
	.map		= generic_pipe_buf_map,
	.unmap		= generic_pipe_buf_unmap,
	.confirm	= generic_pipe_buf_confirm,
	.release	= tracing_pipe_buf_release,
	.steal		= generic_pipe_buf_steal,
	.get		= generic_pipe_buf_get,
 };

(and this is how we do these things elsewhere in the tracing code)

ditto:

> +	struct splice_pipe_desc spd = {
> +		.pages = pages,
> +		.partial = partial,
> +		.nr_pages = 0, /* This gets updated below. */
> +		.flags = flags,
> +		.ops = &tracing_pipe_buf_ops,
> +		.spd_release = tracing_spd_release_pipe,
> +	};

+       for (i = 0, rem = len; i < PIPE_BUFFERS && rem; i++) {
+               pages[i] = alloc_page(GFP_KERNEL);
+
+               /* Seq buffer is page-sized, exactly what we need. */
+               for (;;) {

Ok, that's a minor bug: should check for NULL alloc_page() return.

> +out:
> +	mutex_unlock(&trace_types_lock);
> +
> +	return ret;

please name this label as 'out_err' - which it really is. We generally use the 
'out:' label for error-less exits.

Btw., this is how we do structure initializations:

>  	.open		= tracing_open_pipe,
>  	.poll		= tracing_poll_pipe,
>  	.read		= tracing_read_pipe,
> +	.splice_read	= tracing_splice_read_pipe,
>  	.release	= tracing_release_pipe,
>  };

One more thing, i'd suggest to split this loop (which is an iterator in a larger 
loop):

+               /* Seq buffer is page-sized, exactly what we need. */
+               for (;;) {
+                       count = iter->seq.len;
+                       ret = print_trace_line(iter);
[...]
+		}

Out into a separate helper inline function. This really is a "fill in pipe page" 
logic and having it separate makes it easier to review the splice-loop code pattern 
itself.

Thanks,

	Ingo
