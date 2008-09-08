Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYIHTKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYIHTKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbYIHTK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:10:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:42097 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbYIHTKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:10:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dboP3tglzaSz48pQJ2SQKGPAA3JkR02gInoKXEY1OkTIypMDYzutgWEway4cj0Gx0f
         pSQ8m0834EUApFBm4r414Bkq4AgxBOHdzB+4l3enV3ZhZgQj5CYD7x03pT5J71eGRMS7
         Xh5oqOZXJ599xUKrfXZRZ2rMiXNNMVqEd7jME=
Message-ID: <48C57898.1080304@gmail.com>
Date: Mon, 08 Sep 2008 22:10:16 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Theodore Tso <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
 intensive multi-threaded task
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>	<48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>	<48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>	<48B287D8.1000000@gmail.com> <1219660582.8515.24.camel@twins>	<48B290E7.4070805@gmail.com> <1219664477.8515.54.camel@twins>	<20080825134801.GN1408@mit.edu> <87y72k9otw.fsf@basil.nowhere.org>
In-Reply-To: <87y72k9otw.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-08-26 11:12, Andi Kleen wrote:
> Theodore Tso <tytso@mit.edu> writes:
>
> As a general comment it still sounds there is a regression here?
> If the workload was faster in an earlier kernel and is now slow
> clearly something got slower? And that might be fixable. 
> Perhaps something for Rafael's list?

After some more careful testing with the real program (clamd) I can say
that there is no regression.
If I scan the exact same files as the box running 2.6.18 I get similar
results, the difference is within 10%  [1].

