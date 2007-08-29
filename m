Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbXH2O3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbXH2O3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXH2O3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:29:23 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:55270 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXH2O3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:29:22 -0400
Date: Wed, 29 Aug 2007 08:27:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Understanding I/O behaviour - next try
In-reply-to: <fa.NN9klzYbZhoZ+YoOWgrMeLtzlHE@ifi.uio.no>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Martin Knoblauch <spamtrap@knobisoft.de>, linux-kernel@vger.kernel.org,
       Peter zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com
Message-id: <46D58264.6050403@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.tV0SjP5wHRgCEzqJw2C8w4+Fh90@ifi.uio.no>
 <fa.NN9klzYbZhoZ+YoOWgrMeLtzlHE@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Aug 28 2007, Martin Knoblauch wrote:
>> Keywords: I/O, bdi-v9, cfs
>>
>> Hi,
>>
>>  a while ago I asked a few questions on the Linux I/O behaviour,
>> because I were (still am) fighting some "misbehaviour" related to heavy
>> I/O.
>>
>>  The basic setup is a dual x86_64 box with 8 GB of memory. The DL380
>> has a HW RAID5, made from 4x72GB disks and about 100 MB write cache.
>> The performance of the block device with O_DIRECT is about 90 MB/sec.
>>
>>  The problematic behaviour comes when we are moving large files through
>> the system. The file usage in this case is mostly "use once" or
>> streaming. As soon as the amount of file data is larger than 7.5 GB, we
>> see occasional unresponsiveness of the system (e.g. no more ssh
>> connections into the box) of more than 1 or 2 minutes (!) duration
>> (kernels up to 2.6.19). Load goes up, mainly due to pdflush threads and
>> some other poor guys being in "D" state.
>>
>>  The data flows in basically three modes. All of them are affected:
>>
>> local-disk -> NFS
>> NFS -> local-disk
>> NFS -> NFS
>>
>>  NFS is V3/TCP.
>>
>>  So, I made a few experiments in the last few days, using three
>> different kernels: 2.6.22.5, 2.6.22.5+cfs20.4 an 2.6.22.5+bdi-v9.
>>
>>  The first observation (independent of the kernel) is that we *should*
>> use O_DIRECT, at least for output to the local disk. Here we see about
>> 90 MB/sec write performance. A simple "dd" using 1,2 and 3 parallel
>> threads to the same block device (through a ext2 FS) gives:
>>
>> O_Direct: 88 MB/s, 2x44, 3x29.5
>> non-O_DIRECT: 51 MB/s, 2x19, 3x12.5
>>
>> - Observation 1a: IO schedulers are mostly equivalent, with CFQ
>> slightly worse than AS and DEADLINE
>> - Observation 1b: when using a 2.6.22.5+cfs20.4, the non-O_DIRECT
>> performance goes [slightly] down. With three threads it is 3x10 MB/s.
>> Ingo?
>> - Observation 1c: bdi-v9 does not help in this case, which is not
>> surprising.
>>
>>  The real question here is why the non-O_DIRECT case is so slow. Is
>> this a general thing? Is this related to the CCISS controller? Using
>> O_DIRECT is unfortunatelly not an option for us.
>>
>>  When using three different targets (local disk plus two different NFS
>> Filesystems) bdi-v9 is a big winner. Without it, all threads are [seem
>> to be] limited to the speed of the slowest FS. With bdi-v9 we see a
>> considerable speedup.
>>
>>  Just by chance I found out that doing all I/O inc sync-mode does
>> prevent the load from going up. Of course, I/O throughput is not
>> stellar (but not much worse than the non-O_DIRECT case). But the
>> responsiveness seem OK. Maybe a solution, as this can be controlled via
>> mount (would be great for O_DIRECT :-).
>>
>>  In general 2.6.22 seems to bee better that 2.6.19, but this is highly
>> subjective :-( I am using the following setting in /proc. They seem to
>> provide the smoothest responsiveness:
>>
>> vm.dirty_background_ratio = 1
>> vm.dirty_ratio = 1
>> vm.swappiness = 1
>> vm.vfs_cache_pressure = 1
>>
>>  Another thing I saw during my tests is that when writing to NFS, the
>> "dirty" or "nr_dirty" numbers are always 0. Is this a conceptual thing,
>> or a bug?
>>
>>  In any case, view this as a report for one specific loadcase that does
>> not behave very well. It seems there are ways to make things better
>> (sync, per device throttling, ...), but nothing "perfect yet. Use once
>> does seem to be a problem.
> 
> Try limiting the queue depth on the cciss device, some of those are
> notoriously bad at starving commands. Something like the below hack, see
> if it makes a difference (and please verify in dmesg that it prints the
> message about limiting depth!):

I saw a bulletin from HP recently that sugggested disabling the 
write-back cache on some Smart Array controllers as a workaround because 
it reduced performance in applications that did large bulk writes. 
Presumably they are planning on releasing some updated firmware that 
fixes this eventually..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

