Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZFJLbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZFJLbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZFJLbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:31:07 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:64243 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZFJLbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JlNHgedeLzSioRv9sIpJUhY6ar6Eivge7JwXapsvL62cp7BCp7qOtgg1RS8klt7CFy
         dWU9aNv6vKIu+16iNoQgcGglUb4NRCxDR9zzuLduChuEHngZLpbWR5C5XWKbYsIeRrFH
         C2rVB9dfbrmhI3796yiFLuRFb2goxmOVTNJjg=
MIME-Version: 1.0
In-Reply-To: <20090610101124.GA25042@elte.hu>
References: <20090609014534.790466803@goodmis.org>
	 <20090609014746.481457542@goodmis.org> <20090609192159.GD6057@nowhere>
	 <20090610094819.GA25527@infradead.org>
	 <20090610101124.GA25042@elte.hu>
Date: Wed, 10 Jun 2009 13:31:06 +0200
Message-ID: <c62985530906100431g4ceab378w55250e50219f4650@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] tracing/events: nicer print format for parsing
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/10 Ingo Molnar <mingo@elte.hu>:
>
> * Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Tue, Jun 09, 2009 at 09:22:01PM +0200, Frederic Weisbecker wrote:
>> > But I wonder if the above new language is not breaking the charm
>> > of the TRACE_EVENT(), which charm is that it's easy to implement (hopefully).
>> >
>> > Everyone knows the printk formats. And I guess this new thing is
>> > easy and quick to learn. But because it's a new unknown
>> > language, the TRACE_EVENT will become less readable, less
>> > reachable for newcomers in TRACE_EVENT.
>>
>> I must also say I don't particularly like it.  printk is nice and
>> easy an everybody knows it, but it's not quite flexible enough as
>> we might have to do all kinds of conversions on the reader side.
>> What might be a better idea is to just have C function pointer for
>> output conversions that could be put into the a file in debugfs
>> and used by the binary trace buffer reader.  Or maybe not as we
>> would pull in too many depenencies.
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
>> I think we should go with the printk solution for 2.6.31 and use
>> the full development cycle for 2.6.32 to come up with something
>> better.
>>
>> As soon as a couple of large subsystems use the even tracer we
>> also have a broader base examples to see how new syntax works on
>> them.
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
>   0,6 a 7 + 8 [abc]
>
> Note that i pasted the format string into the code below unchanged,
> and i used the format descriptor to create the record type. (this
> too is easy to automate).
>
> If this is generated into the following function:
>
>  format_block_bio_backmerge(struct record *rec);
>
> and a small dynamic library is built out of it, tooling can use
> dlopen() to load those format printing stubs.
>
> It's all pretty straightforward and can be used for arbitrarily
> complex formats.



Hmm



> And i kind of like the whole notion on a design level as weell: the
> kernel exporting C source code for tools :-)
>
>        Ingo
>
> ------------------>
>
> struct record {
>        unsigned short common_type;
>        unsigned char common_flags;
>        unsigned char common_preempt;
>        int common_pid;
>        int common_tgid;
>        int dev;
>        unsigned long long sector;
>        unsigned int nr_sector;
>        char rwbs[6];
>        char comm[16];
> } this_record = { 1, 2, 3, 4, 5, 6, 7, 8, { 'a', }, "abc" };
>
> void main(void)
> {
>        struct record *REC = &this_record;
>
>        printf("%d,%d %s %llu + %u [%s]", ((unsigned int) ((REC->dev) >> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) - 1))), REC->rwbs, (unsigned long long)REC->sector, REC->nr_sector, REC->comm);
> }


Yeah it's a quite nice idea.
But it's assuming everyone parses binary files using C programs.
Usually, such parsing
more likely involves the use of scripting languages.
