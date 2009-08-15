Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZHORHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZHORHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZHORHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:07:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:33699 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbZHORHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:07:13 -0400
Date: Sat, 15 Aug 2009 17:06:39 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <1250251594-8348-1-git-send-email-borislav.petkov@amd.com>
References: <1250251594-8348-1-git-send-email-borislav.petkov@amd.com>
Subject: [tip:x86/urgent] x86, msr: Add a AMD wrmsr with exception handling
Message-ID: <tip-0ae84a7d38ee64a21290797e51cd0cc38e3da586@git.kernel.org>
Git-Commit-ID: 0ae84a7d38ee64a21290797e51cd0cc38e3da586
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 17:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ae84a7d38ee64a21290797e51cd0cc38e3da586
Gitweb:     http://git.kernel.org/tip/0ae84a7d38ee64a21290797e51cd0cc38e3da586
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 14 Aug 2009 14:06:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 15 Aug 2009 18:43:58 +0200

x86, msr: Add a AMD wrmsr with exception handling

Add native_write_msr_amd_safe() - we need this for a workaround.

( While at it, convert native_read_msr_amd_safe to using
  more robust named inline asm parameters as the rest of the
  functions. )

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: kjwinchester@gmail.com
Cc: mikpe@it.uu.se
Cc: brgerst@gmail.com
LKML-Reference: <1250251594-8348-1-git-send-email-borislav.petkov@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
