Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbZJEGmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbZJEGmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbZJEGmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:42:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40221 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbZJEGmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:42:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC99513.2010504@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 15:41:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/10] x86, mce: change barriers in mce_log
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com>
In-Reply-To: <4AC990E1.7030708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Long time ago, smp_wmb() was replaced to wmb() by following commit:
  commit 7644143cd6f7e029f3a8ea64f5fb0ab33ec39f72
  Author: Mike Waychison <mikew@google.com>
  Date:   Fri Sep 30 00:01:27 2005 +0200
  [PATCH] x86_64: Fix mce_log
  > AK: turned the smp_wmbs into true wmbs to make sure they are not
  > reordered by the compiler on UP.

Change them back to original form, and put comments.

(This piece originates from Huang's patch, titled:
 "x86, MCE: Fix bugs and issues of MCE log ring buffer")

Originally-From: Huang Ying <ying.huang@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 87b2e29..655915b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -141,8 +141,9 @@ void mce_log(struct mce *mce)
 	struct mce_log_cpu *mcelog_cpu = &__get_cpu_var(mce_log_cpus);
 	unsigned next, entry;
 
+	/* mce->finished must be set to 0 before written to buffer */
 	mce->finished = 0;
-	wmb();
+	smp_wmb();
 
 	do {
 		entry = mcelog_cpu->next;
@@ -161,9 +162,12 @@ void mce_log(struct mce *mce)
 
 	memcpy(mcelog_cpu->entry + entry, mce, sizeof(struct mce));
 
-	wmb();
+	/* ".finished" of MCE record in buffer must be set after copy */
+	smp_wmb();
 	mcelog_cpu->entry[entry].finished = 1;
-	wmb();
+
+	/* bit 0 of notify_user should be set after finished be set */
+	smp_wmb();
 	mce->finished = 1;
 	set_bit(0, &mce_need_notify);
 }
-- 
1.6.4.3


