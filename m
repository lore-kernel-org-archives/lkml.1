Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYA0Ps6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYA0Ps6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 10:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbYA0Psu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 10:48:50 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:38754 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYA0Pst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 10:48:49 -0500
Message-ID: <479CA7CE.8040407@web.de>
Date: Sun, 27 Jan 2008 16:48:30 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] KGDB: refactor kconfig menu
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19bcxXNVHn18O9DkAB6LUYz2/+m0e9HUaKfvmQs
	0e2ixEN6/aQb6zQ71kOP0w3pglfAwE9vuqceRCfEaIRlJ/+ntA
	WGfaUio+E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to improve the so far, well, unfortunate Kconfig menu
organization of KGDB. Most notably, it pushes all sub-entries into their
own menuconfig, removes the (IMHO) unneeded "Method for KGDB
communication" choice, and ensures everything is indented properly. This
should keep the original semantic while reducing the number of knobs the
user is confronted with.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 lib/Kconfig.kgdb |   91 +++++++++++++++----------------------------------------
 1 file changed, 25 insertions(+), 66 deletions(-)

Index: b/lib/Kconfig.kgdb
===================================================================
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -1,19 +1,9 @@
 
-config WANT_EXTRA_DEBUG_INFORMATION
-	bool
-	select DEBUG_INFO
-	select UNWIND_INFO
-	select FRAME_POINTER if X86
-	default n
-
-config UNWIND_INFO
-	bool
-	default n
-
-config KGDB
+menuconfig KGDB
 	bool "KGDB: kernel debugging with remote gdb"
-	select WANT_EXTRA_DEBUG_INFORMATION
 	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
+	select DEBUG_INFO
+	select FRAME_POINTER
 	depends on DEBUG_KERNEL && (X86)
 	help
 	  If you say Y here, it will be possible to remotely debug the
@@ -23,62 +13,20 @@ config KGDB
 
 config KGDB_ARCH_HAS_SHADOW_INFO
 	bool
-
-config KGDB_CONSOLE
-	bool "KGDB: Console messages through gdb"
-	depends on KGDB
-	help
-	  If you say Y here, console messages will appear through gdb.
-	  Other consoles such as tty or ttyS will continue to work as usual.
-	  Note that if you use this in conjunction with KGDBOE, if the
-	  ethernet driver runs into an error condition during use with KGDB,
-	  it is possible to hit an infinite recursion, causing the kernel
-	  to crash, and typically reboot.  For this reason, it is preferable
-	  to use NETCONSOLE in conjunction with KGDBOE instead of
-	  KGDB_CONSOLE.
-
-choice
-	prompt "Method for KGDB communication"
 	depends on KGDB
-	default KGDB_8250_NOMODULE
-	help
-	  There are a number of different ways in which you can communicate
-	  with KGDB.  The most common is via serial, with the 8250 driver
-	  (should your hardware have an 8250, or ns1655x style uart).
-	  Another option is to use the NETPOLL framework and UDP, should
-	  your ethernet card support this.  Other options may exist.
-	  You can elect to have one core I/O driver that is built into the
-	  kernel for debugging as the kernel is booting, or using only
-	  kernel modules.
-
-config KGDB_ONLY_MODULES
-	bool "KGDB: Use only kernel modules for I/O"
-	depends on MODULES
-	help
-	  Use only kernel modules to configure KGDB I/O after the
-	  kernel is booted.
-
-config KGDB_8250_NOMODULE
-	bool "KGDB: On generic serial port (8250)"
-	select KGDB_8250
-	select SERIAL_8250
-	help
-	  Uses generic serial port (8250) to communicate with the host
-	  GDB.  This is independent of the normal (SERIAL_8250) driver
-	  for this chipset.
-endchoice
 
 config KGDB_8250
-	tristate "KGDB: On generic serial port (8250)" if !KGDB_8250_NOMODULE
-	depends on m && KGDB_ONLY_MODULES
+	tristate "KGDB: On generic serial port (8250)"
+	depends on KGDB
+	default y
 	help
 	  Uses generic serial port (8250) to communicate with the host
 	  GDB.  This is independent of the normal (SERIAL_8250) driver
 	  for this chipset.
 
 config KGDB_SIMPLE_SERIAL
-	bool "Simple selection of KGDB serial port"
-	depends on KGDB_8250_NOMODULE
+	bool "Simple configuration of KGDB serial port"
+	depends on (KGDB_8250 = y)
 	default y
 	help
 	  If you say Y here, you will only have to pick the baud rate
@@ -90,7 +38,7 @@ config KGDB_SIMPLE_SERIAL
 
 config KGDB_BAUDRATE
 	int "Debug serial port baud rate"
-	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL)
+	depends on KGDB_SIMPLE_SERIAL
 	default "115200"
 	help
 	  gdb and the kernel stub need to agree on the baud rate to be
@@ -99,16 +47,15 @@ config KGDB_BAUDRATE
 
 config KGDB_PORT_NUM
 	int "Serial port number for KGDB"
-	range 0 1 if KGDB_MPSC
 	range 0 3
-	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL) || KGDB_MPSC
+	depends on KGDB_SIMPLE_SERIAL
 	default "1"
 	help
 	  Pick the port number (0 based) for KGDB to use.
 
 config KGDB_8250_CONF_STRING
 	string "Configuration string for KGDB"
-	depends on KGDB_8250_NOMODULE && !KGDB_SIMPLE_SERIAL
+	depends on KGDB_8250 && !KGDB_SIMPLE_SERIAL
 	default "io,2f8,115200,3" if X86
 	help
 	  The format of this string should be <io or mmio>,
@@ -119,11 +66,23 @@ config KGDB_8250_CONF_STRING
 config KGDB_ATTACH_WAIT
 	bool "KGDB: Wait for debugger to attach on an unknown exception"
 	depends on KGDB
-	default y if KGDB_8250_NOMODULE
-	default n if !KGDB_8250_NOMODULE
+	default (KGDB_8250 = y)
 	help
 	  If a panic occurs, or any kind of exception, the kgdb will
 	  stop and wait for a debugger to attach.  This sets the
 	  default behavior for waiting for the debugger to attach.  This
 	  value can also be changed at runtime through
 	  /sys/module/kgdb/parameters/attachwait
+
+config KGDB_CONSOLE
+	bool "KGDB: Console messages through gdb"
+	depends on KGDB
+	help
+	  If you say Y here, console messages will appear through gdb.
+	  Other consoles such as tty or ttyS will continue to work as usual.
+	  Note that if you use this in conjunction with KGDBOE, if the
+	  ethernet driver runs into an error condition during use with KGDB,
+	  it is possible to hit an infinite recursion, causing the kernel
+	  to crash, and typically reboot.  For this reason, it is preferable
+	  to use NETCONSOLE in conjunction with KGDBOE instead of
+	  KGDB_CONSOLE.
