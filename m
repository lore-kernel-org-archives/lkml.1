Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbZKPVTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbZKPVTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZKPVTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:19:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbZKPVTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:19:14 -0500
Date: Mon, 16 Nov 2009 16:14:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091116211412.GJ13235@redhat.com>
References: <1258404660.3533.150.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258404660.3533.150.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 03:51:00PM -0500, Alan D. Brunelle wrote:
> Hi Vivek: 
> 
> I'm finding some things that don't quite seem right - executive
> summary: 

Hi Alan,

Thanks a lot for such an extensive testing and test results. I am still
digesting the results but I thought I will make a quick note about writes.
This patchset works only for sync IO. If you are performing buffered
writes then you will not see any service differentiation. Providing
support for buffered write path is in TODO list. 

> 
> o  I think the apportionment algorithm doesn't work consistently well
> for writes.
> 
> o  I think there are problems with significant performance loss when
> doing random I/Os.

This concerns me. I had a quick look and as per your results, even with
group_idle=0 you are seeing this regression. I guess this might be coming
from the fact that we idle on sync-noidle workload per group and that
idling becomes significant as number of groups increase.

Thanks
Vivek

> 
> ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> 
> Test configuration: HP dl585 (32-way quad-core AMD Opteron processors +
> 128GB RAM + 4 FC HBAs + 4 MSA 1000's (each exporting 3 multi-disk
> striped LUNs)). Running with Jens Axboe's remotes/origin/for-2.6.33
> branch (at commit 8721c81f6480e2c9acbf92078383953f825d1057)) w/out and
> w/ your V2 patch.
> 
> The test: 12 Ext3 file systems (1 per disk), each file system has eight
> 8GB files on it. Doing simple fio runs in various modes and I/O
> directions: random or sequential, read or write or read/write (80%/20%).
> Using 2, 4 or 8 processes per file system (each process working on a
> different file). Here is a sample fio command file:
> 
> [global]
> ioengine=sync
> size=8g
> overwrite=0
> runtime=120
> bs=256k
> readwrite=write
> [/mnt/sdl/data.7]
> filename=/mnt/sdl/data.7
> 
> I'm then using cgroups that have IO weights as follows:
> 
> /cgroup/test0/blkio.weight 100
> /cgroup/test1/blkio.weight 200
> /cgroup/test2/blkio.weight 300
> /cgroup/test3/blkio.weight 400
> /cgroup/test4/blkio.weight 500
> /cgroup/test5/blkio.weight 600
> /cgroup/test6/blkio.weight 700
> /cgroup/test7/blkio.weight 800
> 
> There were 12 X N total processes running in the system for each test,
> and each file system would have N process working on a different file in
> that file system. The N processes would be assigned to increasing test
> groups: process 0 will be in test0's group and working on file 0 in a
> file system; process 1 will be in test1's group and working on file 1 in
> a file system; and so on.
> 
> Before each test I drop caches & umount/mount the filesystem anew.
> 
> In the following tables:
> 
> 'base' - means a kernel generated from Jens' branch (-no- patching)
> 
> 'ioc off' - means a kernel generated w/ your patches added but -no-
> other settings (no CGROUP stuff mounted or enabled)
> 
> 'ioc no idle' - means the ioc kernel w/ CGROUP stuff enabled
> -but- /sys/block/sd*/queue/iosched/cgroup_idle = 0
> 
> 'ioc idle' - means the ioc kernel w/ CGROUP stuff enabled
> -and- /sys/block/sd*/queue/iosched/cgroup_idle = 1
> 
> Modes: random or sequential
> 
> RdWr: rd==read, wr==write, rdwr==80%read & 20%write
> 
> N: Number of processes per disk
> 
> testX: Processes sharing a task group (when enabled)
> 
> ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> 
> The first thing to do is to check for correctness: when the I/O
> controller is enabled do we see correctly apportioned I/O?
> 
> At the tail end of the e-mail I've placed three (3) tables showing the
> state where -no- differences should be seen between the various "task"
> groups in terms of performance ("level playing field"), and sure enough
> no differences were seen. These were done basically as a "control" set
> of tests - the script being used didn't have any inherent biases in
> it.[1]
> 
> This table shows the cases where we should see a difference based upon
> weights:
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>        Test Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>    ioc idle  rnd   rd 2   2.8   6.3 
>    ioc idle  rnd   rd 4   0.7   1.5   2.5   3.5 
>    ioc idle  rnd   rd 8   0.2   0.4   0.5   0.8   0.9   1.2   1.4   1.7 
> 
>    ioc idle  rnd   wr 2  38.2 192.7 
>    ioc idle  rnd   wr 4   1.0  17.7  38.1 204.5 
>    ioc idle  rnd   wr 8   0.3   0.6   0.9   1.5   2.2  16.3  16.6 208.3 
> 
>    ioc idle  rnd rdwr 2   4.9  11.3 
>    ioc idle  rnd rdwr 4   0.9   2.4   4.3   6.2 
>    ioc idle  rnd rdwr 8   0.2   0.5   0.8   1.1   1.4   1.8   2.2   2.7 
> 
> 
>    ioc idle  seq   rd 2 221.0 386.4 
>    ioc idle  seq   rd 4  69.8 128.1 183.2 226.8 
>    ioc idle  seq   rd 8  21.4  40.0  55.6  70.8  85.2  98.3 111.6 121.9 
> 
>    ioc idle  seq   wr 2 398.6 391.6 
>    ioc idle  seq   wr 4 219.0 214.5 214.1 214.5 
>    ioc idle  seq   wr 8 107.6 106.8 104.7 102.5  99.5  99.5 100.5 100.8 
> 
>    ioc idle  seq rdwr 2 196.8 340.9 
>    ioc idle  seq rdwr 4  64.0 109.6 148.7 183.5 
>    ioc idle  seq rdwr 8  22.6  36.6  48.8  61.1  70.3  78.5  84.9  94.3 
> 
> In general, we do see weights associated in correctly increasing order,
> but I don't think the proportions are done correctly in all cases.
> 
> In the random tests for example, the read distribution looks pretty
> decent, but random writes are all off - for some reason the highest
> priority (most heavily weighted) is getting a disproportionately large
> percentage of the I/O bandwidth.
> 
> For the sequential loads, the reads look "OK" - not quite correctly fair
> when we have 8 processes running against the devices, but on the whole
> things look ok. Sequential writes are not working well at all:
> relatively flat distribution. 
> 
> I _think_ this is pointing to some real problems in both the write cases
> for both random & sequential I/Os.
> 
> ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> 
> The next thing to look at is to see what the "penalty" is for the
> additional code: see how much bandwidth we lose for the capability
> added. Here we see the sum of the system's throughput for the various
> tests:
> 
> ---- ---- - ----------- ----------- ----------- ----------- 
> Mode RdWr N    base       ioc off   ioc no idle  ioc idle   
> ---- ---- - ----------- ----------- ----------- ----------- 
>  rnd   rd 2        17.3        17.1         9.4         9.1 
>  rnd   rd 4        27.1        27.1         8.1         8.2 
>  rnd   rd 8        37.1        37.1         6.8         7.1 
> 
>  rnd   wr 2       296.5       243.7       290.2       230.9 
>  rnd   wr 4       287.3       280.7       270.4       261.3 
>  rnd   wr 8       272.5       273.1       237.7       246.5 
> 
>  rnd rdwr 2        27.4        27.7        16.1        16.2 
>  rnd rdwr 4        38.3        39.3        13.5        13.9 
>  rnd rdwr 8        62.0        61.5        10.0        10.7 
> 
>  seq   rd 2       610.2       608.1       610.7       607.4 
>  seq   rd 4       608.4       601.5       609.3       608.0 
>  seq   rd 8       605.7       603.7       605.0       604.8 
> 
>  seq   wr 2       840.3       850.2       836.8       790.2 
>  seq   wr 4       886.8       891.6       868.2       862.2 
>  seq   wr 8       865.1       887.1       832.1       822.0 
> 
>  seq rdwr 2       536.2       550.0       538.1       537.7 
>  seq rdwr 4       595.3       605.7       512.9       505.8 
>  seq rdwr 8       617.3       628.5       526.6       497.1
> 
> The sequential runs look very good - not much variance across the board.
> 
> The random results look horrible, especially when reads are involved:
> The first two columns (base & ioc off) are very similar, however note
> the significant drop in overall system performance once the
> io-controller CGROUP stuff gets involved - the more processes involved
> the more performance is lost. 
> 
> ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> 
> I'm going to spend some time drilling down into three specific tests:
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>        Test Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>    ioc idle  rnd   wr 2  38.2 192.7 
>    ioc idle  seq   wr 2 398.6 391.6 
> 
> This test I can use to see why random writes are so disproportionately
> apportioned - it should be 2-to-1 but we are seeing something like
> 6-to-1. And then I can look at why sequential writes are flat.
> 
> and:
> 
> ---- ---- - ----------- ----------- ----------- ----------- 
> Mode RdWr N    base       ioc off   ioc no idle  ioc idle   
> ---- ---- - ----------- ----------- ----------- ----------- 
>  rnd   rd 2        17.3        17.1         9.4         9.1 
> 
> I will try to find out why we are seeing such a loss in system
> performance...
> 
> Regards,
> Alan D. Brunelle
> Hewlett-Packard / Linux Kernel Technology Team
> 
> ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
> [1] Three tables showing the I/O load distributed when either there was
> no I/O controller code or when it was turned off or when cgroup_idle was
> turned off. All looks sane - with the exception of the ioc-enabled
> kernel with no-idle set - for random writes it appears like there is
> some differences, but not an appreciable amount?
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>        Test Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>        base  rnd   rd 2   8.6   8.6 
>        base  rnd   rd 4   6.8   6.8   6.8   6.7 
>        base  rnd   rd 8   4.7   4.6   4.6   4.6   4.6   4.6   4.6   4.6 
> 
>        base  rnd   wr 2 150.4 146.1 
>        base  rnd   wr 4  75.2  74.8  68.1  69.2 
>        base  rnd   wr 8  36.2  39.3  29.6  35.9  32.9  37.0  29.6  32.2 
> 
>        base  rnd rdwr 2  13.7  13.7 
>        base  rnd rdwr 4   9.6   9.6   9.6   9.6 
>        base  rnd rdwr 8   7.8   7.8   7.7   7.8   7.8   7.7   7.7   7.8 
> 
> 
>        base  seq   rd 2 306.2 304.0 
>        base  seq   rd 4 150.1 152.4 151.9 154.0 
>        base  seq   rd 8  77.2  75.9  75.9  73.9  77.0  75.7  75.0  74.9 
> 
>        base  seq   wr 2 420.2 420.1 
>        base  seq   wr 4 220.5 222.5 221.9 221.9 
>        base  seq   wr 8 108.2 108.8 107.8 107.7 108.7 108.5 108.1 107.2 
> 
>        base  seq rdwr 2 268.4 267.8 
>        base  seq rdwr 4 148.9 150.6 147.8 148.0 
>        base  seq rdwr 8  78.0  77.7  76.3  76.0  79.1  77.9  74.3  77.9 
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>        Test Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>     ioc off  rnd   rd 2   8.6   8.6 
>     ioc off  rnd   rd 4   6.8   6.8   6.7   6.7 
>     ioc off  rnd   rd 8   4.7   4.6   4.6   4.7   4.6   4.6   4.6   4.6 
> 
>     ioc off  rnd   wr 2 112.6 131.1 
>     ioc off  rnd   wr 4  64.9  67.8  79.9  68.1 
>     ioc off  rnd   wr 8  35.1  39.5  31.5  32.0  36.1  34.5  30.8  33.5 
> 
>     ioc off  rnd rdwr 2  13.8  13.8 
>     ioc off  rnd rdwr 4   9.8   9.8   9.9   9.8 
>     ioc off  rnd rdwr 8   7.7   7.7   7.7   7.7   7.7   7.7   7.7   7.7 
> 
> 
>     ioc off  seq   rd 2 303.1 305.0 
>     ioc off  seq   rd 4 150.8 151.6 149.0 150.2 
>     ioc off  seq   rd 8  77.0  76.3  74.5  74.0  77.9  75.5  74.0  74.6 
> 
>     ioc off  seq   wr 2 424.6 425.5 
>     ioc off  seq   wr 4 223.0 222.4 223.9 222.3 
>     ioc off  seq   wr 8 110.8 112.0 111.3 109.6 111.7 111.3 110.8 109.7 
> 
>     ioc off  seq rdwr 2 274.3 275.8 
>     ioc off  seq rdwr 4 151.3 154.8 149.0 150.6 
>     ioc off  seq rdwr 8  81.1  80.6  77.8  74.8  81.0  78.5  77.0  77.7
> 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
>        Test Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
> ----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
> ioc no idle  rnd   rd 2   4.7   4.7 
> ioc no idle  rnd   rd 4   2.0   2.0   2.0   2.0 
> ioc no idle  rnd   rd 8   0.9   0.9   0.8   0.8   0.8   0.8   0.9   0.9 
> 
> ioc no idle  rnd   wr 2 144.8 145.4 
> ioc no idle  rnd   wr 4  73.2  65.9  65.5  65.8 
> ioc no idle  rnd   wr 8  35.5  52.5  26.2  31.0  25.5  19.3  25.1  22.6 
> 
> ioc no idle  rnd rdwr 2   8.1   8.1 
> ioc no idle  rnd rdwr 4   3.4   3.4   3.4   3.4 
> ioc no idle  rnd rdwr 8   1.3   1.3   1.3   1.2   1.2   1.3   1.2   1.3 
> 
> 
> ioc no idle  seq   rd 2 304.1 306.6 
> ioc no idle  seq   rd 4 152.1 154.5 149.8 153.0 
> ioc no idle  seq   rd 8  75.8  75.8  75.2  75.1  75.5  75.3  75.7  76.5 
> 
> ioc no idle  seq   wr 2 418.6 418.2 
> ioc no idle  seq   wr 4 217.7 217.7 215.4 217.4 
> ioc no idle  seq   wr 8 105.5 105.8 105.8 103.4 102.9 103.1 102.7 102.8 
> 
> ioc no idle  seq rdwr 2 269.2 269.0 
> ioc no idle  seq rdwr 4 130.0 126.4 127.8 128.6 
> ioc no idle  seq rdwr 8  67.2  66.6  65.4  65.0  65.3  64.8  65.7  66.5 
> 
> 
> 
