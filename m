Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbZDNWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbZDNWEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZDNWEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:04:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZDNWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:04:08 -0400
Date: Tue, 14 Apr 2009 18:04:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/8] tracing: consolidate trace and trace_event headers
In-Reply-To: <20090414215102.GG5968@nowhere>
Message-ID: <alpine.DEB.2.00.0904141801370.31421@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org> <20090414172640.556670154@goodmis.org> <20090414215102.GG5968@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Frederic Weisbecker wrote:

> On Tue, Apr 14, 2009 at 01:23:38PM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: clean up
> > 
> > Neil Horman (et. al.) criticized the way the trace events were broken up
> > into two files. The reason for that was that ftrace needed to separate out
> > the declarations from where the #include <linux/tracepoint.h> was used.
> > It then dawned on me that the tracepoint.h header only needs to define the
> > TRACE_EVENT macro if it is not already defined.
> > 
> > The solution is simply to test if TRACE_EVENT is defined, and if it is not
> > then the linux/tracepoint.h header can define it. This change consolidates
> > all the <traces>.h and <traces>_event_types.h into the <traces>.h file.
> > 
> > Reported-by: Neil Horman <nhorman@tuxdriver.com>
> > Reported-by: Theodore Tso <tytso@mit.edu>
> > Reported-by: Jiaying Zhang <jiayingz@google.com>
> > Cc: Zhaolei <zhaolei@cn.fujitsu.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Jason Baron <jbaron@redhat.com>
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/tracepoint.h          |    9 +-
> >  include/trace/irq.h                 |   51 +++++-
> >  include/trace/irq_event_types.h     |   55 ------
> >  include/trace/kmem.h                |  189 +++++++++++++++++++-
> >  include/trace/lockdep.h             |   52 +++++-
> >  include/trace/lockdep_event_types.h |   57 ------
> >  include/trace/sched.h               |  333 ++++++++++++++++++++++++++++++++++-
> >  include/trace/sched_event_types.h   |  337 -----------------------------------
> >  include/trace/skb.h                 |   36 ++++-
> >  include/trace/skb_event_types.h     |   38 ----
> >  include/trace/trace_event_types.h   |    7 -
> >  kernel/trace/events.c               |    1 +
> >  kernel/trace/trace_events_stage_1.h |    4 +-
> >  kernel/trace/trace_events_stage_2.h |    8 +-
> >  kernel/trace/trace_events_stage_3.h |    4 +-
> >  15 files changed, 663 insertions(+), 518 deletions(-)
> >  delete mode 100644 include/trace/irq_event_types.h
> >  delete mode 100644 include/trace/lockdep_event_types.h
> >  delete mode 100644 include/trace/sched_event_types.h
> >  delete mode 100644 include/trace/skb_event_types.h
> >  delete mode 100644 include/trace/trace_event_types.h
> 
> 
> 
> I don't know if you use git-format-patch without -M or
> something else specific to git pull request. But it looks
> like the renames are not detected here, so it's a bit
> hard to know what have been actually happened or deleted
> in the end result.
> 

Hmm, good point. I use git format-patch with no options and then use quilt 
to send the emair. I always want the patches to work with quilt, thus I 
avoid anything git specific.

My repo is public, so anyone can still look at it and run any git command 
they want.

-- Steve

