Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXLDN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXLDN5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXLDNy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:54:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbXLDNyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:54:55 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 8/10] change write msr functions interface
Date: Tue,  4 Dec 2007 09:10:02 -0200
Message-Id: <11967666442665-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967666393130-git-send-email-gcosta@redhat.com>
References: <11967666042130-git-send-email-gcosta@redhat.com> <11967666111489-git-send-email-gcosta@redhat.com> <11967666161585-git-send-email-gcosta@redhat.com> <11967666212496-git-send-email-gcosta@redhat.com> <11967666263502-git-send-email-gcosta@redhat.com> <11967666303321-git-send-email-gcosta@redhat.com> <11967666351395-git-send-email-gcosta@redhat.com> <11967666393130-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patche changes the native_write_msr() and friends interface
to explicitly take 2 32-bit registers instead of a 64-bit value.
The change will ease the merge with 64-bit code. As the 64-bit
value will be passed as two registers anyway in i386,
the PVOP_CALL interface has to account for that and use low/high parameters
It would force the x86_64 version to be different.

The change does not make i386 generated code less efficient. As said above,
it would get the values from two registers anyway.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/msr.h      |   19 ++++++++++---------
 include/asm-x86/paravirt.h |    2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index ce2a257..9c695c7 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -59,13 +59,14 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 	return val;
 }
 
-static inline void native_write_msr(unsigned int msr, unsigned long long val)
+static inline void native_write_msr(unsigned int msr,
+				    unsigned low, unsigned high)
 {
-	asm volatile("wrmsr" : : "c" (msr), "A"(val));
+	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high));
 }
 
 static inline int native_write_msr_safe(unsigned int msr,
-					unsigned long long val)
+					unsigned low, unsigned high)
 {
 	int err;
 	asm volatile("2: wrmsr ; xorl %0,%0\n"
@@ -78,7 +79,7 @@ static inline int native_write_msr_safe(unsigned int msr,
 		     "   .long	2b,3b\n\t"
 		     ".previous"
 		     : "=a" (err)
-		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val>>32)),
+		     : "c" (msr), "0" (low), "d" (high),
 		       "i" (-EFAULT));
 	return err;
 }
@@ -114,20 +115,20 @@ static inline unsigned long long native_read_pmc(int counter)
 		(val2) = (u32)(__val >> 32);				\
 	} while(0)
 
-static inline void wrmsr(u32 __msr, u32 __low, u32 __high)
+static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
 {
-	native_write_msr(__msr, ((u64)__high << 32) | __low);
+	native_write_msr(msr, low, high);
 }
 
 #define rdmsrl(msr,val)							\
 	((val) = native_read_msr(msr))
 
-#define wrmsrl(msr,val)	native_write_msr(msr, val)
+#define wrmsrl(msr,val)	native_write_msr(msr, (u32)val, (u32)(val >> 32))
 
 /* wrmsr with exception handling */
-static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
+static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 {
-	return native_write_msr_safe(__msr, ((u64)__high << 32) | __low);
+	return native_write_msr_safe(msr, low, high);
 }
 
 /* rdmsr with exception handling */
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 4a7be97..6f837bb 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -115,7 +115,7 @@ struct pv_cpu_ops {
 	/* MSR, PMC and TSR operations.
 	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
 	u64 (*read_msr)(unsigned int msr, int *err);
-	int (*write_msr)(unsigned int msr, u64 val);
+	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(int counter);
-- 
1.4.4.2

