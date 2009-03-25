Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZCYKIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZCYKIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZCYKI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:08:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZCYKI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:08:27 -0400
Date: Wed, 25 Mar 2009 11:07:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tim Bird <tim.bird@am.sony.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5][RFC] tracing: move function profiler data out of
	function struct
Message-ID: <20090325100746.GI2341@elte.hu>
References: <20090325035646.662994901@goodmis.org> <20090325040832.443420395@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325040832.443420395@goodmis.org>
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

> +/* Interrupts must be disabled calling this */
> +static struct ftrace_profile *
> +ftrace_profile_alloc(unsigned long ip, bool alloc_safe)
> +{
> +	struct ftrace_profile *rec = NULL;
> +
> +	/* prevent recursion */
> +	if (atomic_inc_return(&__get_cpu_var(ftrace_profile_disable)) != 1)
> +		goto out;
> +
> +	__raw_spin_lock(&ftrace_profile_rec_lock);
> +
> +	/* Try to always keep another page available */
> +	if (!profile_pages->next && alloc_safe)
> +		profile_pages->next = (void *)get_zeroed_page(GFP_ATOMIC);

this does not seem to be NMI safe.

This all would be solved much more robustly by the function 
attributes hash approach i suggested in the previous mail. If 
percpu_alloc() is done for 20,000 functions the memory allocation 
overhead is no big deal.

	Ingo
