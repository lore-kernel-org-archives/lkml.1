Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYJ1Ohe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYJ1Ohe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYJ1Oh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:37:26 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:59738 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752110AbYJ1OhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:37:25 -0400
Date: Tue, 28 Oct 2008 10:37:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
Message-ID: <20081028143720.GD8869@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Mike Snitzer <snitzer@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 12:12:48AM -0400, Steven Rostedt wrote:
> 
> Andrew Morton recently suggested having an in-kernel way to profile
> likely and unlikely macros. This patch achieves that goal.

Maybe I'm confused, but when I read through the patch, it looks like
that 'hit' is incremented whenever the condition is true, and 'missed'
is incremented whenever the condition is false, correct?

Is that what you intended?  So for profile_unlikely, "missed" is good,
and "hit" is bad, and for profile_likely, "hit" is good, and "missed"
is bad.  That seems horribly confusing.

If that wasn't what you intended, the meaning of "hit" and "missed"
seems to be highly confusing, either way.  Can we perhaps use some
other terminology?  Simply using "True" and "False" would be better,
since there's no possible confusion what the labels mean.   

> +#define unlikely(x) ({							\
> +			int ______r;					\
> +			static struct ftrace_likely_data ______f	\
> +				__attribute__((__aligned__(4)))		\
> +				__attribute__((section("_ftrace_unlikely"))); \
> +			if (unlikely_notrace(!______f.ip))		\
> +				______f.ip = __THIS_IP__;		\
> +			______r = unlikely_notrace(x);			\
> +			ftrace_likely_update(&______f, ______r);	\
> +			______r;					\
> +		})

Note that unlikely(x) calls ftrace_likely_update(), which does this:

> +void ftrace_likely_update(struct ftrace_likely_data *f, int val)
> +{
> +	/* FIXME: Make this atomic! */
> +	if (val)
> +		f->hit++;
> +	else
> +		f->missed++;
> +}
> +EXPORT_SYMBOL(ftrace_likely_update);


So that seems to mean that if unlikely(x) is false, then _____r is 0,
which means we increment f->missed.   Or am I missing something?

I would have thought that if unlikely(x) is false, that's *good*,
since it means the unlikely label was correct.  And normally, when
people think about cache hits vs cache misses, hits are good and
misses are bad.  Which is why I think the terminology is highly
confusing...

      	       		 	      	    - Ted
