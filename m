Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbYARUG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbYARUG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763767AbYARUEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763843AbYARUEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:46 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/10] provide read and write cr8 paravirt hooks
Date: Fri, 18 Jan 2008 15:20:21 -0200
Message-Id: <12006768631010-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1200676857691-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com> <1200676857691-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the cr8 manipulation functions ended up staying in the tree,
they can't be defined just when PARAVIRT is off: In this patch,
those functions are defined for the PARAVIRT case too.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/system.h |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index 692c28c..a33c3f4 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -236,6 +236,20 @@ static inline void native_write_cr4(unsigned long val)
 	asm volatile("mov %0,%%cr4": :"r" (val), "m" (__force_order));
 }
 
+#ifdef CONFIG_X86_64
+static inline unsigned long native_read_cr8(void)
+{
+	unsigned long cr8;
+	asm volatile("movq %%cr8,%0" : "=r" (cr8));
+	return cr8;
+}
+
+static inline void native_write_cr8(unsigned long val)
+{
+	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
+}
+#endif
+
 static inline void native_wbinvd(void)
 {
 	asm volatile("wbinvd": : :"memory");
@@ -253,21 +267,9 @@ static inline void native_wbinvd(void)
 #define read_cr4_safe()	(native_read_cr4_safe())
 #define write_cr4(x)	(native_write_cr4(x))
 #define wbinvd()	(native_wbinvd())
-
 #ifdef CONFIG_X86_64
-
-static inline unsigned long read_cr8(void)
-{
-	unsigned long cr8;
-	asm volatile("movq %%cr8,%0" : "=r" (cr8));
-	return cr8;
-}
-
-static inline void write_cr8(unsigned long val)
-{
-	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
-}
-
+#define read_cr8()	(native_read_cr8())
+#define write_cr8(x)	(native_write_cr8(x))
 #endif
 
 /* Clear the 'TS' bit */
-- 
1.4.4.2

