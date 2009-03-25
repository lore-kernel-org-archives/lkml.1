Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZCYV0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZCYV0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZCYV00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:26:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57395 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZCYV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:26:25 -0400
Date: Wed, 25 Mar 2009 17:26:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tim Bird <tim.bird@am.sony.com>, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][GIT PULL] x86, function-graph: only save return values
 on x86_64
In-Reply-To: <1238013934.2500.81.camel@ht.satnam>
Message-ID: <alpine.DEB.2.00.0903251724120.5675@gandalf.stny.rr.com>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere>  <20090324214846.GB29509@elte.hu> <20090324215738.GD5975@nowhere>  <alpine.DEB.2.00.0903251153500.5675@gandalf.stny.rr.com>  <alpine.DEB.2.00.0903251625490.5675@gandalf.stny.rr.com>
 <1238013934.2500.81.camel@ht.satnam>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:
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
> 
> hmm, is this gonna work:
> 	movq %rax, 16(%rsp)
> 	movq 8(%rsp), %rdx
>  	movq (%rsp), %rax
>  	addq $16, %rsp
>  	retq

Interesting. I was just talking over IRC with Frederic about this. One 
theory about his earlier failures was not having a proper stack frame when 
calling the function. This is probably a bogus theory and there was 
probably something else that broke the code. But there is no harm in 
allocating 80 bytes (it worked before). Thus, I rather error on the side 
of least change than risk it.

-- Steve

