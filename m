Return-Path: <linux-kernel-owner+w=401wt.eu-S1161232AbXCNMra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161232AbXCNMra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161240AbXCNMra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:47:30 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:36571 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161232AbXCNMr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:47:29 -0400
Message-ID: <45F7EDC6.5090303@hitachi.com>
Date: Wed, 14 Mar 2007 21:42:46 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       nikita@clusterfs.com, leroy.vanlogchem@wldelft.nl
Subject: [PATCH 0/3] VM throttling: avoid blocking occasional writers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ported the patch sent before to 2.6.21-rc3-mm2, so I'm resending it.
( Previous patch is available at
  http://marc.info/?l=linux-kernel&m=117223267512340&w=2 )


-Summary:
I have observed a problem that write(2) can be blocked for a long time
if a system has several disks and is under heavy I/O pressure. This
patchset is to avoid the problem by introducing high/low water-mark
algorithm to balance_dirty_pages() function.

-Example of the probrem:

There are two processes on a system which has two disks. Process-A
writes heavily to disk-a, and process-B writes small data (e.g. log
files) to disk-b occasionally. A portion of system memory, which is
depends on vm.dirty_ratio (typically 40%), is filled up with Dirty
and Writeback pages of disk-a.

In this situation, write(2) of process-B could be blocked for a very
long time (more then 60 seconds), although the load of disk-b is quite
low. In particular, the system would become quite slow, if disk-a is
slow (e.g. backup to an USB disk).

This seems to be the same problem as discussed in LKML:
http://marc.theaimsgroup.com/?t=115559902900003
and
http://marc.theaimsgroup.com/?t=117182340400003

-Cause:

I found this problem is caused by the balance_dirty_pages().

While Dirty+Writeback pages get more than 40% of memory, process-B is
blocked in balance_dirty_pages() until writeback of some (`write_chunk',
typically = 1536) dirty pages on disk-b is started.

However, because disk-b has only a few dirty pages, the process-B will
be blocked until writeback to disk-a is completed and Dirty+Writeback
goes below 40%.

-Solution:

I consider that all of the dirty pages for the disk have been written
back and that the disk is clean if a process cannot write 'write_chunk'
pages in balance_dirty_pages().

To avoid using up the free memory with dirty pages by passing blocking,
this patchset adds a new threshold named vm.dirty_limit_ratio to sysctl.

It modifies balance_dirty_pages() not to block when the amount of
Dirty+Writeback is less than vm.dirty_limit_ratio percent of the memory.
In the other cases, writers are throttled as current Linux does.


In this patchset, vm.dirty_limit_ratio, instead of vm.dirty_ratio, is
used as the clamping level of Dirty+Writeback. And, vm.dirty_ratio is
used as the level at which a writers will itself start writeback of the
dirty pages.


-Testing Results:

In the situation explained in "Example of the problem" section, I
measured time of write(2)ing to disk-b.
The write was completed by 30ms or less under the kernel with this
patchset.

When nr_requests is set too high (e.g. 8192), Dirty+Writeback grows near
vm.dirty_limit_ratio(45% of system memory by defaults). In that case,
write(2) sometimes took about 1 second.


This patchset can be applied to 2.6.21-rc3-mm2.
It consists of 3 pieces:

1/3 - add a sysctl variable `vm.dirty_limit_ratio'
2/3 - modify get_dirty_limits() to return the limit of dirty pages.
3/3 - break out of balance_dirty_pages() loop if the disk doesn't have
      remaining dirty pages, if Dirty+Writeback < vm.dirty_limit_ratio.

-- 
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory


