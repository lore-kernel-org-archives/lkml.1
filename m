Return-Path: <linux-kernel-owner+w=401wt.eu-S1161261AbXCBACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161261AbXCBACr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422642AbXCBABn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:01:43 -0500
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:47910 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161309AbXCAX4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:56:52 -0500
Message-Id: <20070301232529.031999567@goop.org>
References: <20070301232443.195603797@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Mar 2007 15:25:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 22/26] Xen-paravirt_ops: Add early printk support via hvc console
Content-Disposition: inline; filename=xen-hvc-earlyprintk.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add early printk support via hvc console, enable using
"earlyprintk=xen" on the kernel command line.

From: Gerd Hoffmann <kraxel@suse.de>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/x86_64/kernel/early_printk.c |    5 +++++
 drivers/xen/hvc-console.c         |   25 +++++++++++++++++++++++++
 include/xen/hvc-console.h         |    6 ++++++
 3 files changed, 36 insertions(+)

===================================================================
--- a/arch/x86_64/kernel/early_printk.c
+++ b/arch/x86_64/kernel/early_printk.c
@@ -6,6 +6,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/fcntl.h>
+#include <xen/hvc-console.h>
 
 /* Simple VGA output */
 
@@ -243,6 +244,10 @@ static int __init setup_early_printk(cha
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
--- a/drivers/xen/hvc-console.c
+++ b/drivers/xen/hvc-console.c
@@ -28,6 +28,7 @@
 #include <xen/page.h>
 #include <xen/events.h>
 #include <xen/interface/io/console.h>
+#include <xen/hvc-console.h>
 
 #include "../char/hvc_console.h"
 
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
+++ b/include/xen/hvc-console.h
@@ -0,0 +1,6 @@
+#ifndef XEN_HVC_CONSOLE_H
+#define XEN_HVC_CONSOLE_H
+
+extern struct console xenboot_console;
+
+#endif	/* XEN_HVC_CONSOLE_H */

-- 

