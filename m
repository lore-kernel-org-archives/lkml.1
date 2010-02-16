Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab0BPATX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:19:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:36940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab0BPATV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:19:21 -0500
Date: Tue, 16 Feb 2010 00:18:43 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rientjes@google.com
In-Reply-To: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Fix numa emulation calculation of big nodes
Message-ID: <tip-68fd111e02b979876359c7b471a8bcbca0628b75@git.kernel.org>
Git-Commit-ID: 68fd111e02b979876359c7b471a8bcbca0628b75
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Feb 2010 00:18:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68fd111e02b979876359c7b471a8bcbca0628b75
Gitweb:     http://git.kernel.org/tip/68fd111e02b979876359c7b471a8bcbca0628b75
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Mon, 15 Feb 2010 13:43:25 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 15 Feb 2010 14:34:04 -0800

x86, numa: Fix numa emulation calculation of big nodes

numa=fake=N uses split_nodes_interleave() to partition the system into N
fake nodes.  Each node size must have be a multiple of
FAKE_NODE_MIN_SIZE, otherwise it is possible to get strange alignments.
Because of this, the remaining memory from each node when rounded to
FAKE_NODE_MIN_SIZE is consolidated into a number of "big nodes" that are
bigger than the rest.

The calculation of the number of big nodes is incorrect since it is using
a logical AND operator when it should be multiplying the rounded-off
portion of each node with N.

Signed-off-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1002151342230.26927@chino.kir.corp.google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/numa_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 83bbc70..2ecbe0c 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -427,7 +427,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
 	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) & nr_nodes) /
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
 		FAKE_NODE_MIN_SIZE;
 
 	size &= FAKE_NODE_MIN_HASH_MASK;
