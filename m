Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYG3A3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYG3A3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYG3A3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:29:41 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:37682 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYG3A3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:29:41 -0400
Date: Wed, 30 Jul 2008 10:29:39 +1000
From: Simon Horman <horms@verge.net.au>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       linux-sh@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [patch] kdump: sh: parse elfcorehdr command line argument
Message-ID: <20080730002937.GA21998@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick cut and paste from other architectures to allow SH
to parse the elfcorehdr command line argument which is required
for both is_kdump_kernel() and vmcore to function.
(the former is as yet unused on SH).

Tested compilation only

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/arch/sh/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/setup.c	2008-07-30 09:33:45.000000000 +1000
+++ linux-2.6/arch/sh/kernel/setup.c	2008-07-30 09:37:45.000000000 +1000
@@ -25,6 +25,7 @@
 #include <linux/smp.h>
 #include <linux/err.h>
 #include <linux/debugfs.h>
+#include <linux/crash_dump.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/page.h>
@@ -286,6 +287,25 @@ static void __init setup_memory(void)
 extern void __init setup_memory(void);
 #endif
 
+/*
+ * Note: elfcorehdr_addr is not just limited to vmcore. It is also used by
+ * is_kdump_kernel() to determine if we are booting after a panic. Hence
+ * ifdef it under CONFIG_CRASH_DUMP and not CONFIG_PROC_VMCORE.
+ */
+#ifdef CONFIG_CRASH_DUMP
+/* elfcorehdr= specifies the location of elf core header
+ * stored by the crashed kernel.
+ */
+static int __init parse_elfcorehdr(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+	elfcorehdr_addr = memparse(arg, &arg);
+	return 0;
+}
+early_param("elfcorehdr", parse_elfcorehdr);
+#endif
+
 void __init setup_arch(char **cmdline_p)
 {
 	enable_mmu();
