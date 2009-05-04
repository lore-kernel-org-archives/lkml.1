Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZEDK5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZEDK5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbZEDK4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:56:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:61194 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbZEDK4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=NaZxTFdX6NLGJ64P1eA7t0k2HVkTov6i8qggzqx9UceEQN7PxJ4F2gAUxjvpM2XckK
         HAPtWF+MTxisLFa0w4YIlD4KQ0Az5pS/Zis1Em1UkKbRSx5flj0xoS5ZP27Onv0ecnmZ
         b38HCNOMULY2R35d4JZdHhWUE1VTUNj844610=
MIME-Version: 1.0
Date: Mon, 4 May 2009 19:56:52 +0900
Message-ID: <2891419e0905040356x53643144of77eeaa8c210dce7@mail.gmail.com>
Subject: [PATCH 0/2] range-bw : Another I/O scheduling policy of dm-ioband 
	(v1)
From: Dong-Jae Kang <baramsori72@gmail.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>, righi.andrea@gmail.com,
       menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, nauman@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

* Overview
----------------
range-bw was implemented as another I/O scheduling policy of dm-ioband
to support predicable I/O bandwidth between minimum and maximum
bandwidth defined by administrator. So, basic advantages and defects
are same with dm-ioband. Here, minimum I/O bandwidth should be
guaranteed for stable performance or reliability of specific process
groups and I/O bandwidth over maximum should be throttled to protect
the limited I/O resource from over-provisioning in unnecessary usage
or to reserve the I/O bandwidth for another use.

range-bw has two kinds of operation modes, min-max and max mode.
Min-max mode is to supports guaranteeing the minimum I/O requirement
and limitation of unnecessary I/O bandwidth at the same time. And max
mode is to support only limitation. So in case of min-max mode, you
need to configure min-bw and max-bw values and in case of max mode,
configure only max-bw.
So, range-bw was implemented to include the two concepts, guaranteeing
of minimum bandwidth and limitation of maximum bandwidth according to
the importance or priority of specific process groups.

* Attention
-----------------
Range-BW supports the predicable I/O bandwidth, but it should be
configured in the scope of total I/O bandwidth of the I/O system to
guarantee the minimum I/O requirement. For example, if total I/O
bandwidth is 40Mbytes/sec, the summary of I/O bandwidth configured in
each process group should be equal or smaller than 40Mbytes/sec.
So, we need to check total I/O bandwidth before set it up.

* Setup information
------------------------------
range-bw is based on newest version of dm-ioband, bio-cgroup V7(4patch
files), dm-ioband-V1.10.3(1 patch file) and these can be
referred in
http://people.valinux.co.jp/~ryov/dm-ioband/
http://people.valinux.co.jp/~ryov/bio-cgroup/
and the below range-bw patch file(dm-ioband-rangebw-1.10.3.patch)
You have to apply this(dm-ioband-rangebw-1.10.3.patch) patch file
after applying dm-ioband and bio-cgroup patches

* Usage
--------------
It is very useful to refer the documentation for dm-ioband in
/Documentation/device-mapper/ioband.txt or
http://people.valinux.co.jp/~ryov/dm-ioband/, because Range-BW follows
the basic semantics of dm-ioband.
This example is for min-max mode.

# mount the cgroup for range-bw
mount -t cgroup -o bio none /root/cgroup/bio

# create the process groups (3 groups)
mkdir /root/cgroup/bio/bgroup1
mkdir /root/cgroup/bio/bgroup2
mkdir /root/cgroup/bio/bgroup3

# create the ioband device ( name : ioband1 )
echo "0 $(blockdev --getsize /dev/sdb2) ioband /dev/sdb2 1 0 0 none
range-bw 0 :0" | dmsetup create ioband1
: device name (/dev/sdb2) should be modified depending on your system

# init ioband device ( type and policy )
dmsetup message ioband1 0 type cgroup
dmsetup message ioband1 0 policy range-bw

# attach the groups to the ioband device
dmsetup message ioband1 0 attach 2
dmsetup message ioband1 0 attach 3
dmsetup message ioband1 0 attach 4
: group number can be referred in /root/cgroup/bio/bgroup1/bio.id

# allocate the values ( min-bw and max-bw ) : XXX Kbytes
: the sum of minimum I/O bandwidth in each group should be equal or
smaller than total bandwidth to be supported by your system

# range : about 100~500 Kbytes
dmsetup message ioband1 0 min-bw 2:100
dmsetup message ioband1 0 max-bw 2:500

# range : about 700~1000 Kbytes
dmsetup message ioband1 0 min-bw 3:700
dmsetup message ioband1 0 max-bw 3:1000

# range : about 50~60Mbytes
dmsetup message ioband1 0 min-bw 4:50000
dmsetup message ioband1 0 max-bw 4:60000

You can confirm the configuration of range-bw by using this command :
[root@localhost range-bw]# dmsetup table --target ioband
ioband1: 0 305235000 ioband 8:18 1 4 128 cgroup range-bw 16384 :0
2:100:500 3:700:1000 4:30000:60000

