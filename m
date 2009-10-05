Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZJEGhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZJEGhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbZJEGhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:37:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39997 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZJEGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:37:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC993DB.40206@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:36:11 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/10] x86, mce: use do-while in mce_log
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No changes in logic.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9e8eabd..5f88ada 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -134,7 +134,8 @@ void mce_log(struct mce *mce)
 
 	mce->finished = 0;
 	wmb();
-	for (;;) {
+
+	do {
 		entry = rcu_dereference(mcelog.next);
 		for (;;) {
 			/*
@@ -156,14 +157,13 @@ void mce_log(struct mce *mce)
 		}
 		smp_rmb();
 		next = entry + 1;
-		if (cmpxchg(&mcelog.next, entry, next) == entry)
-			break;
-	}
+	} while (cmpxchg(&mcelog.next, entry, next) != entry);
+
 	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
+
 	wmb();
 	mcelog.entry[entry].finished = 1;
 	wmb();
-
 	mce->finished = 1;
 	set_bit(0, &mce_need_notify);
 }
-- 
1.6.4.3


