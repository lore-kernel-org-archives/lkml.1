Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbZE0LPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbZE0LPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760146AbZE0LMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:12:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56152 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760271AbZE0LMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:12:30 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, starlight@binnacle.cx,
       Eric B Munson <ebmunson@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
       Andy Whitcroft <apw@canonical.com>, wli@movementarian.org
Subject: [PATCH 0/2] Fixes for hugetlbfs-related problems on shared memory
Date: Wed, 27 May 2009 12:12:27 +0100
Message-Id: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches are required to fix problems reported by
starlight@binnacle.cx. The tests cases both involve two processes interacting
with shared memory segments backed by hugetlbfs.

Patch 1 fixes an x86-specific problem where regions sharing page tables
are not being reference counted properly. The page tables get freed early
resulting in bad PMD messages printed to the kernel log and the hugetlb
counters getting corrupted. Strictly speaking, this affects mainline but
the problem is masked by UNEVITABLE_LRU as it never leaves VM_LOCKED set for
hugetlbfs-backed mapping. This does affect the stable branch of 2.6.27 and
distributions based on that kernel such as SLES 11. This patch is required
for 2.6.27-stable and while it is optional for mainline, it should be merged
so that the stable branch does not contain patches that are not in mainline.

Patch 2 fixes a general hugetlbfs problem where it is using VM_SHARED instead
of VM_MAYSHARE to detect if the mapping was MAP_SHARED or MAP_PRIVATE. This
causes hugetlbfs to attempt reserving more pages than is required for
MAP_SHARED and mmap() fails when it should succeed. This patch is needed
for 2.6.30 and -stable. It rejects against 2.6.27.24 but the reject is
trivially resolved by changing the last VM_SHARED in hugetlb_reserve_pages()
to VM_MAYSHARE.

Starlight, if you are still watching, can you reconfirm that this patches
fix the problems you were having?

 arch/x86/mm/hugetlbpage.c |    6 +++++-
 mm/hugetlb.c              |   26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 14 deletions(-)

