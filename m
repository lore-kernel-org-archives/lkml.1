Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbZEFOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbZEFOg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbZEFOgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:36:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57440 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbZEFOgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:36:46 -0400
Date: Wed, 6 May 2009 16:36:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing: trace_output.c, fix false positive
	compiler warning
Message-ID: <20090506143608.GA29044@elte.hu>
References: <tip-48dd0fed90e2b1f1ba87401439b85942181c6df3@git.kernel.org> <alpine.DEB.2.00.0905061018260.3239@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905061018260.3239@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Wed, 6 May 2009, tip-bot for Jaswinder Singh Rajput wrote:
> 
> > Commit-ID:  48dd0fed90e2b1f1ba87401439b85942181c6df3
> > Gitweb:     http://git.kernel.org/tip/48dd0fed90e2b1f1ba87401439b85942181c6df3
> > Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> > AuthorDate: Wed, 6 May 2009 15:45:45 +0530
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 6 May 2009 14:19:16 +0200
> > 
> > tracing: trace_output.c, fix false positive compiler warning
> > 
> > This compiler warning:
> > 
> >   CC      kernel/trace/trace_output.o
> >  kernel/trace/trace_output.c: In function ?register_ftrace_event?:
> >  kernel/trace/trace_output.c:544: warning: ?list? may be used uninitialized in this function
> > 
> > Is wrong as 'list' is always initialized - but GCC (4.3.2) does not
> > recognize this relationship properly.
> > 
> > Work around the warning by initializing the variable to NULL.
> > 
> > [ Impact: fix false positive compiler warning ]
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> > LKML-Reference: <new-submission>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  kernel/trace/trace_output.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> > index 5fc51f0..8bd9a2c 100644
> > --- a/kernel/trace/trace_output.c
> > +++ b/kernel/trace/trace_output.c
> > @@ -541,7 +541,7 @@ int register_ftrace_event(struct trace_event *event)
> >  	INIT_LIST_HEAD(&event->list);
> >  
> >  	if (!event->type) {
> > -		struct list_head *list;
> > +		struct list_head *list = NULL;
> 
> Actually this is the wrong place to initialize. The correct place 
> is in the function that is expected to.

does it really matter? It's far more robust to initialize at the 
definition site, because there we can be sure there's no 
side-effects. This one:

>  	/* Did we used up all 65 thousand events??? */
> -	if ((last + 1) > FTRACE_MAX_EVENT)
> +	if ((last + 1) > FTRACE_MAX_EVENT) {
> +		*list = NULL;
>  		return 0;
> +	}

Is correct too but needs a semantic check (and ongoing maintenance, 
etc.).

	Ingo
