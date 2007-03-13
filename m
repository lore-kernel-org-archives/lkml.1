Return-Path: <linux-kernel-owner+w=401wt.eu-S1030778AbXCMQbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030778AbXCMQbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXCMQbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:31:34 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:60640 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030778AbXCMQbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:31:33 -0400
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 12:31:33 EDT
Date: Wed, 14 Mar 2007 01:09:19 +0900 (JST)
Message-Id: <20070314.010919.122026198.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, device@lanana.org, ralf@linux-mips.org,
       sshtylyov@ru.mvista.com
Subject: [PATCH 2.6.21-rc3] serial: Allocate minor device numbers for
 serial_txx9 driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The serial_txx9 driver have abused device numbers (major 4, minor 128)
if CONFIG_SERIAL_TXX9_STDSERIAL was not set.  This patch makes the
driver allocate minor numbers from major 204 (Low-density serial
ports).  I suppose a typical user of this driver set
CONFIG_SERIAL_TXX9_STDSERIAL to Y (i.e. use "ttyS0"), so this patch
would not cause big compatibility issue.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 8de132a..62f85c5 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -2808,6 +2808,9 @@ Your cooperation is appreciated.
 		    ...
 		 190 = /dev/ttyUL3		Xilinx uartlite - port 3
 		 191 = /dev/xvc0		Xen virtual console - port 0
+		 192 = /dev/ttyTX0		TX39/49 serial port 0
+		    ...
+		 199 = /dev/ttyTX7		TX39/49 serial port 7
 
 205 char	Low-density serial ports (alternate device)
 		  0 = /dev/culu0		Callout device for ttyLU0
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 509ace7..c5607ac 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -40,6 +40,7 @@
  *	1.07	Use CONFIG_SERIAL_TXX9_NR_UARTS.  Cleanup.
  *	1.08	Use platform_device.
  *		Fix and cleanup suspend/resume/initialization codes.
+ *	1.09	Use major 204 if CONFIG_SERIAL_TXX9_STDSERIAL was not set.
  */
 
 #if defined(CONFIG_SERIAL_TXX9_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -62,7 +63,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.08";
+static char *serial_version = "1.09";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -70,13 +71,14 @@ static char *serial_name = "TX39/49 Serial driver";
 #if !defined(CONFIG_SERIAL_TXX9_STDSERIAL)
 /* "ttyS" is used for standard serial driver */
 #define TXX9_TTY_NAME "ttyTX"
-#define TXX9_TTY_MINOR_START	(64 + 64)	/* ttyTX0(128), ttyTX1(129) */
+#define TXX9_TTY_MINOR_START	192
+#define TXX9_TTY_MAJOR	204
 #else
 /* acts like standard serial driver */
 #define TXX9_TTY_NAME "ttyS"
 #define TXX9_TTY_MINOR_START	64
-#endif
 #define TXX9_TTY_MAJOR	TTY_MAJOR
+#endif
 
 /* flag aliases */
 #define UPF_TXX9_HAVE_CTS_LINE	UPF_BUGGY_UART


