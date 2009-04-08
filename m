Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbZDHRk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbZDHRk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZDHRks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:40:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:43756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbZDHRkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QbRtGJbJBEXwHpEUyggAEy81hYFZgOdmyWLxSV/wIi6qXa8efGLNT+BPXBWGPmeSmc
         BcBER8WKTljhvX6k+JXSxfbFFkx1I/g3WPMj94TE5HTrsn3OEbjzYRd7o4Dm/PGnlkh8
         A0OuXjADvXn60zIUCvLbw3db5cWtysDoqP8Ws=
Date: Wed, 8 Apr 2009 19:40:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][GIT PULL] x86, function-graph: only save return values
	on x86_64
Message-ID: <20090408174041.GA6017@nowhere>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere> <alpine.DEB.2.00.0903251153500.5675@gandalf.stny.rr.com> <alpine.DEB.2.00.0903251625490.5675@gandalf.stny.rr.com> <20090408160915.GD16759@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408160915.GD16759@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 06:09:15PM +0200, Ingo Molnar wrote:
> 
> (replying to old mail - working down my awful email backlog)
> 
> do we still need this for -tip?
> 
> 	Ingo


Yes. It drops a small overhead on the function graph tracer.

Thanks,
Frederic.

 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > Please pull the latest tip/tracing/function-graph tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/tracing/function-graph
> > 
> > 
> > Steven Rostedt (1):
> >       x86, function-graph: only save return values on x86_64
> > 
> > ----
> >  arch/x86/kernel/entry_64.S |   19 +++----------------
> >  1 files changed, 3 insertions(+), 16 deletions(-)
> > ---------------------------
> > commit d5b754b2208b1c22691a7cd5d1a65398b5973d74
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Wed Mar 25 14:30:04 2009 -0400
> > 
> >     x86, function-graph: only save return values on x86_64
> >     
> >     Impact: speed up
> >     
> >     The return to handler portion of the function graph tracer should only
> >     need to save the return values. The caller already saved off the
> >     registers that the callee can modify. The returning function already
> >     saved the registers it modified. When we call our own trace function
> >     it too will save the registers that the callee must restore.
> >     
> >     There's no reason to save off anything more that the registers used
> >     to return the values.
> >     
> >     Note, I did a complete kernel build with this modification and the
> >     function graph tracer running on x86_64.
> >     
> >     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > 
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index a331ec3..1ac9986 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -147,27 +147,14 @@ END(ftrace_graph_caller)
> >  GLOBAL(return_to_handler)
> >  	subq  $80, %rsp
> >  
> > +	/* Save the return values */
> >  	movq %rax, (%rsp)
> > -	movq %rcx, 8(%rsp)
> > -	movq %rdx, 16(%rsp)
> > -	movq %rsi, 24(%rsp)
> > -	movq %rdi, 32(%rsp)
> > -	movq %r8, 40(%rsp)
> > -	movq %r9, 48(%rsp)
> > -	movq %r10, 56(%rsp)
> > -	movq %r11, 64(%rsp)
> > +	movq %rdx, 8(%rsp)
> >  
> >  	call ftrace_return_to_handler
> >  
> >  	movq %rax, 72(%rsp)
> > -	movq 64(%rsp), %r11
> > -	movq 56(%rsp), %r10
> > -	movq 48(%rsp), %r9
> > -	movq 40(%rsp), %r8
> > -	movq 32(%rsp), %rdi
> > -	movq 24(%rsp), %rsi
> > -	movq 16(%rsp), %rdx
> > -	movq 8(%rsp), %rcx
> > +	movq 8(%rsp), %rdx
> >  	movq (%rsp), %rax
> >  	addq $72, %rsp
> >  	retq

