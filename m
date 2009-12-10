Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbZLJHeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbZLJHeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbZLJHeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:34:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44148 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760548AbZLJHeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:34:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 10 Dec 2009 16:31:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: [RFC mm][PATCH 0/5] per mm counter updates
Message-Id: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better OOM handling and statistics per process, I'd like to add new
counters in mm_struct, counter for swap entries and lowmem usage.

But, simply adding new counter makes page fault path fat and adds more cache
misses. So, before going further, it's better to modify per-mm counter itself.

This is an updated version of percpu cached mm counter.

Main changes from previous one is:
  - If no page faults, no sync at scheduler.
  - removed synchronization at tick.
  - added SWAPENTS counter.
  - added lowmem_rss counter.

(I added Ingo to CC: because this patch has hooks for schedule(), tell me
 if you finds concern in patch [2/5]...)

In general, maintaining a shared counter without frequent atomic_ops can be done
in following ways.
 (1) use simple percpu counter. and calculates sum of it at read.
 (2) use cached percpu counter and make some invalidation/synchronization points.

because read cost of this per mm counter is important, this set uses (2).
And synchronziation points is in schedule().

Scheule() is a good point for synchronize per-process per-cpu cached information.
I wanted to avoid adds hooks to schedule() but 
  - Hadnling all per-cpu cache handling requires complicated refcnt handling.
  - taskacct requires full-synchronization of cached counter information.
    IPI at each task exit()? it's silly.

Follwoing is the cost of this patches. On 2 socket x86-64 hosts.
Measured the number of pagefaults caused by 2 threads in 60secs.
One thread per one socket. (test program will follow this mail.)
This patch set is only for SPLIT_PTLOCK=y case.

[Before] (mmotom-2.6.32-Dec8)
 Performance counter stats for './multi-fault 2' (5 runs):

       45122351  page-faults                ( +-   1.125% )
      989608571  cache-references           ( +-   1.198% )
      205308558  cache-misses               ( +-   0.159% )
 29263096648639268  bus-cycles                 ( +-   0.004% )

   60.003427500  seconds time elapsed   ( +-   0.003% )

4.55 miss/faults

[After patch 2/5] (percpu cached counter)
Performance counter stats for './multi-fault 2' (5 runs):

       46997471  page-faults                ( +-   0.720% )
     1004100076  cache-references           ( +-   0.734% )
      180959964  cache-misses               ( +-   0.374% )
 29263437363580464  bus-cycles                 ( +-   0.002% )

   60.003315683  seconds time elapsed   ( +-   0.004% )

3.85 miss/faults

[After patch 5/5] (adds 2 more coutners..swapents and lowmem)
 Performance counter stats for './multi-fault 2' (5 runs):

       45976947  page-faults                ( +-   0.405% )
      992296954  cache-references           ( +-   0.860% )
      183961537  cache-misses               ( +-   0.473% )
 29261902069414016  bus-cycles                 ( +-   0.002% )

   60.001403261  seconds time elapsed   ( +-   0.000% )

4.0 miss/faults.


Just for curious, this is the result when SPLIT_PTLOCKS is not enabled.

Performance counter stats for './multi-fault 2' (5 runs):

       20329544  page-faults                ( +-   0.795% )
     1041624126  cache-references           ( +-   1.153% )
      160983634  cache-misses               ( +-   3.188% )
 29217349673892936  bus-cycles                 ( +-   0.035% )

   60.004098210  seconds time elapsed   ( +-   0.003% )

Too bad ;(

(Off topic) Why SPLIT_PTLOCKS is disabled if DEBUG_SPINLOCK=y ?

Thanks,
-Kame