* Evaluation
------------------

range-bw supports the 2 kinds of configuration style, one is min-max
configuration
and the other is only-max configuration.
min-max is to supports guaranteeing the minimum I/O requirement and
limitation of
unnecessary I/O bandwidth at the same time. And only-max is to support
only bandwidth limitation.
the evaluation result of range-bw is as like below

-Testing tool : fio-1.26
-Total bandwidth in my test system :
  * Sequential read / write : about 60 Mbytes/sec
  * Random read / write : about 290 Kbytes/sec
- configuration semantics : X:Y:Z = process group : min-bw : max-bw
and min-bw, max-bw : Kbytes/sec

1. Sequential read / write (total bandwidth : about 60 Mbytes/sec)

1.1 Test1
* Configuration (min-max)
[root@localhost range-bw]# dmsetup table --target ioband
ioband1: 0 305235000 ioband 8:18 1 4 128 cgroup range-bw 16384 :0
2:500:700 3:3000:5000 4:50000:55000

* Command :
fio --time_based --runtime=30 --ioengine=libaio --iodepth=50
--direct=1  --rw=write --name=grp1 --filename=/dev/mapper/ioband1
--numjobs=1 --norandommap

* Result :
- Group2
Run status group 0 (all jobs):
  WRITE: io=21,008KiB, aggrb=693KiB/s, minb=693KiB/s, maxb=693KiB/s,
mint=30311msec, maxt=30311msec
- Group3
Run status group 0 (all jobs):
  WRITE: io=147MiB, aggrb=4,979KiB/s, minb=4,979KiB/s,
maxb=4,979KiB/s, mint=30128msec, maxt=30128msec
- Group4
Run status group 0 (all jobs):
WRITE: io=1,526MiB, aggrb=52,057KiB/s, minb=52,057KiB/s,
maxb=52,057KiB/s, mint=30010msec, maxt=30010msec

1.2 Test2
* Configuration (only-max)
[root@localhost range-bw]# dmsetup table --target ioband
ioband1: 0 305235000 ioband 8:18 1 4 128 cgroup range-bw 16384 :0
2:0:700 3:0:5000 4:0:10000

* Command :
fio --time_based --runtime=30 --ioengine=libaio --iodepth=50
--direct=1  --rw=read --name=grp1 --filename=/dev/mapper/ioband1
--numjobs=1 --norandommap

* Result :
- Group2
Run status group 0 (all jobs):
   READ: io=20,424KiB, aggrb=676KiB/s, minb=676KiB/s, maxb=676KiB/s,
mint=30169msec, maxt=30169msec
- Group3
Run status group 0 (all jobs):
   READ: io=142MiB, aggrb=4,836KiB/s, minb=4,836KiB/s,
maxb=4,836KiB/s, mint=30022msec, maxt=30022msec
- Group4
Run status group 0 (all jobs):
   READ: io=293MiB, aggrb=9,755KiB/s, minb=9,755KiB/s,
maxb=9,755KiB/s, mint=30752msec, maxt=30752msec

2. Random read / write (total bandwidth : about 290 Kbytes/sec)

2.1 Test1 (min-max)
* Configuration :
[root@localhost range-bw]# dmsetup table --target ioband
ioband1: 0 305235000 ioband 8:18 1 4 128 cgroup range-bw 16384 :0
2:80:90 3:180:200 4:0:0

* Command :
fio --time_based --runtime=30 --ioengine=libaio --iodepth=50
--direct=1  --rw=randread --name=grp1 --filename=/dev/mapper/ioband1
--numjobs=1 --norandommap

* Result :
Group2
Run status group 0 (all jobs):
   READ: io=2,780KiB, aggrb=92KiB/s, minb=92KiB/s, maxb=92KiB/s,
mint=30175msec, maxt=30175msec
Group3
Run status group 0 (all jobs):
   READ: io=6,008KiB, aggrb=193KiB/s, minb=193KiB/s, maxb=193KiB/s,
mint=30998msec, maxt=30998msec

2.2 Test2 (min-max)
* Configuration :
[root@localhost range-bw]# dmsetup table --target ioband
ioband1: 0 305235000 ioband 8:18 1 4 128 cgroup range-bw 16384 :0
2:50:60 3:200:220 4:0:0

* Command :
fio --time_based --runtime=30 --ioengine=libaio --iodepth=50
--direct=1  --rw=randwrite --name=grp1 --filename=/dev/mapper/ioband1
--numjobs=1 --norandommap

* Result :
- Group2
Run status group 0 (all jobs):
  WRITE: io=1,848KiB, aggrb=61KiB/s, minb=61KiB/s, maxb=61KiB/s,
mint=30158msec, maxt=30158msec
- Group3
Run status group 0 (all jobs):
  WRITE: io=6,612KiB, aggrb=213KiB/s, minb=213KiB/s, maxb=213KiB/s,
mint=30994msec, maxt=30994msec

-- 
Best Regards,
Dong-Jae Kang
