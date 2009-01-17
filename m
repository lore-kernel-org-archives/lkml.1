Return-Path: <linux-kernel-owner+w=401wt.eu-S1764114AbZAQAow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764114AbZAQAow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbZAQAom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:44:42 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:56070 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbZAQAol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:44:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkQFAHO3cElMQWt2/2dsb2JhbACBbMp0hXI
Date: Fri, 16 Jan 2009 19:44:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <jens.axboe@oracle.com>, Andrea Arcangeli <andrea@suse.de>,
       akpm@linux-foundation.org, Ben Gamari <bgamari@gmail.com>,
       ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [Regression] High latency when doing large I/O
Message-ID: <20090117004439.GA11492@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:20:49 up 16 days, 18 min,  5 users,  load average: 0.60, 0.38,
	0.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A long standing I/O regression (since 2.6.18, still there today) has hit
Slashdot recently :
http://bugzilla.kernel.org/show_bug.cgi?id=12309
http://it.slashdot.org/article.pl?sid=09/01/15/049201

I've taken a trace reproducing the wrong behavior on my machine and I
think it's getting us somewhere.

LTTng 0.83, kernel 2.6.28
Machine : Intel Xeon E5405 dual quad-core, 16GB ram
(just created a new block-trace.c LTTng probe which is not released yet.
It basically replaces blktrace)


echo 3 > /proc/sys/vm/drop_caches

lttctl -C -w /tmp/trace -o channel.mm.bufnum=8 -o channel.block.bufnum=64 trace

dd if=/dev/zero of=/tmp/newfile bs=1M count=1M
cp -ax music /tmp   (copying 1.1GB of mp3)

ls  (takes 15 seconds to get the directory listing !)

lttctl -D trace

I looked at the trace (especially at the ls surroundings), and bash is
waiting for a few seconds for I/O in the exec system call (to exec ls).

While this happens, we have dd doing lots and lots of bio_queue. There
is a bio_backmerge after each bio_queue event. This is reasonable,
because dd is writing to a contiguous file.

However, I wonder if this is not the actual problem. We have dd which
has the head request in the elevator request queue. It is progressing
steadily by plugging/unplugging the device periodically and gets its
work done. However, because requests are being dequeued at the same
rate others are being merged, I suspect it stays at the top of the queue
and does not let the other unrelated requests run.

There is a test in the blk-merge.c which makes sure that merged requests
do not get bigger than a certain size. However, if the request is
steadily dequeued, I think this test is not doing anything.

If you are interested in looking at the trace I've taken, I could
provide it.

Does that make sense ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
