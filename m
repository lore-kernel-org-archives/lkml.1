Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbZJEDIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbZJEDIP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758275AbZJEDIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:08:14 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48603 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234AbZJEDIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:08:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC962E8.9020501@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 12:07:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] mce-inject: no wait on write with MCE_INJ_CTX_RANDOM
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC95F5A.4000708@jp.fujitsu.com>
In-Reply-To: <4AC95F5A.4000708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip schedule_timeout() on write with MCE_INJ_CTX_RANDOM.
And call raise_mce() only when it is required.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 2c1fc5a..e9379b6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -136,12 +136,11 @@ static int raise_local(void)
 
 static void raise_mce(struct mce *m)
 {
-	int context = MCE_INJ_CTX(m->inject_flags);
-
-	inject_mce(m);
-
-	if (context == MCE_INJ_CTX_RANDOM)
-		return;
+	/*
+	 * Need to give user space some time to set everything up,
+	 * so do it a jiffie or two later everywhere.
+	 */
+	schedule_timeout(2);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	if (m->inject_flags & MCE_INJ_NMI_BROADCAST) {
@@ -199,12 +198,12 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	if (m.extcpu >= num_possible_cpus() || !cpu_online(m.extcpu))
 		return -EINVAL;
 
-	/*
-	 * Need to give user space some time to set everything up,
-	 * so do it a jiffie or two later everywhere.
-	 */
-	schedule_timeout(2);
-	raise_mce(&m);
+	/* Copy to percpu */
+	inject_mce(&m);
+
+	if (MCE_INJ_CTX(m.inject_flags) != MCE_INJ_CTX_RANDOM)
+		raise_mce(&m);
+
 	return usize;
 }
 
-- 
1.6.4.3


