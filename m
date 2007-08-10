Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbXHJWAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbXHJWAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXHJWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:00:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbXHJWAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:00:00 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/25 -v2] native versions for system.h functions
Date: Fri, 10 Aug 2007 16:12:17 -0300
Message-Id: <11867731831138-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867731781610-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the native hook for the functions in system.h
They are the read/write_crX, clts and wbinvd. The later, also
gets its call sites patched.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/tce.c    |    2 +-
 arch/x86_64/mm/pageattr.c   |    2 +-
 include/asm-x86_64/system.h |   54 +++++++++++++++++++++++++++++-------------
 3 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/arch/x86_64/kernel/tce.c b/arch/x86_64/kernel/tce.c
index e3f2569..587f0c2 100644
--- a/arch/x86_64/kernel/tce.c
+++ b/arch/x86_64/kernel/tce.c
@@ -42,7 +42,7 @@ static inline void flush_tce(void* tceaddr)
 	if (cpu_has_clflush)
 		asm volatile("clflush (%0)" :: "r" (tceaddr));
 	else
-		asm volatile("wbinvd":::"memory");
+		wbinvd();
 }
 
 void tce_build(struct iommu_table *tbl, unsigned long index,
diff --git a/arch/x86_64/mm/pageattr.c b/arch/x86_64/mm/pageattr.c
index 7e161c6..b497afd 100644
--- a/arch/x86_64/mm/pageattr.c
+++ b/arch/x86_64/mm/pageattr.c
@@ -76,7 +76,7 @@ static void flush_kernel_map(void *arg)
 	/* When clflush is available always use it because it is
 	   much cheaper than WBINVD. */
 	if (!cpu_has_clflush)
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	else list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		cache_flush_page(adr);
diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index 02175aa..20ed9df 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -68,53 +68,56 @@ extern void load_gs_index(unsigned);
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
 	asm("movq %%cr2,%0" : "=r" (cr2));
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
 	asm("movq %%cr3,%0" : "=r" (cr3));
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
 	asm("movq %%cr4,%0" : "=r" (cr4));
 	return cr4;
 }
 
-static inline void write_cr4(unsigned long val)
-{ 
+static inline void native_write_cr4(unsigned long val)
+{
 	asm volatile("movq %0,%%cr4" :: "r" (val) : "memory");
 }
 
@@ -130,10 +133,27 @@ static inline void write_cr8(unsigned long val)
 	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
 }
 
-#define stts() write_cr0(8 | read_cr0())
+static inline void native_wbinvd(void)
+{
+	asm volatile ("wbinvd" ::: "memory");
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

