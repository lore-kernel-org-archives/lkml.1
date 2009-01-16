Return-Path: <linux-kernel-owner+w=401wt.eu-S935978AbZAPOUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935978AbZAPOUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935148AbZAPOQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:16:59 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:14025 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935056AbZAPOQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:16:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=x5l3G1B4HRYHwxIydgJKwwQTFSe3937mSLSwwwV0B5JZsxCAqII8mxNrz16dKRatiQ
         UEUJD/R0JrdxwK5p1hzEi3CHuHVjxsQWdE08mOM8FvDs8GDmKAUDDzmN6Vo5h81KoDea
         SSiqy/zjvHNW7qimFNN0MdcM/WDixLp53LK34=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 15/17] percpu: Refactor percpu.h
Date: Fri, 16 Jan 2009 09:16:34 -0500
Message-Id: <1232115396-26367-15-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1.rc1
In-Reply-To: <1232115396-26367-14-git-send-email-brgerst@gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
 <1232115396-26367-1-git-send-email-brgerst@gmail.com>
 <1232115396-26367-2-git-send-email-brgerst@gmail.com>
 <1232115396-26367-3-git-send-email-brgerst@gmail.com>
 <1232115396-26367-4-git-send-email-brgerst@gmail.com>
 <1232115396-26367-5-git-send-email-brgerst@gmail.com>
 <1232115396-26367-6-git-send-email-brgerst@gmail.com>
 <1232115396-26367-7-git-send-email-brgerst@gmail.com>
 <1232115396-26367-8-git-send-email-brgerst@gmail.com>
 <1232115396-26367-9-git-send-email-brgerst@gmail.com>
 <1232115396-26367-10-git-send-email-brgerst@gmail.com>
 <1232115396-26367-11-git-send-email-brgerst@gmail.com>
 <1232115396-26367-12-git-send-email-brgerst@gmail.com>
 <1232115396-26367-13-git-send-email-brgerst@gmail.com>
 <1232115396-26367-14-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the DEFINE_PER_CPU_* macros to enable adding arch specific
per-cpu sections simpler.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 include/linux/percpu.h |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 9f2a375..73ef5d8 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -9,34 +9,34 @@
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
 
-#define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
-	__attribute__((__section__(SHARED_ALIGNED_SECTION)))		\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name		\
-	____cacheline_aligned_in_smp
+#else
+
+#define PER_CPU_BASE_SECTION ".data"
+#define PER_CPU_SHARED_ALIGNED_SECTION ""
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
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-- 
1.6.1.rc1

