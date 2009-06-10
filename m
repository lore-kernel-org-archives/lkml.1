Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbZFJOjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbZFJOjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZFJOjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:39:14 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:43650 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990AbZFJOjN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:39:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEAEtgL0pMQW1W/2dsb2JhbACBT81uhA0F
Date: Wed, 10 Jun 2009 10:39:12 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Theodore Tso <tytso@mit.edu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] [GIT PULL] more updates for the tag format
Message-ID: <20090610143912.GB23770@Krystal>
References: <20090610054206.510574695@goodmis.org> <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu> <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:36:47 up 102 days, 11:03,  4 users,  load average: 0.22, 0.38,
	0.42
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Wed, 10 Jun 2009, Theodore Tso wrote:
> 
> > On Wed, Jun 10, 2009 at 01:11:40PM +0200, Frédéric Weisbecker wrote:
> > > Well, indeed I had worries, but I discussed about it with Steven and
> > > now I actually
> > > think this new tag format is much more powerful than printf style.
> > > It brings a cleaner, and much higher level way to control the data exports.
> > > 
> > > But it would be nice to read some opinions from end users (end
> > > developers) of TRACE_EVENT().
> > 
> > Maybe I'm missing something, but looks like the this new format, while
> > simpler and easier to read, doesn't have support for using a more
> > complicated C expression as a printk argument.  For example:
> > 
> > 	TP_printk("dev %s ino %lu mode %d uid %u gid %u blocks %llu",
> > 		  jbd2_dev_to_name(__entry->dev), __entry->ino, __entry->mode,
> > 		  __entry->uid, __entry->gid, __entry->blocks)
> > 
> > How should I handle the "jbd2_dev_to_name(__entry->dev)" argument to
> > TP_printk?  The whole point of calling jbd2_dev_to_name() at TP_printk
> > time is to not bloat the ring buffer with a 32 byte devname.
> 
> Understood, and the example you just gave also has the flaw that a 
> userspace tool could not parse it, because it would not know what to do 
> with "jbd2_dev_to_name()".
> 
> This is why I suggested keeping the TP_printk, for cases like this. Since 
> it is also currently useless in userspace.
> 
> But we really should convert all cases, and I was toying with an idea to 
> dynamically make your own data type, and be able to make a way to print 
> it. That is you could register:
> 
> register_trace_event_data_type(const char *name, 
> 	(int)(*print_func)(struct trace_seq *s, void *data, int size),
> 	const char *fmt, ...);
> 
> Where the name would be the data type you are making, the print_func is 
> how ftrace would print it in debugfs/tracing/trace, and the fmt, ... would 
> be who to show the user how to print it.
> 
> For example, for the GFP flags we could do something like:
> 
> /* helper routine */
> unsigned long long trace_get_word(void *p, int len)
> {
> 	unsigned long long val;
> 
>         switch (size) {
>         case 1:
>                 val = *(char *)p;
>                 break;
>         case 2:
>                 val = *(short *)p;
>                 break;
>         case 4:
>                 val = *(int *)p;
>                 break;
>         case 8:
>                 val = *(long long *)p;
>                 break;
>         default:
> 		WARN(1,"length %d not valid word size\n");
>                 return 0;
>         }
> 
>         return val;
> }
> 
> static int test_gfp(unsigned long *gfp, unsigned long mask)
> {
> 	if ((*gfp & mask) == mask) {
> 		*gfp &= ~mask;
> 		return 1;
> 	}
> 	return 0;
> }
> 
> #define test_gfp_name(under, name)			\
> 	if (test_gfp(&gfp, under##GFP_##name)) {	\
> 		if (first)				\
> 			first = 0;			\
> 		else					\
> 			trace_seq_putc(s, '|');		\
> 		trace_seq_puts(s, "GFP_" #name);	\
> 	}
> 
> 
> static int print_gfp(struct trace_seq *s, void *data, int len)
> {
> 	unsigned long gfp;
> 
> 	gfp = trace_get_word(data, len);
> 
> 	if (!gfp) {
> 		trace_seq_puts(s, GPF_NOWAIT);
> 		return 0;
> 	}
> 
> 	while (gfp) {
> 		test_gfp_name(,HIGHUSER_MOVABLE);
> 		test_gfp_name(,HIGHUSER);
> 		test_gfp_name(,USER);
> 		test_gfp_name(,TEMPORARY);
> 		test_gfp_name(,KERNEL);
> 		test_gfp_name(,NOFS);
> 		test_gfp_name(,ATOMIC);
> 		test_gfp_name(,NOIO);
> 		test_gfp_name(__,HIGH);
> 		test_gfp_name(__,WAIT);
> 		test_gfp_name(__,IO);
> 		test_gfp_name(__,COLD);
> 		test_gfp_name(__,NOWARN);
> 		test_gfp_name(__,REPEAT);
> 		test_gfp_name(__,NOFAIL);
> 		test_gfp_name(__,NORETRY);
> 		test_gfp_name(__,COMP);
> 		test_gfp_name(__,ZERO);
> 		test_gfp_name(__,NOMEMALLOC);
> 		test_gfp_name(__,HARDWALL);
> 		test_gfp_name(__,THISNODE);
> 		test_gfp_name(__,RECLAIMABLE);
> 		test_gfp_name(__,MOVABLE);
> 
> }
> 
> #define gfp_insert(under, name)	\
> 		(unsigned long)under##GFP_##name, "GFP_" #name
> 
> 	register_trace_event_data_type("gfp", print_gfp,
> 		"mask:\n"
> 	        " 0=GFP_NOWAIT,"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n"
> 		" 0x%lx=%s,\n",
> 		gfp_insert(,HIGHUSER_MOVABLE),
> 		gfp_insert(,HIGHUSER),
> 		gfp_insert(,USER),
> 		gfp_insert(,TEMPORARY),
> 		gfp_insert(,NOFS),
> 		gfp_insert(,ATOMIC),
> 		gfp_insert(,NOIO),
> 		gfp_insert(__,HIGH),
> 		gfp_insert(__,WAIT),
> 		gfp_insert(__,IO),
> 		gfp_insert(__,COLD),
> 		gfp_insert(__,NOWARN),
> 		gfp_insert(__,REPEAT),
> 		gfp_insert(__,NOFAIL),
> 		gfp_insert(__,NORETRY),
> 		gfp_insert(__,COMP),
> 		gfp_insert(__,ZERO),
> 		gfp_insert(__,NOMEMALLOC),
> 		gfp_insert(__,HARDWALL),
> 		gfp_insert(__,THISNODE),
> 		gfp_insert(__,RECLAIMABLE),
> 		gfp_insert(__,MOVEABLE));
> 
> 
> And then in the trace format, we could do:
> 
> 	<data:gfp:field>
> 
> And the 'data' will flag us to how to print the data.
> 
> For userland, there could be a file in:
> 
> 	/debug/tracing/events/data_types/gfp/format
> 
> That will show that format. Yes we duplicate some of the code, but it 
> it would solve these types of issues.
> 

It sounds a lot like the type tables LTTng is currently exporting
through specific channels. One for the list of IRQ handlers, one listing
softirqs, one for syscalls.... etc etc. The nice side of this approach
is that it permits to deal with dynamic events that modify the table
state while tracing is active, e.g. : loadling a module which adds an
IRQ handlers.

This is planned to be used for enum description eventually.

Mathieu

> -- Steve
> 
> 
> 		
> 		
> 	


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
