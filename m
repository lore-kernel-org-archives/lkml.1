Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZJIFrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZJIFrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZJIFrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:47:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52172 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbZJIFrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:47:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACECE47.3080004@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 14:46:47 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] mce-inject: support injecting multiple error to a CPU
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com> <1255053299.5228.28.camel@yhuang-dev.sh.intel.com> <4ACECC49.7000602@jp.fujitsu.com>
In-Reply-To: <4ACECC49.7000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one register set in structure mce_fake_banks, so
we cannot inject more than one event to a CPU.  For example, we
cannot emulate situation that bank 1 of CPU X has a error while
bank 3 of same CPU X has an another error.

This patch make mce_fake_banks to have a list of register set,
and allow us to test more various error combination.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/include/asm/mce.h              |    6 +++++
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   32 +++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/mcheck/mce.c        |   22 ++++++++++++++------
 3 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 0668044..8776ab1 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -244,6 +244,12 @@ struct mce_fake_banks {
 
 	__u8  inject_flags;	/* software inject flags */
 
+	struct list_head list;
+};
+
+struct mce_fake_bank {
+	struct list_head list;
+	__u8  loaded;
 	__u8  bank;
 	__u64 status;
 	__u64 misc;
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 6275318..943fc93 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -29,15 +29,30 @@
 static void inject_mce(struct mce *m)
 {
 	struct mce_fake_banks *banks = &per_cpu(mce_fake_banks, m->extcpu);
+	struct mce_fake_bank *b, *temp;
 
 	banks->mcgstatus	= m->mcgstatus;
 	banks->ip		= m->ip;
 	banks->cs		= m->cs;
 	banks->inject_flags	= m->inject_flags;
-	banks->bank		= m->bank;
-	banks->status		= m->status;
-	banks->addr		= m->addr;
-	banks->misc		= m->misc;
+
+	list_for_each_entry(temp, &banks->list, list) {
+		if (temp->bank == m->bank)
+			b = temp;
+	}
+	if (!b) {
+		b = kzalloc(sizeof(struct mce_fake_bank), GFP_KERNEL);
+		if (!b)
+			return;	/* -ENOMEM */
+		INIT_LIST_HEAD(&b->list);
+		b->bank = m->bank;
+		list_add(&b->list, &banks->list);
+	}
+
+	b->status	= m->status;
+	b->addr		= m->addr;
+	b->misc		= m->misc;
+	b->loaded	= 1;
 
 	mb();
 	banks->loaded = 1;
@@ -45,6 +60,15 @@ static void inject_mce(struct mce *m)
 
 static void clean_injected(struct mce_fake_banks *banks)
 {
+	struct mce_fake_bank *b;
+
+	list_for_each_entry(b, &banks->list, list) {
+		/*
+		 * Might be in NMI context, so avoid doing kfree here.
+		 * Allocated fake bank will be reused in next injections.
+		 */
+		b->loaded = 0;
+	}
 	banks->loaded = 0;
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index edd2a82..327c72d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -303,19 +303,26 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 
 static u64 *mce_get_fake_reg(u32 msr)
 {
-	unsigned bank = __get_cpu_var(mce_fake_banks).bank;
+	struct mce_fake_bank *b;
 
 	if (msr == rip_msr)
 		return &__get_cpu_var(mce_fake_banks).ip;
-	if (msr == MSR_IA32_MCx_STATUS(bank))
-		return &__get_cpu_var(mce_fake_banks).status;
-	if (msr == MSR_IA32_MCx_ADDR(bank))
-		return &__get_cpu_var(mce_fake_banks).addr;
-	if (msr == MSR_IA32_MCx_MISC(bank))
-		return &__get_cpu_var(mce_fake_banks).misc;
 	if (msr == MSR_IA32_MCG_STATUS)
 		return &__get_cpu_var(mce_fake_banks).mcgstatus;
 
+	list_for_each_entry(b, &__get_cpu_var(mce_fake_banks).list, list) {
+		unsigned bank = b->bank;
+
+		if (!b->loaded)
+			continue;
+		if (msr == MSR_IA32_MCx_STATUS(bank))
+			return &b->status;
+		if (msr == MSR_IA32_MCx_ADDR(bank))
+			return &b->addr;
+		if (msr == MSR_IA32_MCx_MISC(bank))
+			return &b->misc;
+	}
+
 	return NULL;
 }
 
@@ -1456,6 +1463,7 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	mce_cpu_features(c);
 	mce_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
+	INIT_LIST_HEAD(&__get_cpu_var(mce_fake_banks).list);
 }
 
 /*
-- 
1.6.2.2


