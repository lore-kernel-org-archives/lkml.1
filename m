Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbZE0Ebm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbZE0Ebm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 00:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZE0Ebc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 00:31:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54296 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556AbZE0Ebc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 00:31:32 -0400
Message-ID: <4A1CC21A.10301@jp.fujitsu.com>
Date: Wed, 27 May 2009 13:31:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] x86: MCE: Fix for mce_panic_timeout
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org> <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com> <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com> <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com> <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com> <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com> <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com> <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com> <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com> <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com> <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com> <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com> <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com
 >
In-Reply-To: <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes:

 - In case of panic_timeout == 0 and mce_bootlog != 0:
   System should reboot after mce panic, but it doesn't because current
   mce code doesn't overwrite small panic_timeout even if it is 0.

 - In case of panic_timeout > 0 and mce_bootlog == 0.
   System should reboot after panic, but it doesn't on mce panic because
   current mce code overwrite panic_timeout to 0.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 0b87fb4..40fedb2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -82,7 +82,7 @@ static unsigned long		notify_user;
 static int			rip_msr;
 static int			mce_bootlog = -1;
 static int			monarch_timeout = -1;
-static int			mce_panic_timeout;
+static int			mce_panic_timeout = 30;
 
 static char			trigger[128];
 static char			*trigger_argv[2] = { trigger, NULL };
@@ -196,6 +196,15 @@ static void print_mce(struct mce *m)
 
 static atomic_t mce_paniced;
 
+/* Let system panic to reboot for logging the fatal machine check */
+static void mce_set_panic_timeout(void)
+{
+	if (!mce_bootlog)
+		return;
+	if (!panic_timeout || mce_panic_timeout < panic_timeout)
+		panic_timeout = mce_panic_timeout;
+}
+
 /* Panic in progress. Enable interrupts and wait for final IPI */
 static void wait_for_panic(void)
 {
@@ -204,8 +213,7 @@ static void wait_for_panic(void)
 	local_irq_enable();
 	while (timeout-- > 0)
 		udelay(1);
-	if (mce_panic_timeout < panic_timeout)
-		panic_timeout = mce_panic_timeout;
+	mce_set_panic_timeout();
 	panic("Panicing machine check CPU died");
 }
 
@@ -243,8 +251,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
-	if (mce_panic_timeout < panic_timeout)
-		panic_timeout = mce_panic_timeout;
+	mce_set_panic_timeout();
 	panic(msg);
 }
 
@@ -1109,8 +1116,6 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
-	if (mce_bootlog != 0)
-		mce_panic_timeout = 30;
 }
 
 static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
-- 
1.6.3

