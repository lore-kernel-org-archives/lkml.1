Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbZEFO5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbZEFO5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932129AbZEFOtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55910 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760329AbZEFOtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:49:33 -0400
Date: Wed, 6 May 2009 10:49:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing: trace_output.c, fix false positive
 compiler warning
In-Reply-To: <20090506143608.GA29044@elte.hu>
Message-ID: <alpine.DEB.2.00.0905061041450.3239@gandalf.stny.rr.com>
References: <tip-48dd0fed90e2b1f1ba87401439b85942181c6df3@git.kernel.org> <alpine.DEB.2.00.0905061018260.3239@gandalf.stny.rr.com> <20090506143608.GA29044@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 6 May 2009, Ingo Molnar wrote:
> > > ---
> > >  kernel/trace/trace_output.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > > index 5fc51f0..8bd9a2c 100644
> > > --- a/kernel/trace/trace_output.c
> > > +++ b/kernel/trace/trace_output.c
> > > @@ -541,7 +541,7 @@ int register_ftrace_event(struct trace_event *event)
> > >  	INIT_LIST_HEAD(&event->list);
> > >  
> > >  	if (!event->type) {
> > > -		struct list_head *list;
> > > +		struct list_head *list = NULL;
> > 
> > Actually this is the wrong place to initialize. The correct place 
> > is in the function that is expected to.
> 
> does it really matter? It's far more robust to initialize at the 
> definition site, because there we can be sure there's no 
> side-effects. This one:
> 
> >  	/* Did we used up all 65 thousand events??? */
> > -	if ((last + 1) > FTRACE_MAX_EVENT)
> > +	if ((last + 1) > FTRACE_MAX_EVENT) {
> > +		*list = NULL;
> >  		return 0;
> > +	}
> 
> Is correct too but needs a semantic check (and ongoing maintenance, 
> etc.).

Actually, to answer this, we need to look at the entire code. Just looking 
at the changes of a patch does not include the big picture.

The original code is:

static int trace_search_list(struct list_head **list)
{
        struct trace_event *e;
        int last = __TRACE_LAST_TYPE;

        if (list_empty(&ftrace_event_list)) {
                *list = &ftrace_event_list;
                return last + 1;
        }

        /*
         * We used up all possible max events,
         * lets see if somebody freed one.
         */
        list_for_each_entry(e, &ftrace_event_list, list) {
                if (e->type != last + 1)
                        break;
                last++;
        }

        /* Did we used up all 65 thousand events??? */
        if ((last + 1) > FTRACE_MAX_EVENT)
                return 0;

        *list = &e->list;
        return last + 1;
}

[...]
                struct list_head *list;

                if (next_event_type > FTRACE_MAX_EVENT) {

                        event->type = trace_search_list(&list);
                        if (!event->type)
                                goto out;

                } else {

                        event->type = next_event_type++;
                        list = &ftrace_event_list;
                }

                if (WARN_ON(ftrace_find_event(event->type)))
                        goto out;

                list_add_tail(&event->list, list);



The caller is:

	struct list_head *list;

	if () {
		event->type = trace_seach_list(&list);
	} else {
		[...]
		list = &ftrace_event_list;
	}

This code shows that list is initialized by either trace_seach_list() or 
set manually.

Thus, my change makes trace_search_list always initialize the list 
variable. Thus if trace_search_list() is used someplace else, it will not 
cause us this error again.

If gcc can not figure out that trace_search_list initializes the code 
(from the original code), the

	struct list_head *list = NULL;

will always be performed, because gcc thinks that's the only way to 
guarantee that it will be initialized.

My solution, gcc can easily see that trace_search_list will always 
initialize list, and will not set it needlessly to NULL.

-- Steve

