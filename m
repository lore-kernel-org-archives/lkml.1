Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZDJM6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZDJM6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZDJM6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:58:31 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:36001 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZDJM6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zr1jOXqaVnTqVwRV0TtiI4gI/xSuZlkPe+cnwAt6loMeGgD2rbEyzWHpUrdAiQs2UA
         tG8Q7Q44jeH/3vcHzo6sJkrv6bfl4kA26cgj3L0p2n6lsXSdGCBr7IpArzZSCCJc4Qt2
         /w633Au6dUTmVllMIEYTOzZJ8C5gnzAWlB0RA=
Date: Fri, 10 Apr 2009 14:58:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       josh@freedesktop.org
Subject: Re: [PATCH -tip] x86: ftrace.c declare prepare_ftrace_return
	before they get used
Message-ID: <20090410125824.GA5988@nowhere>
References: <1239295068.3296.20.camel@ht.satnam> <20090409172053.GA6033@nowhere> <1239298915.3296.24.camel@ht.satnam> <alpine.DEB.2.00.0904091452590.21189@gandalf.stny.rr.com> <1239337795.3036.25.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239337795.3036.25.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 09:59:55AM +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-04-09 at 14:55 -0400, Steven Rostedt wrote:
> > 
> > On Thu, 9 Apr 2009, Jaswinder Singh Rajput wrote:
> > 
> > > 
> > > Subject: [PATCH] x86: ftrace.c declare prepare_ftrace_return before they get used
> > > 
> > > Impact: fix sparse warning:
> > >   arch/x86/kernel/ftrace.c:411:6: warning: symbol 'prepare_ftrace_return' was not declared. Should it be static?
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  arch/x86/include/asm/ftrace.h |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > > index bd2c651..ddc9236 100644
> > > --- a/arch/x86/include/asm/ftrace.h
> > > +++ b/arch/x86/include/asm/ftrace.h
> > > @@ -59,6 +59,11 @@ struct dyn_arch_ftrace {
> > >  };
> > >  
> > >  #endif /*  CONFIG_DYNAMIC_FTRACE */
> > > +
> > > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > > +extern void prepare_ftrace_return(unsigned long *, unsigned long);
> > > +#endif
> > > +
> > 
> > The only caller is from assembly, so this patch is unnecessary. Unless we 
> > have some rule that all functions must have a prototype, even when it is 
> > only called from assembly.
> > 
> 
> Then:
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 18dfa30..75c0682 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -408,6 +408,7 @@ int ftrace_disable_ftrace_graph_caller(void)
>   * Hook the return address and push it in the stack of return addrs
>   * in current thread info.
>   */
> +asmlinkage



No. This is how prepare_ftrace_return was called at first.
But note that prepare_ftrace_return may be called for every
kernel function while tracing, hence every pico optimization
is important. asmlinkage will push the arguments to the stack
while we want to keep the fastcall here by passing them to the
registers.

Sparse is a useful tool, but sometime there are exceptions when its
warnings should be ignored IMO.

Frederic.

>  void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  {
>         unsigned long old;
> 
> 
> Josh: Do you think sparse should not warn like for this case.
> What will be the best solution for this case.
> 
> --
> JSR
> 
> 

