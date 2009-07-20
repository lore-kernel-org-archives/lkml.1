Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZGTBY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZGTBY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 21:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZGTBY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 21:24:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:56576 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZGTBY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 21:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BHvtjyIPoFhLIlipuNNxcDKyAP4EDcSxqoOt5JJM520aC4ClB54ATdlRjq6i+iId19
         IW/rbkOn63wp9DsWDtawaBrwp8b7M9+kNcP48BlZEZthDS6D4Z4Lt9Ul6D1iH7SqCVGX
         gqT9aCP/fW4UWR480ttVq2XN0JF3w8s0DEihU=
Date: Sun, 19 Jul 2009 21:24:38 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Improve subsystem filter
Message-ID: <20090720012430.GA5172@nowhere>
References: <4A5EECDC.4080500@cn.fujitsu.com> <20090717203422.GA7136@nowhere> <4A63C166.8010201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A63C166.8010201@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 08:59:18AM +0800, Li Zefan wrote:
> >> -static void filter_free_subsystem_preds(struct event_subsystem *system)
> >> +/*
> >> + * flag == 0: remove all events' filter
> >> + * flag == 1: clear filter->no_reset
> >> + * flag == 2: remove all preds with no_reset == false
> >> + */
> > 
> > Once an option overlap the boolean binary range, it's better
> > to start thinking about an enum type, for better self-explaining code.
> > 
> 
> Ok.
> 
> I was lazy to think of proper names for those enums..
> 
> >> +static void filter_free_subsystem_preds(struct event_subsystem *system,
> >> +					int flag)
> >>  {
> >>  	struct ftrace_event_call *call;
> >>  
> >> @@ -428,6 +434,14 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
> >>  		if (!call->define_fields)
> >>  			continue;
> >>  
> >> +		if (flag == 1) {
> >> +			call->filter->no_reset = false;
> >> +			continue;
> >> +		}
> >> +
> >> +		if (flag == 2 && call->filter->no_reset == true)
> > 
> > Or simply if (flag == 2 && call->filter->no_reset)
> > 
> 
> Sure.
> 
> >> +			continue;
> >> +
> >>  		if (!strcmp(call->system, system->name)) {
> >>  			filter_disable_preds(call);
> >>  			remove_filter_string(call->filter);
> >> @@ -529,7 +543,8 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
> >>  
> >>  static int filter_add_pred(struct filter_parse_state *ps,
> >>  			   struct ftrace_event_call *call,
> >> -			   struct filter_pred *pred)
> >> +			   struct filter_pred *pred,
> >> +			   bool apply)
> > 
> > 
> > bool dry_run sounds perhaps more intuitive for what is happening there.
> 
> I guess you "try_run". ;)
> 
> > Because "apply" is surprising in a "add_thing" function, it's like
> > a field to confirm that we know what what we are doing :)
> > 
> > (May be I start to become a PITA with my naming worries, especially
> > since I'm usually not good at it in my patches :)
> > 
> 
> I'll take "try_run". Naming is often hard for me.


No I really meant "dry run"
"Try run" is already a function that would implicitly fit into
every function :)

Ie, dry run means:

"Behave as if you were truly doing it, just to see if it works.
But don't really do it"


> 
> > Otherwise, the rest looks good.
> > 
> 
> Thanks!

