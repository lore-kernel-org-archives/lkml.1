Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZD1Irk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZD1Irk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbZD1IrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:47:12 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:50864 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbZD1IrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GnitVnfnxDRf888+QlV+Kkby+NMFn1OPOSHncJEFaWQED5FDWUfdfj+ttLsn6KrGFu
         hwlihMRPPZsQwZ2OKqSLz21YztfTb2ud0hfF8S2XD2NH+yMRSesgauZusQeTeunP8lVJ
         3elT2pceqQ4kGuIdPViqkqfrmPsLEZ0gMdXKs=
Date: Tue, 28 Apr 2009 10:47:00 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, tytso@mit.edu,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       matt@bluehost.com, dradford@bluehost.com, ngupta@google.com,
       randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it, m-ikeda@ds.jp.nec.com,
       paulmck@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v15 0/7] cgroup: io-throttle controller
Message-ID: <20090428084700.GA13279@linux>
References: <1240908234-15434-1-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240908234-15434-1-git-send-email-righi.andrea@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've repeated some tests with this new version (v15) of the io-throttle
controller.

The following results have been generated using the io-throttle
testcase, available at:
http://download.systemimager.org/~arighi/linux/patches/io-throttle/testcase/

The testcase is an update version of the io-throttle testcase included
in LTP
(http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/kernel/controllers/io-throttle/).

Summary
~~~~~~~
The goal of this test is to highlight the effectiveness of io-throttle
to control direct and writeback IO applying maximum BW limits (the
proportional BW approach is not addressed by this test, only absolute BW
limits are considered).

The benchmark #1 is a run of different parallel streams per cgroup
without imposing any IO limitation. The benchmark #2 repeats the same
tests using 4 cgroups with a BW limit of respectively 2MB/s, 4MB/s,
6MB/s and 8MB/s. The disk IO is constantly monitored (using dstat) to
evaluate the amount of writeback IO with and without the IO BW limits.

The results of benchmark #2 show the validity of the IO controller both
from the application's and disk's point of view.

Experimental Results
~~~~~~~~~~~~~~~~~~~~
==> collect system info <==
* kernel: 2.6.30-rc3
* disk: /dev/sda:
 Timing cached reads:   1380 MB in  2.00 seconds = 690.79 MB/sec
 Timing buffered disk reads:   76 MB in  3.07 seconds =  24.73 MB/sec
* filesystem: ext3
* VM dirty_ratio/dirty_background_ratio: 20/10

==> start benchmark #1 <==
* block-size: 16384 KB
* file-size: 262144 KB
* using 4 io-throttle cgroups:
  - unlimited IO BW

==> results #1 (avg io-rate per cgroup) <==
* 1 parallel streams per cgroup, O_DIRECT=n
(cgroup-1, 1 tasks) [async-io] rate 12695 KiB/s
(cgroup-2, 1 tasks) [async-io] rate 13671 KiB/s
(cgroup-3, 1 tasks) [async-io] rate 12695 KiB/s
(cgroup-4, 1 tasks) [async-io] rate 12695 KiB/s
* 2 parallel streams per cgroup, O_DIRECT=n
(cgroup-1, 2 tasks) [async-io] rate 14648 KiB/s
(cgroup-2, 2 tasks) [async-io] rate 15625 KiB/s
(cgroup-3, 2 tasks) [async-io] rate 14648 KiB/s
(cgroup-4, 2 tasks) [async-io] rate 14648 KiB/s
* 4 parallel streams per cgroup, O_DIRECT=n
(cgroup-1, 4 tasks) [async-io] rate 20507 KiB/s
(cgroup-2, 4 tasks) [async-io] rate 20507 KiB/s
(cgroup-3, 4 tasks) [async-io] rate 20507 KiB/s
(cgroup-4, 4 tasks) [async-io] rate 20507 KiB/s
* 1 parallel streams per cgroup, O_DIRECT=y
(cgroup-1, 1 tasks) [direct-io] rate 3906 KiB/s
(cgroup-2, 1 tasks) [direct-io] rate 3906 KiB/s
(cgroup-3, 1 tasks) [direct-io] rate 3906 KiB/s
(cgroup-4, 1 tasks) [direct-io] rate 3906 KiB/s
* 2 parallel streams per cgroup, O_DIRECT=y
(cgroup-1, 2 tasks) [direct-io] rate 3906 KiB/s
(cgroup-2, 2 tasks) [direct-io] rate 3906 KiB/s
(cgroup-3, 2 tasks) [direct-io] rate 3906 KiB/s
(cgroup-4, 2 tasks) [direct-io] rate 3906 KiB/s
* 4 parallel streams per cgroup, O_DIRECT=y
(cgroup-1, 4 tasks) [direct-io] rate 3906 KiB/s
(cgroup-2, 4 tasks) [direct-io] rate 3906 KiB/s
(cgroup-3, 4 tasks) [direct-io] rate 3906 KiB/s
(cgroup-4, 4 tasks) [direct-io] rate 3906 KiB/s

