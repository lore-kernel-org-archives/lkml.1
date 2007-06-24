Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXFXL6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXFXL6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 07:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXFXL6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 07:58:32 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21568 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbXFXL6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 07:58:31 -0400
Message-ID: <467E5C5E.6000706@msgid.tls.msk.ru>
Date: Sun, 24 Jun 2007 15:58:22 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Carlo Wood <carlo@alinoe.com>, Tejun Heo <htejun@gmail.com>,
       Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org>
In-Reply-To: <467DA1F5.2060306@garzik.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> IN THEORY, RAID performance should /increase/ due to additional queued
> commands available to be sent to the drive.  NCQ == command queueing ==
> sending multiple commands to the drive, rather than one-at-a-time like
> normal.
> 
> But hdparm isn't the best test for that theory, since it does not
> simulate the transactions like real-world MD device usage does.
> 
> We have seen buggy NCQ firmwares where performance decreases, so it is
> possible that NCQ just isn't good on your drives.

By the way, I did some testing of various drives, and NCQ/TCQ indeed
shows some difference -- with multiple I/O processes (like "server"
workload), IF NCQ/TCQ is implemented properly, especially in the
drive.

For example, this is a good one:

Single Seagate 74Gb SCSI drive (10KRPM)

BlkSz Trd linRd rndRd linWr  rndWr  linR/W     rndR/W
   4k   1  66.4   0.5   0.6   0.5   0.6/ 0.6   0.4/ 0.2
        2         0.6         0.6              0.5/ 0.1
        4         0.7         0.6              0.6/ 0.2
  16k   1  84.8   2.0   2.5   1.9   2.5/ 2.5   1.6/ 0.6
        2         2.3         2.1              2.0/ 0.6
        4         2.7         2.5              2.3/ 0.6
  64k   1  84.8   7.4   9.3   7.2   9.4/ 9.3   5.8/ 2.2
        2         8.6         7.9              7.3/ 2.1
        4         9.9         9.1              8.1/ 2.2
 128k   1  84.8  13.6  16.7  12.9  16.9/16.6  10.6/ 3.9
        2        15.6        14.4             13.5/ 3.2
        4        17.9        16.4             15.7/ 2.7
 512k   1  84.9  34.0  41.9  33.3  29.0/27.1  22.4/13.2
        2        36.9        34.5             30.7/ 8.1
        4        40.5        38.1             33.2/ 8.3
1024k   1  83.1  36.0  55.8  34.6  28.2/27.6  20.3/19.4
        2        45.2        44.1             36.4/ 9.9
        4        48.1        47.6             40.7/ 7.1

The tests are direct-I/O over whole drive (/dev/sdX), with
either 1, 2, or 4 threads doing sequential or random reads
or writes in blocks of a given size.  For the R/W tests,
we've 2, 4 or 8 threads running in total (1, 2 or 4 readers
and the same amount of writers).  Numbers are MB/sec, as
totals (summary) for all threads.

Especially interesting is the very last column - random R/W
in parallel.  In almost all cases, more threads gives larger
total speed (I *guess* it's due to internal optimisations in
the drive -- with more threads the drive has more chances to
reorder commands to minimize seek time etc).

The only thing I don't understand is why with larger I/O block
size we see write speed drop with multiple threads.

And in contrast to the above, here's another test run, now
with Seagate SATA ST3250620AS ("desktop" class) 250GB
7200RPM drive:

BlkSz Trd linRd rndRd linWr rndWr   linR/W    rndR/W
   4k   1  47.5   0.3   0.5   0.3   0.3/ 0.3   0.1/ 0.1
        2         0.3         0.3              0.2/ 0.1
        4         0.3         0.3              0.2/ 0.2
  16k   1  78.4   1.1   1.8   1.1   0.9/ 0.9   0.6/ 0.6
        2         1.2         1.1              0.6/ 0.6
        4         1.3         1.2              0.6/ 0.6
  64k   1  78.4   4.3   6.7   4.0   3.5/ 3.5   2.1/ 2.2
        2         4.5         4.1              2.2/ 2.3
        4         4.7         4.2              2.3/ 2.4
 128k   1  78.4   8.0  12.6   7.2   6.2/ 6.2   3.9/ 3.8
        2         8.2         7.3              4.1/ 4.0
        4         8.7         7.7              4.3/ 4.3
 512k   1  78.5  23.1  34.0  20.3  17.1/17.1  11.3/10.7
        2        23.5        20.6             11.3/11.4
        4        24.7        21.3             11.6/11.8
1024k   1  78.4  34.1  33.5  24.6  19.6/19.5  16.0/12.7
        2        33.3        24.6             15.4/13.8
        4        34.3        25.0             14.7/15.0

Here, the (total) I/O speed does not depend on the number
of threads.  From which I conclude that the drive does
not reorder/optimize commands internally, even if NCQ is
enabled (queue depth is 32).

(And two notes.  First of all, for some, those tables may
look.. strange, showing too low speed.  Note the block
size, and note I'm doing *direct* *random* I/O, without
buffering in the kernel.  Yes, even the most advanced
modern drives are very slow in this workload, due to
seek times and rotation latency -- the disk is maxing
out at the theoretical requests/secound -- take average
seek time plus rotation latency (usually given in the
drive specs), and divide one secound to the calculated
value -- you'll see about 200..250 - that's requests/sec.
And the numbers - like 0.3Mb/sec write - are very close
to those 200..250.  In any way, this is not a typical
workload - file server for example is not like this.
But it's more or less resembles database workload.

And second, so far I haven't seen a case where a drive
with NCQ/TCQ enabled works worse than without.  I don't
want to say there aren't such drives/controllers, but
it just happen that I haven't seen any.)

/mjt
