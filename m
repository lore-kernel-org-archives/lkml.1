Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXCVCDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXCVCDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXCVCDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:03:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:37503 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbXCVCDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:03:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 21 Mar 2007 19:02:16 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: AIO, FIO and Threads ...
In-Reply-To: <20070321074014.GD14389@kernel.dk>
Message-ID: <Pine.LNX.4.64.0703211853340.3716@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703202146570.28960@alien.or.mcafeemobile.com>
 <20070321074014.GD14389@kernel.dk>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Jens Axboe wrote:

> On Tue, Mar 20 2007, Davide Libenzi wrote:
> > 
> > I was looking at Jens FIO stuff, and I decided to cook a quick patch for 
> > FIO to support GUASI (Generic Userspace Asyncronous Syscall Interface):
> > 
> > http://www.xmailserver.org/guasi-lib.html
> > 
> > I then ran a few tests on my Dual Opteron 252 with SATA drives (sata_nv) 
> > and 8GB of RAM.
> > Mind that I'm not FIO expert, like at all, but I got some interesting 
> > results when comparing GUASI with libaio at 8/1000/10000 depths.
> > If I read those result correctly (Jens may help), GUASI output is more 
> > then double the libaio one.
> > Lots of context switches, yes. But the throughput looks like 2+ times.
> > Can someone try to repeat the measures and/or spot the error?
> > Or tell me which other tests to run?
> > This is kinda a suprise for me ...
> 
> I don't know guasi at all, but libaio requires O_DIRECT to be async. I'm
> sure you know this, but you may not know that fio default to buffered IO
> so you have to tell it to use O_DIRECT :-)
> 
> So try adding a --direct=1 (or --buffered=0, same thing) as an extra
> option when comparing depths > 1.

This is a much smaller box. P4 with 1GB of RAM, and on a 1GB RW test. 
Now libaio performs well, even though GUASI can keep the pace. Quite a 
surprise, nonetheless ...




- Davide



*** fio --name=global --rw=randrw --size=1g --bs=4k --direct=1 
        --ioengine=guasi --name=job1 --iodepth=100 --thread --runtime=20
job1: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=guasi, iodepth=100
Starting 1 thread
Jobs: 1: [m] [100.0% done] [   609/     0 kb/s] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=21862
  read : io=8,300KiB, bw=412KiB/s, iops=100, runt= 20599msec
    slat (msec): min=    0, max=    2, avg= 0.04, stdev= 0.29
    clat (msec): min=   11, max= 1790, avg=564.76, stdev=350.58
    bw (KiB/s) : min=   47, max=  692, per=121.80%, avg=501.83, stdev=196.86
  write: io=11,344KiB, bw=563KiB/s, iops=137, runt= 20599msec
    slat (msec): min=    0, max=    2, avg= 0.04, stdev= 0.28
    clat (msec): min=    2, max=  643, avg=311.86, stdev=108.85
    bw (KiB/s) : min=    0, max= 1695, per=143.52%, avg=808.00, stdev=632.11
  cpu          : usr=0.19%, sys=1.94%, ctx=28036
  IO depths    : 1=0.0%, 2=0.0%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.7%, >=64=98.7%
     lat (msec): 2=0.0%, 4=0.0%, 10=0.0%, 20=0.3%, 50=1.2%, 100=2.2%
     lat (msec): 250=16.4%, 500=51.4%, 750=16.8%, 1000=6.5%, >=2000=5.1%

Run status group 0 (all jobs):
   READ: io=8,300KiB, aggrb=412KiB/s, minb=412KiB/s, maxb=412KiB/s, mint=20599msec, maxt=20599msec
  WRITE: io=11,344KiB, aggrb=563KiB/s, minb=563KiB/s, maxb=563KiB/s, mint=20599msec, maxt=20599msec

Disk stats (read/write):
  sda: ios=2074/2846, merge=1/26, ticks=945564/14060, in_queue=959624, util=97.65%



*** fio --name=global --rw=randrw --size=1g --bs=4k --direct=1 
        --ioengine=libaio --name=job1 --iodepth=100 --thread --runtime=20
job1: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=100
Starting 1 thread
Jobs: 1: [m] [100.0% done] [   406/   438 kb/s] [eta 00m:00s]
job1: (groupid=0, jobs=1): err= 0: pid=21860
  read : io=8,076KiB, bw=403KiB/s, iops=98, runt= 20495msec
    slat (msec): min=    0, max=  494, avg= 0.55, stdev=14.75
    clat (msec): min=    0, max= 1788, avg=509.38, stdev=391.43
    bw (KiB/s) : min=   20, max=  682, per=104.55%, avg=421.32, stdev=153.91
  write: io=11,024KiB, bw=550KiB/s, iops=134, runt= 20495msec
    slat (msec): min=    0, max=  441, avg= 0.23, stdev= 8.40
    clat (msec): min=    0, max= 1695, avg=368.51, stdev=308.11
    bw (KiB/s) : min=    0, max= 1787, per=105.78%, avg=581.78, stdev=438.43
  cpu          : usr=0.06%, sys=0.76%, ctx=6185
  IO depths    : 1=0.1%, 2=0.2%, 4=0.3%, 8=0.7%, 16=1.3%, 32=2.7%, >=64=94.7%
     lat (msec): 2=0.4%, 4=0.1%, 10=0.7%, 20=2.5%, 50=7.0%, 100=9.4%
     lat (msec): 250=20.2%, 500=23.2%, 750=17.8%, 1000=10.9%, >=2000=7.9%

