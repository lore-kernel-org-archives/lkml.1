Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbZFEITu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbZFEITu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZFEIGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37570 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbZFEIGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 41/62] Blackfin: include system/processor info in dump messages
Date: Fri,  5 Jun 2009 04:04:50 -0400
Message-Id: <1244189111-19639-42-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

People often copy & paste crash messages without surrounding context, so
include common useful information like system/processor stats in the crash
summary.  This should smooth over the report/test cycle a bit more.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 778a756..331027a 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -32,6 +32,8 @@
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/fs.h>
+#include <linux/compile.h>
+#include <linux/utsname.h>
 #include <linux/rbtree.h>
 #include <asm/traps.h>
 #include <asm/cacheflush.h>
@@ -1080,6 +1082,30 @@ void show_regs(struct pt_regs *fp)
 	unsigned int cpu = smp_processor_id();
 	unsigned char in_atomic = (bfin_read_IPEND() & 0x10) || in_atomic();
 
+	verbose_printk(KERN_NOTICE "\n");
+	if (CPUID != bfin_cpuid())
+		verbose_printk(KERN_NOTICE "Compiled for cpu family 0x%04x (Rev %d), "
+			"but running on:0x%04x (Rev %d)\n",
+			CPUID, bfin_compiled_revid(), bfin_cpuid(), bfin_revid());
+
+	verbose_printk(KERN_NOTICE "ADSP-%s-0.%d",
+		CPU, bfin_compiled_revid());
+
+	if (bfin_compiled_revid() !=  bfin_revid())
+		verbose_printk("(Detected 0.%d)", bfin_revid());
+
+	verbose_printk(" %lu(MHz CCLK) %lu(MHz SCLK) (%s)\n",
+		get_cclk()/1000000, get_sclk()/1000000,
+#ifdef CONFIG_MPU
+		"mpu on"
+#else
+		"mpu off"
+#endif
+		);
+
+	verbose_printk(KERN_NOTICE "%s version %s\n" KERN_NOTICE "Built with %s\n",
+		utsname()->sysname, utsname()->release, LINUX_COMPILER);
+
 	verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "SEQUENCER STATUS:\t\t%s\n", print_tainted());
 	verbose_printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  SYSCFG: %04lx\n",
 		(long)fp->seqstat, fp->ipend, fp->syscfg);
-- 
1.6.3.1

