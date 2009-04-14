Return-Path: <linux-kernel-owner+w=401wt.eu-S1753068AbZDNEVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbZDNEVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZDNEVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:21:31 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28042 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZDNEVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NSbAT56qWA7yIw9YaQRnRNc4EeYDdtdp6NYv03Teb7351hThPXfsbL4VxUtmNK9f3O
         wOJAI3KJ3Sa66OlmiKVGHtkOH+edhZiNnODS0rZIuulfZskVyOXH796nN6iZJxU3XQRG
         5JrXR5ZXXXc9NcurnfPXaYM3r+oVoNGCZeOhU=
Subject: Re: [PATCH 1/3] tracing/filters: allow user-input to be
 integer-like string
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090413222951.GG8514@elte.hu>
References: <49E2A594.4060306@cn.fujitsu.com>
	 <20090413144513.GF5977@nowhere>  <20090413222951.GG8514@elte.hu>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 23:21:27 -0500
Message-Id: <1239682887.7011.54.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 00:29 +0200, Ingo Molnar wrote:
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Apr 13, 2009 at 10:38:12AM +0800, Li Zefan wrote:
> > > Suppose we would like to trace all tasks named '123', but this
> > > will fail:
> > >  # echo 'parent_comm == 123' > events/sched/sched_process_fork/filter
> > >  bash: echo: write error: Invalid argument
> > > 
> > > Don't guess the type of the filter pred in filter_parse(), but instead
> > > we check it in filter_add_pred().
> > > 
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > ---
> > >  kernel/trace/trace_events_filter.c |   26 +++++++++++++-------------
> > >  1 files changed, 13 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> > > index 9f8ecca..a63f965 100644
> > > --- a/kernel/trace/trace_events_filter.c
> > > +++ b/kernel/trace/trace_events_filter.c
> > > @@ -229,6 +229,7 @@ static int is_string_field(const char *type)
> > >  int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
> > >  {
> > >  	struct ftrace_event_field *field;
> > > +	unsigned long long val;
> > >  
> > >  	field = find_event_field(call, pred->field_name);
> > >  	if (!field)
> > > @@ -237,14 +238,14 @@ int filter_add_pred(struct ftrace_event_call *call, struct filter_pred *pred)
> > >  	pred->offset = field->offset;
> > >  
> > >  	if (is_string_field(field->type)) {
> > > -		if (!pred->str_val)
> > > -			return -EINVAL;
> > >  		pred->fn = filter_pred_string;
> > >  		pred->str_len = field->size;
> > >  		return __filter_add_pred(call, pred);
> > >  	} else {
> > > -		if (pred->str_val)
> > > +		if (strict_strtoull(pred->str_val, 0, &val))
> > >  			return -EINVAL;
> > > +		pred->val = val;
> > > +		kfree(pred->str_val);
> > 
> > 
> > And you might also want to do
> > pred->str_val = NULL;
> > Otherwise filter_free_pred() may crash later:
> > 
> > void filter_free_pred(struct filter_pred *pred)
> > {
> > 	if (!pred)
> > 		return;
> > 
> > 	kfree(pred->field_name);
> > 	kfree(pred->str_val);
> > 	kfree(pred);
> > }
> > 
> > 
> > Other than that, it looks good.
> 
> This also conflicts with Tom's rewrite of the filter engine to make 
> it on-the-fly modifiable.
> 
> Li, mind reworking your series against latest -tip? (it has Tom's 
> patch included already)
> 
> Also, it would be nice to hear Tom's opinion about this series as 
> well. I know there's new parsing features planned - if it's better 
> that way then Tom you might want to pick up Li's patches and submit 
> them together with any pending or upcoming changes? We can apply 
> them directly too if that's easier to you.
> 

I had started on the new parser a couple weeks ago, but got sidetracked
by other things.  I'll be getting back to it this week, but until it's
ready it wouldn't hurt for you to pick up Li's patches, and I'll make
any changes I need to in the new code.

What this patch does will be needed by the new code too, so it would be
good to have it, though it might get moved around.  Patch 2 won't hurt
either, though everything in filter_parse() will probably change.  And
patch 3 fixes a bug that needs to be fixed regardless...

Thanks,

Tom

> Thanks,
> 
> 	Ingo

