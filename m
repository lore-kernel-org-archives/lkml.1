Return-Path: <linux-kernel-owner+w=401wt.eu-S932807AbZDAPZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807AbZDAPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764187AbZDAPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:25:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762473AbZDAPZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:25:11 -0400
Date: Wed, 1 Apr 2009 17:22:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, Jason Baron <jbaron@redhat.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       alexn@dsv.su.se, akpm@linux-foundation.org, alexn@telia.com,
       apw@shadowen.org, cl@linux-foundation.org, haveblue@us.ibm.com,
       kamezawa.hiroyu@jp.fujitu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: + page-owner-tracking.patch added to -mm tree
Message-ID: <20090401152251.GB23390@elte.hu>
References: <200903312321.n2VNLAMI006236@imap1.linux-foundation.org> <20090401111540.GC15442@elte.hu> <20090401125506.GA6406@csn.ul.ie> <20090401131713.GQ12966@elte.hu> <20090401133220.GB6406@csn.ul.ie> <20090401134917.GC18677@elte.hu> <1238597398.23857.11.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238597398.23857.11.camel@penberg-laptop>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Wed, 2009-04-01 at 15:49 +0200, Ingo Molnar wrote:
> > And this info could be added to that, and it would sure be nice to 
> > hook it up to kmemtrace primarily, which does a lot of similar 
> > looking work in the slab space. (but Eduard and Pekka will know how 
> > feasible/interesting this is to them.)
> 
> Yup, makes sense to me. Something like this is probably a good 
> starting point for a proper patch.

looks like an excellent starting point.

> +kmemtrace_print_page_alloc_user(struct trace_iterator *iter,
> +				struct kmemtrace_page_alloc_entry *entry)
> +{
> +	struct kmemtrace_user_event_page_alloc *ev_alloc;
> +	struct trace_seq *s = &iter->seq;
> +	struct kmemtrace_user_event *ev;
> +
> +	ev = trace_seq_reserve(s, sizeof(*ev));
> +	if (!ev)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	ev->event_id		= KMEMTRACE_USER_PAGE_ALLOC;
> +	ev->type_id		= entry->type_id;
> +	ev->event_size		= sizeof(*ev) + sizeof(*ev_alloc);
> +	ev->cpu			= iter->cpu;
> +	ev->timestamp		= iter->ts;
> +	ev->call_site		= 0ULL;	/* FIXME */
> +	ev->ptr			= 0ULL;	/* FIXME */

Here we could call save_stack_trace(), in a way like this, to save 
up to 8 entries of the allocation back-trace:

#define NR_ENTRIES		8

struct kmemtrace_user_event {
...
        unsigned long		entries[NR_ENTRIES];
...
};

        struct stack_trace trace;

        trace.nr_entries	= 0;
        trace.max_entries	= NR_ENTRIES;
        trace.entries		= ev->entries;
        trace.skip		= 2;

        save_stack_trace(&trace);

( the '2' for skip will skip the useless tracer-internal backtrace 
  bits. )

ftrace has built-in stacktrace capabilities as well - but they are 
not hooked up to the binary-tracing pathway yet - right Steve?

	Ingo
