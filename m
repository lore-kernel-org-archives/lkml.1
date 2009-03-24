Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbZCXPzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbZCXPzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbZCXPy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:54:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbZCXPyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:54:54 -0400
Date: Tue, 24 Mar 2009 11:54:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Avoid double-free of dyn_ftrace
In-Reply-To: <18199AAD941A4071B7FD8A0D6C67733A@zhaoleiwin>
Message-ID: <alpine.DEB.2.00.0903241152020.22830@gandalf.stny.rr.com>
References: <49BA23D9.1050900@cn.fujitsu.com> <20090313092558.GD2571@elte.hu> <18199AAD941A4071B7FD8A0D6C67733A@zhaoleiwin>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Mar 2009, Zhaolei wrote:

> * From: "Ingo Molnar" <mingo@elte.hu>
> > 
> > * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> > 
> >> If dyn_ftrace is free before ftrace_release(), 
> >> ftrace_release() will free it again and make 
> >> ftrace_free_records wrong.
> >> 
> >> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> >> ---
> >>  kernel/trace/ftrace.c |    3 ++-
> >>  1 files changed, 2 insertions(+), 1 deletions(-)
> >> 
> >> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> >> index d33d306..26c45aa 100644
> >> --- a/kernel/trace/ftrace.c
> >> +++ b/kernel/trace/ftrace.c
> >> @@ -356,7 +356,8 @@ void ftrace_release(void *start, unsigned long size)
> >>  
> >>  mutex_lock(&ftrace_lock);
> >>  do_for_each_ftrace_rec(pg, rec) {
> >> - if ((rec->ip >= s) && (rec->ip < e))
> >> + if ((rec->ip >= s) && (rec->ip < e) &&
> >> +     !(rec->flags & FTRACE_FL_FREE))
> >>  ftrace_free_rec(rec);
> > 
> > Applied to tip:tracing/ftrace, thanks!
> > 
> > I'm wondering, did you trigger this in practice (if yes, how?), 
> > or have you found it via code review?
> Hello, Ingo
> 
> It is found via code review.

Hmm, could you explain this more. I'm thinking that this scenario should 
not happen, and if it does, it should probably be a bug.

Because when we call ftrace_free_rec we change the rec->ip to point to the 
next record in the chain. Something is very wrong if rec->ip >= s && 
rec->ip < e and the record is already free.

We can add a:

	WARN_ON(rec->flags & FTRACE_FL_FREE);

in ftrace_free_rec if you are worried about this happening.

-- Steve

