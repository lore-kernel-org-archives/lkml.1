Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYIEDN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYIEDN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYIEDJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbYIEDJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TbP+f0B3ztE5YHXT+Zm44VwJJBKFK3ZGWsb9Q5ePyW5agIdnVORjp9inDe1Y0ZaxQc
         3NrQ8cUZPoDBL0l3irQ8BvEFC5r4UqNs7Nlgv/OBbyrbcypV5McS45/gRspuXlOhEzCv
         trG8bUdy+j8w0U4sH7nnzywoeJ6rWXUl1tnbA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 12/16] x86: cpu common merge early_identify_cpu
Date: Thu,  4 Sep 2008 20:09:10 -0700
Message-Id: <1220584154-32497-12-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |    4 ++++
 arch/x86/kernel/cpu/common_64.c |   19 ++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ffc2f5e..61a7074 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -490,7 +490,11 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
  */
 static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_X86_64
+	c->x86_clflush_size = 64;
+#else
 	c->x86_clflush_size = 32;
+#endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 
 	if (!have_cpuid_p())
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 75bb7ff..6475548 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -482,15 +482,28 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 #endif
 }
 
-/* Do some early cpuid on the boot CPU to get some parameter that are
-   needed before check_bugs. Everything advanced is in identify_cpu
-   below. */
+/*
+ * Do minimum CPU detection early.
+ * Fields really needed: vendor, cpuid_level, family, model, mask,
+ * cache alignment.
+ * The others are not touched to avoid unwanted side effects.
+ *
+ * WARNING: this function is only called on the BP.  Don't add code here
+ * that is supposed to run on all CPUs.
+ */
 static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
 
+#ifdef CONFIG_X86_64
 	c->x86_clflush_size = 64;
+#else
+	c->x86_clflush_size = 32;
+#endif
 	c->x86_cache_alignment = c->x86_clflush_size;
 
+	if (!have_cpuid_p())
+		return;
+
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
 	c->extended_cpuid_level = 0;
-- 
1.5.4.5

