Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYJBJNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYJBJNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJBJNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:13:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631AbYJBJNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:13:19 -0400
Date: Thu, 2 Oct 2008 02:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: allocate buffer page pointer
Message-Id: <20081002020615.4840542a.akpm@linux-foundation.org>
In-Reply-To: <20081002085030.GF26084@elte.hu>
References: <20080930000307.GA2929@Krystal>
	<alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>
	<20080930034603.GA13801@Krystal>
	<alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com>
	<20080930092001.69849210@bike.lwn.net>
	<1222790072.24384.21.camel@twins>
	<alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org>
	<alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com>
	<alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org>
	<alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com>
	<20081002085030.GF26084@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 10:50:30 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > The current method of overlaying the page frame as the buffer page pointer
> > can be very dangerous and limits our ability to do other things with
> > a page from the buffer, like send it off to disk.
> > 
> > This patch allocates the buffer_page instead of overlaying the page's
> > page frame. The use of the buffer_page has hardly changed due to this.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/ring_buffer.c |   54 ++++++++++++++++++++++++++-------------------
> >  1 file changed, 32 insertions(+), 22 deletions(-)
> 
> applied to tip/tracing/ftrace, with the extended changlog below - i 
> think this commit warrants that extra mention.
> 
> 	Ingo
> 
> --------------->
> >From da78331b4ced2763322d732ac5ba275965853bde Mon Sep 17 00:00:00 2001
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Wed, 1 Oct 2008 10:52:51 -0400
> Subject: [PATCH] ftrace: type cast filter+verifier
> 
> The mmiotrace map had a bug that would typecast the entry from
> the trace to the wrong type. That is a known danger of C typecasts,
> there's absolutely zero checking done on them.
> 
> Help that problem a bit by using a GCC extension to implement a
> type filter that restricts the types that a trace record can be
> cast into, and by adding a dynamic check (in debug mode) to verify
> the type of the entry.
> 
> This patch adds a macro to assign all entries of ftrace using the type
> of the variable and checking the entry id. The typecasts are now done
> in the macro for only those types that it knows about, which should
> be all the types that are allowed to be read from the tracer.
> 

I'm somewhat at a loss here because I'm unable to find any version of
kernel/trace/trace.c which looks anything like the one which is being
patched, but...

> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1350,7 +1350,9 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
>  	}
>  	switch (entry->type) {
>  	case TRACE_FN: {
> -		struct ftrace_entry *field = (struct ftrace_entry *)entry;

Why was this code using a cast in the first place?  It should be using
entry->some_field_i_dont_have_here?  That was the whole point in using 
the anonymous union in struct trace_entry?

