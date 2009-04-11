Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbZDKRgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbZDKRgn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 13:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZDKRge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 13:36:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51315 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZDKRgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 13:36:33 -0400
Date: Sat, 11 Apr 2009 10:36:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] tracing: bug fixes for tracing/filters
Message-ID: <20090411173633.GE6822@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49E04C22.4040608@cn.fujitsu.com> <1239442248.8793.65.camel@tropicana> <20090411144823.GB5977@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411144823.GB5977@nowhere>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 04:48:33PM +0200, Frederic Weisbecker wrote:
> On Sat, Apr 11, 2009 at 04:30:48AM -0500, Tom Zanussi wrote:
> > Hi,
> > 
> > On Sat, 2009-04-11 at 15:52 +0800, Li Zefan wrote:
> > > This patchset fixes some bugs in tracing/filters. Most of the change
> > > goes to the last patch, and others are small ones.
> > > 
> > 
> > At first glance, they look good and fix real problems - thanks for
> > fixing them.  Re patch 7, there's been some discussion about using rcu
> > for this.  See:
> > 
> > http://lkml.org/lkml/2009/4/5/46
> > 
> > >From that discussion, it seems some non-trivial changes to rcu would be
> > needed for this.  I'm playing around with a different idea now to
> > hopefully avoid the need for that, or the other approach mentioned, of
> > temporarily stopping tracing while removing/changing the filters.
> > 
> > Basically my thought is to avoid the problem by not allocating or
> > destroying the preds when removing filters but instead switch out the
> > pred->fns with a nop version while keeping the fields intact for awhile.
> > I think that will work for removing filters, but I still need to think
> > about how it would (or would not) work for replacing them.
> >  
> > Tom
> 
> It would be sort of reinventing rcu :-)
> Well, Paul proposed something recently, hmm I should double check
> this discussion.

I am actually thinking about doing this.  Please do take a look at:

	http://lkml.org/lkml/2009/4/6/332
	http://lkml.org/lkml/2009/4/6/496

What I need from you is to tell me whether or not the proposed placement
of rcu_idle(), rcu_idle_start(), and rcu_idle_end() makes sense from a
tracing viewpoint.

							Thanx, Paul

> Anyway, the fixes from Li (other than 4 and 7 for which we have comments)
> look very good!
> 
> Frederic.
> 
> 
> 
> > 
> > > Maybe 3rd to 6th patches can be regarded as small enhancements instead
> > > of bug fixes? But they are behavioural changes.
> > > 
> > > 
> > > [PATCH 1/7] tracing/filters: NUL-terminate user input filter
> > > [PATCH 2/7] tracing/filters: fix NULL pointer dereference
> > > [PATCH 3/7] tracing/filters: allow user input integer to be oct or hex
> > > [PATCH 4/7] tracing/filters: allow user to specify a filter val to be string
> > > [PATCH 5/7] tracing/filters: disallow newline as delimeter
> > > [PATCH 6/7] tracing/filters: return proper error code when writing filter file
> > > [PATCH 7/7] tracing/filters: make filter preds RCU safe
> > > 
> > >  kernel/trace/trace.h                |    6 +-
> > >  kernel/trace/trace_events.c         |   16 +++--
> > >  kernel/trace/trace_events_filter.c  |  131 ++++++++++++++++++++++++++---------
> > >  kernel/trace/trace_events_stage_3.h |   10 +++-
> > >  4 files changed, 121 insertions(+), 42 deletions(-)
> > > ---
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
