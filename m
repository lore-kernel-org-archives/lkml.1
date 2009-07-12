Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZGLS57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZGLS57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbZGLS5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:57:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60184 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbZGLS5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:57:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       vgoyal@redhat.com
Subject: [RFC] Improve CFQ fairness
Date: Sun, 12 Jul 2009 14:57:08 -0400
Message-Id: <1247425030-25344-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Sometimes fairness and throughput are orthogonal to each other. CFQ provides
fair access to disk to different processes in terms of disk time used by the
process.

Currently above notion of fairness seems to be valid only for sync queues
whose think time is within slice_idle (8ms by default) limit.

To boost throughput, CFQ disables idling based on seek patterns also. So even
if a sync queue's think time is with-in slice_idle limit, but this sync queue
is seeky, then CFQ will disable idling on hardware supporting NCQ.

Above is fine from throughput perspective but not necessarily from fairness
perspective. In general CFQ seems to be inclined to favor throughput over
fairness.

How about introducing a CFQ ioscheduler tunable "fairness" which if set, will
help CFQ to determine that user is interested in getting fairness right
and will disable some of the hooks geared towards throughput.

Two patches in this series introduce the tunable "fairness" and also do not
disable the idling based on seek patterns if "fairness" is set.

I ran four "dd" prio 0 BE class sequential readers on SATA disk.

# Test script
ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile1
ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile2
ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile3
ionice -c 2 -n 0 dd if=/mnt/sdb/zerofile4
 
Normally one would expect that these processes should finish in almost similar
time but following are the results of one of the runs (results vary between runs).

234179072 bytes (234 MB) copied, 6.0338 s, 38.8 MB/s
234179072 bytes (234 MB) copied, 6.34077 s, 36.9 MB/s
234179072 bytes (234 MB) copied, 8.4014 s, 27.9 MB/s
234179072 bytes (234 MB) copied, 10.8469 s, 21.6 MB/s

Different between first and last process finishing is almost 5 seconds (Out of
total 10 seconds duration). This seems to be too big a variance. 

I ran the blktrace to find out what is happening, and it seems we are very
quick to disable idling based mean seek distance. Somehow initial 7-10 reads
seem to be seeky for these dd processes. After that things stablize and we
enable back the idling. But some of the processes get idling enabled early
and some get it enabled really late and that leads to discrepancy in results.

With this patchset applied, following are the results for above test case.

echo 1  > /sys/block/sdb/queue/iosched/fairness

234179072 bytes (234 MB) copied, 9.88874 s, 23.7 MB/s
234179072 bytes (234 MB) copied, 10.0234 s, 23.4 MB/s
234179072 bytes (234 MB) copied, 10.1747 s, 23.0 MB/s
234179072 bytes (234 MB) copied, 10.4844 s, 22.3 MB/s

Notice, how close the finish time and effective bandwidth are for all the
four processes. Also notice that I did not witness any throughput degradation
at least for this particular test case.

Thanks
Vivek
