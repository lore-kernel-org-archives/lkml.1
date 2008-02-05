Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbYBEXet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbYBEXet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763092AbYBEXeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:34:24 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:43378 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761115AbYBEXeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:34:23 -0500
Message-ID: <47A8F27D.3030004@web.de>
Date: Wed, 06 Feb 2008 00:34:21 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] KGDB_8250: consolidate config string
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1//AonUFPJ5tvySoYj3gS+5x01OmcBh+ylvqcGF
	v7dUWWBtLZr6Q7SIaZhT4xO9wI1x48G+9k8FCJsO+uUU/ciG0G
	mRxMH7oxA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge mmio and mmap of the KGDB_8250 config string into mmio (with
mapping semantic). I see no point in current mmio that accepts
pre-mapped addresses from the user. Moreover, this conforms to the
interface of 8250_early.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 drivers/serial/8250_kgdb.c |   36 ++++++++++++++----------------------
 lib/Kconfig.kgdb           |    2 +-
 2 files changed, 15 insertions(+), 23 deletions(-)

Index: b/drivers/serial/8250_kgdb.c
===================================================================
--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -208,7 +208,7 @@ static int kgdb8250_uart_init(void)
 
 /*
  * Syntax for this cmdline option is:
- *   <io|mmio|mmap>,<address>[/<regshift>],<baud rate>,<irq> or
+ *   <io|mmio>,<address>[/<regshift>],<baud rate>,<irq> or
  *   ttyS<n>,<baud rate>
  */
 static int kgdb8250_parse_config(char *str)
@@ -225,13 +225,9 @@ static int kgdb8250_parse_config(char *s
 	if (!strncmp(str, "io", 2)) {
 		kgdb8250_port.iotype = UPIO_PORT;
 		str += 2;
-	} else if (!strncmp(str, "mmap", 4)) {
-		kgdb8250_port.iotype = UPIO_MEM;
-		kgdb8250_port.flags |= UPF_IOREMAP;
-		str += 4;
 	} else if (!strncmp(str, "mmio", 4)) {
 		kgdb8250_port.iotype = UPIO_MEM;
-		kgdb8250_port.flags &= ~UPF_IOREMAP;
+		kgdb8250_port.flags = UPF_IOREMAP;
 		str += 4;
 	} else if (!strncmp(str, "ttyS", 4)) {
 		str += 4;
@@ -246,7 +242,7 @@ static int kgdb8250_parse_config(char *s
 			if (late_init_passed)
 				return err;
 			printk(KERN_WARNING "kgdb8250: ttyS%d init delayed, "
-			       "use io|mmio|mmap syntax for early init.\n",
+			       "use io/mmio syntax for early init.\n",
 			       line);
 			return 0;
 		}
@@ -272,14 +268,9 @@ static int kgdb8250_parse_config(char *s
 
 	if (kgdb8250_port.iotype == UPIO_PORT)
 		kgdb8250_port.iobase = simple_strtoul(str, &str, 16);
-	else {
-		if (kgdb8250_port.flags & UPF_IOREMAP)
-			kgdb8250_port.mapbase =
-				(unsigned long) simple_strtoul(str, &str, 16);
-		else
-			kgdb8250_port.membase =
-				(void *) simple_strtoul(str, &str, 16);
-	}
+	else
+		kgdb8250_port.mapbase =
+			(unsigned long)simple_strtoul(str, &str, 16);
 
 	if (*str == '/') {
 		str++;
@@ -362,11 +353,11 @@ static int kgdb8250_late_init(void)
 	kgdb8250_uart_init();
 
 	/* Request memory/io regions that we use. */
-	if (kgdb8250_port.flags & UPF_IOREMAP) {
+	if (kgdb8250_port.iotype == UPIO_MEM) {
 		if (!request_mem_region(kgdb8250_port.mapbase,
 					8 << kgdb8250_port.regshift, "kgdb"))
 			goto rollback;
-	} else if (kgdb8250_port.iotype == UPIO_PORT) {
+	} else {
 		if (!request_region(kgdb8250_port.iobase,
 				    8 << kgdb8250_port.regshift, "kgdb"))
 			goto rollback;
@@ -423,14 +414,15 @@ static void kgdb8250_cleanup(void)
 
 	fully_initialized = 0;
 
-	if (kgdb8250_port.iotype == UPIO_PORT) {
+	if (kgdb8250_port.iotype == UPIO_MEM) {
+		if (kgdb8250_port.flags & UPF_IOREMAP)
+			iounmap(kgdb8250_port.membase);
+		release_mem_region(kgdb8250_port.mapbase,
+				   8 << kgdb8250_port.regshift);
+	} else {
 		ioport_unmap(ioaddr);
 		release_region(kgdb8250_port.iobase,
 			       8 << kgdb8250_port.regshift);
-	} else if (kgdb8250_port.flags & UPF_IOREMAP) {
-		iounmap(kgdb8250_port.membase);
-		release_mem_region(kgdb8250_port.mapbase,
-				   8 << kgdb8250_port.regshift);
 	}
 
 	/* Give the port back to the 8250 driver. */
Index: b/lib/Kconfig.kgdb
===================================================================
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -43,7 +43,7 @@ config KGDB_8250
 	  passed as kernel or module parameter, respectively.  The
 	  configuration comes in two flavors:
 
-	  <io|mmio|mmap>,<address>[/<regshift>],<baud rate>,<irq>
+	  <io|mmio>,<address>[/<regshift>],<baud rate>,<irq>
 	    or
 	  ttyS<n>,<baud rate>
 
