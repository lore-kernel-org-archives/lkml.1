Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbZFJKMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbZFJKMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 06:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbZFJKMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 06:12:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZFJKMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 06:12:09 -0400
Date: Wed, 10 Jun 2009 12:11:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
Message-ID: <20090610101124.GA25042@elte.hu>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere> <20090610094819.GA25527@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610094819.GA25527@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jun 09, 2009 at 09:22:01PM +0200, Frederic Weisbecker wrote:
> > But I wonder if the above new language is not breaking the charm
> > of the TRACE_EVENT(), which charm is that it's easy to implement (hopefully).
> > 
> > Everyone knows the printk formats. And I guess this new thing is 
> > easy and quick to learn. But because it's a new unknown 
> > language, the TRACE_EVENT will become less readable, less 
> > reachable for newcomers in TRACE_EVENT.
> 
> I must also say I don't particularly like it.  printk is nice and 
> easy an everybody knows it, but it's not quite flexible enough as 
> we might have to do all kinds of conversions on the reader side.  
> What might be a better idea is to just have C function pointer for 
> output conversions that could be put into the a file in debugfs 
> and used by the binary trace buffer reader.  Or maybe not as we 
> would pull in too many depenencies.

Another bigger problem with the new tag format, beyond introducing 
an arbitrary descriptor language (which is easy to mess up) is the 
loss of type checking.

With the tags the field printouts can go stray easily - while with 
TP_printk() we had printf type checking. (which, as imperfect as it 
may be to specify a format, does create a real connection between 
the record and the output format specification.)

> I think we should go with the printk solution for 2.6.31 and use 
> the full development cycle for 2.6.32 to come up with something 
> better.
>
> As soon as a couple of large subsystems use the even tracer we 
> also have a broader base examples to see how new syntax works on 
> them.

I think much of the tooling problem could be solved with a little 
trick: the format string can be injected into an artificial .c file 
(runtime), and the tool could compile that .c file (in user-space) 
and get access to the result.

For example, one of the more complex block tracepoints, 
/debug/tracing/events/block/block_bio_backmerge:

print fmt: "%d,%d %s %llu + %u [%s]", ((unsigned int) ((REC->dev) >> 
20)), ((unsigned int) ((REC->dev) & ((1U << 20) - 1))), REC->rwbs, 
(unsigned long long)REC->sector, REC->nr_sector, REC->comm

when pasted verbatim into the stub below, produces:

   0,6 a 7 + 8 [abc]

Note that i pasted the format string into the code below unchanged, 
and i used the format descriptor to create the record type. (this 
too is easy to automate).

If this is generated into the following function:

 format_block_bio_backmerge(struct record *rec);

and a small dynamic library is built out of it, tooling can use 
dlopen() to load those format printing stubs.

It's all pretty straightforward and can be used for arbitrarily 
complex formats.

And i kind of like the whole notion on a design level as weell: the 
kernel exporting C source code for tools :-)

	Ingo

------------------>

struct record {
	unsigned short common_type;
	unsigned char common_flags;
	unsigned char common_preempt;
	int common_pid;
	int common_tgid;
	int dev;
	unsigned long long sector;
	unsigned int nr_sector;
	char rwbs[6];
	char comm[16];
} this_record = { 1, 2, 3, 4, 5, 6, 7, 8, { 'a', }, "abc" };

void main(void)
{
	struct record *REC = &this_record;

	printf("%d,%d %s %llu + %u [%s]", ((unsigned int) ((REC->dev) >> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) - 1))), REC->rwbs, (unsigned long long)REC->sector, REC->nr_sector, REC->comm);
}

