Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbYLEFax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbYLEFax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 00:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYLEFap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 00:30:45 -0500
Received: from po-out-1718.google.com ([72.14.252.154]:44435 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYLEFao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 00:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=XeXM9QG4wcQ5aP1z4SBLQoDVrWDp5SXdbOPwWW8JtA7p684l/hEsihXyiWu5GiqiPm
         +4Lf4ejdX+/Dq+t4i7t2fnaxAOK+VIKZ1eU+GTFB/iIcp/yO9ShnewEliGODlEiCXrDB
         2+YGKd/EYx32VMlVEAWqPL3nGLo614DdrGTd4=
Message-ID: <50fb67e90812042130m6274fb9bv110495a3a98ccb03@mail.gmail.com>
Date: Fri, 5 Dec 2008 11:00:19 +0530
From: "Srinivasan Jayarajan" <srinivasan.jayarajan.lnxkrnl@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Controlling use of page cache for usb-storage disk access in a MIPS based embedded system
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

  I have Linux 2.6.16-17 running on a MIPS development board. The
board also has an usb port. I also have samba 3.0.28a running on the
platform, which is used to share usb-storage disk partitions. The
system does not have any swap partition and after a cold reboot, the
system has about 154MB free

cat /proc/meminfo
MemTotal: 404768 kB
MemFree: 153508 kB
Buffers: 80 kB
Cached: 136464 kB
SwapCached: 0 kB
Active: 123828 kB
Inactive: 82316 kB
HighTotal: 163712 kB
HighFree: 376 kB
LowTotal: 241056 kB
LowFree: 153132 kB
SwapTotal: 0 kB
SwapFree: 0 kB
Dirty: 0 kB
Writeback: 0 kB
Mapped: 98996 kB
Slab: 25364 kB
CommitLimit: 202384 kB
Committed_AS: 235796 kB
PageTables: 2512 kB
VmallocTotal: 1015800 kB
VmallocUsed: 8060 kB
VmallocChunk: 1007568 kB

I have also tweaked the /proc/sys/vm entries as follows to limit the
use of page cache

/proc/sys/vm/dirty_background_ratio = 2
/proc/sys/vm/dirty_ratio = 5
/proc/sys/vm/dirty_expire_centisecs = 1000
/proc/sys/vm/vfs_cache_pressure = 10000

The moment I try to copy a huge file (about 1GB), the cached page
count goes up and eats away about 100MB in spite of the above vm
tweaks. In some cases, the system runs out of memory and OOM kicks in.

MemTotal: 404768 kB
MemFree: 10512 kB
Buffers: 1208 kB
Cached: 274260 kB
SwapCached: 0 kB
Active: 126472 kB
Inactive: 219632 kB
HighTotal: 163712 kB
HighFree: 376 kB
LowTotal: 241056 kB
LowFree: 10136 kB
SwapTotal: 0 kB
SwapFree: 0 kB
Dirty: 16200 kB
Writeback: 0 kB
Mapped: 101500 kB
Slab: 28176 kB
CommitLimit: 202384 kB
Committed_AS: 240220 kB
PageTables: 2596 kB
VmallocTotal: 1015800 kB
VmallocUsed: 8060 kB
VmallocChunk: 1007568 kB

I even tried copying a file from one folder to another from shell
using dd with the direct flag

dd oflag=direct if=/mnt/usb/test.avi of=/mnt/usb/copy/test.avi

The copy was very slow with the following results

1638660+0 records in
1638660+0 records out
838993920 bytes (839 MB) copied, 1827.17 s, 459 kB/s

But the page cache still ate quite a lot of memory close to 100MB, but
the growth in page cache was much slow. I would like to cap the use of
page cache to a hard limit of say about

Cached: 179200 kB. Is this possible and is it safe?


Thanks,

Srini
