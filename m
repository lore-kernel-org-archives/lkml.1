Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYKMNUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYKMNUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYKMNUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:20:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51793 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbYKMNUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:20:10 -0500
Date: Thu, 13 Nov 2008 14:19:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
Message-ID: <20081113131939.GA2669@elte.hu>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org> <20081113084040.GD25479@elte.hu> <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com>
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

> The line count is very misleading. The 83 insertions and deletions where 
> moved code or indentation:

but that indentation is completely unnecessary:

> -               ret = ring_buffer_resize(max_tr.buffer, val);
> -               if (ret < 0) {
> -                       int r;
> -                       cnt = ret;
> -                       r = ring_buffer_resize(global_trace.buffer,
> -                                              global_trace.entries);
> -                       if (r < 0) {
> -                               /* AARGH! We are left with different
> -                                * size max buffer!!!! */
> -                               WARN_ON(1);
> -                               tracing_disabled = 1;
>                         }
> -                       goto out;
>                 }
> 
> 
> +               if (max_tr.buffer) {
> +                       ret = ring_buffer_resize(max_tr.buffer, val);
> +                       if (ret < 0) {
> +                               int r;
> +                               cnt = ret;
> +                               r = ring_buffer_resize(global_trace.buffer,
> +                                                      global_trace.entries);
> +                               if (r < 0) {
> +                                       /* AARGH! We are left with different
> +                                        * size max buffer!!!! */
> +                                       WARN_ON(1);
> +                                       tracing_disabled = 1;
> +                               }
> +                               goto out;
>                         }
>                 }

the obvious solution is to add this to ring_buffer_resize():

	if (!buffer)
		return size;

resizing a non-existent buffer should succeed. A two-liner patch. Not 
160 lines of flux.

Really, you need to think _hard_ how to avoid invasive-looking changes 
in late -rc's, because every extra line to review uses up precious 
review resources.

	Ingo
