Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZDMVwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZDMVwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZDMVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:52:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52858 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbZDMVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:52:30 -0400
Date: Mon, 13 Apr 2009 23:52:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       fweisbec@gmail.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] tracing/filters: allow on-the-fly filter switching
Message-ID: <20090413215214.GD8514@elte.hu>
References: <1239610670.6660.49.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239610670.6660.49.camel@tropicana>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> This patch allows event filters to be safely removed or switched 
> on-the-fly while avoiding the use of rcu or the suspension of 
> tracing of previous versions.
> 
> It does it by adding a new filter_pred_none() predicate function 
> which does nothing and by never deallocating either the predicates 
> or any of the filter_pred members used in matching; the predicate 
> lists are allocated and initialized during ftrace_event_calls 
> initialization.
> 
> Whenever a filter is removed or replaced, the filter_pred_* 
> functions currently in use by the affected ftrace_event_call are 
> immediately switched over to to the filter_pred_none() function, 
> while the rest of the filter_pred members are left intact, 
> allowing any currently executing filter_pred_* functions to finish 
> up, using the values they're currently using.
> 
> In the case of filter replacement, the new predicate values are 
> copied into the old predicates after the above step, and the 
> filter_pred_none() functions are replaced by the filter_pred_* 
> functions for the new filter.  In this case, it is possible though 
> very unlikely that a previous filter_pred_* is still running even 
> after the filter_pred_none() switch and the switch to the new 
> filter_pred_*.  In that case, however, because nothing has been 
> deallocated in the filter_pred, the worst that can happen is that 
> the old filter_pred_* function sees the new values and as a result 
> produces either a false positive or a false negative, depending on 
> the values it finds.
> 
> So one downside to this method is that rarely, it can produce a 
> bad match during the filter switch, but it should be possible to 
> live with that, IMHO.

Yeah.

It is really a strong thing to avoid RCU here. Instrumentation 
should be self-sufficient to a large degree, and it does not get any 
more lowlevel than filter expression evaluation engine. Forcing the 
use of rcu_read_lock() there would limit its utility.

> The other downside is that at least in this patch the predicate 
> lists are always pre-allocated, taking up memory from the start.  
> They could probably be allocated on first-use, and de-allocated 
> when tracing is completely stopped - if this patch makes sense, I 
> could create another one to do that later on.

That's not a big issue IMO.

> Oh, and it also places a restriction on the size of __arrays in 
> events, currently set to 128, since they can't be larger than the 
> now embedded str_val arrays in the filter_pred struct.

that's OK too - we really want pre-calculated filter expressions and 
as atomic evaluations as possible. So having the maximum width 
specified is no big deal.

The only exception would be if we ever do PATH_MAX type of field 
value comparisons - and i dont see any reason why not, once tracing 
is extended to the VFS or once the syscall tracer . That would 
increase it to 4096 bytes, making the max kzalloc larger than page 
size - still not outrageous so not a big problem. Just lets keep it 
in mind that 128 is a bit on the low side.

also:

> +     if (!val_str || !strlen(val_str)
> +         || strlen(val_str) >= MAX_FILTER_STR_VAL) {
>               pred->field_name = NULL;
>               return -EINVAL;
>	}

it might be quite cryptic to the user why a complex expression was 
not installed. I think a single-line KERN_INFO syslog entry would be 
most helpful.

	Ingo