A snapshot of the writeback IO (with O_DIRECT=n) in bytes/sec:
(statistics collected using dstat)

	/dev/sda
	----------
	21729280.0
	20733952.0
	19628032.0
	19390464.0
	...		<-- uniform to 20MB/s for the whole run

	average: 19563861.33
	stdev:    1078639.21


==> start benchmark #2 <==
* block-size: 16384 KB
* file-size: 262144 KB
* using 4 io-throttle cgroups:
  - cgroup 1: 2048 KB/s on /dev/sda
  - cgroup 2: 4096 KB/s on /dev/sda
  - cgroup 3: 6144 KB/s on /dev/sda
  - cgroup 4: 8192 KB/s on /dev/sda

==> results #2 (avg io-rate per cgroup) <==
* 1 parallel streams per cgroup, O_DIRECT=n
(cgroup-1, 1 tasks) [async-io] io-bw 2048 KiB/s, io-rate 12695 KiB/s
(cgroup-2, 1 tasks) [async-io] io-bw 4096 KiB/s, io-rate 15625 KiB/s
(cgroup-3, 1 tasks) [async-io] io-bw 6144 KiB/s, io-rate 15625 KiB/s
(cgroup-4, 1 tasks) [async-io] io-bw 8192 KiB/s, io-rate 22460 KiB/s
* 2 parallel streams per cgroup, O_DIRECT=n
(cgroup-1, 2 tasks) [async-io] io-bw 2048 KiB/s, io-rate 14648 KiB/s
(cgroup-2, 2 tasks) [async-io] io-bw 4096 KiB/s, io-rate 20507 KiB/s
(cgroup-3, 2 tasks) [async-io] io-bw 6144 KiB/s, io-rate 23437 KiB/s
(cgroup-4, 2 tasks) [async-io] io-bw 8192 KiB/s, io-rate 29296 KiB/s
* 4 parallel streams per cgroup, O_DIRECT=n
(cgroup-1, 4 tasks) [async-io] io-bw 2048 KiB/s, io-rate 10742 KiB/s
(cgroup-2, 4 tasks) [async-io] io-bw 4096 KiB/s, io-rate 16601 KiB/s
(cgroup-3, 4 tasks) [async-io] io-bw 6144 KiB/s, io-rate 21484 KiB/s
(cgroup-4, 4 tasks) [async-io] io-bw 8192 KiB/s, io-rate 23437 KiB/s
* 1 parallel streams per cgroup, O_DIRECT=y
(cgroup-1, 1 tasks) [direct-io] io-bw 2048 KiB/s, io-rate 2929 KiB/s
(cgroup-2, 1 tasks) [direct-io] io-bw 4096 KiB/s, io-rate 3906 KiB/s
(cgroup-3, 1 tasks) [direct-io] io-bw 6144 KiB/s, io-rate 4882 KiB/s
(cgroup-4, 1 tasks) [direct-io] io-bw 8192 KiB/s, io-rate 5859 KiB/s
* 2 parallel streams per cgroup, O_DIRECT=y
(cgroup-1, 2 tasks) [direct-io] io-bw 2048 KiB/s, io-rate 2929 KiB/s
(cgroup-2, 2 tasks) [direct-io] io-bw 4096 KiB/s, io-rate 4882 KiB/s
(cgroup-3, 2 tasks) [direct-io] io-bw 6144 KiB/s, io-rate 5859 KiB/s
(cgroup-4, 2 tasks) [direct-io] io-bw 8192 KiB/s, io-rate 5859 KiB/s
* 4 parallel streams per cgroup, O_DIRECT=y
(cgroup-1, 4 tasks) [direct-io] io-bw 2048 KiB/s, io-rate 976 KiB/s
(cgroup-2, 4 tasks) [direct-io] io-bw 4096 KiB/s, io-rate 1953 KiB/s
(cgroup-3, 4 tasks) [direct-io] io-bw 6144 KiB/s, io-rate 2929 KiB/s
(cgroup-4, 4 tasks) [direct-io] io-bw 8192 KiB/s, io-rate 3906 KiB/s

