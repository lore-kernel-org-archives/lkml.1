Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbZAGJc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbZAGJc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbZAGJcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:32:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:41107 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZAGJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:32:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gwb3q6bnjIncWtAv937r+/1dO+IM35luqLDKlwIqmcPrCe9wYzpR3fXmYGLQKgn3Y8
         x0hS6zC/OX6JINYKDBG5DhIA8m/pY3T+NooAyo0H2v24IHNIzjoK4nBwappjRludu1L4
         f00ETsMeRugeZ/wqYNpvDGXGdj4miRo+Fvofc=
Date: Wed, 7 Jan 2009 10:32:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: ftrace: struct tracer API and trace_iterator::private
Message-ID: <20090107093200.GB6401@nowhere>
References: <20090106161335.12f69487@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106161335.12f69487@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 04:13:35PM +0200, Pekka Paalanen wrote:
> Hi,
> 
> In the tracing framework, struct trace_iterator has field 'private'. This
> field is used by mmiotrace, I'm not sure if anything else uses it. The issue
> here is, that there are no create and destroy operations defined for
> struct trace_iterator. That object gets created ad hoc, and dies whenever,
> which means that there is no sane way to clean up trace_iterator::private.
> 
> Mmiotrace uses trace_iterator::private to print the PCI device list in
> the beginning of each trace, and it needs to allocate resources. Currently
> these resources are released when the list is printed. If user space decides
> to close the file before all devices are printed, we leak locks and memory.
> 
> Considering when and how mmiotrace is used, this is not a big problem, but
> it is a bug. I am not quite sure how to fix this. I would like to introduce
> create and destroy (or init and cleanup) calls for struct trace_iterator,
> but it does not look trivial.
> 
> Another thing I'd like to point out here is the multitude of printing
> callbacks in struct tracer:
> - read
> - print_header
> - print_line
> 
> tracer::read is a low level callback, that can interrupt the reading of
> entries from the ring buffer. This works only for the pipe.
> 
> tracer::print_header is called via trace_seq_ops when iter->ent is NULL,
> and works only for the regular output (/debug/tracing/trace).
> 
> tracer::print_line is systematically called for every entry in the
> ring buffer and works for both the pipe and the regular output.
> 
> Mmiotrace uses tracer::read to print its (long) header, and keeps track
> of it via trace_iterator::private. Then there are the other header
> printing functions that are directly called from trace.c:s_show().
> Maybe tracer::read, tracer::print_header and the other functions
> could be collected under a single tracer API callback, or at least use
> the existing and more flexible interfaces instead of hard-coding where
> possible.


Hi Pekka,


I think you're right. You are using read as a trick to print your headers
on trace_pipe.
Actually print_header should probably work on both trace and trace_pipe.
It needs to change the parameter passed to trace_header, probably turning
the seq_file into a trace_iterator to make it generic for both trace and trace_pipe,
and then let it catch headers in more than one shot because your headers are
probably too large for the seq buffer.

This change would solve the problem of a generic handler.
Concerning your free of allocation and lock, I guess two callbacks can
be added on struct tracer (unfortunately adding some complexity in it,
but if the optional annotation is added, it could go well):

_file_open and file_release

both adapted for seq files and pipes to signal the tracer that the file
is opened or released. You could put or release your allocated and private
datas on them and retrieve them in the trace_iterator on each callback.

It's just an opinion...

 
> It looks like there are two kinds of tracers: integrated and plugins.
> Plugins, like mmiotrace, work via the (fairly) well defined tracer API.
> Integrated tracers (latency tracer, function tracer, ...) are called
> directly from the framework core, which makes the core big and difficult
> to understand. File trace.c is over 3200 lines even after cutting stuff
> out to trace_output.c.
> 
> I just feel the interface between the tracing framework core and the
> myriad of tracers should be more clear, and maybe it is slowly going
> that way. Unfortunately I do not have the time to seriously do
> something about it, I can barely keep up maintaining mmiotrace. I just
> wanted to express my concerns.


IMHO, perhaps the trace insertions of integrated tracers, and other particular tracers
things should be put in their own tracer files. That could indeed make more clear
the tracing core in trace.c


> 
> Thanks.
> 
> -- 
> Pekka Paalanen
> http://www.iki.fi/pq/

