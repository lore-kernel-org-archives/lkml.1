Return-Path: <linux-kernel-owner+w=401wt.eu-S934191AbZKXVOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934191AbZKXVOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934162AbZKXVOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:14:37 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:37476 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161AbZKXVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:14:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nVRkP+LdZmxdvf6lJ0R0HD4quvEPwXPs8wtpJfkOydXxRitMhayIHVYCqsIos7k4+3
         dVww1Mp/ZfaJRe01ugSdwqr0GokN451izXvnDBPds2JSgiDHEVTyZhV67qaYW3JjOi6S
         EXxkiT6Ed/8VPOG/evEXXb+MECVoXEAloeDB0=
Date: Tue, 24 Nov 2009 22:14:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
	failed entries
Message-ID: <20091124211423.GE5071@nowhere>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com> <1259082845.22249.1110.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259082845.22249.1110.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 12:14:05PM -0500, Steven Rostedt wrote:
> On Tue, 2009-11-24 at 13:57 +0100, Jiri Olsa wrote:
> > Hi,
> > 
> > there's a case where the graph tracer might get confused and omits
> > display of a single record.  This applies for both destructive
> > (trace_pipe) and nondestructive (trace) cases.
> > 
> > 
> > <issue description>
> > 
> > The issue description for nondestructive case (trace) follows:
> > 
> > As the function_graph tracer goes through the trace entries (using "trace" file)
> > it keeps pointer to the current record and the next one:
> > 
> > current ->  func1 ENTRY
> >    next ->  func2 ENTRY
> >             func2 RETURN
> >             func1 RETURN
> > 
> > If it spots adjacent ENTRY and RETURN trace entries of the same function
> > and pid, it displays the "func2();" trace
> > 
> >             func1 ENTRY
> > current ->  func2 ENTRY 
> >    next ->  func2 RETURN
> >             func1 RETURN
> > 
> > and moves the next trace entry pointer behind the RETURN entry
> > 
> >             func1 ENTRY
> > current ->  func2 ENTRY 
> >             func2 RETURN
> >    next ->  func1 RETURN
> > 
> > so the next record peek will skip the RETURN entry and continue with
> > whatever is next.
> > 
> > It works ok but for one case. 
> > 
> > If the "func2()" trace does not make it to the seq_file read buffer, it needs
> 
> In the trace_pipe it may be possible to fill the trace_seq buffer if the
> buffer passed into userspace is larger than the trace_seq buffer. But
> the trace_seq buffer should never overflow on the "trace" case. If it
> is, then there's probably another bug.



Hmm, yeah in trace_pipe case we repeat until we have no space
left in trace_seq (TRACE_TYPE_PARTIAL_LINE), or until we
the user buffer is filled.

But indeed in case of trace file, we are using a seq file
so the buffer gets flushed after each entries.

Assuming the trace_seq is 4096 bytes long this is probably
enough for every function graph entries (even with headers and
interrupts), this is not something we are supposed to see in trace_seq.

I did not realized that when Jiri sent the first version of this patch.

 
> 
> > to be processed again in the next read.  And here comes the issue: 
> > the next read will see following pointers setup for func2 processing:
> > 
> >             func1 ENTRY
> > current ->  func2 ENTRY 
> >             func2 RETURN
> >    next ->  func1 RETURN
> > 
> > which will turn to displaying the func2 entry like: "func2() {", since the
> > next entry is not RETURN of the same type.  Generaly it is whatever entry 
> > that follows, but definitelly not the RETURN entry of the same function.
> > 
> > The destructive case (trace_pipe) suffers from the similar issue,
> > although it keeps only the current pointer.
> > 
> > </issue description>
> > 
> > 
> > The following patch propose generic solution for both cases.
> > It keeps the last read entry/return in the tracer private
> > iterator storage and keeps track of the failed output.
> > Whenever the output fails, next read will output previous
> > 'not displayed' entry before processing next entry.
> 
> Have you added tests to make sure that the trace_seq buffer is indeed
> filling up?  In the trace_pipe, this could happen when the user buffer
> gets full.
> 
> What I think you are seeing, is a buffer overflow during a run. If the
> trace buffer overflows, it will leave gaps in the trace. Those abandoned
> leaf functions are probably a result of a trace buffer wrap.
> 
> I don't thing this is the proper solution to the problem.


But I guess it doesn't happen because the function graph tracer
has too large entries, or it would do an endless loop while
reading the trace file.

It's more likely a bug somewhere in the trace_seq_* functions.

I'm going to have a look.

Thanks.

