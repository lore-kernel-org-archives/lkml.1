Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZKELJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZKELJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbZKELJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:09:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:37978 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbZKELJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:09:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=n/CjBsUrhojqrXtuab6K+N/1fzZP4wa2EpwhmKVcZLxCeO7Olrzz0v0rJdawqycUrN
         vyDRwrLWx+Uu3PhqIXNkfHOPR/DOGLfMMG4pKPM7vuGWBb+kyzMC2B+sJzcQcCx5Mx6U
         EXHdJdn2exdBXzGHTcXtmB8NjDd75nt3VtELU=
Date: Thu, 5 Nov 2009 12:09:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer
	on top of perf events
Message-ID: <20091105110951.GB4877@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <1257275474-5285-5-git-send-email-fweisbec@gmail.com> <19186.5488.320389.567026@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19186.5488.320389.567026@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 10:59:44AM +1100, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > This patch rebase the implementation of the breakpoints API on top of
> > perf events instances.
> > 
> > Each breakpoints are now perf events that handle the
> > register scheduling, thread/cpu attachment, etc..
> 
> What I haven't managed to understand yet is how you provide reliable
> breakpoints for debugging purposes.  If I'm debugging a program and I
> have set a breakpoint, I'll be very unhappy if the breakpoint should
> trigger but doesn't because the perf_event infrastructure has decided
> it can't schedule that breakpoint in.  If the breakpoint isn't going
> to work then I want to know that at the time that I set it.



That won't happen because of the set of constraints we have.
We never overcommit the debug register resources, except in
the case of non-pinned counter, but that's in their nature :)


 
> We can go some distance towards that with the pinned attribute, but
> not far enough.  The pinned attribute doesn't guarantee that the event
> will always be scheduled in, it just says that we'll do our best to
> schedule it in, and if we can't, we'll put the event into error state
> so that the user knows we didn't manage to schedule it in.  But
> there's no way to get back to gdb and tell it that a breakpoint that
> it had previously successfully created is no longer working.
> 
> Also, we don't currently fail the creation of a pinned event if it
> would conflict with another pinned event already created in the same
> context.  We would need to do something like that if we want to use
> pinned events for debugging breakpoints (as distinct from breakpoints
> for performance monitoring purposes, for which it matters less if they
> are sometimes not scheduled in).
> 
> And then there's the question of whether a per-cpu pinned breakpoint
> event conflicts with a per-task pinned breakpoint event if you only
> have one breakpoint register (as is the case on Power server CPUs).
> Plus the fact that we don't currently give per-task pinned events
> priority over per-cpu non-pinned events (perhaps that would be a good
> idea anyway).
> 
> Paul.


All that is already handled by the constraints.

