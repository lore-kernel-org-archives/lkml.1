Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899Ab0AVCvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0AVCvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888Ab0AVCvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:51:07 -0500
Received: from mail-fx0-f223.google.com ([209.85.220.223]:61075 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab0AVCvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:51:05 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2010 21:51:04 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i+y3/7OXqi90dCsc/apyAGhyQzHOXwg7cH4dGTjFIyHQ7iw2ca1eHzLBlEeROg+mlt
         psVJxbQYTAZnNe7oLxBX6/5nQBmA21+FztcG+EcTkKrsSRFOYqX+ivo8Y2BS4Vj0IHt3
         Ii6oDw8hzM2PZUPD+6G9ijwpqKuc0Q1G928is=
Date: Fri, 22 Jan 2010 03:43:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [RFC PATCH 03/10] ftrace: Drop the ftrace_profile_enabled
	checks in tracing hot path
Message-ID: <20100122024332.GB8140@nowhere>
References: <1264122982-1553-1-git-send-regression-fweisbec@gmail.com> <1264122982-1553-4-git-send-regression-fweisbec@gmail.com> <1264125917.31321.312.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264125917.31321.312.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 09:05:17PM -0500, Steven Rostedt wrote:
> On Fri, 2010-01-22 at 02:16 +0100, Frederic Weisbecker wrote:
> > Every time we enter the function profiler tracing callbacks, we first
> > check if the function profiling is enabled.
> > 
> > This check is useless because we register the function graph
> > callbacks only after the hashlist has been initialized.
> 
> Unfortunately, since the previous patch is incorrect, it makes this one
> buggy too.
> 
> If you remove the check to ftrace_profile_enabled, the call to the
> profiled code could have been preempted and pending to be called.
> 
> Stop machine may remove all calls to the tracing, but it only affects
> new hits. Pending hits may still exist.
> 
> If you remove this check, and the user re-enables the profiling, then
> all PER_CPU hashs will be reset. If in the process of this happening,
> the task with the pending trace wakes up, it may access the PER_CPU list
> and corrupt it.


Indeed.



> Now for the reason I Cc'd Paul and Mathieu...
> 
> If we had a synchronize_sched() like function that would wait and return
> when all preempted tasks have been scheduled again and went to either
> userspace or called schedule directly, then we could actually do this.
> 
> After unregistering the function graph trace, you call this
> "synchronize_tasks()" and it will guarantee that all currently preempted
> tasks have either went to userspace or have called schedule() directly.
> Then it would be safe to remove this check.



Good point!

I fear that would require heavy hooks in the scheduler though...

