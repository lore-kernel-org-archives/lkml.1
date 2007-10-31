Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbXJaWEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbXJaWEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:04:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760688AbXJaWAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:00:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759795AbXJaWAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:00:46 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit paravirt
Date: Wed, 31 Oct 2007 16:14:48 -0300
Message-Id: <1193858118284-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581133479-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces, and patch callers when needed, native
versions for read/write_crX functions, clts and wbinvd.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pageattr_64.c   |    3 +-
 include/asm-x86/system_64.h |   60 ++++++++++++++++++++++++++++++------------
 2 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/pageattr_64.c b/arch/x86/mm/pageattr_64.c
index c40afba..59a52b0 100644
--- a/arch/x86/mm/pageattr_64.c
+++ b/arch/x86/mm/pageattr_64.c
@@ -12,6 +12,7 @@
 #include <asm/processor.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
+#include <asm/paravirt.h>
 
 pte_t *lookup_address(unsigned long address)
 { 
@@ -77,7 +78,7 @@ static void flush_kernel_map(void *arg)
 	   much cheaper than WBINVD. */
 	/* clflush is still broken. Disable for now. */
 	if (1 || !cpu_has_clflush)
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		clflush_cache_range(adr, PAGE_SIZE);
diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index 4cb2384..b558cb2 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -65,53 +65,62 @@ extern void load_gs_index(unsigned);
 /*
  * Clear and set 'TS' bit respectively
  */
-#define clts() __asm__ __volatile__ ("clts")
+static inline void native_clts(void)
+{
+	asm volatile ("clts");
+}
 
-static inline unsigned long read_cr0(void)
-{ 
+static inline unsigned long native_read_cr0(void)
+{
 	unsigned long cr0;
 	asm volatile("movq %%cr0,%0" : "=r" (cr0));
 	return cr0;
 }
 
-static inline void write_cr0(unsigned long val) 
-{ 
+static inline void native_write_cr0(unsigned long val)
+{
 	asm volatile("movq %0,%%cr0" :: "r" (val));
 }
 
-static inline unsigned long read_cr2(void)
+static inline unsigned long native_read_cr2(void)
 {
 	unsigned long cr2;
 	asm volatile("movq %%cr2,%0" : "=r" (cr2));
 	return cr2;
 }
 
-static inline void write_cr2(unsigned long val)
+static inline void native_write_cr2(unsigned long val)
 {
 	asm volatile("movq %0,%%cr2" :: "r" (val));
 }
 
-static inline unsigned long read_cr3(void)
-{ 
+static inline unsigned long native_read_cr3(void)
+{
 	unsigned long cr3;
 	asm volatile("movq %%cr3,%0" : "=r" (cr3));
 	return cr3;
 }
 
-static inline void write_cr3(unsigned long val)
+static inline void native_write_cr3(unsigned long val)
 {
 	asm volatile("movq %0,%%cr3" :: "r" (val) : "memory");
 }
 
-static inline unsigned long read_cr4(void)
-{ 
+static inline unsigned long native_read_cr4(void)
+{
 	unsigned long cr4;
 	asm volatile("movq %%cr4,%0" : "=r" (cr4));
 	return cr4;
 }
 
-static inline void write_cr4(unsigned long val)
-{ 
+static inline unsigned long native_read_cr4_safe(void)
+{
+	/* CR4 always exist */
+	return native_read_cr4();
+}
+
+static inline void native_write_cr4(unsigned long val)
+{
 	asm volatile("movq %0,%%cr4" :: "r" (val) : "memory");
 }
 
@@ -127,10 +136,27 @@ static inline void write_cr8(unsigned long val)
 	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
 }
 
-#define stts() write_cr0(8 | read_cr0())
+static inline void native_wbinvd(void)
+{
+	asm volatile("wbinvd" ::: "memory");
+}
 
-#define wbinvd() \
-	__asm__ __volatile__ ("wbinvd": : :"memory")
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define clts		native_clts
+#define wbinvd		native_wbinvd
+#define read_cr0 	native_read_cr0
+#define read_cr2 	native_read_cr2
+#define read_cr3 	native_read_cr3
+#define read_cr4 	native_read_cr4
+#define write_cr0	native_write_cr0
+#define write_cr2	native_write_cr2
+#define write_cr3	native_write_cr3
+#define write_cr4	native_write_cr4
+#endif
+
+#define stts() write_cr0(8 | read_cr0())
 
 #endif	/* __KERNEL__ */
 
-- 
1.4.4.2

