Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbXLDNzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbXLDNzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbXLDNyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:54:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425AbXLDNyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:54:35 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 4/10] split get_cycles_sync
Date: Tue,  4 Dec 2007 09:09:58 -0200
Message-Id: <11967666263502-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967666212496-git-send-email-gcosta@redhat.com>
References: <11967666042130-git-send-email-gcosta@redhat.com> <11967666111489-git-send-email-gcosta@redhat.com> <11967666161585-git-send-email-gcosta@redhat.com> <11967666212496-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits get_cycles_sync() into  __get_cycles_sync(),
and the rdtscll part. Paravirt guests cannot issue rdtscl directly,
as it involves a function call in vdso area.

So, using the __get_cycles_sync() base, we introduce vget_cycles_sync,
which then calls the native version of rdtscll. Ideally, however, a guest
should define its own clocksource, together with a vread function

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/tsc_64.c |    2 +-
 include/asm-x86/tsc.h    |   37 +++++++++++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 5158476..4502539 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -269,7 +269,7 @@ static cycle_t read_tsc(void)
 
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
-	cycle_t ret = (cycle_t)get_cycles_sync();
+	cycle_t ret = (cycle_t)vget_cycles_sync();
 	return ret;
 }
 
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index 6baab30..d6cb056 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -33,14 +33,14 @@ static inline cycles_t get_cycles(void)
 }
 
 /* Like get_cycles, but make sure the CPU is synchronized. */
-static __always_inline cycles_t get_cycles_sync(void)
+static __always_inline cycles_t __get_cycles_sync(void)
 {
 	unsigned long long ret;
 	unsigned eax, edx;
 
 	/*
-  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
- 	 * and doesn't cause a VMEXIT on Hypervisors
+	 * Use RDTSCP if possible; it is guaranteed to be synchronous
+	 * and doesn't cause a VMEXIT on Hypervisors
 	 */
 	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
 		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
@@ -55,11 +55,40 @@ static __always_inline cycles_t get_cycles_sync(void)
 	 */
 	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
 			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-	rdtscll(ret);
 
+	return 0;
+}
+
+static __always_inline cycles_t get_cycles_sync(void)
+{
+	unsigned long long ret;
+	ret = __get_cycles_sync();
+	if (!ret)
+		rdtscll(ret);
 	return ret;
 }
 
+#ifdef CONFIG_PARAVIRT
+/*
+ * For paravirt guests, some functionalities are executed through function
+ * pointers in the various pvops structures.
+ * These function pointers exist inside the kernel and can not
+ * be accessed by user space. To avoid this, we make a copy of the
+ * get_cycles_sync (called in kernel) but force the use of native_read_tsc.
+ * Ideally, the guest should set up it's own clock and vread
+ */
+static __always_inline long long vget_cycles_sync(void)
+{
+	unsigned long long ret;
+	ret = __get_cycles_sync();
+	if (!ret)
+		ret = native_read_tsc();
+	return ret;
+}
+#else
+# define vget_cycles_sync() get_cycles_sync()
+#endif
+
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
-- 
1.4.4.2

