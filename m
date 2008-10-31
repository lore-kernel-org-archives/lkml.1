Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYJaJif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYJaJif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYJaJiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:38:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbYJaJiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:38:22 -0400
Date: Fri, 31 Oct 2008 10:38:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] ring-buffer: add paranoid checks for loops
Message-ID: <20081031093804.GF30317@elte.hu>
References: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com> <20081030184552.GC17822@elte.hu> <alpine.DEB.1.10.0810302314460.26352@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810302314460.26352@gandalf.stny.rr.com>
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

> +	/*
> +	 * This should normally only loop twice. But because the
> +	 * start of the reader inserts an empty page, it causes
> +	 * a case where we will loop three times. There should be no
> +	 * reason to loop four times (that I know of).
> +	 */
> +	if (unlikely(paranoid > 2)) {
> +		RB_WARN_ON(cpu_buffer, 1);
> +		reader = NULL;
> +		goto out;
> +	}
> +	paranoid++;

ok, the explanations look nice now.

A small nit - the above comment suggests that looping 4 times is the 
anomaly - still the test is for paranoid > 2 ?

> +	int paranoid = 0;

another small nit: i'd suggest to rename 'paranoid' to 'nr_loops' or 
'nr_iterations' or so. It is the _condition_ that signals paranoia, 
not the variable in itself - making the current patch look a bit 
weird.

>   again:
> +	/*
> +	 * We repeat when a timestamp is encountered. It is possible
> +	 * to get multiple timestamps from an interrupt entering just
> +	 * as one timestamp is about to be written. The max times
> +	 * that this can happen is the number of nested interrupts we
> +	 * can have.  10 should be more than enough.
> +	 */
> +	if (unlikely(paranoid > 10)) {
> +		RB_WARN_ON(cpu_buffer, 1);
> +		return NULL;

s/10 should be more than enough/Nesting higher than 10 is clearly 
anomalous/

> +	/*
> +	 * We repeat when a timestamp is encountered. It is possible
> +	 * to get multiple timestamps from an interrupt entering just
> +	 * as one timestamp is about to be written. The max times
> +	 * that this can happen is the number of nested interrupts we
> +	 * can have.  10 should be more than enough.
> +	 */
> +	if (unlikely(paranoid > 10)) {
> +		RB_WARN_ON(cpu_buffer, 1);
> +		return NULL;

ditto.

	Ingo
