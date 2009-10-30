Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZJ3XVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZJ3XVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 19:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933036AbZJ3XVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 19:21:37 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:62784 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932997AbZJ3XVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 19:21:37 -0400
MIME-Version: 1.0
Date: Fri, 30 Oct 2009 16:21:39 -0700
Message-ID: <47c554d90910301621y1f19a96bx454f539adec1ae35@mail.gmail.com>
Subject: SSD read latency negatively impacted by large writes (independent of 
	choice of I/O scheduler)
From: Zubin Dittia <zubin@tintri.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing some testing with an Intel X25-E SSD, and noticed that
large writes can severely affect read latency, regardless of which I/O
scheduler or scheduler parameters are in use (this is with kernel
2.6.28-16 from Ubuntu jaunty 9.04).  The test was very simple: I had
two threads running; the first was in a tight loop reading different
4KB sized blocks (and recording the latency of each read) from the SSD
block device file.  While the first thread is doing this, a second
thread does a single big 5MB write to the device.  What I noticed is
that about 30 seconds after the write (which is when the write is
actually written back to the device from buffer cache), I see a very
large spike in read latency: from 200 microseconds to 25 milliseconds.
 This seems to imply that the writes issued by the scheduler are not
being broken up into sufficiently small chunks with interspersed
reads; instead, the whole sequential write seems to be getting issued
while starving reads during that period.  I've noticed the same
behavior with SSDs from another vendor as well, and there the latency
impact was even worse (80 ms).  Playing around with different I/O
schedulers and parameters doesn't seem to help at all.

The same behavior is exhibited when using O_DIRECT as well (except
that the latency hit is immediate instead of 30 seconds later, as one
would expect).  The only way I was able to reduce the worst-case read
latency was by using O_DIRECT and breaking up the large write into
multiple smaller writes (with one system call per smaller write).  My
theory is that the time between write system calls was enough to allow
reads to squeeze themselves in between the writes.  But, as would be
expected, this does bad things to the sequential write throughput
because of the overhead of multiple system calls.

My question is: have others seen this behavior?  Are there any
tunables that could help (perhaps a parameter that would dictate the
largest size of a write that can be pending to the device at any given
time).  If not, would it make sense to implement a new I/O scheduler
(or hack an existing one) which does this.

Thanks,
-Zubin
