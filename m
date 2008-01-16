Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbYAPGSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbYAPGSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 01:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYAPGSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 01:18:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42770 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbYAPGSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 01:18:16 -0500
Date: Wed, 16 Jan 2008 15:17:36 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: rvr split LRU minor regression ?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080108205939.323955454@redhat.com>
References: <20080108205939.323955454@redhat.com>
Message-Id: <20080116144826.11C0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik

I tested new hackbench on rvr split LRU patch.

new hackbench URL is
   http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c


method of test

(1) $ ./hackbench 150 process 1000
(2) # sync; echo 3 > /proc/sys/vm/drop_caches
    $ dd if=tmp10G of=/dev/null
    $ ./hackbench 150 process 1000

test machine:
  CPU:    x86_64 1.86GHz x2
  memory: 6GB


result:

         2.6.24-rc6-mm1      +rvr-split-lru      ratio
                                                (small is faster)
-------------------------------------------------------------------
(1)      364.981             359.386            98.47%
(2)      364.461             387.471           106.31%


more detail:
1. /usr/bin/time command output

vanilla 2.6.24-rc6-mm1
	33.74user 703.10system 6:09.56elapsed 199%CPU (0avgtext+0avgdata 0maxresident)k
	0inputs+0outputs (0major+372467minor)pagefaults 0swaps

2.6.24-rc6-mm1 + rvr-split-lru
	36.22user 731.30system 6:35.16elapsed 194%CPU (0avgtext+0avgdata 0maxresident)k
	0inputs+0outputs (804major+389524minor)pagefaults 0swaps

It seems increase page fault.


2.
after test (2), cat /proc/meminfo

vanilla 2.6.24-rc6-mm1

	MemTotal:      5931808 kB
	MemFree:       1751632 kB
	Buffers:          4360 kB
	Cached:        3930020 kB
	SwapCached:          0 kB
	Active:          46396 kB
	Inactive:      3924108 kB
	SwapTotal:    20972848 kB
	SwapFree:     20972720 kB
	Dirty:               0 kB
	Writeback:           0 kB
	AnonPages:       36140 kB
	Mapped:          10104 kB
	Slab:           160020 kB
	SReclaimable:     3460 kB
	SUnreclaim:     156560 kB
	PageTables:       3712 kB
	NFS_Unstable:        0 kB
	Bounce:              0 kB
	CommitLimit:  23938752 kB
	Committed_AS:    78940 kB
	VmallocTotal: 34359738367 kB
	VmallocUsed:     57220 kB
	VmallocChunk: 34359680999 kB
	HugePages_Total:     0
	HugePages_Free:      0
	HugePages_Rsvd:      0
	HugePages_Surp:      0
	Hugepagesize:     2048 kB


2.6.24-rc6-mm1 + rvr-split-lru

	MemTotal:        5931356 kB
	MemFree:         1771800 kB
	Buffers:            2776 kB
	Cached:          3914800 kB
	SwapCached:         7940 kB
	Active(anon):      21868 kB
	Inactive(anon):     6560 kB
	Active(file):    1722888 kB
	Inactive(file):  2192128 kB
	Noreclaim:        3472 kB
	Mlocked:          3724 kB
	SwapTotal:      20972848 kB
	SwapFree:       20935032 kB
	Dirty:                 8 kB
	Writeback:             0 kB
	AnonPages:         23912 kB
	Mapped:             9500 kB
	Slab:             162188 kB
	SReclaimable:       5544 kB
	SUnreclaim:       156644 kB
	PageTables:         4444 kB
	NFS_Unstable:          0 kB
	Bounce:                0 kB
	CommitLimit:    23938524 kB
	Committed_AS:     106816 kB
	VmallocTotal:   34359738367 kB
	VmallocUsed:       57220 kB
	VmallocChunk:   34359680999 kB
	HugePages_Total:     0
	HugePages_Free:      0
	HugePages_Rsvd:      0
	HugePages_Surp:      0
	Hugepagesize:     2048 kB


It seems used once memory incorrect activation increased.
What do you think it?



- kosaki


