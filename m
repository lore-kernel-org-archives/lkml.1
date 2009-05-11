Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbZEKJ6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbZEKJ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbZEKJzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:55:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:49452 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757990AbZEKJzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:55:40 -0400
Date: Mon, 11 May 2009 09:54:15 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, mel@csn.ul.ie,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, mel@csn.ul.ie,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A03E13E.6050107@kernel.org>
References: <4A03E13E.6050107@kernel.org>
Subject: [tip:x86/mm] x86: Allow 1MB of slack between the e820 map and SRAT, not 4GB
Message-ID: <tip-0964b0562bb9c93194e852b47bab2397b9e11c18@git.kernel.org>
Git-Commit-ID: 0964b0562bb9c93194e852b47bab2397b9e11c18
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:54:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0964b0562bb9c93194e852b47bab2397b9e11c18
Gitweb:     http://git.kernel.org/tip/0964b0562bb9c93194e852b47bab2397b9e11c18
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 8 May 2009 00:37:34 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 11:38:21 +0200

x86: Allow 1MB of slack between the e820 map and SRAT, not 4GB

It is expected that there might be slight differences between the e820
map and the SRAT table and the intention was that 1MB of slack be allowed.

The calculation comparing e820ram and pxmram assumes the units are bytes,
when they are in fact pages. This means 4GB of slack is being allowed,
not 1MB. This patch makes the correct comparison.

comment is from Mel.

[ Impact: don't accept buggy SRATs that could dump up to 4G of RAM ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A03E13E.6050107@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/srat_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index c7a18aa..87b45bf 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -346,8 +346,8 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 	}
 
 	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow a bit of slack. */
-	if ((long)(e820ram - pxmram) >= 1*1024*1024) {
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
 		printk(KERN_ERR
 	"SRAT: PXMs only cover %luMB of your %luMB e820 RAM. Not used.\n",
 			(pxmram << PAGE_SHIFT) >> 20,
