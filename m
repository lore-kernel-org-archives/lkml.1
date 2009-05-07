Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbZEGLc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbZEGLc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZEGLcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:32:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZEGLcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:32:45 -0400
Date: Thu, 7 May 2009 13:32:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] tracing/events: add rcu locking around trace event
	prints
Message-ID: <20090507113217.GK28398@elte.hu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.467656424@goodmis.org> <alpine.DEB.2.00.0905062207370.24643@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905062207370.24643@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Somehow this patch got dropped. I believe Ted's work requires it.
> 
> I'm not sure if we need to include rcupdate.h or not to use 
> rcu_read_lock. I think it may be fine to include it in ftrace.h. 
> 
> Jeremy, does this patch effect anything that you are doing?
> 
> -- Steve
> 
> On Wed, 15 Apr 2009, Steven Rostedt wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Some trace events need to have a way to print out data that his
> > allocated, but will be freed later. Using a function that can allocate
> > memory, and free it with call_rcu, can be useful.
> > 
> > This patch adds rcu locking around the print part of the TRACE_EVENT
> > macro to facilitate this.
> > 
> > Reported-by: Theodore Tso <tytso@mit.edu>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/trace/ftrace.h |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> > index 60c5323..6fb06bd 100644
> > --- a/include/trace/ftrace.h
> > +++ b/include/trace/ftrace.h
> > @@ -62,7 +62,9 @@
> >   *
> >   *	field = (typeof(field))entry;
> >   *
> > + *	rcu_read_lock();
> >   *	ret = trace_seq_printf(s, <TP_printk> "\n");
> > + *	rcu_read_unlock();
> >   *	if (!ret)
> >   *		return TRACE_TYPE_PARTIAL_LINE;
> >   *
> > @@ -99,7 +101,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> >  									\
> >  	field = (typeof(field))entry;					\
> >  									\
> > +	rcu_read_lock();						\
> >  	ret = trace_seq_printf(s, #call ": " print);			\
> > +	rcu_read_unlock();						\
> >  	if (!ret)							\
> >  		return TRACE_TYPE_PARTIAL_LINE;				\

Hm, this patch adds usage for RCU primitives, but doesnt include 
rcupdate.h.

	Ingo