Run status group 0 (all jobs):
   READ: io=8,076KiB, aggrb=403KiB/s, minb=403KiB/s, maxb=403KiB/s, mint=20495msec, maxt=20495msec
  WRITE: io=11,024KiB, aggrb=550KiB/s, minb=550KiB/s, maxb=550KiB/s, mint=20495msec, maxt=20495msec

Disk stats (read/write):
  sda: ios=2019/2788, merge=0/38, ticks=988100/1048096, in_queue=2036196, util=99.38%



*** fio --name=global --rw=randrw --size=1g --bs=4k --direct=1 
        --ioengine=guasi --name=job1 --iodepth=1000 --thread --runtime=20
job1: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=guasi, iodepth=1000
Starting 1 thread
Jobs: 1: [m] [1.9% done] [  2348/  1710 kb/s] [eta 21m:00s]s]
job1: (groupid=0, jobs=1): err= 0: pid=19471
  read : io=10,640KiB, bw=436KiB/s, iops=106, runt= 24972msec
    slat (msec): min=    0, max=   26, avg= 3.46, stdev= 7.68
    clat (msec): min=   27, max= 9800, avg=5048.47, stdev=1728.19
    bw (KiB/s) : min=   44, max=  689, per=98.52%, avg=429.54, stdev=190.74
  write: io=9,748KiB, bw=399KiB/s, iops=97, runt= 24972msec
    slat (msec): min=    0, max=   26, avg= 4.04, stdev= 8.21
    clat (msec): min=    9, max= 9153, avg=4718.51, stdev=1692.57
    bw (KiB/s) : min=    0, max= 1586, per=109.27%, avg=436.00, stdev=395.51
  cpu          : usr=0.24%, sys=1.57%, ctx=20661
  IO depths    : 1=0.0%, 2=0.0%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.6%, >=64=98.8%
     lat (msec): 2=0.0%, 4=0.0%, 10=0.0%, 20=0.0%, 50=0.2%, 100=0.1%
     lat (msec): 250=0.5%, 500=0.4%, 750=1.1%, 1000=1.0%, >=2000=3.8%

Run status group 0 (all jobs):
   READ: io=10,640KiB, aggrb=436KiB/s, minb=436KiB/s, maxb=436KiB/s, mint=24972msec, maxt=24972msec
  WRITE: io=9,748KiB, aggrb=399KiB/s, minb=399KiB/s, maxb=399KiB/s, mint=24972msec, maxt=24972msec

Disk stats (read/write):
  sda: ios=2660/2449, merge=0/27, ticks=1016188/22112, in_queue=1038296, util=97.60%


*** fio --name=global --rw=randrw --size=1g --bs=4k --direct=1 
        --ioengine=libaio --name=job1 --iodepth=1000 --thread --runtime=20
job1: (g=0): rw=randrw, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=1000
Starting 1 thread
Jobs: 1: [m] [1.8% done] [  3502/     0 kb/s] [eta 20m:01s]s]
job1: (groupid=0, jobs=1): err= 0: pid=19723
  read : io=10,944KiB, bw=493KiB/s, iops=120, runt= 22697msec
    slat (msec): min=  363, max= 5490, avg=3917.46, stdev=1842.45
    clat (msec): min=    0, max= 5491, avg=980.56, stdev=1764.36
    bw (KiB/s) : min=    1, max= 4091, per=211.44%, avg=1042.38, stdev=1517.27
  write: io=8,468KiB, bw=382KiB/s, iops=93, runt= 22697msec
    slat (msec): min=    0, max= 3025, avg=2864.85, stdev=115.63
    clat (msec): min=    0, max= 6104, avg=381.86, stdev=1124.52
    bw (KiB/s) : min=    0, max= 3046, per=196.70%, avg=751.40, stdev=1305.17
  cpu          : usr=0.04%, sys=0.62%, ctx=2148
  IO depths    : 1=0.0%, 2=0.0%, 4=0.1%, 8=0.2%, 16=0.3%, 32=0.7%, >=64=98.7%
     lat (msec): 2=74.0%, 4=0.1%, 10=0.1%, 20=0.0%, 50=0.0%, 100=0.0%
     lat (msec): 250=0.0%, 500=2.8%, 750=0.0%, 1000=4.6%, >=2000=2.6%

Run status group 0 (all jobs):
   READ: io=10,944KiB, aggrb=493KiB/s, minb=493KiB/s, maxb=493KiB/s, mint=22697msec, maxt=22697msec
  WRITE: io=8,468KiB, aggrb=382KiB/s, minb=382KiB/s, maxb=382KiB/s, mint=22697msec, maxt=22697msec

Disk stats (read/write):
  sda: ios=2734/2135, merge=2/36, ticks=2345836/1359304, in_queue=3722228, util=99.23%



