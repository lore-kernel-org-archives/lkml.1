Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbXEUTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbXEUTik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765375AbXEUTWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:22:39 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46542 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765564AbXEUTWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:22:37 -0400
Message-Id: <20070521191731.636832000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dwg@au1.ibm.com,
       kenchen@google.com, mbligh@google.com, agl@us.ibm.com,
       david@gibson.dropbear.id.au
Subject: [patch 37/69] fix leaky resv_huge_pages when cpuset is in use
Content-Disposition: inline; filename=fix-leaky-resv_huge_pages-when-cpuset-is-in-use.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  <kenchen@google.com>

The internal hugetlb resv_huge_pages variable can permanently leak nonzero
value in the error path of hugetlb page fault handler when hugetlb page is
used in combination of cpuset.  The leaked count can permanently trap N
number of hugetlb pages in unusable "reserved" state.

Steps to reproduce the bug:

  (1) create two cpuset, user1 and user2
  (2) reserve 50 htlb pages in cpuset user1
  (3) attempt to shmget/shmat 50 htlb page inside cpuset user2
  (4) kernel oom the user process in step 3
  (5) ipcrm the shm segment

At this point resv_huge_pages will have a count of 49, even though
there are no active hugetlbfs file nor hugetlb shared memory segment
in the system.  The leak is permanent and there is no recovery method
other than system reboot. The leaked count will hold up all future use
of that many htlb pages in all cpusets.

The culprit is that the error path of alloc_huge_page() did not
properly undo the change it made to resv_huge_page, causing
inconsistent state.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Acked-by: David Gibson <dwg@au1.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.21.1.orig/mm/hugetlb.c
+++ linux-2.6.21.1/mm/hugetlb.c
@@ -140,6 +140,8 @@ static struct page *alloc_huge_page(stru
 	return page;
 
 fail:
+	if (vma->vm_flags & VM_MAYSHARE)
+		resv_huge_pages++;
 	spin_unlock(&hugetlb_lock);
 	return NULL;
 }

-- 
