Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYIEDMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYIEDMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYIEDJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:58345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYIEDJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uQ1lE0G8hhFu/0JN8SmNelcFFsi2vGkkRGr5xIouaYATiuEfv84Q3hQ0IIlxZICSA2
         UvkLB1QXmQUgAsIujZCTzGiSYHg5wllG9K8xvNkzDFGo7Kg+qrYKDfOwtMtDA8hs7eNo
         Zgyz+xXioR8zsR9jXbvN6sdQ1bHKs384CrXE4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 09/16] x86: cpu common merge display_cacheinfo
Date: Thu,  4 Sep 2008 20:09:07 -0700
Message-Id: <1220584154-32497-9-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |    8 ++++++++
 arch/x86/kernel/cpu/common_64.c |   17 +++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2c4bfa2..f919120 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -285,6 +285,10 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
 				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
 		c->x86_cache_size = (ecx>>24) + (edx>>24);
+#ifdef CONFIG_X86_64
+		/* On K8 L1 TLB is inclusive, so don't count it */
+		c->x86_tlbsize = 0;
+#endif
 	}
 
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
@@ -293,6 +297,9 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 	cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
 	l2size = ecx >> 16;
 
+#ifdef CONFIG_X86_64
+	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
+#else
 	/* do processor-specific cache resizing */
 	if (this_cpu->c_size_cache)
 		l2size = this_cpu->c_size_cache(c, l2size);
@@ -303,6 +310,7 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (l2size == 0)
 		return;		/* Again, no L2 cache is possible */
+#endif
 
 	c->x86_cache_size = l2size;
 
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 2fda109..f7a2d52 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -285,8 +285,10 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
 				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
 		c->x86_cache_size = (ecx>>24) + (edx>>24);
+#ifdef CONFIG_X86_64
 		/* On K8 L1 TLB is inclusive, so don't count it */
 		c->x86_tlbsize = 0;
+#endif
 	}
 
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
@@ -294,7 +296,22 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	cpuid(0x80000006, &dummy, &ebx, &ecx, &edx);
 	l2size = ecx >> 16;
+
+#ifdef CONFIG_X86_64
 	c->x86_tlbsize += ((ebx >> 16) & 0xfff) + (ebx & 0xfff);
+#else
+
+	/* do processor-specific cache resizing */
+	if (this_cpu->c_size_cache)
+		l2size = this_cpu->c_size_cache(c, l2size);
+
+	/* Allow user to override all this if necessary. */
+	if (cachesize_override != -1)
+		l2size = cachesize_override;
+
+	if (l2size == 0)
+		return;		/* Again, no L2 cache is possible */
+#endif
 
 	c->x86_cache_size = l2size;
 
-- 
1.5.4.5

