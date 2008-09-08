Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYIHM6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYIHM6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYIHM6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:58:15 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:32950 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbYIHM6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:58:14 -0400
Date: Mon, 8 Sep 2008 13:57:29 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] mm: ifdef Quicklists in /proc/meminfo
Message-ID: <Pine.LNX.4.64.0809081351240.4983@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A "Quicklists:          0 kB" line has just started appearing in
/proc/meminfo, but most architectures (including x86) don't have
them configured: may we please #ifdef it, like the highmem lines?

And those architectures which do have quicklists configured are
using them for page tables: so let's place it next to PageTables.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/proc/proc_misc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- 2.6.27-rc5-git/fs/proc/proc_misc.c.0	2008-09-03 07:32:07.000000000 +0100
+++ linux/fs/proc/proc_misc.c	2008-09-08 13:07:41.000000000 +0100
@@ -183,6 +183,9 @@ static int meminfo_read_proc(char *page,
 		"SReclaimable: %8lu kB\n"
 		"SUnreclaim:   %8lu kB\n"
 		"PageTables:   %8lu kB\n"
+#ifdef CONFIG_QUICKLIST
+		"Quicklists:   %8lu kB\n"
+#endif
 		"NFS_Unstable: %8lu kB\n"
 		"Bounce:       %8lu kB\n"
 		"WritebackTmp: %8lu kB\n"
@@ -190,8 +193,7 @@ static int meminfo_read_proc(char *page,
 		"Committed_AS: %8lu kB\n"
 		"VmallocTotal: %8lu kB\n"
 		"VmallocUsed:  %8lu kB\n"
-		"VmallocChunk: %8lu kB\n"
-		"Quicklists:   %8lu kB\n",
+		"VmallocChunk: %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
 		K(i.bufferram),
@@ -216,6 +218,9 @@ static int meminfo_read_proc(char *page,
 		K(global_page_state(NR_SLAB_RECLAIMABLE)),
 		K(global_page_state(NR_SLAB_UNRECLAIMABLE)),
 		K(global_page_state(NR_PAGETABLE)),
+#ifdef CONFIG_QUICKLIST
+		K(quicklist_total_size()),
+#endif
 		K(global_page_state(NR_UNSTABLE_NFS)),
 		K(global_page_state(NR_BOUNCE)),
 		K(global_page_state(NR_WRITEBACK_TEMP)),
@@ -223,8 +228,7 @@ static int meminfo_read_proc(char *page,
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
-		vmi.largest_chunk >> 10,
-		K(quicklist_total_size())
+		vmi.largest_chunk >> 10
 		);
 
 		len += hugetlb_report_meminfo(page + len);
