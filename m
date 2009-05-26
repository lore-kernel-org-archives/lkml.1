Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbZEZXT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbZEZXT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758971AbZEZXSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53159 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbZEZXSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:31 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/17] x86: MCE: Rename 64bit mce_dont_init to mce_disabled
Date: Wed, 27 May 2009 01:18:04 +0200
Message-Id: <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Give it the same name as on 32bit. This makes further merging easier.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h       |    4 ----
 arch/x86/kernel/cpu/mcheck/mce.c |   15 +++++++--------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 84b405d..ca79ee8 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -86,11 +86,7 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_X86_32
 extern int mce_disabled;
-#else /* CONFIG_X86_32 */
-#endif /* !CONFIG_X86_32 */
-
 
 #include <asm/atomic.h>
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 13ba422..9bbdd11 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -49,14 +49,15 @@ static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 /* Call the installed machine check handler for this CPU setup. */
 void (*machine_check_vector)(struct pt_regs *, long error_code) =
 						unexpected_machine_check;
+
+int				mce_disabled;
+
 #ifdef CONFIG_X86_64
 
 #define MISC_MCELOG_MINOR	227
 
 atomic_t mce_entry;
 
-static int			mce_dont_init;
-
 /*
  * Tolerant levels:
  *   0: always panic on uncorrected errors, log corrected errors
@@ -194,7 +195,7 @@ static void mce_panic(char *msg, struct mce *backup, u64 start)
 
 int mce_available(struct cpuinfo_x86 *c)
 {
-	if (mce_dont_init)
+	if (mce_disabled)
 		return 0;
 	return cpu_has(c, X86_FEATURE_MCE) && cpu_has(c, X86_FEATURE_MCA);
 }
@@ -721,7 +722,7 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 		return;
 
 	if (mce_cap_init() < 0) {
-		mce_dont_init = 1;
+		mce_disabled = 1;
 		return;
 	}
 	mce_cpu_quirks(c);
@@ -912,7 +913,7 @@ static struct miscdevice mce_log_device = {
  */
 static int __init mcheck_disable(char *str)
 {
-	mce_dont_init = 1;
+	mce_disabled = 1;
 	return 1;
 }
 __setup("nomce", mcheck_disable);
@@ -926,7 +927,7 @@ __setup("nomce", mcheck_disable);
 static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
-		mce_dont_init = 1;
+		mce_disabled = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0]))
@@ -1297,8 +1298,6 @@ device_initcall(mce_init_device);
 
 #else /* CONFIG_X86_32: */
 
-int mce_disabled;
-
 int nr_mce_banks;
 EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 
-- 
1.6.0.2

