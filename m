Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZHFMin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZHFMin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZHFMim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:38:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZHFMil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:38:41 -0400
Date: Thu, 6 Aug 2009 14:38:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, chris.mason@oracle.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] ftrace: Fix perf-tracepoint OOPS
Message-ID: <20090806123829.GE15314@elte.hu>
References: <1249497664.5890.4.camel@laptop> <tip-af6af30c0fcd77e621638e53ef8b176bca8bd3b4@git.kernel.org> <1249549910.32113.70.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249549910.32113.70.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> > [ v2: fix build error in the !CONFIG_EVENT_PROFILE case ]
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  include/linux/ftrace_event.h       |    8 +++-----
> >  kernel/trace/trace_event_profile.c |    2 +-
> >  kernel/trace/trace_events.c        |    2 +-
> >  3 files changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> > index 5c093ff..d7cd193 100644
> > --- a/include/linux/ftrace_event.h
> > +++ b/include/linux/ftrace_event.h
> > @@ -119,11 +119,9 @@ struct ftrace_event_call {
> >  	void			*filter;
> >  	void			*mod;
> >  
> > -#ifdef CONFIG_EVENT_PROFILE
> > -	atomic_t	profile_count;
> > -	int		(*profile_enable)(struct ftrace_event_call *);
> > -	void		(*profile_disable)(struct ftrace_event_call *);
> > -#endif
> > +	atomic_t		profile_count;
> > +	int			(*profile_enable)(struct ftrace_event_call *);
> > +	void			(*profile_disable)(struct ftrace_event_call *);
> >  };
> 
> Ah, I would have added ifdefs around the below bit.
> 
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 23d2972..e75276a 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
> >  		entry = trace_create_file("enable", 0644, call->dir, call,
> >  					  enable);
> >  
> > -	if (call->id)
> #ifdef CONFIG_EVENT_PROFILE
> > +	if (call->id && call->profile_enable)
> >  		entry = trace_create_file("id", 0444, call->dir, call,
> >  					  id);
> #endif
> 
> Like that, but I guess this works too ;-)

i think CONFIG_EVENT_PROFILE should go away - it's clearly a core 
functionality of ftrace. Whenever we hit a Kconfig induced build 
breakage we should first consider reducing the Kconfig complexity a 
bit.

	Ingo
