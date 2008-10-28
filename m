Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYJ1O4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYJ1O4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 10:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYJ1O4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 10:56:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYJ1O4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 10:56:39 -0400
Date: Tue, 28 Oct 2008 10:49:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: LKML <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC] trace: profile likely and unlikely annotations
In-Reply-To: <20081028143720.GD8869@mit.edu>
Message-ID: <alpine.DEB.1.10.0810281045040.29482@gandalf.stny.rr.com>
References: <170fa0d20810271529g3c64ae89me29ed8b65a9c3b5e@mail.gmail.com> <alpine.DEB.1.10.0810271918390.19731@gandalf.stny.rr.com> <20081028001340.GB9797@mit.edu> <alpine.DEB.1.10.0810272316270.802@gandalf.stny.rr.com> <20081028143720.GD8869@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 28 Oct 2008, Theodore Tso wrote:

> On Tue, Oct 28, 2008 at 12:12:48AM -0400, Steven Rostedt wrote:
> > 
> > Andrew Morton recently suggested having an in-kernel way to profile
> > likely and unlikely macros. This patch achieves that goal.
> 
> Maybe I'm confused, but when I read through the patch, it looks like
> that 'hit' is incremented whenever the condition is true, and 'missed'
> is incremented whenever the condition is false, correct?

Correct.

> 
> Is that what you intended?  So for profile_unlikely, "missed" is good,
> and "hit" is bad, and for profile_likely, "hit" is good, and "missed"
> is bad.  That seems horribly confusing.

Correct. Yeah, I figured I'd get complaints about this (hence the RFC).
If you look at my awk example, you will also notice that I switched the
$1 and $2 around when reading the other file.

This can be confusing either way. I did this to reuse the code for both 
outputs.

> 
> If that wasn't what you intended, the meaning of "hit" and "missed"
> seems to be highly confusing, either way.  Can we perhaps use some
> other terminology?  Simply using "True" and "False" would be better,
> since there's no possible confusion what the labels mean.   

So renaming 'hit' and 'miss' to 'True' and 'False' would be good enough?
That is, it will still mean that a 'True' is bad for unlikely but good for 
a likely?

> 
> > +#define unlikely(x) ({							\
> > +			int ______r;					\
> > +			static struct ftrace_likely_data ______f	\
> > +				__attribute__((__aligned__(4)))		\
> > +				__attribute__((section("_ftrace_unlikely"))); \
> > +			if (unlikely_notrace(!______f.ip))		\
> > +				______f.ip = __THIS_IP__;		\
> > +			______r = unlikely_notrace(x);			\
> > +			ftrace_likely_update(&______f, ______r);	\
> > +			______r;					\
> > +		})
> 
> Note that unlikely(x) calls ftrace_likely_update(), which does this:
> 
> > +void ftrace_likely_update(struct ftrace_likely_data *f, int val)
> > +{
> > +	/* FIXME: Make this atomic! */
> > +	if (val)
> > +		f->hit++;
> > +	else
> > +		f->missed++;
> > +}
> > +EXPORT_SYMBOL(ftrace_likely_update);
> 
> 
> So that seems to mean that if unlikely(x) is false, then _____r is 0,
> which means we increment f->missed.   Or am I missing something?
> 
> I would have thought that if unlikely(x) is false, that's *good*,
> since it means the unlikely label was correct.  And normally, when
> people think about cache hits vs cache misses, hits are good and
> misses are bad.  Which is why I think the terminology is highly
> confusing...

OK, I'm fine with changing the terminology. v2 will do:

  s/hit/True/
  s/missed/False/

Fine with you?

-- Steve

