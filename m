Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbYIEDMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbYIEDMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYIEDJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:09:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:54468 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbYIEDJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Unz42AE4a7yLrzgZyaDCBCUUU6qZsCQ4kMYdkIzeG5AaNUauhOK6J4Wqbt/QMSc/Oz
         yTYkooyLWBQBDM2HDadjNhihPqA/Fs+dXRm9G9sYUnFYaYvtqg5ii/i6SIBhy74IJGGv
         XGn4B7HU5wnK8yXy3MF3XjnVc/+sMuU1SPbUs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 11/16] x86: cpu common merge get_cpu_cap
Date: Thu,  4 Sep 2008 20:09:09 -0700
Message-Id: <1220584154-32497-11-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220584154-32497-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/common.c    |   20 ++++++++++++++++++++
 arch/x86/kernel/cpu/common_64.c |    2 ++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b2018f7..ffc2f5e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -458,6 +458,26 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 			c->x86_capability[6] = cpuid_ecx(0x80000001);
 		}
 	}
+
+#ifdef CONFIG_X86_64
+	/* Transmeta-defined flags: level 0x80860001 */
+	xlvl = cpuid_eax(0x80860000);
+	if ((xlvl & 0xffff0000) == 0x80860000) {
+		/* Don't set x86_cpuid_level here for now to not confuse. */
+		if (xlvl >= 0x80860001)
+			c->x86_capability[2] = cpuid_edx(0x80860001);
+	}
+
+	if (c->extended_cpuid_level >= 0x80000007)
+		c->x86_power = cpuid_edx(0x80000007);
+
+	if (c->extended_cpuid_level >= 0x80000008) {
+		u32 eax = cpuid_eax(0x80000008);
+
+		c->x86_virt_bits = (eax >> 8) & 0xff;
+		c->x86_phys_bits = eax & 0xff;
+	}
+#endif
 }
 /*
  * Do minimum CPU detection early.
diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index 7ac0a00..75bb7ff 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -461,6 +461,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 		}
 	}
 
+#ifdef CONFIG_X86_64
 	/* Transmeta-defined flags: level 0x80860001 */
 	xlvl = cpuid_eax(0x80860000);
 	if ((xlvl & 0xffff0000) == 0x80860000) {
@@ -478,6 +479,7 @@ static void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 		c->x86_virt_bits = (eax >> 8) & 0xff;
 		c->x86_phys_bits = eax & 0xff;
 	}
+#endif
 }
 
 /* Do some early cpuid on the boot CPU to get some parameter that are
-- 
1.5.4.5

