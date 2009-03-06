Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZCFP2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZCFP2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbZCFP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:28:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:45141 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021AbZCFP2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:28:19 -0500
Date: Fri, 6 Mar 2009 15:27:36 GMT
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
Subject: [tip:x86/mm] x86: fix warning about nodeid
Message-ID: <tip-5ed346892ca84c1fa36182b17ad117f72f6b5328@git.kernel.org>
Git-Commit-ID: 5ed346892ca84c1fa36182b17ad117f72f6b5328
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:27:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ed346892ca84c1fa36182b17ad117f72f6b5328
Gitweb:     http://git.kernel.org/tip/5ed346892ca84c1fa36182b17ad117f72f6b5328
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Thu, 5 Mar 2009 12:04:57 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:25:45 +0100

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
index 07bfd60..9f77301 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -754,11 +754,6 @@ static unsigned long __init setup_node_bootmem(int nodeid,
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
@@ -791,13 +786,23 @@ void __init setup_bootmem_allocator(void)
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
