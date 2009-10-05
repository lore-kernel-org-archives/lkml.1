Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbZJEGlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbZJEGlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZJEGlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:41:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53700 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZJEGlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:41:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC994D0.1020400@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:40:16 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/10] x86, mce: remove for-loop in mce_log
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new per-CPU buffer allows us to drop this weird code.

Note: This reverts a part of following old commit:

  commit 673242c10d535bfe238d9d8e82ac93432d35b88e
  Author: Andi Kleen <ak@suse.de>
  Date:   Mon Sep 12 18:49:24 2005 +0200
  [PATCH] x86-64: Make lockless machine check record passing a bit more robust.

(This piece originates from Huang's patch, titled:
 "x86, MCE: Fix bugs and issues of MCE log ring buffer")

Originally-From: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ad2eb89..87b2e29 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -146,23 +146,14 @@ void mce_log(struct mce *mce)
 
 	do {
 		entry = mcelog_cpu->next;
-		for (;;) {
-			/*
-			 * When the buffer fills up discard new entries.
-			 * Assume that the earlier errors are the more
-			 * interesting ones:
-			 */
-			if (entry >= MCE_LOG_LEN) {
-				set_bit(MCE_OVERFLOW,
-					(unsigned long *)&mcelog.flags);
-				return;
-			}
-			/* Old left over entry. Skip: */
-			if (mcelog_cpu->entry[entry].finished) {
-				entry++;
-				continue;
-			}
-			break;
+		/*
+		 * When the buffer fills up discard new entries.
+		 * Assume that the earlier errors are the more
+		 * interesting ones:
+		 */
+		if (entry >= MCE_LOG_LEN) {
+			set_bit(MCE_OVERFLOW, (unsigned long *)&mcelog.flags);
+			return;
 		}
 		smp_rmb();
 		next = entry + 1;
-- 
1.6.4.3


