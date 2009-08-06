Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZHFL4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZHFL4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZHFL4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:56:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbZHFL4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:56:11 -0400
Date: Thu, 6 Aug 2009 07:55:27 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       acme <acme@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: malloc() tracing in perf?
Message-ID: <20090806115527.GE18768@redhat.com>
References: <4A7A8ADD.4080208@cs.helsinki.fi> <1249546610.32113.35.camel@twins> <20090806112059.GD18768@redhat.com> <1249558094.32113.242.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249558094.32113.242.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Aug 06, 2009 at 01:28:14PM +0200, Peter Zijlstra wrote:
> [...]
> > That work is ongoing, and being discussed on utrace-devel@redhat.com,
> > since it is a prerequisite. 
> 
> Still hiding the discussion and the design never helped anybody.

I guess "hiding" is a matter of opinion.


> > While these deliberations are ongoing, you can use systemtap.  Probing
> > random places in userspace is about as casual as probing the kernel:
> 
> Right, but that still doesn't tell us anything on how you're doing that,
> does it?

Since you asked...  the probe process("/lib64/libc.so.6") points
systemtap to a shared library file, whose symbol table & debug data
gives us information about what functions & parameters are available.
Among other things, we record a shared-library base-relative address
for the function.

At run time, we monitor the entire system (or just a given process if
-x PID/-c CMD was specified) to see when that shared library gets
loaded.  (This in turn is done with a utrace-based hook of the mmap
syscall - see "task_finder" in our sources).  When it's loaded, we can
finally compute a run-time address for the probed malloc/free
functions.  At this point we insert a uprobe (using the uprobes module
API, which also relies on utrace.)  Should the shared library become
unmapped, or the application exit, the uprobe will be removed.

When/if the uprobe eventually hits, we run the compiled probe handler.
As usual, it can do lots of stuff beside just simple tracing, but in
the case of that statement (println ($$parms ...))  that's all we do.
$$parms was expanded at compilation time to the list of variables, and
instructions about how to fetch their values at run time.  So now
those instructions are run, their values formatted, and the tracing
message sent to our buffer.

This overview skims over issues related to return probes, tracing
buffer manipulations, and much other stuff.


All the code for this is hidden in plain sight in every systemtap
release, so please feel free to refer to that and/or ask more detailed
questions.


- FChE
