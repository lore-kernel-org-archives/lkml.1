Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbXLMEs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbXLMEs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757710AbXLMEqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:46:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759445AbXLMEqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:46:51 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 15/19] use the same data type for tls_array.
Date: Thu, 13 Dec 2007 00:01:48 -0200
Message-Id: <11975113873364-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11975113821418-git-send-email-gcosta@redhat.com>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11975113122984-git-send-email-gcosta@redhat.com> <11975113194101-git-send-email-gcosta@redhat.com> <11975113243875-git-send-email-gcosta@redhat.com> <11975113291722-git-send-email-gcosta@redhat.com> <1197511334416-git-send-email-gcosta@redhat.com> <1197511338810-git-send-email-gcosta@redhat.com> <1197511343355-git-send-email-gcosta@redhat.com> <11975113484194-git-send-email-gcosta@redhat.com> <11975113532186-git-send-email-gcosta@redhat.com> <11975113583644-git-send-email-gcosta@redhat.com> <1197511363887-git-send-email-gcosta@redhat.com> <11975113672937-git-send-email-gcosta@redhat.com> <11975113721808-git-send-email-gcosta@redhat.com> <11975113771692-git-send-email-gcosta@redhat.com> <11975113821418-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the type of tls_array in x86_64 to
a desc_struct. Now, both i386 and x86_64 tls_array have
the same type, and code accessing it can be shared.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/desc_64.h      |    2 +-
 include/asm-x86/processor_64.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/desc_64.h b/include/asm-x86/desc_64.h
index 2dc19e2..7fd9876 100644
--- a/include/asm-x86/desc_64.h
+++ b/include/asm-x86/desc_64.h
@@ -150,7 +150,7 @@ static inline void set_ldt(void *addr, int entries)
 static inline void load_TLS(struct thread_struct *t, unsigned int cpu)
 {
 	unsigned int i;
-	u64 *gdt = (u64 *)(get_cpu_gdt_table(cpu) + GDT_ENTRY_TLS_MIN);
+	struct desc_struct *gdt = (get_cpu_gdt_table(cpu) + GDT_ENTRY_TLS_MIN);
 
 	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
 		gdt[i] = t->tls_array[i];
diff --git a/include/asm-x86/processor_64.h b/include/asm-x86/processor_64.h
index 8efdf99..51f1970 100644
--- a/include/asm-x86/processor_64.h
+++ b/include/asm-x86/processor_64.h
@@ -19,6 +19,7 @@
 #include <linux/personality.h>
 #include <linux/cpumask.h>
 #include <asm/processor-flags.h>
+#include <asm/desc_defs.h>
 
 #define TF_MASK		0x00000100
 #define IF_MASK		0x00000200
@@ -244,7 +245,7 @@ struct thread_struct {
  *               goes into MSR_IA32_DS_AREA */
 	unsigned long	ds_area_msr;
 /* cached TLS descriptors. */
-	u64 tls_array[GDT_ENTRY_TLS_ENTRIES];
+	struct desc_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
 } __attribute__((aligned(16)));
 
 #define INIT_THREAD  { \
-- 
1.5.0.6

