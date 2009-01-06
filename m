Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZAFONw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZAFONw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 09:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZAFONn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 09:13:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:3100 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZAFONm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 09:13:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=trO5+4MatztQtVwKpczUmJIAQ3n5ZMiJqmI1NLs62J2h/C8KdMRBSgrp0ZjK0nT2wr
         a6ZMLn0ChnMRRfZcUdDajPHFF5pHlTJbEQPSfvBdUtYcEJAL8OCdiFkuoRS6put+mAUZ
         8QKMgvSjExrok8cPiVBGMjIXe1i9hHWOm6k9s=
Date: Tue, 6 Jan 2009 16:13:35 +0200
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: ftrace: struct tracer API and trace_iterator::private
Message-ID: <20090106161335.12f69487@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the tracing framework, struct trace_iterator has field 'private'. This
field is used by mmiotrace, I'm not sure if anything else uses it. The issue
here is, that there are no create and destroy operations defined for
struct trace_iterator. That object gets created ad hoc, and dies whenever,
which means that there is no sane way to clean up trace_iterator::private.

Mmiotrace uses trace_iterator::private to print the PCI device list in
the beginning of each trace, and it needs to allocate resources. Currently
these resources are released when the list is printed. If user space decides
to close the file before all devices are printed, we leak locks and memory.

Considering when and how mmiotrace is used, this is not a big problem, but
it is a bug. I am not quite sure how to fix this. I would like to introduce
create and destroy (or init and cleanup) calls for struct trace_iterator,
but it does not look trivial.

Another thing I'd like to point out here is the multitude of printing
callbacks in struct tracer:
- read
- print_header
- print_line

tracer::read is a low level callback, that can interrupt the reading of
entries from the ring buffer. This works only for the pipe.

tracer::print_header is called via trace_seq_ops when iter->ent is NULL,
and works only for the regular output (/debug/tracing/trace).

tracer::print_line is systematically called for every entry in the
ring buffer and works for both the pipe and the regular output.

Mmiotrace uses tracer::read to print its (long) header, and keeps track
of it via trace_iterator::private. Then there are the other header
printing functions that are directly called from trace.c:s_show().
Maybe tracer::read, tracer::print_header and the other functions
could be collected under a single tracer API callback, or at least use
the existing and more flexible interfaces instead of hard-coding where
possible.

It looks like there are two kinds of tracers: integrated and plugins.
Plugins, like mmiotrace, work via the (fairly) well defined tracer API.
Integrated tracers (latency tracer, function tracer, ...) are called
directly from the framework core, which makes the core big and difficult
to understand. File trace.c is over 3200 lines even after cutting stuff
out to trace_output.c.

I just feel the interface between the tracing framework core and the
myriad of tracers should be more clear, and maybe it is slowly going
that way. Unfortunately I do not have the time to seriously do
something about it, I can barely keep up maintaining mmiotrace. I just
wanted to express my concerns.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
