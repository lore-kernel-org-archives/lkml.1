Return-Path: <linux-kernel-owner+w=401wt.eu-S1762631AbXLMQSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762631AbXLMQSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbXLMQSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:18:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXLMQSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:18:31 -0500
Message-ID: <47615B13.4070100@redhat.com>
Date: Thu, 13 Dec 2007 17:17:23 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [Patch 0/8] Enhanced partition statistics
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Between 2.4 and 2.6, some I/O statistic informations concerning partitions disappeared as a result of earlier merging of requests. As a consequence, less statistics are available for partitions than for disks in sysfs and /proc/diskstats. This batch of patches brings back the lost statistics.

Here is basically how it works. Each time a disk statistic is updated, we find out the relevant partition (if any), i.e. the one containing the first sector of the request and update the partition statistics at the same time.

Since requests may be merged across partitions, some requests can not be attributed accurately to a partition. When this happen, the request is attributed entirely to the partition containing the first sector of the request. However, I don't think this inaccuracy can be significant in a real world workload and current I/O statistics are already not exact anyway. 

These patches change the /proc/diskstats and /sys/block/_disk_/_part_/stat files, but iostat seems to be already able to deal with the new format and partition statistics reappears in 'iostat -x' output. Here is how it looks without enhanced partition statistics:
[root@test3 ~]# cat /proc/diskstats
   1    0 ram0 0 0 0 0 0 0 0 0 0 0 0
   1    1 ram1 0 0 0 0 0 0 0 0 0 0 0
   1    2 ram2 0 0 0 0 0 0 0 0 0 0 0
   1    3 ram3 0 0 0 0 0 0 0 0 0 0 0
   1    4 ram4 0 0 0 0 0 0 0 0 0 0 0
   1    5 ram5 0 0 0 0 0 0 0 0 0 0 0
   1    6 ram6 0 0 0 0 0 0 0 0 0 0 0
   1    7 ram7 0 0 0 0 0 0 0 0 0 0 0
   1    8 ram8 0 0 0 0 0 0 0 0 0 0 0
   1    9 ram9 0 0 0 0 0 0 0 0 0 0 0
   1   10 ram10 0 0 0 0 0 0 0 0 0 0 0
   1   11 ram11 0 0 0 0 0 0 0 0 0 0 0
   1   12 ram12 0 0 0 0 0 0 0 0 0 0 0
   1   13 ram13 0 0 0 0 0 0 0 0 0 0 0
   1   14 ram14 0 0 0 0 0 0 0 0 0 0 0
   1   15 ram15 0 0 0 0 0 0 0 0 0 0 0
   8    0 sda 3023 5039 294452 23467 1714 1859 28572 23042 0 15499 46509
   8    1 sda1 980 1966 2 4
   8    2 sda2 7044 292182 3571 28568
   8   16 sdb 0 0 0 0 0 0 0 0 0 0 0
 253    0 dm-0 6793 0 290738 57403 3571 0 28568 50665 0 15286 108068
 253    1 dm-1 110 0 880 473 0 0 0 0 0 38 473
   3    0 hda 0 0 0 0 0 0 0 0 0 0 0
  11    0 sr0 0 0 0 0 0 0 0 0 0 0 0
   9    0 md0 0 0 0 0 0 0 0 0 0 0 0

[root@test3 ~]# iostat -x
Linux 2.6.18-57.el5.kabi (test3.xxx.redhat.com)  12/12/2007

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.16    0.00    0.81    2.97    0.00   95.06

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sda              19.95     7.36 11.98  6.78  1165.85   113.09    68.15     0.18    9.81   3.27   6.14
dm-0              0.00     0.00 26.90 14.13  1151.15   113.08    30.81     0.43   10.43   1.48   6.06
dm-1              0.00     0.00  0.44  0.00     3.48     0.00     8.00     0.00    4.30   0.35   0.02


And now with enhanced partition statistics:
[root@test3 ~]# cat /proc/diskstats
   1    0 ram0 0 0 0 0 0 0 0 0 0 0 0
   1    1 ram1 0 0 0 0 0 0 0 0 0 0 0
   1    2 ram2 0 0 0 0 0 0 0 0 0 0 0
   1    3 ram3 0 0 0 0 0 0 0 0 0 0 0
   1    4 ram4 0 0 0 0 0 0 0 0 0 0 0
   1    5 ram5 0 0 0 0 0 0 0 0 0 0 0
   1    6 ram6 0 0 0 0 0 0 0 0 0 0 0
   1    7 ram7 0 0 0 0 0 0 0 0 0 0 0
   1    8 ram8 0 0 0 0 0 0 0 0 0 0 0
   1    9 ram9 0 0 0 0 0 0 0 0 0 0 0
   1   10 ram10 0 0 0 0 0 0 0 0 0 0 0
   1   11 ram11 0 0 0 0 0 0 0 0 0 0 0
   1   12 ram12 0 0 0 0 0 0 0 0 0 0 0
   1   13 ram13 0 0 0 0 0 0 0 0 0 0 0
   1   14 ram14 0 0 0 0 0 0 0 0 0 0 0
   1   15 ram15 0 0 0 0 0 0 0 0 0 0 0
   8    0 sda 5939 5653 410132 37817 2293 3006 42396 55473 0 19357 93286
   8    1 sda1 98 942 2130 138 2 0 4 15 0 109 153
   8    2 sda2 5822 4693 407706 37625 2291 3006 42392 55458 0 19238 93079
   8   16 sdb 0 0 0 0 0 0 0 0 0 0 0
 253    0 dm-0 10325 0 406658 73792 5299 0 42392 126679 0 19155 200470
 253    1 dm-1 70 0 560 414 0 0 0 0 0 28 414
   3    0 hda 0 0 0 0 0 0 0 0 0 0 0
  11    0 sr0 0 0 0 0 0 0 0 0 0 0 0
   9    0 md0 0 0 0 0 0 0 0 0 0 0 0

[root@test3 ~]# iostat -x
Linux 2.6.24-rc3 (test3.xxx.redhat.com)  12/12/2007

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.20    0.00    1.24    5.13    0.00   91.43

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %u
sda              31.00    16.49 32.57 12.58  2249.39   232.52    54.97     0.51   11.33   2.35  10
sda1              5.17     0.00  0.54  0.01    11.68     0.02    21.34     0.00    1.53   1.09   0
sda2             25.74    16.49 31.93 12.57  2236.09   232.50    55.48     0.51   11.47   2.37  10
dm-0              0.00     0.00 56.63 29.06  2230.34   232.50    28.74     1.10   12.83   1.23  10
dm-1              0.00     0.00  0.38  0.00     3.07     0.00     8.00     0.00    5.91   0.40   0


I also have tested these patches with dbench and iozone with no measurable loss of performance.

Regards,
Jérôme Marchand

