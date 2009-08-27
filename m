Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbZH0IlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbZH0IlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZH0IlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:41:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55447 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZH0IlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:41:09 -0400
Message-ID: <4A9646A2.6080605@np.css.fujitsu.com>
Date: Thu, 27 Aug 2009 17:41:06 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "H.Peter Anvin" <hpa@zytor.com>
Cc: LKLM <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] x86, mce: reset kernel for no-match exception errors
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last case of severity table is used for no match exception error.
Maybe such kind of error could not happen. But I think when the error
really happened, the kernel should be reset. Because such error is
unknown and unexpected. So I make this patch for fixing this problem.

This patch is based on tip/x86/mce.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index bc35a07..092755b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -97,7 +97,7 @@ static struct severity {
 	     "Action optional with lost events", SER),
 	BITSET(MCI_STATUS_UC|MCI_STATUS_OVER, PANIC, "Overflowed uncorrected"),
 	BITSET(MCI_STATUS_UC, UC, "Uncorrected"),
-	BITSET(0, SOME, "No match")	/* always matches. keep at end */
+	BITSET(0, PANIC, "Unknown Error")     /* always matches. keep at end */
 };
 
 /*
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2c3bcd1..cc6e9cb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -245,6 +245,12 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		struct mce *m = &mcelog.entry[i];
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
+		/*
+		 * When no-match error happened, it is a corrected error and
+		 * logged as final one. Prevents it from being printed twice.
+		 */
+		if (final && !memcmp(m, final, sizeof(struct mce)))
+			continue;
 		if (!(m->status & MCI_STATUS_UC))
 			print_mce(m);
 	}
-- 
1.6.2.2

