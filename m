Return-Path: <linux-kernel-owner+w=401wt.eu-S1759904AbZFITpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904AbZFITpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 15:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbZFITph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 15:45:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbZFITpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 15:45:36 -0400
Date: Tue, 9 Jun 2009 15:45:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
In-Reply-To: <20090609192159.GD6057@nowhere>
Message-ID: <alpine.DEB.2.00.0906091531090.30552@gandalf.stny.rr.com>
References: <20090609014534.790466803@goodmis.org> <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 9 Jun 2009, Frederic Weisbecker wrote:
> 
>  
> > The language that is added by this patch is of the following:
> > 
> >  * FMT :=  constant string FMT | COMMAND FMT | empty
> >  * COMMAND := <TYPE:FIELD> | <mask:FIELD:DELIM:MASKS> | <sym:FIELD:SYMBOLS> |
> >  *               <if:FIELD:TRUE:FALSE>
> >  * TYPE := int | hex | ptr | string | strarray
> >  * FIELD := defined by the event structure
> >  * MASKS := MASK=NAME,MASKS | MASK=NAME
> >  * MASK := the bit mask to match
> >  * DELIM := delimiter to separate the fields. None and ':' are both allowed
> >  * SYMBOLS := SYM=NAME,SYMBOLS | SYM=NAME
> >  * SYM := the symbol value to test against
> >  * TRUE := print when field is non zero
> >  * FALSE := print when field is zero or NULL
> >  * NAME := the name to write when a match is found
> >  *
> >  * A '\<' would print '<'
> 
> 
> But I wonder if the above new language is not breaking the charm
> of the TRACE_EVENT(), which charm is that it's easy to implement (hopefully).
> 
> Everyone knows the printk formats. And I guess this new thing is easy and
> quick to learn. But because it's a new unknown language, the TRACE_EVENT
> will become less readable, less reachable for newcomers in TRACE_EVENT.

I tried to avoid this too, but when I started writing a tool in C that 
would parse the format file, I found that the printf was horrible.

Note, I will still keep the TP_printk() macro, that will not change. The 
new macro is TP_FORMAT() that preforms the tags. Thus, if you really want 
it to print out, you can use TP_printk, but the user space tools that read 
the binary will not know how to read it unless the printk is simple.

I really want to keep this language simple. If anyone has any better 
ideas, I'm all for it.

I barfed when I saw this in irq_handler_entry:

  print fmt: "irq=%d handler=%s", REC->irq, (char *)((void *)REC + REC->__data_loc_name)

That we probably can get to show something like:

  print fmt: "irq=%d handler=%s", REC->irq, __get_string(REC->name)

I plan on also adding some type tags. Perhaps adding a GFP that would do 
the flags for kmem, and have a way to export the values in another file.

But for now, I would like to add the tags "major" and "minor" that would 
get the major and minor from a device:

  <major:dev>  <minor:dev>

And also one that can handle time:

  <nsec2usec:nsec> that would convert a ns time to the "%lu.%03lu" format, 
or even a <nsec2sec:n:nsec> that would convert to "%lu.%0" n "lu" format.

Again, anyone have any better ideas?

-- Steve



