Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbZHCMVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbZHCMVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZHCMVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:21:46 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:31663 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754934AbZHCMVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:21:44 -0400
X-Trace: 236589727/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.63.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.63.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAM9ydkpPRT9D/2dsb2JhbACBUs4xgigNgWMFgUpn
X-IronPort-AV: E=Sophos;i="4.43,314,1246834800"; 
   d="scan'208";a="236589727"
Date: Mon, 3 Aug 2009 13:21:34 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 11/12] ksm: add some documentation
In-Reply-To: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
Message-ID: <Pine.LNX.4.64.0908031319180.16754@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Documentation/vm/ksm.txt: how to use the Kernel Samepage Merging feature

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
---

 Documentation/vm/00-INDEX |    2 
 Documentation/vm/ksm.txt  |   89 ++++++++++++++++++++++++++++++++++++
 mm/Kconfig                |    1 
 3 files changed, 92 insertions(+)

--- ksm10/Documentation/vm/00-INDEX	2009-06-10 04:05:27.000000000 +0100
+++ ksm11/Documentation/vm/00-INDEX	2009-08-02 13:50:57.000000000 +0100
@@ -6,6 +6,8 @@ balance
 	- various information on memory balancing.
 hugetlbpage.txt
 	- a brief summary of hugetlbpage support in the Linux kernel.
+ksm.txt
+	- how to use the Kernel Samepage Merging feature.
 locking
 	- info on how locking and synchronization is done in the Linux vm code.
 numa
--- ksm10/Documentation/vm/ksm.txt	1970-01-01 01:00:00.000000000 +0100
+++ ksm11/Documentation/vm/ksm.txt	2009-08-02 13:50:57.000000000 +0100
@@ -0,0 +1,89 @@
+How to use the Kernel Samepage Merging feature
+----------------------------------------------
+
+KSM is a memory-saving de-duplication feature, enabled by CONFIG_KSM=y,
+added to the Linux kernel in 2.6.32.  See mm/ksm.c for its implementation,
+and http://lwn.net/Articles/306704/ and http://lwn.net/Articles/330589/
+
+The KSM daemon ksmd periodically scans those areas of user memory which
+have been registered with it, looking for pages of identical content which
+can be replaced by a single write-protected page (which is automatically
+copied if a process later wants to update its content).
+
+KSM was originally developed for use with KVM (where it was known as
+Kernel Shared Memory), to fit more virtual machines into physical memory,
+by sharing the data common between them.  But it can be useful to any
+application which generates many instances of the same data.
+
+KSM only merges anonymous (private) pages, never pagecache (file) pages.
+KSM's merged pages are at present locked into kernel memory for as long
+as they are shared: so cannot be swapped out like the user pages they
+replace (but swapping KSM pages should follow soon in a later release).
+
+KSM only operates on those areas of address space which an application
+has advised to be likely candidates for merging, by using the madvise(2)
+system call: int madvise(addr, length, MADV_MERGEABLE).
+
+The app may call int madvise(addr, length, MADV_UNMERGEABLE) to cancel
+that advice and restore unshared pages: whereupon KSM unmerges whatever
+it merged in that range.  Note: this unmerging call may suddenly require
+more memory than is available - possibly failing with EAGAIN, but more
+probably arousing the Out-Of-Memory killer.
+
+If KSM is not configured into the running kernel, madvise MADV_MERGEABLE
+and MADV_UNMERGEABLE simply fail with EINVAL.  If the running kernel was
+built with CONFIG_KSM=y, those calls will normally succeed: even if the
+the KSM daemon is not currently running, MADV_MERGEABLE still registers
+the range for whenever the KSM daemon is started; even if the range
+cannot contain any pages which KSM could actually merge; even if
+MADV_UNMERGEABLE is applied to a range which was never MADV_MERGEABLE.
+
+Like other madvise calls, they are intended for use on mapped areas of
+the user address space: they will report ENOMEM if the specified range
+includes unmapped gaps (though working on the intervening mapped areas),
+and might fail with EAGAIN if not enough memory for internal structures.
+
+Applications should be considerate in their use of MADV_MERGEABLE,
+restricting its use to areas likely to benefit.  KSM's scans may use
+a lot of processing power, and its kernel-resident pages are a limited
+resource.  Some installations will disable KSM for these reasons.
+
+The KSM daemon is controlled by sysfs files in /sys/kernel/mm/ksm/,
+readable by all but writable only by root:
+
+max_kernel_pages - set to maximum number of kernel pages that KSM may use
+                   e.g. "echo 2000 > /sys/kernel/mm/ksm/max_kernel_pages"
+                   Value 0 imposes no limit on the kernel pages KSM may use;
+                   but note that any process using MADV_MERGEABLE can cause
+                   KSM to allocate these pages, unswappable until it exits.
+                   Default: 2000 (chosen for demonstration purposes)
+
+pages_to_scan    - how many present pages to scan before ksmd goes to sleep
+                   e.g. "echo 200 > /sys/kernel/mm/ksm/pages_to_scan"
+                   Default: 200 (chosen for demonstration purposes)
+
+sleep_millisecs  - how many milliseconds ksmd should sleep before next scan
+                   e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
+                   Default: 20 (chosen for demonstration purposes)
+
+run              - set 0 to stop ksmd from running but keep merged pages,
+                   set 1 to run ksmd e.g. "echo 1 > /sys/kernel/mm/ksm/run",
+                   set 2 to stop ksmd and unmerge all pages currently merged,
+                         but leave mergeable areas registered for next run
+                   Default: 1 (for immediate use by apps which register)
+
+The effectiveness of KSM and MADV_MERGEABLE is shown in /sys/kernel/mm/ksm/:
+
+pages_shared     - how many shared unswappable kernel pages KSM is using
+pages_sharing    - how many more sites are sharing them i.e. how much saved
+pages_unshared   - how many pages unique but repeatedly checked for merging
+pages_volatile   - how many pages changing too fast to be placed in a tree
+full_scans       - how many times all mergeable areas have been scanned
+
+A high ratio of pages_sharing to pages_shared indicates good sharing, but
+a high ratio of pages_unshared to pages_sharing indicates wasted effort.
+pages_volatile embraces several different kinds of activity, but a high
+proportion there would also indicate poor use of madvise MADV_MERGEABLE.
+
+Izik Eidus,
+Hugh Dickins, 30 July 2009
--- ksm10/mm/Kconfig	2009-08-01 05:02:09.000000000 +0100
+++ ksm11/mm/Kconfig	2009-08-02 13:50:57.000000000 +0100
@@ -224,6 +224,7 @@ config KSM
 	  the many instances by a single resident page with that content, so
 	  saving memory until one or another app needs to modify the content.
 	  Recommended for use with KVM, or with other duplicative applications.
+	  See Documentation/vm/ksm.txt for more information.
 
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
