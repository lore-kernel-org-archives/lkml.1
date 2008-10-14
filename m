Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYJNJ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYJNJ4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYJNJ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:56:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:35678 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYJNJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LmLK1KwBzxC/bvkjrPcInkX2KFnyyTFw691+xlFZGdwi81GrtPaE2VML7xHILHQG6q
         C30Z7W6TSjYzi58nnCXuMPGl2ntdqHS7mPm/ukhcBgSPH6/4FBLuyniiLJ5WKIBVA4Nz
         tqsSHq8tsjDdKe0/TpSv+2eHpOMIOvR4iVks0=
Message-ID: <48F46CB6.3010904@gmail.com>
Date: Tue, 14 Oct 2008 11:56:06 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Dong-Jae Kang <baramsori72@gmail.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Marco Innocenti <m.innocenti@cineca.it>,
       matt@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/6] cgroup: block device i/o controller (v11)
References: <> <1223373818-13687-1-git-send-email-righi.andrea@gmail.com> <2891419e0810140217l70f233bbr3b08760188458c35@mail.gmail.com>
In-Reply-To: <2891419e0810140217l70f233bbr3b08760188458c35@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong-Jae Kang wrote:
> Hi, Andrea
> 
> thank you for your contribution to community
> these days, I am testing several IO controllers in container ML,
> dm-ioband by Ryo tsuruta(v1.7.0), 2-Layer CFQ by Satoshi and your
> io-throttle(v11)

Thanks! this is surely a valuable task.

> 
> I have several question about io-throttle
> below is my test reusult of io-throttle(v11) with xdd 6.5
> But, I think I have something wrong, as showed in result
> In direct IO mode, Only read operation was controlled by io-throttle
> Can you check my  test procedure and result and comments to me about that

Your procedure is correct. Anyway, you found a known bug in io-throttle
v11. If you want to properly use it you need to mount the memory
controller together with blockio, since currently blockio depends on it
to retrieve the owner of a page during writes in submit_bio().

As reported in:

[PATCH -mm 4/6] memcg: interface to charge the right cgroup of asynchronous i/o activity

this is no more than a hack and in perspective a more generic framework
able to provide this functionality should be used (i.e. bio-cgroup).

I'll fix this issue in the next version of io-throttle (probably I'll
try to rewrite io-throttle on top of bio-cgroup), but for now the
workaround is to mount the cgroupfs using -o blockio,memory (at least).

> 
> additionally, your testing shell script(run_io_throttle_test.sh) for
> io-throttle was not updated for new io-throttle
> so, it could be operated after I fixed it

The testing of iops limiting is not yet implemented and I don't have a
very good testcase for this, but I can share with you a small script that
I'm using to check if iops limiting is working or not, if you're interested.

Thanks,
-Andrea

