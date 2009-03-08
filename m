Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZCHS4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZCHS4V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZCHSzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:55:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:33683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbZCHSzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:55:36 -0400
Date: Sun, 8 Mar 2009 18:54:40 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49B03069.80001@kernel.org>
References: <49B03069.80001@kernel.org>
Subject: [tip:kmemcheck] x86: fix warning about nodeid
Message-ID: <tip-e954ef20c29b7af07a8cb5452f14fb69e3d9d2b2@git.kernel.org>
Git-Commit-ID: e954ef20c29b7af07a8cb5452f14fb69e3d9d2b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 18:54:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e954ef20c29b7af07a8cb5452f14fb69e3d9d2b2
Gitweb:     http://git.kernel.org/tip/e954ef20c29b7af07a8cb5452f14fb69e3d9d2b2
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Thu, 5 Mar 2009 12:04:57 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 19:34:17 +0100

x86: fix warning about nodeid

Impact: cleanup

Ingo found there warning about nodeid with some configs.

try to use for_each_online_node for non numa too. in that case
nodeid will be 0.

also move out boundary checking from setup_node_bootmem(), so
non-numa config will not check it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49B03069.80001@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/init_32.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2966c6b..db81e9a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -806,11 +806,6 @@ static unsigned long __init setup_node_bootmem(int nodeid,
 {
 	unsigned long bootmap_size;
 
-	if (start_pfn > max_low_pfn)
-		return bootmap;
-	if (end_pfn > max_low_pfn)
-		end_pfn = max_low_pfn;
-
 	/* don't touch min_low_pfn */
 	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
 					 bootmap >> PAGE_SHIFT,
@@ -843,13 +838,23 @@ void __init setup_bootmem_allocator(void)
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
 
+	for_each_online_node(nodeid) {
+		 unsigned long start_pfn, end_pfn;
+
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	for_each_online_node(nodeid)
-		bootmap = setup_node_bootmem(nodeid, node_start_pfn[nodeid],
-					node_end_pfn[nodeid], bootmap);
+		start_pfn = node_start_pfn[nodeid];
+		end_pfn = node_end_pfn[nodeid];
+		if (start_pfn > max_low_pfn)
+			continue;
+		if (end_pfn > max_low_pfn)
+			end_pfn = max_low_pfn;
 #else
-	bootmap = setup_node_bootmem(0, 0, max_low_pfn, bootmap);
+		start_pfn = 0;
+		end_pfn = max_low_pfn;
 #endif
+		bootmap = setup_node_bootmem(nodeid, start_pfn, end_pfn,
+						 bootmap);
+	}
 
 	after_bootmem = 1;
 }
