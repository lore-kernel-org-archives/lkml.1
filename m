Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbZJMNIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbZJMNIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759578AbZJMNIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:08:12 -0400
Received: from fw.sj.tdf-pmm.net ([91.197.165.186]:52025 "EHLO
	mx.fr.smartjog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759442AbZJMNIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:08:11 -0400
Date: Tue, 13 Oct 2009 15:10:02 +0200
From: Laurent CORBES <laurent.corbes@smartjog.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Ext3 sequential read performance drop 2.6.29 ->
 2.6.30,2.6.31,...
Message-ID: <20091013151002.53efae58@smartjog.com>
In-Reply-To: <20091013120955.6bd5844b@smartjog.com>
References: <20091013120955.6bd5844b@smartjog.com>
Organization: SmartJog
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some updates and added linux-fsdevel in the loop:

> While benchmarking some systems I discover a big sequential read performance
> drop using ext3 on ~ big files. The drop seems to be introduced in 2.6.30. I'm
> testing with 2.6.28.6 -> 2.6.29.6 -> 2.6.30.4 -> 2.6.31.3.
> 
> I'm running a software raid6 (chunk 256k) on 6 750Go 7200rpm disks. here are
> the raw datas of disks and raid device:
> 
> $ dd if=/dev/sda of=/dev/null bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 98.7483 seconds, 109 MB/s
> 
> $ dd if=/dev/md7 of=/dev/null bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 34.8744 seconds, 308 MB/s
> 
> Over the different kernels changes here are not important (~1MB on the raw disk
> and ~5MB on the raid device). The write of a 10GB file over the fs here is also
> almost constant at ~100MB/s.
> 
> $ dd if=/dev/zero of=/mnt/space/benchtmp//dd.out bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 102.547 seconds, 105 MB/s
> 
> However while reading this file there is a huge perf drop between 2.6.29.6 and
> 2.6.30.4 and 2.6.31.3:

I add slabtop infos before and after the runs for 2.6.28.6 and 2.6.31.3. run is
just after a system reboot

 Active / Total Objects (% used)    : 83612 / 90199 (92.7%)
 Active / Total Slabs (% used)      : 4643 / 4643 (100.0%)
 Active / Total Caches (% used)     : 93 / 150 (62.0%)
 Active / Total Size (% used)       : 16989.63K / 17858.85K (95.1%)
 Minimum / Average / Maximum Object : 0.01K / 0.20K / 4096.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 20820  20688  99%    0.12K    694       30      2776K dentry
 12096  12029  99%    0.04K    144       84       576K sysfs_dir_cache
  8701   8523  97%    0.03K     77      113       308K size-32
  6036   6018  99%    0.32K    503       12      2012K inode_cache
  4757   4646  97%    0.05K     71       67       284K buffer_head
  4602   4254  92%    0.06K     78       59       312K size-64
  4256   4256 100%    0.47K    532        8      2128K ext3_inode_cache
  3864   3607  93%    0.08K     84       46       336K vm_area_struct
  2509   2509 100%    0.28K    193       13       772K radix_tree_node
  2130   1373  64%    0.12K     71       30       284K filp
  1962   1938  98%    0.41K    218        9       872K shmem_inode_cache
  1580   1580 100%    0.19K     79       20       316K skbuff_head_cache
  1524   1219  79%    0.01K      6      254        24K anon_vma
  1450   1450 100%    2.00K    725        2      2900K size-2048
  1432   1382  96%    0.50K    179        8       716K size-512
  1260   1198  95%    0.12K     42       30       168K size-128

> 2.6.28.6:
> sj-dev-7:/mnt/space/Benchmark# dd if=dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 43.8288 seconds, 245 MB/s

 Active / Total Objects (% used)    : 78853 / 90405 (87.2%)
 Active / Total Slabs (% used)      : 5079 / 5084 (99.9%)
 Active / Total Caches (% used)     : 93 / 150 (62.0%)
 Active / Total Size (% used)       : 17612.24K / 19391.84K (90.8%)
 Minimum / Average / Maximum Object : 0.01K / 0.21K / 4096.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 17589  17488  99%    0.28K   1353       13      5412K radix_tree_node
 12096  12029  99%    0.04K    144       84       576K sysfs_dir_cache
  9840   5659  57%    0.12K    328       30      1312K dentry
  8701   8568  98%    0.03K     77      113       308K size-32
  5226   4981  95%    0.05K     78       67       312K buffer_head
  4602   4366  94%    0.06K     78       59       312K size-64
  4264   4253  99%    0.47K    533        8      2132K ext3_inode_cache
  3726   3531  94%    0.08K     81       46       324K vm_area_struct
  2130   1364  64%    0.12K     71       30       284K filp
  1962   1938  98%    0.41K    218        9       872K shmem_inode_cache
  1580   1460  92%    0.19K     79       20       316K skbuff_head_cache
  1548   1406  90%    0.32K    129       12       516K inode_cache
  1524   1228  80%    0.01K      6      254        24K anon_vma
  1450   1424  98%    2.00K    725        2      2900K size-2048
  1432   1370  95%    0.50K    179        8       716K size-512
  1260   1202  95%    0.12K     42       30       168K size-128


> 2.6.29.6:
> sj-dev-7:/mnt/space/Benchmark# dd if=dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 42.745 seconds, 251 MB/s
> 
> 2.6.30.4:
> $ dd if=/mnt/space/benchtmp//dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 48.621 seconds, 221 MB/s


 Active / Total Objects (% used)    : 88438 / 97670 (90.5%)
 Active / Total Slabs (% used)      : 5451 / 5451 (100.0%)
 Active / Total Caches (% used)     : 93 / 155 (60.0%)
 Active / Total Size (% used)       : 19564.52K / 20948.54K (93.4%)
 Minimum / Average / Maximum Object : 0.01K / 0.21K / 4096.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 21547  21527  99%    0.13K    743       29      2972K dentry
 12684  12636  99%    0.04K    151       84       604K sysfs_dir_cache
  8927   8639  96%    0.03K     79      113       316K size-32
  6721   6720  99%    0.33K    611       11      2444K inode_cache
  4425   4007  90%    0.06K     75       59       300K size-64
  4240   4237  99%    0.48K    530        8      2120K ext3_inode_cache
  4154   4089  98%    0.05K     62       67       248K buffer_head
  3910   3574  91%    0.08K     85       46       340K vm_area_struct
  2483   2449  98%    0.28K    191       13       764K radix_tree_node
  2280   1330  58%    0.12K     76       30       304K filp
  2240   2132  95%    0.19K    112       20       448K skbuff_head_cache
  2198   2198 100%    2.00K   1099        2      4396K size-2048
  1935   1910  98%    0.43K    215        9       860K shmem_inode_cache
  1770   1738  98%    0.12K     59       30       236K size-96
  1524   1278  83%    0.01K      6      254        24K anon_vma
  1056    936  88%    0.50K    132        8       528K size-512

> 2.6.31.3:
> sj-dev-7:/mnt/space/Benchmark# dd if=dd.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 51.4148 seconds, 209 MB/s

 Active / Total Objects (% used)    : 81843 / 97478 (84.0%)
 Active / Total Slabs (% used)      : 5759 / 5763 (99.9%)
 Active / Total Caches (% used)     : 92 / 155 (59.4%)
 Active / Total Size (% used)       : 19486.81K / 22048.45K (88.4%)
 Minimum / Average / Maximum Object : 0.01K / 0.23K / 4096.00K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 17589  17426  99%    0.28K   1353       13      5412K radix_tree_node
 12684  12636  99%    0.04K    151       84       604K sysfs_dir_cache
 10991   6235  56%    0.13K    379       29      1516K dentry
  8927   8624  96%    0.03K     79      113       316K size-32
  4824   4819  99%    0.05K     72       67       288K buffer_head
  4425   3853  87%    0.06K     75       59       300K size-64
  3910   3527  90%    0.08K     85       46       340K vm_area_struct
  3560   3268  91%    0.48K    445        8      1780K ext3_inode_cache
  2288   1394  60%    0.33K    208       11       832K inode_cache
  2280   1236  54%    0.12K     76       30       304K filp
  2240   2183  97%    0.19K    112       20       448K skbuff_head_cache
  2216   2191  98%    2.00K   1108        2      4432K size-2048
  1935   1910  98%    0.43K    215        9       860K shmem_inode_cache
  1770   1719  97%    0.12K     59       30       236K size-96
  1524   1203  78%    0.01K      6      254        24K anon_vma
  1056    921  87%    0.50K    132        8       528K size-512


> ... Things going worst over time ...
> 
> Numbers are average over ~10 runs each.
> 
> I first check for stripe/stride aligment of the ext3 fs that is quite important
> in raid6. I recheck it and everything seems fine from my understandings and
> formula:
> raid6 chunk 256k -> stride = 64. 4 data disks -> stripe-width = 256 ?
> 
> In both case I'm using cfq IO scheduler and no special tuning is done with it.
> 
> 
> For informations the test server is a Dell PowerEdge R710 with SAS 6iR, 4GB
> ram and 6*750GB sata disks. I got the same behavior on PE2950 Perc6i, 2GB
> ram and 6*750GB sata disks. 
> 
> Here are misc informations about the setup:
> sj-dev-7:/mnt/space/Benchmark# cat /proc/mdstat 
> md7 : active raid6 sdf7[5] sde7[4] sdd7[3] sdc7[2] sdb7[1] sda7[0]
>       2923443200 blocks level 6, 256k chunk, algorithm 2 [6/6] [UUUUUU]
>       bitmap: 0/175 pages [0KB], 2048KB chunk
> 
> sj-dev-7:/mnt/space/Benchmark# dumpe2fs -h /dev/md7
> dumpe2fs 1.40-WIP (14-Nov-2006)
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem UUID:          9c29f236-e4f2-4db4-bf48-ea613cd0ebad
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal resize_inode dir_index filetype
> needs_recovery sparse_super large_file Filesystem flags:         signed
> directory hash Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              713760
> Block count:              730860800
> Reserved block count:     0
> Free blocks:              705211695
> Free inodes:              713655
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      849
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         32
> Inode blocks per group:   1
> Filesystem created:       Thu Oct  1 15:45:01 2009
> Last mount time:          Mon Oct 12 13:17:45 2009
> Last write time:          Mon Oct 12 13:17:45 2009
> Mount count:              10
> Maximum mount count:      30
> Last checked:             Thu Oct  1 15:45:01 2009
> Check interval:           15552000 (6 months)
> Next check after:         Tue Mar 30 15:45:01 2010
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               128
> Journal inode:            8
> Default directory hash:   tea
> Directory Hash Seed:      378d4fd2-23c9-487c-b635-5601585f0da7
> Journal backup:           inode blocks
> Journal size:             128M

Thanks all.
-- 
Laurent Corbes - laurent.corbes@smartjog.com
SmartJog SAS | Phone: +33 1 5868 6225 | Fax: +33 1 5868 6255 | www.smartjog.com
27 Blvd Hippolyte Marquès, 94200 Ivry-sur-Seine, France
A TDF Group company
