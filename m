Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZHFLWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZHFLWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZHFLWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:22:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbZHFLWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:22:00 -0400
Date: Thu, 6 Aug 2009 07:20:59 -0400
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
Message-ID: <20090806112059.GD18768@redhat.com>
References: <4A7A8ADD.4080208@cs.helsinki.fi> <1249546610.32113.35.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249546610.32113.35.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Aug 06, 2009 at 10:16:50AM +0200, Peter Zijlstra wrote:
> [...]
> > But then it hit me, why can't I have kmemtrace + perf but for 
> > user-space? Something like the "Malloc Trace" shown here:
> > [...]

> I seem to have heard people are working on such a thing, but I can't
> seem to find a single LKML post with 'uprobe' in the subject in the
> past two years [...]

That work is ongoing, and being discussed on utrace-devel@redhat.com,
since it is a prerequisite.  One of the widgets that is being proposed
for it is an ftrace engine frontend for uprobes, paralleling the one
mhiramat wrote for kprobes.


> Now doing probes on userspace is hard because you need to know more
> about the userspace bits than a kernel really ought to be interested
> in.  [...]  Anyway, like you say, it has uses (potentially very
> powerful ones), Sun/Apple do it with Dtrace, Linux wants it but I
> don't think we quite agreed on how to do it :-)

While these deliberations are ongoing, you can use systemtap.  Probing
random places in userspace is about as casual as probing the kernel:


# stap -e '
   probe process("/lib/libc.so.6").function("malloc").return,
         process("/lib/libc.so.6").function("free").return
   { println(probfunc()," ",$$parms," ",$$return) }
' -c 'ls'   # -c 'CMD ARGS'

__libc_malloc bytes=0x238  return=0x1524010 
__libc_malloc bytes=0x238  return=0x1524010 
__libc_malloc bytes=0x78  return=0x1524250 
__libc_malloc bytes=0xa  return=0x15242d0 
__libc_free mem=0x1524250  
__libc_free mem=0x1524010  
__libc_malloc bytes=0x64  return=0x1524010 
__libc_malloc bytes=0x16  return=0x1524080 
__libc_free mem=0x1524010  
__libc_malloc bytes=0x64  return=0x1524010 
[...]
__libc_free mem=0x1524490  
__libc_free mem=0x1524500  
__libc_free mem=0x15245e0  
__libc_free mem=0x1524620  
__libc_free mem=0x1524430  
__libc_free mem=0x1524570  
__libc_free mem=0x1524660  
__libc_free mem=0x15246d0  
__libc_free mem=0x15242d0  

You can google some other success stories or ask for more help at
systemtap@sourceware.org.


- FChE