There is however a problem with mmap [mmap with N threads is as slow as
mmap with 1 thread, i.e. it is sequential :(], pagefaults and disk I/O,
I think I am hitting the problem described in this thread (2 years ago!)
http://lwn.net/Articles/200215/
http://lkml.org/lkml/2006/9/19/260

It looks like such a patch is still not part of 2.6.27, what happened to it?
I will see if that patch applies to 2.6.27, and will rerun my test with
that patch applied too.

While running clamd I noticed in latencytop, that besides mmap/munmap
latencies (around 20 ms), I also get page fault latencies (again around
20 ms).

So I wrote another test program [2] that walks a directory tree, and
reads each file once using read for each, and once using mmap for each.
It clears the cache (using echo 3 >/proc/sys/vm/drop_caches) before each
test (and I run the read test first, so if the cache wouldn't be cleared,
then mmap would be faster not slower).
The results show that reading files using mmap() takes about the same
time, regardless of how many threads I use (1,2,4,8,16), but
using read has a near linear speedup with the number of threads.


First lets see some numbers [3], time to run the program on /usr/bin in
seconds [4]
Number of CPUs, 4
Number of threads ->, 1,, 2,, 4,, 8,, 16
Kernel version, read, mmap, read, mmap, read, mmap, read, mmap, read, mmap
2.6.27-rc5, 16.70, 17.01, 12.86, 16.26, 7.31, 15.16, 4.01, 14.93, 3.79,
15.40
2.6.26-1-amd64, 17.90, 16.95, 13.30, 16.18, 7.31, 15.34, 3.87, 14.96,
3.86, 15.89
2.6.22-3-amd64, 15.12, 15.41, 11.98, 15.17, 6.36, 14.29, 3.15, 14.61,
3.08, 15.44

The kernels are standard Debian kernels, except for 2.6.27-rc5 which
I've built myself (posted .config earlier in this thread).
mmap and read are about the same speed with nthreads=1, so lets see
speedups relative to nthreads=1

Kernel version, read, mmap, read, mmap, read, mmap, read, mmap, read, mmap
"2.6.27-rc5",1.00,1.00,1.30,1.05,2.28,1.12,4.16,1.14,4.41,1.10
"2.6.26-1-amd64",1.00,1.00,1.35,1.05,2.45,1.10,4.63,1.13,4.64,1.07
"2.6.22-3-amd64",1.00,1.00,1.26,1.02,2.38,1.08,4.80,1.05,4.91,1.00

I was running this on a usr/bin/ directory that has 372M, average file
size 160K.

So mmap performance stays about the same (14% change at most) regardless
number of threads, while
read performance *improves* with the number of threads, it is 4.8 times
*faster* than with single threaded case.

I think what happens is the following:
- thread A open a file with mmap, and starts reading it, this generates
page faults (which is normal for reading from an mmaped region)
- thread B opens another file with mmap, and starts reading it. It
happened to find mmap_sem untaken, so it locks it for writing, makes the
change, and unlocks
- thread A reads from a page that is not present triggering a page
fault, mmap_sem is taken, and thread A is waiting for the page to be
read from the disk
- thread B does the same, and takes mmap_sem for reading
- thread C creates a new mapping, and tries to take mmap_sem for
writing, it cannot because there are readers, so it blocks waiting
- thread A finishes the pagefault, releases the mmap_sem
- thread B hasn't finished the pagefault, C is still blocked
- A encounters another pagefault and takes the mmap_sem for reading
- B finishes, and releases, C still blocked because mmap_sem is taken
for reading
....
C eventually takes the mmap_sem for writing, blocking A and B who want
to read from a file
....

Even if C gets the semaphore as soon as one pagefault is done, it still
has to wait for the disk I/O for that pagefault to be completed.

Why do you need to hold the process-wide mmap_sem while waiting for the
page to be read from disk?
As I understand (I coudl be wrong, please correct me!) we need to make
sure that the page we are reading into exists and doesn't change mapping
details
during the disk I/O read, meaning it must not be unmapped, flags
changed, etc.
Can't we have a per-vma lock that would ensure this?

If a process would want to munmap something, it would take the mmap_sem,
then the per-vma lock, remove the mapping, release locks
If you want to mmap something, you take mmap_sem, create the mapping
with the per-vma lock held, release locks
When a page fault reads, it takes the mmap_sem for reading, finds the
vma, locks the per-vma lock, releases mmap_sem; does disk I/O;
makes any changes needed to the vma, acquires the mmap_sem, releases the
per-vma lock, releases mmap_sem
Anybody else wishing to modify a vma, needs to take mmap_sem, the
per-vma lock, release mmap_sem, make modification, release per-vma lock
Anybody wishing to add/remove/reorder vmas needs to take the mmap_sem,
the locks of all affected vmas, make modifications, and release all locks

Is there something wrong with the above approach?
>From a lock contention perspective it can't be worse than holding a
single mmap_sem during the entire disk I/O.
mmap_sem would now mean: take me if you add/remove vmas, and take me
before taking a vma lock
vma lock: take me if you modify this vma, or if you need to be sure that
the vma doesn't go away

Thoughts?

[1] 2.6.18 won't boot on my box, because it won't recognize an ICH10
SATA controller
[2] the test program is available here:
 http://edwintorok.googlepages.com/scalability.tar.gz
You just build it using 'make' (has to be GNU make), and the run
$ sh ./runtest.sh /usr/bin/ | tee log
$ sh ./postproc.sh log

[3] the raw logs are available here:
http://edwintorok.googlepages.com/logs.tar.gz

[4] The test program was run on this system:
Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz
4 GB DDR3 RAM
Motherboard GA-EP45T-DS3, chipset ICH10, SATA controller in AHCI mode
HDD 6x750GB WD Caviar Black, RAID 1 for /, and RAID10 for the rest
/ has ext3
I've run the test on /mnt/bak/usr/bin which is on /

You need to run the testprogram on a system with fast disks (for eg it
doesn't really make a difference on my laptop with 5k4 rpm disks).
This system has these timings:
/dev/md3:
 Timing cached reads:   11112 MB in  2.00 seconds = 5561.88 MB/sec
 Timing buffered disk reads:  296 MB in  3.00 seconds =  98.57 MB/sec

If you need more info, please ask.

Best regards,
--Edwin
