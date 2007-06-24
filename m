Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbXFXOVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbXFXOVj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 10:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbXFXOVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 10:21:30 -0400
Received: from lucidpixels.com ([75.144.35.66]:39895 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbXFXOV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 10:21:29 -0400
Date: Sun, 24 Jun 2007 10:21:28 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: "Dr. David Alan Gilbert" <linux@treblig.org>
cc: Michael Tokarev <mjt@tls.msk.ru>, Jeff Garzik <jeff@garzik.org>,
       Carlo Wood <carlo@alinoe.com>, Tejun Heo <htejun@gmail.com>,
       Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
In-Reply-To: <20070624125957.GA28067@gallifrey>
Message-ID: <Pine.LNX.4.64.0706241021030.12207@p34.internal.lan>
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org>
 <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org>
 <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org>
 <467E5C5E.6000706@msgid.tls.msk.ru> <20070624125957.GA28067@gallifrey>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget about max_sectors_kb either (for all drives in the SW RAID5 
array)

max_sectors_kb = 8
$ dd if=/dev/zero of=file.out6 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 55.4848 seconds, 194 MB/s

max_sectors_kb = 16
$ dd if=/dev/zero of=file.out5 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 37.6886 seconds, 285 MB/s

max_sectors_kb = 32
$ dd if=/dev/zero of=file.out4 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 26.2875 seconds, 408 MB/s

max_sectors_kb = 64
$ dd if=/dev/zero of=file.out2 bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 24.8301 seconds, 432 MB/s

max_sectors_kb = 128
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 22.6298 seconds, 474 MB/s


On Sun, 24 Jun 2007, Dr. David Alan Gilbert wrote:

> * Michael Tokarev (mjt@tls.msk.ru) wrote:
>
> <snip>
>
>> By the way, I did some testing of various drives, and NCQ/TCQ indeed
>> shows some difference -- with multiple I/O processes (like "server"
>> workload), IF NCQ/TCQ is implemented properly, especially in the
>> drive.
>>
>> For example, this is a good one:
>>
>> Single Seagate 74Gb SCSI drive (10KRPM)
>>
>> BlkSz Trd linRd rndRd linWr  rndWr  linR/W     rndR/W
>
> <snip>
>
>> 1024k   1  83.1  36.0  55.8  34.6  28.2/27.6  20.3/19.4
>>         2        45.2        44.1             36.4/ 9.9
>>         4        48.1        47.6             40.7/ 7.1
>>
>> The tests are direct-I/O over whole drive (/dev/sdX), with
>> either 1, 2, or 4 threads doing sequential or random reads
>> or writes in blocks of a given size.  For the R/W tests,
>> we've 2, 4 or 8 threads running in total (1, 2 or 4 readers
>> and the same amount of writers).  Numbers are MB/sec, as
>> totals (summary) for all threads.
>>
>> Especially interesting is the very last column - random R/W
>> in parallel.  In almost all cases, more threads gives larger
>> total speed (I *guess* it's due to internal optimisations in
>> the drive -- with more threads the drive has more chances to
>> reorder commands to minimize seek time etc).
>>
>> The only thing I don't understand is why with larger I/O block
>> size we see write speed drop with multiple threads.
>
> My guess is that something is chopping them up into smaller writes.
>
>> And in contrast to the above, here's another test run, now
>> with Seagate SATA ST3250620AS ("desktop" class) 250GB
>> 7200RPM drive:
>>
>> BlkSz Trd linRd rndRd linWr rndWr   linR/W    rndR/W
>
> <snip>
>
>> 1024k   1  78.4  34.1  33.5  24.6  19.6/19.5  16.0/12.7
>>         2        33.3        24.6             15.4/13.8
>>         4        34.3        25.0             14.7/15.0
>>
>
> <snip>
>
>> And second, so far I haven't seen a case where a drive
>> with NCQ/TCQ enabled works worse than without.  I don't
>> want to say there aren't such drives/controllers, but
>> it just happen that I haven't seen any.)
>
> Yes you have - the random writes with large blocks and 2 or 4 threads
> is significantly better for your non-NCQ drive; and getting more
> significant as you add more threads - I'm curious what happens
> on 8 threads or more.
>
> Dave
> -- 
> -----Open up your eyes, open up your mind, open up your code -------
> / Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \
> \ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
> \ _________________________|_____ http://www.treblig.org   |_______/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
