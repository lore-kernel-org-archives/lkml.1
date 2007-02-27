Return-Path: <linux-kernel-owner+w=401wt.eu-S1030578AbXB0InL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030578AbXB0InL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbXB0InK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:43:10 -0500
Received: from gw.goop.org ([64.81.55.164]:46893 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010AbXB0Iiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:50 -0500
Message-Id: <20070227081637.324223166@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:59 -0800
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
 arch/x86_64/kernel/early_printk.c |    8 ++++++++
 drivers/xen/hvc-console.c         |   24 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

===================================================================
--- a/arch/x86_64/kernel/early_printk.c
+++ b/arch/x86_64/kernel/early_printk.c
@@ -196,6 +196,10 @@ static struct console simnow_console = {
 	.flags =	CON_PRINTBUFFER,
 	.index =	-1,
 };
+
+#ifdef CONFIG_XEN
+extern struct console xenboot_console;
+#endif
 
 /* Direct interface for emergencies */
 struct console *early_console = &early_vga_console;
@@ -243,6 +247,10 @@ static int __init setup_early_printk(cha
  		simnow_init(buf + 6);
  		early_console = &simnow_console;
  		keep_early = 1;
+#ifdef CONFIG_XEN
+	} else if (!strncmp(buf, "xen", 3)) {
+ 		early_console = &xenboot_console;
+#endif
 	}
 
 	if (keep_early)
===================================================================
--- a/drivers/xen/hvc-console.c
+++ b/drivers/xen/hvc-console.c
@@ -133,3 +133,27 @@ module_init(xen_init);
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

-- 

