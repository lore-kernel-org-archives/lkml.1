Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXI1Gcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXI1Gcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXI1Gcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:32:39 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:36720 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbXI1Gci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bPsGUKlNlUoL9ffgTfnlVlUi20SKNNy+GMiNkHPKjAI2W28E4MeoBB5+D47t0ppyffKYmn1sSGC548TGxyKmrWv/nQJPUSPi3Ea1NJo+FbuizLv5+MuP9PYiAtFMWKdu2YU+5XecbwWnXPI7Wy7icI6Eo9tLLqKl/Ha07+H+I9c=
Message-ID: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
Date: Thu, 27 Sep 2007 23:32:36 -0700
From: "Chakri n" <chakriin5@gmail.com>
To: akpm@linux-foundation.org, linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In my testing, a unresponsive file system can hang all I/O in the system.
This is not seen in 2.4.

I started 20 threads doing I/O on a NFS share. They are just doing 4K
writes in a loop.

Now I stop NFS server hosting the NFS share and start a
"dd" process to write a file on local EXT3 file system.

# dd if=/dev/zero of=/tmp/x count=1000

This process never progresses.
There is plenty of HIGH MEMORY available in the system, but this
process never progresses.

# free
                        total       used          free
shared    buffers     cached
Mem:       3238004     609340    2628664          0              15136
    551024
-/+ buffers/cache:      43180    3194824
Swap:      4096532          0    4096532

vmstat on the machine:
# vmstat
procs -----------memory---------- ---swap-- -----io---- --system--
-----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0 21      0 2628416  15152 551024    0    0     0     0   28  344  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  340  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0   26  343  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  341  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0   26  357  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  325  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0   26  343  0
0  0 100  0
 0 21      0 2628416  15152 551024    0    0     0     0    8  325  0
0  0 100  0

The problem seems to be in balance_dirty_pages, which calculates
dirty_thresh based on only ZONE_NORMAL. The same scenario works fine
in 2.4. The dd processes finishes in no time.
NFS file systems can go offline, due to multiple reasons, a failed
switch, filer etc, but that should not effect other file systems in
the machine.
Can this behavior be fenced?, can the buffer cache be tuned so that
other processes do not see the effect?

The following is the back trace of the processes:
--------------------------------------
PID: 3552   TASK: cb1fc610  CPU: 0   COMMAND: "dd"
 #0 [f5c04c38] schedule at c0624a34
 #1 [f5c04cac] schedule_timeout at c06250ee
 #2 [f5c04cf0] io_schedule_timeout at c0624c15
 #3 [f5c04d04] congestion_wait at c045eb7d
 #4 [f5c04d28] balance_dirty_pages_ratelimited_nr at c045ab91
 #5 [f5c04d7c] generic_file_buffered_write at c0457148
 #6 [f5c04e10] __generic_file_aio_write_nolock at c04576e5
 #7 [f5c04e84] generic_file_aio_write at c0457799
 #8 [f5c04eb4] ext3_file_write at f8888fd7
 #9 [f5c04ed0] do_sync_write at c0472e27
#10 [f5c04f7c] vfs_write at c0473689
#11 [f5c04f98] sys_write at c0473c95
#12 [f5c04fb4] sysenter_entry at c0404ddf
------------------------------------------
PID: 3091  TASK: cb1f0100 CPU: 1   COMMAND: "test"
 #0 [f6050c10] schedule at c0624a34
 #1 [f6050c84] schedule_timeout at c06250ee
 #2 [f6050cc8] io_schedule_timeout at c0624c15
 #3 [f6050cdc] congestion_wait at c045eb7d
 #4 [f6050d00] balance_dirty_pages_ratelimited_nr at c045ab91
 #5 [f6050d54] generic_file_buffered_write at c0457148
 #6 [f6050de8] __generic_file_aio_write_nolock at c04576e5
 #7 [f6050e40] enqueue_entity at c042131f
 #8 [f6050e5c] generic_file_aio_write at c0457799
 #9 [f6050e8c] nfs_file_write at f8f90cee
#10 [f6050e9c] getnstimeofday at c043d3f7
#11 [f6050ed0] do_sync_write at c0472e27
#12 [f6050f7c] vfs_write at c0473689
#13 [f6050f98] sys_write at c0473c95
#14 [f6050fb4] sysenter_entry at c0404ddf

Thanks
--Chakri
