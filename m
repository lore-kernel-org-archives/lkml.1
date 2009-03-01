Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZCAOK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZCAOK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZCAOKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:10:18 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:45371 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbZCAOKQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:10:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=hJAXJaAMx1xJ14VK2jd2/KdNJuGFvcR7u6VFEfHnWksnmEXTCjLv262GuPTXzsXoQE
         t+AVlV5lOoPB3PRO048dPUNJ5tEnWnWAzOG+UJSna3ZeoZ9AWWePHhjs/G7i37Y/54ln
         hKru39ZK+raIh+YFtynRtRJIka0yNnHyP9524=
Date: Sun, 1 Mar 2009 16:10:08 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Stuart Bennett <stuart@freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/7] x86: add far read test to testmmiotrace
Message-ID: <20090301161008.78fdbab6@daedalus.pq.iki.fi>
In-Reply-To: <20090301160643.05a2219b@daedalus.pq.iki.fi>
References: <20090301160643.05a2219b@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d3f1d5f4a087c6e57cc1d2aa8fc2c82c23a5096a Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sun, 22 Feb 2009 14:09:25 +0200
Subject: [PATCH] x86: add far read test to testmmiotrace

Apparently pages far into an ioremapped region might not actually be
mapped during ioremap(). Add an optional read test to try to trigger a
multiply faulting MMIO access. Also add more messages to the kernel log
to help debugging.

This patch is based on a patch suggested by
Stuart Bennett <stuart@freedesktop.org>
who discovered bugs in mmiotrace related to normal kernel space faults.

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/testmmiotrace.c |   35 ++++++++++++++++++++++++++++-------
 1 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 4b29f3b..427fd1b 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -9,7 +9,13 @@
 
 static unsigned long mmio_address;
 module_param(mmio_address, ulong, 0);
-MODULE_PARM_DESC(mmio_address, "Start address of the mapping of 16 kB.");
+MODULE_PARM_DESC(mmio_address, " Start address of the mapping of 16 kB "
+				"(or 8 MB if read_far is non-zero).");
+
+static unsigned long read_far = 0x400100;
+module_param(read_far, ulong, 0);
+MODULE_PARM_DESC(read_far, " Offset of a 32-bit read within 8 MB "
+				"(default: 0x400100).");
 
 static unsigned v16(unsigned i)
 {
@@ -24,6 +30,7 @@ static unsigned v32(unsigned i)
 static void do_write_test(void __iomem *p)
 {
 	unsigned int i;
+	pr_info(MODULE_NAME ": write test.\n");
 	mmiotrace_printk("Write test.\n");
 
 	for (i = 0; i < 256; i++)
@@ -40,6 +47,7 @@ static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
 	unsigned errs[3] = { 0 };
+	pr_info(MODULE_NAME ": read test.\n");
 	mmiotrace_printk("Read test.\n");
 
 	for (i = 0; i < 256; i++)
@@ -58,9 +66,17 @@ static void do_read_test(void __iomem *p)
 						errs[0], errs[1], errs[2]);
 }
 
-static void do_test(void)
+static void do_read_far_test(void __iomem *p)
+{
+	pr_info(MODULE_NAME ": read far test.\n");
+	mmiotrace_printk("Read far test.\n");
+
+	ioread32(p + read_far);
+}
+
+static void do_test(unsigned long size)
 {
-	void __iomem *p = ioremap_nocache(mmio_address, 0x4000);
+	void __iomem *p = ioremap_nocache(mmio_address, size);
 	if (!p) {
 		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
 		return;
@@ -68,11 +84,15 @@ static void do_test(void)
 	mmiotrace_printk("ioremap returned %p.\n", p);
 	do_write_test(p);
 	do_read_test(p);
+	if (read_far && read_far < size - 4)
+		do_read_far_test(p);
 	iounmap(p);
 }
 
 static int __init init(void)
 {
+	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
+
 	if (mmio_address == 0) {
 		pr_err(MODULE_NAME ": you have to use the module argument "
 							"mmio_address.\n");
@@ -81,10 +101,11 @@ static int __init init(void)
 		return -ENXIO;
 	}
 
-	pr_warning(MODULE_NAME ": WARNING: mapping 16 kB @ 0x%08lx "
-					"in PCI address space, and writing "
-					"rubbish in there.\n", mmio_address);
-	do_test();
+	pr_warning(MODULE_NAME ": WARNING: mapping %lu kB @ 0x%08lx in PCI "
+		"address space, and writing 16 kB of rubbish in there.\n",
+		 size >> 10, mmio_address);
+	do_test(size);
+	pr_info(MODULE_NAME ": All done.\n");
 	return 0;
 }
 
-- 
1.6.0.6

