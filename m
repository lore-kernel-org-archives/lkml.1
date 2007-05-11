Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbXEKTNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbXEKTNe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965638AbXEKTK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:10:26 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:60113 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762018AbXEKTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:10:25 -0400
Message-Id: <20070511001204.948444000@goop.org>
References: <20070511000643.025196000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 17:07:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 19/28]xen: Add early printk support via hvc console
Content-Disposition: inline; filename=xen-hvc-earlyprintk.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add early printk support via hvc console, enable using
"earlyprintk=xen" on the kernel command line.

From: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86_64/kernel/early_printk.c |    5 +++++
 drivers/char/hvc_xen.c            |   25 +++++++++++++++++++++++++
 drivers/xen/Makefile              |    1 +
 include/xen/hvc-console.h         |    6 ++++++
 4 files changed, 37 insertions(+)

===================================================================
--- a/arch/x86_64/kernel/early_printk.c
+++ b/arch/x86_64/kernel/early_printk.c
@@ -6,6 +6,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
+#include <xen/hvc-console.h>
 
 /* Simple VGA output */
 
@@ -242,6 +243,10 @@ static int __init setup_early_printk(cha
  		simnow_init(buf + 6);
  		early_console = &simnow_console;
  		keep_early = 1;
+#ifdef CONFIG_XEN
+	} else if (!strncmp(buf, "xen", 3)) {
+ 		early_console = &xenboot_console;
+#endif
 	}
 	register_console(early_console);
 	return 0;
===================================================================
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -28,6 +28,7 @@
 #include <xen/page.h>
 #include <xen/events.h>
 #include <xen/interface/io/console.h>
+#include <xen/hvc-console.h>
 
 #include "hvc_console.h"
 
@@ -132,3 +133,27 @@ module_init(xen_init);
 module_init(xen_init);
 module_exit(xen_fini);
 console_initcall(xen_cons_init);
+
+static void xenboot_write_console(struct console *console, const char *string,
+				  unsigned len)
+{
+	unsigned int linelen, off = 0;
+	const char *pos;
+
+	while (off < len && NULL != (pos = strchr(string+off, '\n'))) {
+		linelen = pos-string+off;
+		if (off + linelen > len)
+			break;
+		write_console(0, string+off, linelen);
+		write_console(0, "\r\n", 2);
+		off += linelen + 1;
+	}
+	if (off < len)
+		write_console(0, string+off, len-off);
+}
+
+struct console xenboot_console = {
+	.name		= "xenboot",
+	.write		= xenboot_write_console,
+	.flags		= CON_PRINTBUFFER | CON_BOOT,
+};
===================================================================
--- /dev/null
+++ b/drivers/xen/Makefile
@@ -0,0 +1,1 @@
+obj-y	+= grant-table.o
===================================================================
--- /dev/null
+++ b/include/xen/hvc-console.h
@@ -0,0 +1,6 @@
+#ifndef XEN_HVC_CONSOLE_H
+#define XEN_HVC_CONSOLE_H
+
+extern struct console xenboot_console;
+
+#endif	/* XEN_HVC_CONSOLE_H */

-- 

