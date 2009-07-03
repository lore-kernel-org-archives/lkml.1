Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZGCJz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZGCJz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbZGCJzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:55:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZGCJzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:55:51 -0400
Date: Fri, 3 Jul 2009 11:55:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kmemtrace: print binary output only if 'bin' option
	is set
Message-ID: <20090703095547.GE21141@elte.hu>
References: <4A4DD0A0.5060500@cn.fujitsu.com> <20090703095456.GA3505@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703095456.GA3505@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Fri, Jul 03, 2009 at 05:34:24PM +0800, Li Zefan wrote:
> > Currently by default the output of kmemtrace is binary format instead
> > of human-readable output.
> > 
> > This patch makes the following changes:
> >   - We'll see human-readable output by default
> >   - We'll see binary output if 'bin' option is set
> > 
> > Note: you may probably need to explicitly disable context-info binary
> >       output:
> > 
> > 	# echo 0 > options/context-info
> > 	# echo 1 > options/bin
> > 	# cat trace_pipe
> > 
> > v2:
> > - use %pF to print call_site
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> > Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  kernel/trace/kmemtrace.c |  120 ++++++++++++++++++++++++++++++++++-----------
> >  1 files changed, 90 insertions(+), 30 deletions(-)
> > 
> > diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
> > index 1edaa95..74903b6 100644
> > --- a/kernel/trace/kmemtrace.c
> > +++ b/kernel/trace/kmemtrace.c
> > @@ -239,12 +239,52 @@ struct kmemtrace_user_event_alloc {
> >  };
> >  
> >  static enum print_line_t
> > -kmemtrace_print_alloc_user(struct trace_iterator *iter,
> > -			   struct kmemtrace_alloc_entry *entry)
> > +kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
> > +{
> > +	struct trace_seq *s = &iter->seq;
> > +	struct kmemtrace_alloc_entry *entry;
> > +	int ret;
> > +
> > +	trace_assign_type(entry, iter->ent);
> > +
> > +	ret = trace_seq_printf(s, "type_id %d call_site %pF ptr %lu "
> > +	    "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
> > +	    entry->type_id, (void *)entry->call_site, (unsigned long)entry->ptr,
> > +	    (unsigned long)entry->bytes_req, (unsigned long)entry->bytes_alloc,
> > +	    (unsigned long)entry->gfp_flags, entry->node);
> > +
> > +	if (!ret)
> > +		return TRACE_TYPE_PARTIAL_LINE;
> > +	return TRACE_TYPE_HANDLED;
> > +}
> 
> [snip]
> 
> kmemtrace_print_alloc_user() is meant for kmemtrace-user, that's 
> what the naming is meant to convey. Also, 
> kmemtrace_print_alloc_user_bin is kinda long. Could you leave the 
> former as it was and come up with another name for the non-binary 
> variant?

should i hold off on this patch for now?

	Ingo
