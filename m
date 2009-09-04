Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZIDRgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZIDRgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZIDRgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:36:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbZIDRgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:36:49 -0400
Date: Fri, 4 Sep 2009 13:36:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       guijianfeng@cn.fujitsu.com
Subject: Re: [RFC] Improve CFQ fairness
Message-ID: <20090904173642.GA10880@redhat.com>
References: <1247425030-25344-1-git-send-email-vgoyal@redhat.com> <x491vmox8bn.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491vmox8bn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 01:10:52PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Hi,
> >
> > Sometimes fairness and throughput are orthogonal to each other. CFQ provides
> > fair access to disk to different processes in terms of disk time used by the
> > process.
> >
> > Currently above notion of fairness seems to be valid only for sync queues
> > whose think time is within slice_idle (8ms by default) limit.
> >
> > To boost throughput, CFQ disables idling based on seek patterns also. So even
> > if a sync queue's think time is with-in slice_idle limit, but this sync queue
> > is seeky, then CFQ will disable idling on hardware supporting NCQ.
> >
> > Above is fine from throughput perspective but not necessarily from fairness
> > perspective. In general CFQ seems to be inclined to favor throughput over
> > fairness.
> >
> > How about introducing a CFQ ioscheduler tunable "fairness" which if set, will
> > help CFQ to determine that user is interested in getting fairness right
> > and will disable some of the hooks geared towards throughput.
> >
> > Two patches in this series introduce the tunable "fairness" and also do not
> > disable the idling based on seek patterns if "fairness" is set.
> >
> > I ran four "dd" prio 0 BE class sequential readers on SATA disk.
> >
> > # Test script
> > ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile1
> > ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile2
> > ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile3
> > ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile4
> 
> > Normally one would expect that these processes should finish in almost similar
> > time but following are the results of one of the runs (results vary between runs).
> 
> Actually, what you've written above would run each dd in sequence.  I
> get the idea, though.
> 
> > 234179072 bytes (234 MB) copied, 6.0338 s, 38.8 MB/s
> > 234179072 bytes (234 MB) copied, 6.34077 s, 36.9 MB/s
> > 234179072 bytes (234 MB) copied, 8.4014 s, 27.9 MB/s
> > 234179072 bytes (234 MB) copied, 10.8469 s, 21.6 MB/s
> >
> > Different between first and last process finishing is almost 5 seconds (Out of
> > total 10 seconds duration). This seems to be too big a variance. 
> >
> > I ran the blktrace to find out what is happening, and it seems we are very
> > quick to disable idling based mean seek distance. Somehow initial 7-10 reads
> 
> I submitted a patch to fix that, so maybe this isn't a problem anymore?
> Here are my results, with fairness=0:

Hi Jeff,

I still seem to be getting the same behavior. I am using 2.6.31-rc7. I got
a SATA drive which supports command queuing with depth of 31.

Following are results of three runs.

234179072 bytes (234 MB) copied, 5.98348 s, 39.1 MB/s
234179072 bytes (234 MB) copied, 8.24508 s, 28.4 MB/s
234179072 bytes (234 MB) copied, 8.54762 s, 27.4 MB/s
234179072 bytes (234 MB) copied, 11.005 s, 21.3 MB/s

234179072 bytes (234 MB) copied, 5.51245 s, 42.5 MB/s
234179072 bytes (234 MB) copied, 5.62906 s, 41.6 MB/s
234179072 bytes (234 MB) copied, 9.44299 s, 24.8 MB/s
234179072 bytes (234 MB) copied, 10.9674 s, 21.4 MB/s

234179072 bytes (234 MB) copied, 5.50074 s, 42.6 MB/s
234179072 bytes (234 MB) copied, 5.62541 s, 41.6 MB/s
234179072 bytes (234 MB) copied, 8.63945 s, 27.1 MB/s
234179072 bytes (234 MB) copied, 10.9058 s, 21.5 MB/s

Thanks
Vivek

> 
> # cat test.sh
> #!/bin/bash
> 
> ionice -c 2 -n 0 dd if=/mnt/test/testfile1 of=/dev/null count=524288 &
> ionice -c 2 -n 0 dd if=/mnt/test/testfile2 of=/dev/null count=524288 &
> ionice -c 2 -n 0 dd if=/mnt/test/testfile3 of=/dev/null count=524288 &
> ionice -c 2 -n 0 dd if=/mnt/test/testfile4 of=/dev/null count=524288 &
> 
> wait
> 
> # bash test.sh
> 524288+0 records in
> 524288+0 records out
> 268435456 bytes (268 MB) copied, 10.3071 s, 26.0 MB/s
> 524288+0 records in
> 524288+0 records out
> 268435456 bytes (268 MB) copied, 10.3591 s, 25.9 MB/s
> 524288+0 records in
> 524288+0 records out
> 268435456 bytes (268 MB) copied, 10.4217 s, 25.8 MB/s
> 524288+0 records in
> 524288+0 records out
> 268435456 bytes (268 MB) copied, 10.4649 s, 25.7 MB/s
> 
> That looks pretty good to me.
> 
> Running a couple of fio workloads doesn't really show a difference
> between a vanilla kernel and a patched cfq with fairness set to 1:
> 
> Vanilla:
> 
> total priority: 800
> total data transferred: 887264
> class   prio    ideal   xferred %diff
> be      4       110908  124404  12
> be      4       110908  123380  11
> be      4       110908  118004  6
> be      4       110908  113396  2
> be      4       110908  107252  -4
> be      4       110908  98356   -12
> be      4       110908  96244   -14
> be      4       110908  106228  -5
> 
> Patched, with fairness set to 1:
> 
> total priority: 800
> total data transferred: 953312
> class   prio    ideal   xferred %diff
> be      4       119164  127028  6
> be      4       119164  128244  7
> be      4       119164  120564  1
> be      4       119164  127476  6
> be      4       119164  119284  0
> be      4       119164  116724  -3
> be      4       119164  103668  -14
> be      4       119164  110324  -8
> 
> So, can you still reproduce this on your setup?  I was just using a
> boring SATA disk.
> 
> Cheers,
> out
