Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbZKWLxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbZKWLxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbZKWLxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:53:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:56005 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbZKWLxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:53:07 -0500
Date: Mon, 23 Nov 2009 11:52:29 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, akpm@linux-foundation.org,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <4B07A739.3030104@kernel.org>
References: <4B07A739.3030104@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, numa, bootmem: Only free bootmem on NUMA failure path
Message-ID: <tip-021428ad1418cf3c386a1a0157140c3ea29b17ef@git.kernel.org>
Git-Commit-ID: 021428ad1418cf3c386a1a0157140c3ea29b17ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  021428ad1418cf3c386a1a0157140c3ea29b17ef
Gitweb:     http://git.kernel.org/tip/021428ad1418cf3c386a1a0157140c3ea29b17ef
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 21 Nov 2009 00:23:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 10:00:48 +0100

x86, numa, bootmem: Only free bootmem on NUMA failure path

In the NUMA bootmem setup failure path we freed nodedata_phys
incorrectly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4B07A739.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa_64.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 086f98a..3acd870 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -239,8 +239,14 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	bootmap = early_node_mem(nodeid, bootmap_start, end,
 				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
 	if (bootmap == NULL)  {
-		if (nodedata_phys < start || nodedata_phys >= end)
-			free_bootmem(nodedata_phys, pgdat_size);
+		if (nodedata_phys < start || nodedata_phys >= end) {
+			/*
+			 * only need to free it if it is from other node
+			 * bootmem
+			 */
+			if (nid != nodeid)
+				free_bootmem(nodedata_phys, pgdat_size);
+		}
 		node_data[nodeid] = NULL;
 		return;
 	}
