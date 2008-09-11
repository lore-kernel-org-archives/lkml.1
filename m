Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYIKLIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYIKLIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYIKLH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:07:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48528 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYIKLH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:07:58 -0400
Date: Thu, 11 Sep 2008 20:08:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: kamezawa.hiroyu@jp.fujitsu.com, "xemul@openvz.org" <xemul@openvz.org>,
       "hugh@veritas.com" <hugh@veritas.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: [RFC] [PATCH 0/9]  remove page_cgroup pointer (with some
 enhancements)
Message-Id: <20080911200855.94d33d3b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Balbir.

I wrote remove-page-cgroup-pointer patch on top of my small patches.
This series includes enhancements patches for memory resource controller
on my queue. 

I think I can (or have to) do more twaeks but post this while it's hot.
Passed some tests.

remove-page-cgroup-pointer patch is [8/9] and [9/9].
How about this ?

Peformance comparison is below.
==
rc5-mm1
==
Execl Throughput                           3006.5 lps   (29.8 secs, 3 samples)
C Compiler Throughput                      1006.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               4863.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)                943.7 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               482.7 lpm   (60.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         124804.9 lpm   (30.0 secs, 3 samples)

After this series
==
Execl Throughput                           3003.3 lps   (29.8 secs, 3 samples)
C Compiler Throughput                      1008.0 lpm   (60.0 secs, 3 samples)
Shell Scripts (1 concurrent)               4580.6 lpm   (60.0 secs, 3 samples)
Shell Scripts (8 concurrent)                913.3 lpm   (60.0 secs, 3 samples)
Shell Scripts (16 concurrent)               569.0 lpm   (60.0 secs, 3 samples)
Dc: sqrt(2) to 99 decimal places         124918.7 lpm   (30.0 secs, 3 samples)

Hmm..no loss ? But maybe I should find what I can do to improve this.

Brief patch description is below.

1. patches/nolimit_root.patch
   This patch makes 'root' cgroup's limit to be fixed to unlimited.

2. patches/atomic_flags.patch
   This patch makes page_cgroup->flags to be unsigned long and add atomic ops.

3. patches/account_move.patch
   This patch implements move_account() function for recharging account 
   from a memory resource controller to another.

4. patches/new_force_empty.patch
   This patch makes force_empty() to use move_account() rather than just drop
   accounts. (As fist step, account is moved to 'root'. We can change this later.)

5. patches/make_mapping_null.patch
   Clean up. This guarantees page->mapping to be NULL before uncharge() against 
   page cache is called.

6. patches/stat.patch
   Optimize page_cgroup_change_statistics().

7. patches/charge-will-success.patch
   Add "likely" to charge function.

8. patches/page_cgroup.patch
   remove page_cgroup pointer from struct page and add lookup-system for
   page_cgroup from pfn,

9. patches/boost_page_cgroup_lookupg.patch
   user per-cpu cache for fast access to page_cgroup.

Thanks,
-Kame

