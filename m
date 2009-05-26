Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbZEZX7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbZEZX7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756426AbZEZXy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38617 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbZEZXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:51 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 19/31] x86: MCE: Default to panic timeout for machine checks v2
Date: Wed, 27 May 2009 01:54:21 +0200
Message-Id: <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fatal machine checks can be logged to disk after boot, but only if
the system did a warm reboot. That's unfortunately difficult with the
default panic behaviour, which waits forever and the admin has to
press the power button because modern systems usually miss a reset button.
This clears the machine checks in the registers and make
it impossible to log them.

This patch changes the default for machine check panic to always
reboot after 30s. Then the mce can be successfully logged after
reboot.

I believe this will improve machine check experience for any
system running the X server.

This is dependent on successfull boot logging of MCEs. This currently
only works on Intel systems, on AMD there are quite a lot of systems
around which leave junk in the machine check registers after boot,
so it's disabled here. These systems will continue to default
to endless waiting panic.

v2: Only force panic timeout when it's shorter (H.Seto)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bf9bd6f..c31cbcf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -82,6 +82,7 @@ static unsigned long		notify_user;
 static int			rip_msr;
 static int			mce_bootlog = -1;
 static int			monarch_timeout = -1;
+static int			mce_panic_timeout;
 
 static char			trigger[128];
 static char			*trigger_argv[2] = { trigger, NULL };
@@ -203,6 +204,8 @@ static void wait_for_panic(void)
 	local_irq_enable();
 	while (timeout-- > 0)
 		udelay(1);
+	if (mce_panic_timeout < panic_timeout)
+		panic_timeout = mce_panic_timeout;
 	panic("Panicing machine check CPU died");
 }
 
@@ -240,6 +243,8 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 		printk(KERN_EMERG "Some CPUs didn't answer in synchronization\n");
 	if (exp)
 		printk(KERN_EMERG "Machine check: %s\n", exp);
+	if (mce_panic_timeout < panic_timeout)
+		panic_timeout = mce_panic_timeout;
 	panic(msg);
 }
 
@@ -1100,6 +1105,8 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 	}
 	if (monarch_timeout < 0)
 		monarch_timeout = 0;
+	if (mce_bootlog != 0)
+		mce_panic_timeout = 30;
 }
 
 static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
-- 
1.6.0.2

