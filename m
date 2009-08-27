Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZH0QRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZH0QRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 12:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZH0QRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 12:17:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:14858 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZH0QRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 12:17:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i6MnOF7haPqMvvNyMShdf8ndzRFz6pdyRp8p6tqTnahR3hETdZiwo+QvzmUAForKws
         88smIZvO5COZcrOTbTf9MMOLBA/5jCV8mXABOjqmzGwREgTadd3FYuzIE9LW2LiN6DC6
         GPAMwLcqHZfOcb9u1hgM9dyrIBaBx6NG1PzPM=
Date: Thu, 27 Aug 2009 18:17:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH] tracing: Undef TRACE_EVENT_FN between trace events headers
	inclusion
Message-ID: <20090827161732.GA7618@nowhere>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251344087-28719-1-git-send-email-fweisbec@gmail.com> <20090827152438.GA32553@elte.hu> <20090827155912.GH6058@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827155912.GH6058@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 05:59:14PM +0200, Frederic Weisbecker wrote:
> On Thu, Aug 27, 2009 at 05:24:38PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Ingo,
> > > 
> > > This v2 can be either pulled after tracing/kprobes (the v1) or can 
> > > be pulled alone, it is based on the previous one and addresses 
> > > reviews from Li Zefan.
> > > 
> > > Thanks,
> > > Frederic.
> > > 
> > > The following changes since commit 24851d2447830e6cba4c4b641cb73e713f312373:
> > >   Frederic Weisbecker (1):
> > >         tracing/kprobes: Dump the culprit kprobe in case of kprobe recursion
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git \
> > > 	tracing/kprobes-2
> > > 
> > > Frederic Weisbecker (2):
> > >       tracing: Restore the const qualifier for field names and types definition
> > >       tracing: Remove unneeded pointer casts
> > > 
> > >  include/linux/ftrace_event.h  |    6 +++---
> > >  kernel/trace/trace_events.c   |    4 ++--
> > >  kernel/trace/trace_syscalls.c |    8 ++++----
> > >  3 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > I've pulled it into a staging branch (not yet in tip:master either 
> > and not yet on the road to upstream either), thanks guys!
> > 
> > I have done some brief testing. One hickup is this build failure on 
> > x86, caused by the kprobes instruction decoder self-test:
> > 
> >    CHK     include/linux/compile.h
> >    TEST    posttest
> >  Error: 41001024:        a1 08 30 c9 41          mov    
> >  0x41c93008,%eax
> >  Error: objdump says 5 bytes, but insn_get_length() says 9 (attr:40000)
> > 
> > another one is this build warning:
> > 
> >  In file included from include/trace/events/napi.h:5,
> >                   from net/core/net-traces.c:28:
> >  include/linux/tracepoint.h:285:1: warning: "TRACE_EVENT_FN" redefined
> >  In file included from include/trace/define_trace.h:61,
> >                   from include/trace/events/skb.h:40,
> >                   from net/core/net-traces.c:27:
> >  include/trace/ftrace.h:50:1: warning: this is the location of the previous definition
> > 
> > config attached.
> > 
> > 	Ingo
> 
> 
> That happens also in a pure -tip master.
> 


The below patch should solve this problem.


---
>From e9ff53c590ed08f28bcaaff547ae559e809d963a Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 27 Aug 2009 18:05:11 +0200
Subject: [PATCH] tracing: Undef TRACE_EVENT_FN between trace events headers inclusion

The recent commit:
	tracing/events: fix the include file dependencies
fixed a file dependency problem while including more than
one trace event header file.

This fix undefined TRACE_EVENT after an event header macro
preprocessing in order to make tracepoint.h able to correctly declare
the tracepoints necessary for the next event header file.

But now we also need to undefine TRACE_EVENT_FN at the end of an event
header file preprocessing for the same reason.

This fixes the following build error:

In file included from include/trace/events/napi.h:5,
                 from net/core/net-traces.c:28:
include/linux/tracepoint.h:285:1: warning: "TRACE_EVENT_FN" redefined
In file included from include/trace/define_trace.h:61,
                 from include/trace/events/skb.h:40,
                 from net/core/net-traces.c:27:
include/trace/ftrace.h:50:1: warning: this is the location of the previous definition
In file included from include/trace/events/napi.h:5,
                 from net/core/net-traces.c:28:
include/linux/tracepoint.h:285:1: warning: "TRACE_EVENT_FN" redefined
In file included from include/trace/define_trace.h:61,
                 from include/trace/events/skb.h:40,
                 from net/core/net-traces.c:27:
include/trace/ftrace.h:50:1: warning: this is the location of the previous definition

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/define_trace.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index a89ed59..2a4b3bf 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -62,6 +62,7 @@
 #endif
 
 #undef TRACE_EVENT
+#undef TRACE_EVENT_FN
 #undef TRACE_HEADER_MULTI_READ
 
 /* Only undef what we defined in this file */
-- 
1.6.2.3


