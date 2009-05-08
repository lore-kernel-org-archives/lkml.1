Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZEHIaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZEHIaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932163AbZEHI3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:29:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41363 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbZEHI32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:29:28 -0400
Message-ID: <4A03ED38.8000700@jp.fujitsu.com>
Date: Fri, 08 May 2009 17:28:40 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86 MCE: yet another shut up lockdep warning
References: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
In-Reply-To: <1241754429.4444.12.camel@sli10-desk.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep report below warning when Li try to offline one cpu:

[  110.835487] =================================
[  110.835616] [ INFO: inconsistent lock state ]
[  110.835688] 2.6.30-rc4-00336-g8c9ed89 #52
[  110.835757] ---------------------------------
[  110.835828] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  110.835908] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  110.835982]  (cmci_discover_lock){?.+...}, at: [<ffffffff80236dc0>] cmci_clear+0x30/0x9b

cmci_clear can be called via smp_call_function_single().
It is better to disable interrupt while holding cmci_discover_lock.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Reported-by: Shaohua Li<shaohua.li@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index d6b72df..cef3ee3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -151,10 +151,11 @@ static void print_update(char *type, int *hdr, int num)
 static void cmci_discover(int banks, int boot)
 {
 	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
+	unsigned long flags;
 	int hdr = 0;
 	int i;
 
-	spin_lock(&cmci_discover_lock);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		u64 val;
 
@@ -184,7 +185,7 @@ static void cmci_discover(int banks, int boot)
 			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
 		}
 	}
-	spin_unlock(&cmci_discover_lock);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 	if (hdr)
 		printk(KERN_CONT "\n");
 }
@@ -211,13 +212,14 @@ void cmci_recheck(void)
  */
 void cmci_clear(void)
 {
+	unsigned long flags;
 	int i;
 	int banks;
 	u64 val;
 
 	if (!cmci_supported(&banks))
 		return;
-	spin_lock(&cmci_discover_lock);
+	spin_lock_irqsave(&cmci_discover_lock, flags);
 	for (i = 0; i < banks; i++) {
 		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
 			continue;
@@ -227,7 +229,7 @@ void cmci_clear(void)
 		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
 		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
-	spin_unlock(&cmci_discover_lock);
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
 /*
-- 
1.6.2.2