A snapshot of the writeback IO (with O_DIRECT=n) in bytes/sec:
(statistics collected using dstat)

	/dev/sda
	----------
	...		<-- all cgroups running (expected io-rate 20MB/s)
	19550208.0
	19030016.0
	19546112.0
	20070400.0
	...		<-- 1st cgroup ends (expected io-rate 12MB/s)
	12673024.0
	11304960.0
	10604544.0
	12357632.0
	...		<-- 2nd cgroup ends (expected io-rate 6MB/s)
 	 6332416.0
	 6324224.0
	 6324224.0
	 6320128.0
	...		<-- 3rd cgroup ends (expected io-rate 2MB/s)
	 2105344.0
	 2113536.0
	 2097152.0
	 2101248.0

Open issues & toughts
~~~~~~~~~~~~~~~~~~~~~
1) impact for the VM

Limiting the IO without considering the amount of dirty pages per cgroup
can cause potential OOM conditions due to the presence of hard
reclaimable pages (that must be flushed to disk, before being evicted
from memory). At the moment, when a cgroup exceeds the IO BW limit,
direct IO requests are delayed and at the same time each task (in the
exceeding cgroups) is blocked in balance_dirty_pages_ratelimited_nr() to
prevent the generation of additional dirty pages in the system.

This will be probably handled in a better way by the memory cgroup soft
limits (under development by Kamezawa) and the accounting of the dirty
pages per cgroup. For the accounting something like task_struct->dirties
should be probably implemented in struct mem_cgroup (i.e.
memcg->dirties) to keep track of the dirty pages generated by a generic
mem_cgroup. And based on these statistics tasks should start to actively
writeback dirty inodes in proportion of the previously generated dirty
pages, when a threshold is exceeded.

There are also the cgroups interactions to keep in consideration. As a
practical example, if task T belonging to cgroup A is dirtying some
pages in cgroup B and the other tasks in cgroup A dirtied a lot of pages
in the whole system before, then task T1 should be forced to writeback
some pages, in proportion of the dirtied pages accounted to A.

In general, all the IO requests generated to writeback some dirty pages
must be affected by the IO BW limiting rules of the cgroup that
originally dirtied those pages. So, if B is under memory pressure and
task T stops to write, the tasks in cgroup B must start to actively
writeback some dirty pages, but using the BW limits defined for cgroup A
(that originally dirtied the pages).

>From the IO controller point of view, it should only keep track of the
cgroup that dirtied each page and apply the IO BW limits defined for
this cgroup for the writeback IO. At the moment the io-throttle
controller uses this approach to throttle writeback IO requests.

2) impact for the IO subsystem

A block device with IO limits should be considered just like a "normal"
slow device by the kernel. Following the io-throttle approach, the
slowness is implemented in the submission of IO requests (throttling the
tasks directly in submit_bio() for synchronous requests, or delaying
these requests, adding them in a rbtree and dispatch them asynchronously
by kiothrottled, for writeback IO). Implementing such slowness at the IO
scheduler level is another valid solution that should be explored (i.e.
the work proposed by Vivek).

3) proportional BW and absolute BW limits

Other related works, like dm-ioband or a recent work proposed by Vivek
(https://lists.linux-foundation.org/pipermail/containers/2009-March/016129.html)
implement the logic of proportional weight IO control.

Proportional BW control allows to better exploit the whole physical BW
of the disk: if a cgroup is not using its dedicated BW, other cgroups
sharing the same disk can make use of the spare BW.

OTOH, absolute limiting rules do not fully exploit all the physical BW,
but offer an immediate action on policy enforcement. With absolute BW
limits the problem is mitigated before it happens, because the system
guarantees that the "hard" limits are never exceeded. IOW it is a kind
of performance isolation through static partitioning. This approach can
be suitable for environments where certain critical/low-latency
applications must respect strict timing constraint (real-time). Or in
hosted environment where we want to "contain" classes of user as if they
were on a virtual private system (depending on how much customer
customer pays).

A good "general-purpose" IO controller should be able to provide both
solutions to satisfy all the possible user requirements.

Currentely, the proportional BW control is not provided by io-throttle.
This is in the TODO list, but it requires additional work, especially to
maintain the controller "light" and to not introduce too much overhead
or complexity.

4) sync(2) handling

What is the correct behaviour when an user issues "sync" in presence of
the io-throttle controller?

>From the sync(2) manpage:

  According to the standard specification (e.g., POSIX.1-2001), sync() schedules
  the writes, but may return before the actual  writing  is  done.  However,
  since version 1.3.20 Linux does actually wait.  (This still does not
  guarantee data integrity: modern disks have large caches.)

In the current io-throttle implementation the sync(2) waits that all the
delayed IO requests pending in the rbtree are all flushed back to disk.
In this way obviuosly a cgroup can be forced to wait for other cgroups'
BW limit, that could sound strange, but this is probably the correct
behaviour to respect the semantic of this command.

-Andrea
