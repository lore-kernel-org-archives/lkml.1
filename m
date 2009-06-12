Return-Path: <linux-kernel-owner+w=401wt.eu-S1765887AbZFLQ2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765887AbZFLQ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764255AbZFLQZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39080 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764426AbZFLQZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:01 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 11/27] Blackfin: do not configure the UART early if on wrong processor
Date: Fri, 12 Jun 2009 12:24:29 -0400
Message-Id: <1244823885-22410-12-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Before we configure the early UART, check to make sure we are running on
the expected processor - otherwise, we cause problems by configuring pins
that don't exist (and causing an infinite loop of faults).

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/early_printk.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index 3302719..2ab5681 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -202,11 +202,15 @@ asmlinkage void __init init_early_exception_vectors(void)
 asmlinkage void __init early_trap_c(struct pt_regs *fp, void *retaddr)
 {
 	/* This can happen before the uart is initialized, so initialize
-	 * the UART now
+	 * the UART now (but only if we are running on the processor we think
+	 * we are compiled for - otherwise we write to MMRs that don't exist,
+	 * and cause other problems. Nothing comes out the UART, but it does
+	 * end up in the __buf_log.
 	 */
-	if (likely(early_console == NULL))
+	if (likely(early_console == NULL) && CPUID == bfin_cpuid())
 		setup_early_printk(DEFAULT_EARLY_PORT);
 
+	printk(KERN_EMERG "Early panic\n");
 	dump_bfin_mem(fp);
 	show_regs(fp);
 	dump_bfin_trace_buffer();
-- 
1.6.3.1

