Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZICRLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZICRLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZICRLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:11:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbZICRLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:11:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       guijianfeng@cn.fujitsu.com
Subject: Re: [RFC] Improve CFQ fairness
References: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 Sep 2009 13:10:52 -0400
In-Reply-To: <1247425030-25344-1-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Sun, 12 Jul 2009 14:57:08 -0400")
Message-ID: <x491vmox8bn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Hi,
>
> Sometimes fairness and throughput are orthogonal to each other. CFQ provides
> fair access to disk to different processes in terms of disk time used by the
> process.
>
> Currently above notion of fairness seems to be valid only for sync queues
> whose think time is within slice_idle (8ms by default) limit.
>
> To boost throughput, CFQ disables idling based on seek patterns also. So even
> if a sync queue's think time is with-in slice_idle limit, but this sync queue
> is seeky, then CFQ will disable idling on hardware supporting NCQ.
>
> Above is fine from throughput perspective but not necessarily from fairness
> perspective. In general CFQ seems to be inclined to favor throughput over
> fairness.
>
> How about introducing a CFQ ioscheduler tunable "fairness" which if set, will
> help CFQ to determine that user is interested in getting fairness right
> and will disable some of the hooks geared towards throughput.
>
> Two patches in this series introduce the tunable "fairness" and also do not
> disable the idling based on seek patterns if "fairness" is set.
>
> I ran four "dd" prio 0 BE class sequential readers on SATA disk.
>
> # Test script
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile1
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile2
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile3
> ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile4

> Normally one would expect that these processes should finish in almost similar
> time but following are the results of one of the runs (results vary between runs).

Actually, what you've written above would run each dd in sequence.  I
get the idea, though.

> 234179072 bytes (234 MB) copied, 6.0338 s, 38.8 MB/s
> 234179072 bytes (234 MB) copied, 6.34077 s, 36.9 MB/s
> 234179072 bytes (234 MB) copied, 8.4014 s, 27.9 MB/s
> 234179072 bytes (234 MB) copied, 10.8469 s, 21.6 MB/s
>
> Different between first and last process finishing is almost 5 seconds (Out of
> total 10 seconds duration). This seems to be too big a variance. 
>
> I ran the blktrace to find out what is happening, and it seems we are very
> quick to disable idling based mean seek distance. Somehow initial 7-10 reads

I submitted a patch to fix that, so maybe this isn't a problem anymore?
Here are my results, with fairness=0:

# cat test.sh
#!/bin/bash

ionice -c 2 -n 0 dd if=/mnt/test/testfile1 of=/dev/null count=524288 &
ionice -c 2 -n 0 dd if=/mnt/test/testfile2 of=/dev/null count=524288 &
ionice -c 2 -n 0 dd if=/mnt/test/testfile3 of=/dev/null count=524288 &
ionice -c 2 -n 0 dd if=/mnt/test/testfile4 of=/dev/null count=524288 &

wait

# bash test.sh
524288+0 records in
524288+0 records out
268435456 bytes (268 MB) copied, 10.3071 s, 26.0 MB/s
524288+0 records in
524288+0 records out
268435456 bytes (268 MB) copied, 10.3591 s, 25.9 MB/s
524288+0 records in
524288+0 records out
268435456 bytes (268 MB) copied, 10.4217 s, 25.8 MB/s
524288+0 records in
524288+0 records out
268435456 bytes (268 MB) copied, 10.4649 s, 25.7 MB/s

That looks pretty good to me.

Running a couple of fio workloads doesn't really show a difference
between a vanilla kernel and a patched cfq with fairness set to 1:

Vanilla:

total priority: 800
total data transferred: 887264
class   prio    ideal   xferred %diff
be      4       110908  124404  12
be      4       110908  123380  11
be      4       110908  118004  6
be      4       110908  113396  2
be      4       110908  107252  -4
be      4       110908  98356   -12
be      4       110908  96244   -14
be      4       110908  106228  -5

Patched, with fairness set to 1:

total priority: 800
total data transferred: 953312
class   prio    ideal   xferred %diff
be      4       119164  127028  6
be      4       119164  128244  7
be      4       119164  120564  1
be      4       119164  127476  6
be      4       119164  119284  0
be      4       119164  116724  -3
be      4       119164  103668  -14
be      4       119164  110324  -8

So, can you still reproduce this on your setup?  I was just using a
boring SATA disk.

Cheers,
Jeff
