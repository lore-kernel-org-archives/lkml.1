Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYLCAw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYLCAw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYLCAwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:52:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:60216 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYLCAwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:52:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:content-transfer-encoding;
	b=YX0HjX6hv0bf+WKqGq1l0EBWSufM4sh9MDFZQeTz3RRLRYkToDPl3OOheQIqYxjdb
	6Yk8tDTDsxMAdqIuJFQ7A==
MIME-Version: 1.0
Date: Tue, 2 Dec 2008 16:52:15 -0800
Message-ID: <5df78e1d0812021652w74c968bboba5e6457059b569b@mail.gmail.com>
Subject: [RFC PATCH 0/3] A couple of feature requests to the unified trace 
	buffer
From: Jiaying Zhang <jiayingz@google.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>, Martin Bligh <mbligh@google.com>,
       Michael Rubin <mrubin@google.com>, Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We have taken Steve's unified trace buffer patches while implementing our
kernel tracing prototype. The unified trace buffer has many features we need
and has simplified our implementation a lot. However, our use of the unified
trace buffer is slightly different from ftrace's cases. We need to trace large
amounts of data in a production environment, so it's critical that we have as
little impact on performance as possible.

We are particularly concerned about two performance requirements:

1. read large amounts of data from the unified trace buffer at little
performance cost.
2. write to the unified trace buffer with little performance overhead.

We are considering two approaches to satisfy the first requirement -
mmap vs splice. Right now, we only implemented mmap support, so I am
going to talk about that approach in detail. For the second requirement,
our performance tests suggest the use of inline versions of buffer write
functions for high-throughput kernel events, as described below.

The patches of our changes are sent following this email. We haven't tested
these patches much, and they are probably very buggy. However, we would
like to get some early feedback and see if we are headed in the right direction.
Here is the summary of the changes we made.

A major feature we would like to include in the unified trace buffer is the
mmap support. Instead of reading one event out of the buffer at a time, we
implemented a debugfs interface that allows a user-level program to mmap the
unified trace buffer and directly copy the trace data to a disk file or socket
descriptor. Compared with reading a single event at a time, this approach
saves a copy from kernel to user-space. It also allows a trace reader to read
bulk data in a single system call. We haven't yet conducted a performance
comparison, but we think the mmap approach will have a significant performance
advantage over the current read interface. To make mmap work, I made several
changes to the unified trace buffer code. The changes include an API that maps
a page offset to a physical page in a trace buffer,  APIs that export the offset
of the current produced/consumed data, and an API to advance the consumed
data pointer. The patch in the next email, "adding mmap support to the unified
trace buffer", contains the described changes. We notice that there are other
alternatives to save kernel to user-space copy, like splice_read. We haven't
explored those approaches yet. Implementations of those interfaces would be
very welcome.

Other helpful features from the unified trace buffer are the inline versions of
buffer write functions, i.e., ring_buffer_lock_reserve and
ring_buffer_unlock_commit. We found that function calls can add noticeable
overhead while tracing high-throughput events. According to our measurement,
the function calls from trace buffer writing alone add roughly 3% overhead
under the tbench benchmark. To see how we can eliminate this overhead,
I tried the inline versions of lock_reserve and unlock_commit (see the second
patch "adding inline buffer write functions to the unified trace buffer"). The
inline functions basically copy the existing code from ring_buffer_lock_reserve
and ring_buffer_unlock_commit. But to make it compile, I also need to move
certain functions to the header file. The side effect is that the interface
becomes less clean.

We may need more fundamental changes to implement inline versions of
ring buffer write functions while still keep the clean layered design.
Our goal is to enable certain kernel event tracing by default, so we
consider 3% a big saving and we think it is important to make sure that
entering an event into a cpu buffer is really fast.

I attached our current kernel tracing prototype in the third email to give
you an idea on how we intend to use the unified trace buffer. We will post
the trace prototype alone later, but would love to hear any early feedback.

Jiaying
