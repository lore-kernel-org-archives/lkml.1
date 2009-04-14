Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbZDNVYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbZDNVYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZDNVXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:23:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbZDNVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:23:46 -0400
Date: Tue, 14 Apr 2009 17:23:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
In-Reply-To: <20090414210445.GM955@mit.edu>
Message-ID: <alpine.DEB.2.00.0904141716300.31421@gandalf.stny.rr.com>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 14 Apr 2009, Theodore Tso wrote:

> On Tue, Apr 14, 2009 at 01:23:37PM -0400, Steven Rostedt wrote:
> > 
> > Removal of the two headers per trace system. No need to have
> > include/trace/sched.h and include/linux/sched_event_types.h
> > All the changes go into include/trace/sched.h. But note that how that
> > file is made is important. One could look at the sched.h file, or
> > skb.h, lockdep.h and kmem.h as an example.
> 
> Hi Steven,
> 
> One thing which I would really like is to avoid needing to drop the
> header file in include/trace/<subsystem.h>.
> 
> The problem that I have with this is that for ext4, we need to access
> private data structures which are defined in header files in
> fs/ext4/*.h --- which we moved into fs/ext4 a long time ago at the
> request of those who felt include/linux/* was getting rather
> cluttered, and if a subsystem had header files which were only needed
> by files for that particular subsystems, they should be moved out of
> include/linux.  
> 
> I supported the above-mentioned cleanup, but it's causing problems
> given that include/trace/ext4_events_types.h (or include/trace/ext4.h
> in the new world order) needs access to various structure definitions
> in fs/ext4/*.h.  I could move the required header files into
> include/linux/ext4_tracing_types.h --- which has the downside that it
> is a very random collection of data structures --- or I could entirely
> revert the cleanup we did long ago and move all of the ext4 header
> files back into include/linux.  But better yet would be if there was
> some way we could tell the tracing subsystem that tracing header file
> for ext4 could be found in fs/ext4/ext4_trace.h.
> 
> Any chance you could support something like this?

Yes, at the bottom of your header file, before including define_trace.h, 
you can simply add:

#undef TRACE_INCLUDE_PATH
#define TRACE_INCLUDE_PATH ../../fs/ext4

#include <trace/define_trace.h>

the TRACE_INCLUDE_PATH is a reference from where trace/define_trace.h is 
located. It may even be cleaner to do:


#undef TRACE_INCLUDE_PATH
#define TRACE_INCLUDE_PATH EXT4_PATH

and in the Makefile have:

CFLAGS_ext4_jbd2.o := -DEXT4_PATH=$(PWD)

That's something like what I did for my external module test.

-- Steve


