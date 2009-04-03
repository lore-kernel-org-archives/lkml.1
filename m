Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbZDCIcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbZDCIcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 04:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZDCIb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 04:31:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60193 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbZDCIb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 04:31:56 -0400
Message-ID: <49D5C972.8000903@garzik.org>
Date: Fri, 03 Apr 2009 04:31:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain> <49D53787.9060503@garzik.org> <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain> <49D56DF6.5020300@garzik.org> <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904021910380.4130@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------080403060403060605080805"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080403060403060605080805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> On Thu, 2 Apr 2009, Jeff Garzik wrote:
>> The most interesting thing I found:  the SSD does 80 MB/s for the first ~1 GB
>> or so, then slows down dramatically.  After ~2GB, it is down to 32 MB/s.
>> After ~4GB, it reaches a steady speed around 23 MB/s.
> 
> Are you sure that isn't an effect of double and triple indirect blocks 
> etc? The metadata updates get more complex for the deeper indirect blocks.
> 
> Or just our page cache lookup? Maybe our radix tree thing hits something 
> stupid. Although it sure shouldn't be _that_ noticeable.
> 
>> There is a similar performance fall-off for the Seagate, but much less
>> pronounced:
>> 	After 1GB:	52 MB/s
>> 	After 2GB:	44 MB/s
>> 	After 3GB:	steady state
> 
> That would seem to indicate that it's something else than the disk speed. 

Attached are some additional tests using sync_file_range, dd, an SSD and 
a normal SATA disk.  The test program -- overwrite.c -- is unchanged 
from my last posting, basically the same as Linus's except with 
posix_fadvise()

Observations:

* the no-name SSD does seem to burst the first ~1GB of writes rapidly, 
but degrades to a much lower sustained level, as observed before. 
Repeated tests do not produce ~80 MB/s, only the first test, which lends 
credence to the theory about background activity.

* For the SSD, overwrite is noticeably faster than dd.

* For the Seagate NCQ hard drive, dd is noticeably faster than overwrite.

* fadvise() appears to help, but mostly the results are either 
inconclusive or lost in the noise:  A slight increase in throughput, and 
a slight increase in system time.

The test sequence for both SATA devices was the following:

	3 x dd
	3 x overwrite
	3 x overwrite w/ fadvise(don't need)

System setup: Intel Nahalem(sp?) x86-64, ICH10, Fedora 10, ext3 
filesystem (mounted defaults + noatime), 2.6.29 vanilla kernel.

Regards,

	Jeff






--------------080403060403060605080805
Content-Type: text/plain;
 name="test-output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="test-output.txt"

=======================================================
128GB, 3.0 Gbps no-name SATA SSD, x86-64, ext3, 2.6.29 vanilla

First dd(1) creates the file, others simply rewrite it.
=======================================================
24000+0 records in
24000+0 records out
25165824000 bytes (25 GB) copied, 917.599 s, 27.4 MB/s)

real	15m30.928s
user	0m0.016s
sys	1m3.924s


24000+0 records in
24000+0 records out
25165824000 bytes (25 GB) copied, 1056.92 s, 23.8 MB/s)

real	18m1.686s
user	0m0.016s
sys	1m4.816s


24000+0 records in
24000+0 records out
25165824000 bytes (25 GB) copied, 1044.25 s, 24.1 MB/s)

real	17m37.884s
user	0m0.020s
sys	1m4.300s


writing 2800 buffers of size 8m
21.867 GB written in 645.56 (34 MB/s)

real	10m46.502s
user	0m0.044s
sys	0m35.990s


writing 2800 buffers of size 8m
21.867 GB written in 634.55 (35 MB/s)

real	10m35.448s
user	0m0.036s
sys	0m36.466s


writing 2800 buffers of size 8m
21.867 GB written in 642.00 (34 MB/s)

real	10m42.890s
user	0m0.044s
sys	0m34.930s


using fadvise()
writing 2800 buffers of size 8m
21.867 GB written in 639.49 (35 MB/s)

real	10m40.384s
user	0m0.036s
sys	0m38.582s


using fadvise()
writing 2800 buffers of size 8m
21.867 GB written in 636.17 (35 MB/s)

real	10m37.061s
user	0m0.024s
sys	0m39.146s


using fadvise()
writing 2800 buffers of size 8m
21.867 GB written in 636.07 (35 MB/s)

real	10m37.003s
user	0m0.060s
sys	0m39.174s


=======================================================
500GB, 3.0Gbps Seagate SATA drive, x86-64, ext3, 2.6.29 vanilla

First dd(1) creates the file, others simply rewrite it.
=======================================================
24000+0 records in
24000+0 records out
25165824000 bytes (25 GB) copied, 494.797 s, 50.9 MB/s)

real	8m42.680s
user	0m0.016s
sys	0m58.176s


24000+0 records in
24000+0 records out
25165824000 bytes (25 GB) copied, 498.295 s, 50.5 MB/s)

real	8m27.505s
user	0m0.016s
sys	0m58.744s


24000+0 records in
24000+0 records out
25165824000 bytes (25 GB) copied, 492.145 s, 51.1 MB/s)

real	8m23.616s
user	0m0.016s
sys	0m59.064s


writing 2800 buffers of size 8m
21.867 GB written in 478.41 (46 MB/s)

real	7m59.690s
user	0m0.032s
sys	0m33.210s


writing 2800 buffers of size 8m
21.867 GB written in 513.54 (43 MB/s)

real	8m34.461s
user	0m0.048s
sys	0m33.342s


writing 2800 buffers of size 8m
21.867 GB written in 471.38 (47 MB/s)

real	7m52.641s
user	0m0.020s
sys	0m33.486s


using fadvise()
writing 2800 buffers of size 8m
21.867 GB written in 467.67 (47 MB/s)

real	7m48.756s
user	0m0.048s
sys	0m36.838s


using fadvise()
writing 2800 buffers of size 8m
21.867 GB written in 462.69 (48 MB/s)

real	7m43.597s
user	0m0.020s
sys	0m37.462s


using fadvise()
writing 2800 buffers of size 8m
21.867 GB written in 463.56 (48 MB/s)

real	7m44.472s
user	0m0.036s
sys	0m37.342s



--------------080403060403060605080805
Content-Type: application/x-sh;
 name="run-test.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="run-test.sh"

#!/bin/sh

for outf in /spare/tmp/test.dat /garz/tmp/test.dat
do
	echo "======================================================="
	echo "Beginning test run, output file $outf"
	echo "======================================================="

	for n in 1 2 3
	do
		time sh -c "dd if=/dev/zero of=$outf bs=1048576 count=24000 ; sync"
	done

	for n in 1 2 3
	do
		time ./overwrite -b 2800 $outf
	done

	for n in 1 2 3
	do
		time ./overwrite -b 2800 -f $outf
	done

	rm -f "$outf"
done


--------------080403060403060605080805--
