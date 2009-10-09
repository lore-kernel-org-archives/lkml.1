Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZJIFqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZJIFqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZJIFqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:46:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52125 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZJIFqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:46:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACECE09.8090408@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 14:45:45 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] mce-inject: change msr_to_offset() to mce_get_fake_reg()
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com> <1255053299.5228.28.camel@yhuang-dev.sh.intel.com> <4ACECC49.7000602@jp.fujitsu.com>
In-Reply-To: <4ACECC49.7000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mce_get_fake_reg() which returns address of variable for
faked register.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a6f17d..edd2a82 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -301,20 +301,22 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 
 /* Support code for software error injection */
 
-static int msr_to_offset(u32 msr)
+static u64 *mce_get_fake_reg(u32 msr)
 {
 	unsigned bank = __get_cpu_var(mce_fake_banks).bank;
+
 	if (msr == rip_msr)
-		return offsetof(struct mce_fake_banks, ip);
+		return &__get_cpu_var(mce_fake_banks).ip;
 	if (msr == MSR_IA32_MCx_STATUS(bank))
-		return offsetof(struct mce_fake_banks, status);
+		return &__get_cpu_var(mce_fake_banks).status;
 	if (msr == MSR_IA32_MCx_ADDR(bank))
-		return offsetof(struct mce_fake_banks, addr);
+		return &__get_cpu_var(mce_fake_banks).addr;
 	if (msr == MSR_IA32_MCx_MISC(bank))
-		return offsetof(struct mce_fake_banks, misc);
+		return &__get_cpu_var(mce_fake_banks).misc;
 	if (msr == MSR_IA32_MCG_STATUS)
-		return offsetof(struct mce_fake_banks, mcgstatus);
-	return -1;
+		return &__get_cpu_var(mce_fake_banks).mcgstatus;
+
+	return NULL;
 }
 
 /* MSR access wrappers used for error injection */
@@ -323,12 +325,11 @@ static u64 mce_rdmsrl(u32 msr)
 	u64 v;
 
 	if (__get_cpu_var(mce_fake_banks).valid) {
-		int offset = msr_to_offset(msr);
-		char *m = (char *)&__get_cpu_var(mce_fake_banks);
+		u64 *reg = mce_get_fake_reg(msr);
 
-		if (offset < 0)
+		if (!reg)
 			return 0;
-		return *(u64 *)(m + offset);
+		return *reg;
 	}
 
 	if (rdmsrl_safe(msr, &v)) {
@@ -347,11 +348,10 @@ static u64 mce_rdmsrl(u32 msr)
 static void mce_wrmsrl(u32 msr, u64 v)
 {
 	if (__get_cpu_var(mce_fake_banks).valid) {
-		int offset = msr_to_offset(msr);
-		char *m = (char *)&__get_cpu_var(mce_fake_banks);
+		u64 *reg = mce_get_fake_reg(msr);
 
-		if (offset >= 0)
-			*(u64 *)(m + offset) = v;
+		if (reg)
+			*reg = v;
 		return;
 	}
 	wrmsrl(msr, v);
-- 
1.6.2.2


