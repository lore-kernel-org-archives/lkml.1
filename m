Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZEKJ6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZEKJ6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbZEKJzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:55:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:49457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219AbZEKJzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:55:50 -0400
Date: Mon, 11 May 2009 09:54:04 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, mel@csn.ul.ie,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, mel@csn.ul.ie,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A03E10C.60906@kernel.org>
References: <4A03E10C.60906@kernel.org>
Subject: [tip:x86/mm] x86: Sanity check the e820 against the SRAT table using e820 map only
Message-ID: <tip-b37ab91907e9002925f4217e3bbd496aa12c2fa3@git.kernel.org>
Git-Commit-ID: b37ab91907e9002925f4217e3bbd496aa12c2fa3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:54:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b37ab91907e9002925f4217e3bbd496aa12c2fa3
Gitweb:     http://git.kernel.org/tip/b37ab91907e9002925f4217e3bbd496aa12c2fa3
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 8 May 2009 00:36:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 11:35:07 +0200

x86: Sanity check the e820 against the SRAT table using e820 map only

node_cover_memory() sanity checks the SRAT table by ensuring that all
PXMs cover the memory reported in the e820.

However, when calculating the size of the holes in the e820, it uses
the early_node_map[] which contains information taken from both SRAT
and e820. If the SRAT is missing an entry, then it is not detected
that the SRAT table is incorrect and missing entries.

This patch uses the e820 map to calculate the holes instead of
early_node_map[].

comment is from Mel.

[ Impact: reject incorrect SRAT tables ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A03E10C.60906@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/srat_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 0176595..c7a18aa 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -345,7 +345,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 			pxmram = 0;
 	}
 
-	e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
+	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
 	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
 	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
 		printk(KERN_ERR
