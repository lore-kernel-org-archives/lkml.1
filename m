Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbZJGNsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbZJGNsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 09:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758486AbZJGNsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 09:48:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63777 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbZJGNsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 09:48:20 -0400
Subject: Re: [PATCH V2] fix a warning on kernel/trace/trace_branch.c and
 trace_hw_branches.c
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4ACC7E35.4050001@gmail.com>
References: <20091007081946.GA25350@helight>
	 <4ACC5715.4000201@cn.fujitsu.com>  <4ACC7E35.4050001@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 09:46:20 -0400
Message-Id: <1254923180.1696.138.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 19:40 +0800, Helight.Xu wrote:
> Li Zefan wrote:
> > Zhenwen Xu wrote:
> >   
> >> fix warnings that caused the API change of trace_buffer_lock_reserve()
> >> change files: kernel/trace/trace_hw_branch.c
> >> 	      kernel/trace/trace_branch.c
> >>
> >>     
> >
> > Hmm, did you really compile trace_hw_branch.c while testing
> > this patch?
> >
> > This change is necessary too:
> >
> > -	trace_buffer_unlock_commit(tr, event, 0, 0);
> > +	trace_buffer_unlock_commit(tr->buffer, event, 0, 0);
> >
> > And use a varaible "buffer = tr->buffer" should be better.
> >   
> oh!   sorry for my careless!
> >   
> >> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> >> ---
> >>  kernel/trace/trace_branch.c      |    2 +-
> >>  kernel/trace/trace_hw_branches.c |    2 +-
> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> >> index 7a7a9fd..216e2dd 100644
> >> --- a/kernel/trace/trace_branch.c
> >> +++ b/kernel/trace/trace_branch.c
> >> @@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
> >>  		goto out;
> >>  
> >>  	pc = preempt_count();
> >> -	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
> >> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
> >>  					  sizeof(*entry), flags, pc);

Also, You should not pass in the buffer directly. This is because the
tr->buffer can change, and if it changes between the reserve and commit,
then you can corrupt the ring buffer.

What you want to do is:

	struct ring_buffer *buffer = tr->buffer;

	event = trace_buffer_lock_reserve(buffer, TRACE_BRANCH ...)

[...]

	ring_buffer_unlock_commit(buffer, ...)


-- Steve

> >>  	if (!event)
> >>  		goto out;
> >> diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
> >> index 23b6385..1cc17ca 100644
> >> --- a/kernel/trace/trace_hw_branches.c
> >> +++ b/kernel/trace/trace_hw_branches.c
> >> @@ -180,7 +180,7 @@ void trace_hw_branch(u64 from, u64 to)
> >>  	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
> >>  		goto out;
> >>  
> >> -	event = trace_buffer_lock_reserve(tr, TRACE_HW_BRANCHES,
> >> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_HW_BRANCHES,
> >>  					  sizeof(*entry), 0, 0);
> >>  	if (!event)
> >>  		goto out;
> >>     
> >
> >   
> 
> 

