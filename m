Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbZFJOc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbZFJOc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 10:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbZFJOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 10:32:47 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:46424 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291AbZFJOcq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:32:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroEAAtgL0pMQW1W/2dsb2JhbACBT81shA0F
Date: Wed, 10 Jun 2009 10:32:44 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
Message-ID: <20090610143244.GA23770@Krystal>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org> <20090610101124.GA25042@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090610101124.GA25042@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:28:43 up 102 days, 10:54,  4 users,  load average: 0.67, 0.49,
	0.46
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, Jun 09, 2009 at 09:22:01PM +0200, Frederic Weisbecker wrote:
> > > But I wonder if the above new language is not breaking the charm
> > > of the TRACE_EVENT(), which charm is that it's easy to implement (hopefully).
> > > 
> > > Everyone knows the printk formats. And I guess this new thing is 
> > > easy and quick to learn. But because it's a new unknown 
> > > language, the TRACE_EVENT will become less readable, less 
> > > reachable for newcomers in TRACE_EVENT.
> > 
> > I must also say I don't particularly like it.  printk is nice and 
> > easy an everybody knows it, but it's not quite flexible enough as 
> > we might have to do all kinds of conversions on the reader side.  
> > What might be a better idea is to just have C function pointer for 
> > output conversions that could be put into the a file in debugfs 
> > and used by the binary trace buffer reader.  Or maybe not as we 
> > would pull in too many depenencies.
> 
> Another bigger problem with the new tag format, beyond introducing 
> an arbitrary descriptor language (which is easy to mess up) is the 
> loss of type checking.
> 
> With the tags the field printouts can go stray easily - while with 
> TP_printk() we had printf type checking. (which, as imperfect as it 
> may be to specify a format, does create a real connection between 
> the record and the output format specification.)
> 
> > I think we should go with the printk solution for 2.6.31 and use 
> > the full development cycle for 2.6.32 to come up with something 
> > better.
> >
> > As soon as a couple of large subsystems use the even tracer we 
> > also have a broader base examples to see how new syntax works on 
> > them.
> 
> I think much of the tooling problem could be solved with a little 
> trick: the format string can be injected into an artificial .c file 
> (runtime), and the tool could compile that .c file (in user-space) 
> and get access to the result.
> 
> For example, one of the more complex block tracepoints, 
> /debug/tracing/events/block/block_bio_backmerge:
> 
> print fmt: "%d,%d %s %llu + %u [%s]", ((unsigned int) ((REC->dev) >> 
> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) - 1))), REC->rwbs, 
> (unsigned long long)REC->sector, REC->nr_sector, REC->comm
> 
> when pasted verbatim into the stub below, produces:
> 
>    0,6 a 7 + 8 [abc]
> 
> Note that i pasted the format string into the code below unchanged, 
> and i used the format descriptor to create the record type. (this 
> too is easy to automate).
> 
> If this is generated into the following function:
> 
>  format_block_bio_backmerge(struct record *rec);
> 
> and a small dynamic library is built out of it, tooling can use 
> dlopen() to load those format printing stubs.
> 
> It's all pretty straightforward and can be used for arbitrarily 
> complex formats.
> 
> And i kind of like the whole notion on a design level as weell: the 
> kernel exporting C source code for tools :-)
> 

Hrm, it's problematic for users who run the userspace analysis tools on
different machine than their kernel. And also problematic for 64-bits
kernel/32-bits userland. A lot of embedded developers run on very
resource limited ARM boards and have to analyse the traces on a
different machine.

It would be much more flexible if we parse the event format description
from a userland tool than trying to use C as a direct way to export
trace metadata, which would cause us to build an ABI-specific,
non-portable, analyser tool.

Mathieu


> 	Ingo
> 
> ------------------>
> 
> struct record {
> 	unsigned short common_type;
> 	unsigned char common_flags;
> 	unsigned char common_preempt;
> 	int common_pid;
> 	int common_tgid;
> 	int dev;
> 	unsigned long long sector;
> 	unsigned int nr_sector;
> 	char rwbs[6];
> 	char comm[16];
> } this_record = { 1, 2, 3, 4, 5, 6, 7, 8, { 'a', }, "abc" };
> 
> void main(void)
> {
> 	struct record *REC = &this_record;
> 
> 	printf("%d,%d %s %llu + %u [%s]", ((unsigned int) ((REC->dev) >> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) - 1))), REC->rwbs, (unsigned long long)REC->sector, REC->nr_sector, REC->comm);
> }
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
