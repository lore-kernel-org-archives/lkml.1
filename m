Return-Path: <linux-kernel-owner+w=401wt.eu-S1762469AbZEHJJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762469AbZEHJJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbZEHJJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:09:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:53283 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761184AbZEHJJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:09:24 -0400
Date: Fri, 8 May 2009 09:07:36 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com,
       shaohua.li@intel.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com,
       shaohua.li@intel.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4A03ED38.8000700@jp.fujitsu.com>
References: <4A03ED38.8000700@jp.fujitsu.com>
Subject: [tip:x86/urgent] x86: MCE: make cmci_discover_lock irq-safe
Message-ID: <tip-e5299926d7459d9fa7c7f856983147817aedb10e@git.kernel.org>
Git-Commit-ID: e5299926d7459d9fa7c7f856983147817aedb10e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 09:07:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5299926d7459d9fa7c7f856983147817aedb10e
Gitweb:     http://git.kernel.org/tip/e5299926d7459d9fa7c7f856983147817aedb10e
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Fri, 8 May 2009 17:28:40 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 May 2009 11:03:26 +0200

x86: MCE: make cmci_discover_lock irq-safe

Lockdep reports the warning below when Li tries to offline one cpu:

[  110.835487] =================================
[  110.835616] [ INFO: inconsistent lock state ]
[  110.835688] 2.6.30-rc4-00336-g8c9ed89 #52
[  110.835757] ---------------------------------
[  110.835828] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  110.835908] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  110.835982]  (cmci_discover_lock){?.+...}, at: [<ffffffff80236dc0>] cmci_clear+0x30/0x9b

cmci_clear() can be called via smp_call_function_single().

It is better to disable interrupt while holding cmci_discover_lock,
to turn it into an irq-safe lock - we can deadlock otherwise.

[ Impact: fix possible deadlock in the MCE code ]

Reported-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4A03ED38.8000700@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
