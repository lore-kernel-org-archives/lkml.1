Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZASAw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZASAw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 19:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbZASAwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 19:52:31 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:52405 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbZASAwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 19:52:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=W/5H287QQJB12a1/G4tDLY4/56dPOP9ANxfhJ/aUoufnwZN1tbxt3iTwuc2O4DeOYP
         Hsw285W7do1k9OovokzeQXwm/sFICbUNXJsP0LaQl+KqqVOO2Rb9o1OJjMBkwIZZNwPa
         SlUIJgozqu1C8rJG1r28sK0J9iGG+XLsQTHaQ=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 2/5] percpu: Refactor percpu.h
Date: Sun, 18 Jan 2009 19:52:22 -0500
Message-Id: <1232326345-3534-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232326345-3534-1-git-send-email-brgerst@gmail.com>
References: <73c1f2160901181651w3dff5e2co762b767168416c92@mail.gmail.com>
 <1232326345-3534-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the DEFINE_PER_CPU_* macros and add .data.percpu.first
section.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |    1 +
 include/linux/percpu.h            |   41 ++++++++++++++++++++----------------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index aa6b9b1..32bbf50 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -486,6 +486,7 @@
  */
 #define PERCPU_VADDR(vaddr, phdr)					\
 	PERCPU_PROLOG(vaddr)						\
+		*(.data.percpu.first)					\
 		*(.data.percpu.page_aligned)				\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9f2a375..0e24202 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -9,34 +9,39 @@
 #include <asm/percpu.h>
 
 #ifdef CONFIG_SMP
-#define DEFINE_PER_CPU(type, name)					\
-	__attribute__((__section__(".data.percpu")))			\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+#define PER_CPU_BASE_SECTION ".data.percpu"
 
 #ifdef MODULE
-#define SHARED_ALIGNED_SECTION ".data.percpu"
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
 #else
-#define SHARED_ALIGNED_SECTION ".data.percpu.shared_aligned"
+#define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
 #endif
+#define PER_CPU_FIRST_SECTION ".first"
 
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
-	____cacheline_aligned_in_smp
+#else
+
+#define PER_CPU_BASE_SECTION ".data"
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_FIRST_SECTION ""
+
+#endif
 
-#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)			\
-	__attribute__((__section__(".data.percpu.page_aligned")))	\
+#define DEFINE_PER_CPU_SECTION(type, name, section)			\
+	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
 	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-#else
+
 #define DEFINE_PER_CPU(type, name)					\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+	DEFINE_PER_CPU_SECTION(type, name, "")
 
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)		      \
-	DEFINE_PER_CPU(type, name)
+#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
+	____cacheline_aligned_in_smp
 
-#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)		      \
-	DEFINE_PER_CPU(type, name)
-#endif
+#define DEFINE_PER_CPU_PAGE_ALIGNED(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, ".page_aligned")
+
+#define DEFINE_PER_CPU_FIRST(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_FIRST_SECTION)
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-- 
1.6.1.rc1

