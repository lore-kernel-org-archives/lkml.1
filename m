Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbZCFROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbZCFROU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZCFROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:14:12 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:34165 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZCFROK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p8iYIUZ2+0xUd7Zt51o9aIYKY3+ENtlicnzcIS8kSKzkv4nOIbu+EetcgrUbJbJBih
         MB6EwhzLrCPZ+yyo/6x21FXh49SwL3dIgIKwixXXLqOEGBT2IvruRwWCMLZ1jyiuEYIa
         69ayrC8yEuJFrfYQLXfmLirlu3kpJ9rl/Ik1s=
Date: Fri, 6 Mar 2009 18:14:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/5 v3] tracing/core: drop the old ftrace_printk
	implementation in favour of ftrace_bprintk
Message-ID: <20090306171403.GA7329@nowhere>
References: <1236356510-8381-1-git-send-email-fweisbec@gmail.com> <1236356510-8381-5-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903061146000.23248@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903061146000.23248@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 11:49:40AM -0500, Steven Rostedt wrote:
> 
> 
> On Fri, 6 Mar 2009, Frederic Weisbecker wrote:
> 
> > Impact: faster and lighter tracing
> > 
> > Now that we have ftrace_bprintk() which is faster and consume lesser
> > memory than ftrace_printk() and has the same purpose, we can now drop
> > the old implementation in favour of the binary one from ftrace_bprintk(),
> > which means we move all the implementation of ftrace_bprintk() to
> > ftrace_printk(), so the Api doesn't change except that we must now use
> > trace_seq_bprintk() to print the TRACE_PRINT entries.
> > 
> > Some changes result of this:
> > 
> > - Previously, ftrace_bprintk depended of a single tracer and couldn't
> >   work without. This tracer has been dropped and the whole implementation
> >   of ftrace_printk() (like the module formats management) is now integrated
> >   in the tracing core (comes with CONFIG_TRACING), though we keep the file
> >   trace_printk (previously trace_bprintk.c) where we can find the module
> >   management. Thus we don't overflow trace.c
> > 
> > - changes some parts to use trace_seq_bprintk() to print TRACE_PRINT entries.
> > 
> > - change a bit ftrace_printk/ftrace_vprintk macros to support non-builtin formats
> >   constants, and fix 'const' qualifiers warnings. But this is all transparent for
> >   developers.
> > 
> > - etc...
> > 
> > V2:
> > 
> > - Rebase against last changes
> > - Fix mispell on the changelog
> > 
> > V3:
> > 
> > - Rebase against last changes (moving ftrace_printk() to kernel.h)
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Very nice Frederic!


Thanks!

 
> For some reason I'm still missing patch 1. Perhaps it decided to take the
> scenic route ;-)
> 
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 0f5077f..6140922 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -20,7 +20,6 @@ enum trace_type {
> >  	TRACE_WAKE,
> >  	TRACE_STACK,
> >  	TRACE_PRINT,
> > -	TRACE_BPRINTK,
> >  	TRACE_SPECIAL,
> >  	TRACE_MMIO_RW,
> >  	TRACE_MMIO_MAP,
> > @@ -120,16 +119,10 @@ struct userstack_entry {
> >   */
> >  struct print_entry {
> >  	struct trace_entry	ent;
> > -	unsigned long		ip;
> > +	unsigned long 		ip;
> >  	int			depth;
> > -	char			buf[];
> > -};
> > -
> 
> 
> Note, this is going to break my recent patch that exports the internal 
> ftrace events.

Argh, sorry I forgot these recent patches.

> That's OK, I'll fix it after Ingo pulls it in.


Thanks :-)


> Ingo,
> 
> Would you prefer that I pull these patches in and then fix the code, and 
> let you pull it from me?
> 
> -- Steve
> 