> 
> -----------------------------------------------------------------------------------
> - Test System Information
> 
> Computer Name, localhost.localdomain, User Name, root
> OS release and version, Linux 2.6.27-rc5-mm1 #1 SMP Thu Oct 9 18:27:09 KST 2008
> Machine hardware type, i686
> Number of processors on this system, 1
> Page size in bytes, 4096
> Number of physical pages, 515885
> Megabytes of physical memory, 2015
> Target[0] Q[0], /dev/sdb
> Per-pass time limit in seconds, 30
> Blocksize in bytes, 512
> Request size, 128, blocks, 65536, bytes
> Number of Requests, 16384
> Number of MegaBytes, 512 or 1024
> Direct I/O, disabled or enable
> Seek pattern, sequential
> Queue Depth, 1
> 
> - Test Procedure
> 
> 	mkdir /dev/blockioctl
> 	mount -t cgroup -o blockio cgroup /dev/blockioctl
> 	mkdir /dev/blockioctl/cgroup-1
> 	mkdir /dev/blockioctl/cgroup-2
> 	mkdir /dev/blockioctl/cgroup-3
> 	echo /dev/sdb:$((1024*1024)):0:0 >
> /dev/blockioctl/cgroup-1/blockio.bandwidth-max
> 	echo /dev/sdb:$((2*1024*1024)):0:0 >
> /dev/blockioctl/cgroup-2/blockio.bandwidth-max
> 	echo /dev/sdb:$((3*1024*1024)):0:0 >
> /dev/blockioctl/cgroup-3/blockio.bandwidth-max
> 	in terminal 1, echo $$ > /dev/blockioctl/cgroup-1/tasks
> 	in terminal 2, echo $$ > /dev/blockioctl/cgroup-2/tasks
> 	in terminal 3, echo $$ > /dev/blockioctl/cgroup-3/tasks
> 	in each terminal, xdd.linux -op write( or read ) -targets 1 /dev/sdb
> -blocksize 512 -reqsize 128 -mbytes 1024( or 512 )  -timelimit 30
> -verbose –dio(enable or disable)
> 
> - setting status information
> 
> [root@localhost blockioctl]# cat ./cgroup-1/blockio.bandwidth-max
> 8 16 1048576 0 0 0 13016
> [root@localhost blockioctl]# cat ./cgroup-2/blockio.bandwidth-max
> 8 16 2097152 0 0 0 11763
> [root@localhost blockioctl]# cat ./cgroup-3/blockio.bandwidth-max
> 8 16 3145728 0 0 0 11133
> 
> - Test Result
> xdd.linux -op read -targets 1 /dev/sdb -blocksize 512 -reqsize 128
> -mbytes 512 -timelimit 30 -dio -verbose
> 
> cgroup-1
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1      31522816      481    30.005     1.051      16.03    0.0624
>   0.00   read       65536
> 0  1      31522816      481    30.005     1.051      16.03    0.0624
>   0.00   read       65536
> 1  1      31522816      481    30.005     1.051      16.03    0.0624
>   0.00   read       65536
> 
> cgroup-2
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1      62980096      961    30.001     2.099      32.03    0.0312
>   0.00   read       65536
> 0  1      62980096      961    30.001     2.099      32.03    0.0312
>   0.00   read       65536
> 1  1      62980096      961    30.001     2.099      32.03    0.0312
>   0.00   read       65536
> 
> cgroup-3
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1      94437376     1441    30.003     3.148      48.03    0.0208
>   0.00   read       65536
> 0  1      94437376     1441    30.003     3.148      48.03    0.0208
>   0.00   read       65536
> 1  1      94437376     1441    30.003     3.148      48.03    0.0208
>   0.00   read       65536
> 
> xdd.linux -op write -targets 1 /dev/sdb -blocksize 512 -reqsize 128
> -mbytes 512 -timelimit 30 -dio –verbose
> 
> cgroup-1
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1     640221184     9769    30.097    21.272     324.58    0.0031
>   0.00   write       65536
> 0  1     640221184     9769    30.097    21.272     324.58    0.0031
>   0.00   write       65536
> 1  1     640221184     9769    30.097    21.272     324.58    0.0031
>   0.00   write       65536
> 
> cgroup-2
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1     633798656     9671    30.001    21.126     322.36    0.0031
>   0.00   write       65536
> 0  1     633798656     9671    30.001    21.126     322.36    0.0031
>   0.00   write       65536
> 1  1     633798656     9671    30.001    21.126     322.36    0.0031
>   0.00   write       65536
> 
> cgroup-3
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1     630652928     9623    30.001    21.021     320.76    0.0031
>   0.00   write       65536
> 0  1     630652928     9623    30.001    21.021     320.76    0.0031
>   0.00   write       65536
> 1  1     630652928     9623    30.001    21.021     320.76    0.0031
>   0.00   write       65536
> 
> xdd.linux -op read -targets 1 /dev/sdb -blocksize 512 -reqsize 128
> -mbytes 1024  -timelimit 30  -verbose
> 
> cgroup-1
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1      70123520     1070    30.150     2.326      35.49    0.0282
>   0.00   read       65536
> 0  1      70123520     1070    30.150     2.326      35.49    0.0282
>   0.00   read       65536
> 1  1      70123520     1070    30.150     2.326      35.49    0.0282
>   0.00   read       65536
> 
> cgroup-2
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1      70844416     1081    30.063     2.357      35.96    0.0278
>   0.00   read       65536
> 0  1      70844416     1081    30.063     2.357      35.96    0.0278
>   0.00   read       65536
> 1  1      70844416     1081    30.063     2.357      35.96    0.0278
>   0.00   read       65536
> 
> cgroup-3
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1      72155136     1101    30.204     2.389      36.45    0.0274
>   0.00   read       65536
> 0  1      72155136     1101    30.204     2.389      36.45    0.0274
>   0.00   read       65536
> 1  1      72155136     1101    30.204     2.389      36.45    0.0274
>   0.00   read       65536
> 
> xdd.linux -op write -targets 1 /dev/sdb -blocksize 512 -reqsize 128
> -mbytes 1024  -timelimit 30  -verbose
> 
> cgroup-1
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1     818610176    12491    30.031    27.258     415.93    0.0024
>   0.00   write       65536
> 0  1     818610176    12491    30.031    27.258     415.93    0.0024
>   0.00   write       65536
> 1  1     818610176    12491    30.031    27.258     415.93    0.0024
>   0.00   write       65536
> 
> cgroup-2
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1     848494592    12947    30.066    28.221     430.62    0.0023
>   0.00   write       65536
> 0  1     848494592    12947    30.066    28.221     430.62    0.0023
>   0.00   write       65536
> 1  1     848494592    12947    30.066    28.221     430.62    0.0023
>   0.00   write       65536
> 
> cgroup-3
> 
> T  Q       Bytes      Ops    Time      Rate      IOPS   Latency
> %CPU  OP_Type    ReqSize
> 0  1     786563072    12002    30.078    26.151     399.03    0.0025
>   0.00   write       65536
> 0  1     786563072    12002    30.078    26.151     399.03    0.0025
>   0.00   write       65536
> 1  1     786563072    12002    30.078    26.151     399.03    0.0025
>   0.00   write       65536
> 
> Best Regards,
> Dong-Jae Kang
> 
> 
> 2008/10/7 Andrea Righi <righi.andrea@gmail.com>:
>> The objective of the i/o controller is to improve i/o performance
>> predictability of different cgroups sharing the same block devices.
>>
>> Respect to other priority/weight-based solutions the approach used by this
>> controller is to explicitly choke applications' requests that directly (or
>> indirectly) generate i/o activity in the system.
>>
>> The direct bandwidth and/or iops limiting method has the advantage of improving
>> the performance predictability at the cost of reducing, in general, the overall
>> performance of the system (in terms of throughput).
>>
>> Detailed informations about design, its goal and usage are described in the
>> documentation.
>>
>> Patchset against 2.6.27-rc5-mm1:
>>
>>  [PATCH 0/6] cgroup: block device i/o controller (v11)
>>  [PATCH 1/6] i/o controller documentation
>>  [PATCH 2/6] introduce ratelimiting attributes and functionality to res_counter
>>  [PATCH 3/6] i/o controller infrastructure
>>  [PATCH 4/6] memcg: interface to charge the right cgroup of asynchronous i/o activity
>>  [PATCH 5/6] i/o controller instrumentation: accounting and throttling
>>  [PATCH 6/6] export per-task i/o throttling statistics to userspace
>>
>> The all-in-one patch (and previous versions) can be found at:
>> http://download.systemimager.org/~arighi/linux/patches/io-throttle/
>>
>> There are no significant changes respect to v10, I've only implemented/fixed
>> some suggestions I received.
>>
>> Changelog: (v10 -> v11)
>>
>> * report per block device i/o statistics (total bytes read/written and iops)
>>  in blockio.stat for i/o limited cgroups
>> * distinct bandwidth and iops statistics: both in blockio.throttlecnt and
>>  /proc/PID/io-throttle-stat (suggested by David Radford)
>> * merge res_counter_ratelimit functionality into res_counter, to avoid code
>>  duplication (suggested by Paul Manage)
>> * use kernel-doc style for documenting struct res_counter attributes
>>  (suggested by Randy Dunalp)
>> * udpated documentation
>>
>> Thanks to all for the feedback!
>> -Andrea
