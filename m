Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYIEDMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYIEDMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYIEDJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:52408 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYIEDJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p5x0DKN/kRE2CV6GOlhNUxSF/KZ6OtoVNP+SJsoF+NyBdT8hX6tUCwXDsnxWNl09Q2
         zDQbM58vF0nCdu03LPT8p3UvXJ/SPdEi+mkA+rrIPn974xTKf+xIzIIT6JYloXNbfrSP
         ucvLzDyqljcWPzjuBhORGuVZemeXXVyYTawk0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 10/16] x86: cpu common merge detect_ht
Date: Thu,  4 Sep 2008 20:09:08 -0700
Message-Id: <1220584154-32497-10-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |   13 ++++++++++++-
 arch/x86/kernel/cpu/common_64.c |    9 +++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f919120..b2018f7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -330,6 +330,9 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
 		goto out;
 
+	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
+		return;
+
 	cpuid(1, &eax, &ebx, &ecx, &edx);
 
 	smp_num_siblings = (ebx & 0xff0000) >> 16;
@@ -346,8 +349,11 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		}
 
 		index_msb = get_count_order(smp_num_siblings);
+#ifdef CONFIG_X86_64
+		c->phys_proc_id = phys_pkg_id(index_msb);
+#else
 		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
-
+#endif
 
 		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
 
@@ -355,8 +361,13 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 		core_bits = get_count_order(c->x86_max_cores);
 
+#ifdef CONFIG_X86_64
+		c->cpu_core_id = phys_pkg_id(index_msb) &
+					       ((1 << core_bits) - 1);
+#else
 		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
 					       ((1 << core_bits) - 1);
+#endif
 	}
 
 out:
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index f7a2d52..7ac0a00 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -349,7 +349,11 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		}
 
 		index_msb = get_count_order(smp_num_siblings);
+#ifdef CONFIG_X86_64
 		c->phys_proc_id = phys_pkg_id(index_msb);
+#else
+		c->phys_proc_id = phys_pkg_id(c->initial_apicid, index_msb);
+#endif
 
 		smp_num_siblings = smp_num_siblings / c->x86_max_cores;
 
@@ -357,8 +361,13 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 		core_bits = get_count_order(c->x86_max_cores);
 
+#ifdef CONFIG_X86_64
 		c->cpu_core_id = phys_pkg_id(index_msb) &
 					       ((1 << core_bits) - 1);
+#else
+		c->cpu_core_id = phys_pkg_id(c->initial_apicid, index_msb) &
+					       ((1 << core_bits) - 1);
+#endif
 	}
 
 out:
-- 
1.5.4.5

