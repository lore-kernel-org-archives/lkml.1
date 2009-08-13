Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbZHMMbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbZHMMbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZHMMbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:31:45 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:58604 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbZHMMbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:31:43 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KOBESH-03-GL4-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: kjwinchester@gmail.com
CC: mikpe@it.uu.se, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86, msr: Add an AMD wrmsr with exception handling
Date: Thu, 13 Aug 2009 14:31:26 +0200
Message-ID: <1250166687-17673-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090813122337.GB7029@aftab>
References: <20090813122337.GB7029@aftab>
X-OriginalArrivalTime: 13 Aug 2009 12:31:28.0785 (UTC) FILETIME=[FB31D810:01CA1C11]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, convert native_read_msr_amd_safe to using named inline asm
parameters as the rest of the functions.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/msr.h |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 48ad9d2..3ea381b 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -76,14 +76,14 @@ static inline unsigned long long native_read_msr_amd_safe(unsigned int msr,
 {
 	DECLARE_ARGS(val, low, high);
 
-	asm volatile("2: rdmsr ; xor %0,%0\n"
+	asm volatile("2: rdmsr ; xor %[err],%[err]\n"
 		     "1:\n\t"
 		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %3,%0 ; jmp 1b\n\t"
+		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
 		     ".previous\n\t"
 		     _ASM_EXTABLE(2b, 3b)
-		     : "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), "D" (0x9c5a203a), "i" (-EFAULT));
+		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
+		     : "c" (msr), "D" (0x9c5a203a), [fault] "i" (-EFAULT));
 	return EAX_EDX_VAL(val, low, high);
 }
 
@@ -111,6 +111,25 @@ notrace static inline int native_write_msr_safe(unsigned int msr,
 	return err;
 }
 
+static inline unsigned long long native_write_msr_amd_safe(unsigned int msr,
+							   unsigned low,
+							   unsigned high)
+{
+	int err;
+	asm volatile("2: wrmsr ; xor %[err],%[err]\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
+		     ".previous\n\t"
+		     _ASM_EXTABLE(2b, 3b)
+		     : [err] "=a" (err)
+		     : "c" (msr), "0" (low), "d" (high), [fault] "i" (-EFAULT),
+		       "D" (0x9c5a203a)
+		     : "memory");
+	return err;
+
+}
+
 extern unsigned long long native_read_tsc(void);
 
 static __always_inline unsigned long long __native_read_tsc(void)
@@ -164,6 +183,11 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	return native_write_msr_safe(msr, low, high);
 }
 
+static inline int wrmsr_amd_safe(unsigned msr, unsigned low, unsigned high)
+{
+	return native_write_msr_amd_safe(msr, low, high);
+}
+
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr, p1, p2)					\
 ({								\
-- 
1.6.3.3


