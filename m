Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZCCJc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZCCJc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZCCJcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:32:16 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:57053 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZCCJcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dWHS3UXYm8lJVcZ4CkyNWyBBEQupcbEHwOZcd7uBs0wMkpLSbs5ESgwG7tX2GB3Qmu
         MiqOgZGpdRtmpejqEGXTpJciFziEWN5OaMqbVKrey3+GuBDeuTgKkilfHCUE4jxK1Lyn
         zcNrczwCRjx9tbKm19AmbqqqqcH9dN7FVP9tI=
Message-ID: <49ACF8FE.2020904@panasas.com>
Date: Tue, 03 Mar 2009 11:31:42 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Large amount of scsi-sgpool objects
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> 
> I am noticing that there are a lot of objects active after a few tens 
> minutes of running xfs_fsr.
> 
> $ slabtop
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> 818616 818616 100%    0.16K  34109       24    136436K sgpool-8
> 253692 253692 100%    0.62K  42282        6    169128K sgpool-32
>  52017  52016  99%    2.50K  17339        3    138712K sgpool-128
>  26220  26219  99%    0.31K   2185       12      8740K sgpool-16
>   8927   8574  96%    0.03K     79      113       316K size-32
> 

Looks like a leak, by failing to call scsi_release_buffers()
somehow. (Which was changed recently)

> $ uname -a
> Linux yaguchi 2.6.29-rc6-rt #1 SMP PREEMPT RT 2009-02-19 23:12:33 
> +0100 i686 athlon i386 GNU/Linux
> 

Did you have a chance to try exact same thing with vanilla 2.6.29-rc6?

try a bisect -- drivers/scsi/scsi_lib.c there should not be more then
a couple of patches

> What could be the problem that there are so many objects around and not 
> freed? 

Only one reason, failing to call scsi_release_buffers()

There should not be more then .can_queue sg-pool objects in flight
per disk. Which is rarely more then 255

This makes the system pretty much unusable after a while as it 
> runs towards a low-memory condition.
> 
> $ free
>              total       used       free     shared    buffers     cached
> Mem:        766592     758688       7904          0          0     137184
> -/+ buffers/cache:     621504     145088
> Swap:       795136         32     795104
> 
> 
> $ cat /proc/meminfo 
> MemTotal:         766592 kB
> MemFree:           79388 kB
> Buffers:               0 kB
> Cached:            62120 kB
> SwapCached:         1428 kB
> Active:            74472 kB
> Inactive:         113524 kB
> Active(anon):      58228 kB
> Inactive(anon):    69124 kB
> Active(file):      16244 kB
> Inactive(file):    44400 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> HighTotal:             0 kB
> HighFree:              0 kB
> LowTotal:         766592 kB
> LowFree:           79388 kB
> SwapTotal:        795136 kB
> SwapFree:         792404 kB
> Dirty:                 0 kB
> Writeback:             0 kB
> AnonPages:        124440 kB
> Mapped:            13672 kB
> Slab:             478576 kB
> SReclaimable:       5316 kB
> SUnreclaim:       473260 kB
> PageTables:         1220 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:     1178432 kB
> Committed_AS:   4294655912 kB
> VmallocTotal:     245816 kB
> VmallocUsed:       27404 kB
> VmallocChunk:     197108 kB
> HugePages_Total:       0
> HugePages_Free:        0
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> Hugepagesize:       4096 kB
> DirectMap4k:      696256 kB
> DirectMap4M:       90112 kB
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Please try some more tests, could it be a race that gets exposed in -rt?

Boaz
