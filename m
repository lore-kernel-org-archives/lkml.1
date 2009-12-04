Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZLDKqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZLDKqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZLDKqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:46:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbZLDKqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:46:20 -0500
Date: Fri, 4 Dec 2009 11:46:16 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
Message-ID: <20091204104616.GC1931@jolsa.lab.eng.brq.redhat.com>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
 <1259082845.22249.1110.camel@gandalf.stny.rr.com>
 <20091124211423.GE5071@nowhere>
 <20091125084525.GA1940@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125084525.GA1940@jolsa.lab.eng.brq.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 09:45:25AM +0100, Jiri Olsa wrote:
> On Tue, Nov 24, 2009 at 10:14:36PM +0100, Frederic Weisbecker wrote:
> > On Tue, Nov 24, 2009 at 12:14:05PM -0500, Steven Rostedt wrote:
> > > On Tue, 2009-11-24 at 13:57 +0100, Jiri Olsa wrote:
> > > > Hi,
> > > > 
> > > > there's a case where the graph tracer might get confused and omits
> > > > display of a single record.  This applies for both destructive
> > > > (trace_pipe) and nondestructive (trace) cases.
> > > > 
> > > > 
> > > > <issue description>
> > > > 
> > > > The issue description for nondestructive case (trace) follows:
> > > > 
> > > > As the function_graph tracer goes through the trace entries (using "trace" file)
> > > > it keeps pointer to the current record and the next one:
> > > > 
> > > > current ->  func1 ENTRY
> > > >    next ->  func2 ENTRY
> > > >             func2 RETURN
> > > >             func1 RETURN
> > > > 
> > > > If it spots adjacent ENTRY and RETURN trace entries of the same function
> > > > and pid, it displays the "func2();" trace
> > > > 
> > > >             func1 ENTRY
> > > > current ->  func2 ENTRY 
> > > >    next ->  func2 RETURN
> > > >             func1 RETURN
> > > > 
> > > > and moves the next trace entry pointer behind the RETURN entry
> > > > 
> > > >             func1 ENTRY
> > > > current ->  func2 ENTRY 
> > > >             func2 RETURN
> > > >    next ->  func1 RETURN
> > > > 
> > > > so the next record peek will skip the RETURN entry and continue with
> > > > whatever is next.
> > > > 
> > > > It works ok but for one case. 
> > > > 
> > > > If the "func2()" trace does not make it to the seq_file read buffer, it needs
> > > 
> > > In the trace_pipe it may be possible to fill the trace_seq buffer if the
> > > buffer passed into userspace is larger than the trace_seq buffer. But
> > > the trace_seq buffer should never overflow on the "trace" case. If it
> > > is, then there's probably another bug.
> > 
> > 
> > 
> > Hmm, yeah in trace_pipe case we repeat until we have no space
> > left in trace_seq (TRACE_TYPE_PARTIAL_LINE), or until we
> > the user buffer is filled.
> > 
> > But indeed in case of trace file, we are using a seq file
> > so the buffer gets flushed after each entries.
> > 
> > Assuming the trace_seq is 4096 bytes long this is probably
> > enough for every function graph entries (even with headers and
> > interrupts), this is not something we are supposed to see in trace_seq.
> > 
> > I did not realized that when Jiri sent the first version of this patch.
> 
> sure, but it is not the trace_seq structure that overflows, it is the bare 
> seq_file underneath. The s_show calls "trace_print_seq":
> 
> void trace_print_seq(struct seq_file *m, struct trace_seq *s)
> {               
>         int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
>         
>         seq_write(m, s->buffer, len);
> 
>         trace_seq_init(s);
> }               
> 
> it flushes the trace_seq to the seq_file and reinits the trace_seq.
> But the seq_file will get filled in the end, ending up with
> not displayed output in that case I described in the first email.
> 

hi, any feedback on this?

thanks,
jirka


> > 
> >  
> > > 
> > > > to be processed again in the next read.  And here comes the issue: 
> > > > the next read will see following pointers setup for func2 processing:
> > > > 
> > > >             func1 ENTRY
> > > > current ->  func2 ENTRY 
> > > >             func2 RETURN
> > > >    next ->  func1 RETURN
> > > > 
> > > > which will turn to displaying the func2 entry like: "func2() {", since the
> > > > next entry is not RETURN of the same type.  Generaly it is whatever entry 
> > > > that follows, but definitelly not the RETURN entry of the same function.
> > > > 
> > > > The destructive case (trace_pipe) suffers from the similar issue,
> > > > although it keeps only the current pointer.
> > > > 
> > > > </issue description>
> > > > 
> > > > 
> > > > The following patch propose generic solution for both cases.
> > > > It keeps the last read entry/return in the tracer private
> > > > iterator storage and keeps track of the failed output.
> > > > Whenever the output fails, next read will output previous
> > > > 'not displayed' entry before processing next entry.
> > > 
> > > Have you added tests to make sure that the trace_seq buffer is indeed
> > > filling up?  In the trace_pipe, this could happen when the user buffer
> > > gets full.
> 
> that should be in the trace_output.c part of the patch,
> each display function set the 'failed' flag appropriatelly
> 
> > > 
> > > What I think you are seeing, is a buffer overflow during a run. If the
> > > trace buffer overflows, it will leave gaps in the trace. Those abandoned
> > > leaf functions are probably a result of a trace buffer wrap.
> > > 
> > > I don't thing this is the proper solution to the problem.
> 
> I can see other solution, which would need to move the look ahead
> skip of the record in the 'get_return_for_leaf' function.
> 
> jirka
> > 
> > 
> > But I guess it doesn't happen because the function graph tracer
> > has too large entries, or it would do an endless loop while
> > reading the trace file.
> > 
> > It's more likely a bug somewhere in the trace_seq_* functions.
> > 
> > I'm going to have a look.
> > 
> > Thanks.
> > 
