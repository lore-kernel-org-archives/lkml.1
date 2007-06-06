Return-Path: <linux-kernel-owner+w=401wt.eu-S964797AbXFFBik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbXFFBik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933359AbXFFBiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:38:18 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:40656 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbXFFBiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:38:16 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 21:38:16 EDT
Message-ID: <46660CB2.60409@xensource.com>
Date: Tue, 05 Jun 2007 18:24:02 -0700
From: Jeremy Fitzhardinge <jeremy@xensource.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] paravirt: helper to disable all IO space
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2007 01:24:15.0546 (UTC) FILETIME=[657819A0:01C7A7D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In a virtual environment, device drivers such as legacy IDE will waste
quite a lot of time probing for their devices which will never appear.
This helper function allows a paravirt implementation to lay claim to
the whole iomem and ioport space, thereby disabling all device drivers
trying to claim IO resources.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

diff -r 83c67f9402b5 arch/i386/kernel/paravirt.c
--- a/arch/i386/kernel/paravirt.c	Tue Jun 05 17:41:04 2007 -0700
+++ b/arch/i386/kernel/paravirt.c	Tue Jun 05 18:17:29 2007 -0700
@@ -227,6 +227,39 @@ static int __init print_banner(void)
 	return 0;
 }
 core_initcall(print_banner);
+
+static struct resource reserve_ioports = {
+	.start = 0,
+	.end = IO_SPACE_LIMIT,
+	.name = "paravirt-ioport",
+	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
+};
+
+static struct resource reserve_iomem = {
+	.start = 0,
+	.end = -1,
+	.name = "paravirt-iomem",
+	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
+};
+
+/*
+ * Reserve the whole legacy IO space to prevent any legacy drivers
+ * from wasting time probing for their hardware.  This is a fairly
+ * brute-force approach to disabling all non-virtual drivers.
+ * 
+ * Note that this must be called very early to have any effect.
+ */
+int paravirt_disable_iospace(void)
+{
+	int ret = 0;
+
+	ret = request_resource(&ioport_resource, &reserve_ioports);
+	if (ret == 0)
+		ret = request_resource(&iomem_resource, &reserve_iomem);
+
+	return ret;
+}
+
 
 struct paravirt_ops paravirt_ops = {
 	.name = "bare hardware",
diff -r 83c67f9402b5 arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c	Tue Jun 05 17:41:04 2007 -0700
+++ b/arch/i386/xen/setup.c	Tue Jun 05 18:17:29 2007 -0700
@@ -8,12 +8,14 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/pm.h>
+#include <linux/ioport.h>
 
 #include <asm/elf.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
+#include <asm/io.h>
 
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
diff -r 83c67f9402b5 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h	Tue Jun 05 17:41:04 2007 -0700
+++ b/include/asm-i386/paravirt.h	Tue Jun 05 18:17:29 2007 -0700
@@ -262,6 +262,7 @@ unsigned paravirt_patch_insns(void *site
 unsigned paravirt_patch_insns(void *site, unsigned len,
 			      const char *start, const char *end);
 
+int paravirt_disable_iospace(void);
 
 /*
  * This generates an indirect call based on the operation type number.

