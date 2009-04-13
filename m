Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZDMWaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZDMWaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZDMWaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:30:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59766 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbZDMWaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:30:04 -0400
Date: Tue, 14 Apr 2009 00:29:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/filters: allow user-input to be
	integer-like string
Message-ID: <20090413222951.GG8514@elte.hu>
References: <49E2A594.4060306@cn.fujitsu.com> <20090413144513.GF5977@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413144513.GF5977@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Apr 13, 2009 at 10:38:12AM +0800, Li Zefan wrote:
> > Suppose we would like to trace all tasks named '123', but this
> > will fail:
> >  # echo 'parent_comm == 123' > events/sched/sched_process_fork/filter
> >  bash: echo: write error: Invalid argument
> > 
> > Don't guess the type of the filter pred in filter_parse(), but instead
> > we check it in filter_add_pred().
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/trace/trace_events_filter.c |   26 +++++++++++++-------------
> >  1 files changed, 13 insertions(+), 13 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > index 9f8ecca..a63f965 100644
> > --- a/kernel/trace/trace_events_filter.c
> > +++ b/kernel/trace/trace_events_filter.c
> > @@ -229,6 +229,7 @@ static int is_string_field(const char *type)
> >  int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
> >  {
> >  	struct ftrace_event_field *field;
> > +	unsigned long long val;
> >  
> >  	field = find_event_field(call, pred->field_name);
> >  	if (!field)
> > @@ -237,14 +238,14 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
> >  	pred->offset = field->offset;
> >  
> >  	if (is_string_field(field->type)) {
> > -		if (!pred->str_val)
> > -			return -EINVAL;
> >  		pred->fn = filter_pred_string;
> >  		pred->str_len = field->size;
> >  		return __filter_add_pred(call, pred);
> >  	} else {
> > -		if (pred->str_val)
> > +		if (strict_strtoull(pred->str_val, 0, &val))
> >  			return -EINVAL;
> > +		pred->val = val;
> > +		kfree(pred->str_val);
> 
> 
> And you might also want to do
> pred->str_val = NULL;
> Otherwise filter_free_pred() may crash later:
> 
> void filter_free_pred(struct filter_pred *pred)
> {
> 	if (!pred)
> 		return;
> 
> 	kfree(pred->field_name);
> 	kfree(pred->str_val);
> 	kfree(pred);
> }
> 
> 
> Other than that, it looks good.

This also conflicts with Tom's rewrite of the filter engine to make 
it on-the-fly modifiable.

Li, mind reworking your series against latest -tip? (it has Tom's 
patch included already)

Also, it would be nice to hear Tom's opinion about this series as 
well. I know there's new parsing features planned - if it's better 
that way then Tom you might want to pick up Li's patches and submit 
them together with any pending or upcoming changes? We can apply 
them directly too if that's easier to you.

Thanks,

	Ingo
