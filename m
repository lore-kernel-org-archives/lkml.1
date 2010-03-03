Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0CCJiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:38:00 -0500
Received: from tenax.loup.net ([209.169.16.66]:58129 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab0CCJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:37:58 -0500
X-Greylist: delayed 3596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 04:37:57 EST
Date: Wed, 3 Mar 2010 01:26:32 -0700
Message-Id: <201003030826.o238QWXK015588@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: linux-kernel@vger.kernel.org
CC: kasey.erickson@gmail.com
Subject: O_NONBLOCK is NOOP on block devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure who is working on block io these days, but hopefully an
active developer can steer this feedback toward folks who are as
interested in io performance as I am :-)

I've spent the last several years or so developing a user space
distributed storage system and I've recently gotten down to some io
performance tuning.  Surprisingly, my results indicate that the
O_NONBLOCK flag produces no noticable effect on read or writev to a
Linux block device.  I always perform aligned ios which are a multiple
of the sector size which also allows the use of O_DIRECT if desired.
For testing, I've been using 2.6.22 and 2.6.24 kernels (fedora core
and ubuntu distros) on both x86_64 and 32 bit arm architectures and
get similar results on every variation of hardware and kernel tested,
so I figure the behavior may still exist in the most recent kernels.

To extract the following data, I used the following set of system
calls in a loop driven by poll, surrounding read and write calls
immediately with time checks.

fd = open( filename, O_RDWR | O_NONBLOCK | O_NOATIME );
gettimeofday( &time, 0 );
read( fd, pos, len );
writev( fd, iov, count );
poll( pfd, npfd, timeoutms );

Byte counts are displayed in hex.  On my core 2 duo laptop, for
example, io to or from the buffer cache typically takes 100 to 125
micro seconds to transfer 64k.

----------------------------------------------------------------------
BUFFER CACHE NOT FULL, NONBLOCKING 64K WRITES AS EXPECTED

write fd:3 0.000117s bytes:10000 remain:0
write fd:3 0.000115s bytes:10000 remain:0
write fd:3 0.000116s bytes:10000 remain:0
write fd:3 0.000118s bytes:10000 remain:0
write fd:3 0.000125s bytes:10000 remain:0
write fd:3 0.000126s bytes:10000 remain:0
write fd:3 0.000101s bytes:10000 remain:0

----------------------------------------------------------------------
READING AND WRITING, BUFFER CACHE FULL

read  fd:3 0.006351s bytes:10000 remain:0
write fd:3 0.001235s bytes:200   remain:0
write fd:3 0.002477s bytes:200   remain:0
read  fd:3 0.005010s bytes:10000 remain:0
write fd:3 0.001243s bytes:200   remain:0
read  fd:3 0.005028s bytes:10000 remain:0
write fd:3 0.000506s bytes:200   remain:0
write fd:3 0.000106s bytes:10000 remain:0
write fd:3 0.000812s bytes:200   remain:0
write fd:3 0.000108s bytes:10000 remain:0
write fd:3 0.000807s bytes:200   remain:0
write fd:3 0.002652s bytes:200   remain:0
write fd:3 0.000107s bytes:10000 remain:0
write fd:3 0.000141s bytes:10000 remain:0
write fd:3 0.002232s bytes:200   remain:0

These are not worst-case, but rather best case results.  For an
example of more worse case results, using a usb flash device,
frequently (about once a second or so) under heavier load I see reads
or writes blocked for 500ms or more when vmstat and top report more
than 90% idle / wait.  500ms to perform a 512 byte "non blocking" io
with a nearly idle cpu is an eternity in computer time; more than
10,000 times longer than it should take to memcpy all or even a
portion of the data or return EAGAIN.

I discovered this because, even though they succeed, all of these
"non" blocking system calls are blocking so much so that they easily
choke my process non blocking socket io.  As a work around to this
failed attempt at nonblocking disk io, I now intend to implement a
somewhat more complex solution using aio or scsi generic to prevent
block device io from choking network io.

I think this O_NONBLOCK behavior has aspects that could probably be
classified as both a documentation and a kernel defect depending upon
whether the existing open(2) man page documents the intended behavior
of read and write or not.

If O_NONBLOCK is meaningful whatsoever (see man page docs for
semantics) against block devices, one would expect a nonblocking io
involving an unbuffered page to return either a partial result if a
prefix of the io can be completed immediately, or EAGAIN, schedule an
io against the device, then trigger a blocking select or poll type
call after the relevant page at the offending file descriptor cursor
becomes available in the buffer cache.  The timing and results of each
read or write call speak for themselves.  Specifying O_NONBLOCK does
not convert unbuffered ios to async buffer cache ios as expected;
typically blocking ios (i.e unbuffered reads or sustained writes to a
full, dirty buffer cache) definitely block in my app, whether or not
O_NONBLOCK is specified.

I've spent a tremendous amount of time building and benchmarking a
program based upon the Linux documentation for the previously
mentioned system calls only to find out the kernel doesn't behave as
specified.  To save someone else from my fate, if O_NONBLOCK doesn't
prevent reads and writes to block devices from blocking, it should be
documented in the man page, and preferably also return an error when
supplied as a flag to open or fcntl for a block device.  That's the
easy solution.  The harder solution would be to make the system calls
actually be non blocking when O_NONBLOCK is specified.

Furthermore, I've also noticed these kernels also allow O_NONBLOCK and
O_DIRECT to be simultaneously specified against a block device even
though this is not logically even possible since, by definition, the
buffer cache is not involved and the process will have to wait for the
io to synchronously complete.  This flag incompatibility should
probably be documented for clarity and it would be straight forward
for it to return an error if these contradictory behaviors are
simultaneously specified, unintentionally of course.

Thoughts anyone?

- Mike
