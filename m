Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXL2JPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXL2JPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 04:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXL2JPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 04:15:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49501
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbXL2JPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 04:15:42 -0500
Date: Sat, 29 Dec 2007 01:15:42 -0800 (PST)
Message-Id: <20071229.011542.224506346.davem@davemloft.net>
To: bunk@kernel.org
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071229.005408.76652528.davem@davemloft.net>
References: <20071229.001411.210630819.davem@davemloft.net>
	<20071229084846.GA27360@does.not.exist>
	<20071229.005408.76652528.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 29 Dec 2007 00:54:08 -0800 (PST)

> From: Adrian Bunk <bunk@kernel.org>
> Date: Sat, 29 Dec 2007 10:48:46 +0200
> 
> > On Sat, Dec 29, 2007 at 12:14:11AM -0800, David Miller wrote:
> > > That's why I'm not worried about this issue and it's not critical at
> > > all.
> > 
> > If a module calls sunserial_console_match() that's an Oops.
> 
> That's true.
> 
> I'm trying to figure out a way to fix this.

At the end of this email is one idea I came up with but it still
results in:

WARNING: vmlinux.o(.text+0x19e52c): Section mismatch: reference to .init.text:sunserial_console_match (between 'hv_probe' and 'sunzilog_get_mctrl')
WARNING: vmlinux.o(.text+0x19fd1c): Section mismatch: reference to .init.text:sunserial_console_match (between 'zs_probe' and 'serial_in')
WARNING: vmlinux.o(.text+0x19fd5c): Section mismatch: reference to .init.text:sunserial_console_match (between 'zs_probe' and 'serial_in')
WARNING: vmlinux.o(.text+0x1a19e0): Section mismatch: reference to .init.text:sunserial_console_match (between 'su_probe' and 'sunsu_console_putchar')
WARNING: vmlinux.o(.text+0x1a307c): Section mismatch: reference to .init.text:sunserial_console_match (between 'sab_probe' and 'sunsab_send_xchar')
WARNING: vmlinux.o(.text+0x1a3090): Section mismatch: reference to .init.text:sunserial_console_match (between 'sab_probe' and 'sunsab_send_xchar')
WARNING: vmlinux.o(.sun4v_2insn_patch+0x4f8): Section mismatch: reference to .init.text:

if CONFIG_HOTPLUG is set because driver initialization code has to be
marked with __devinit and with HOTPLUG that isn't __init.

This means it's impossible to call add_preferred_console() (either
directly or indirectly via a helper like sunserial_console_match())
from a driver init routine.

The only way I can think of to "work around" this is to mark
sunserial_console_match() as __init_refok, and use some static
variable in suncore which starts as "0" gets set to "1" via a
late_initcall() to block the call to add_preferred_console().

But that's just gross.

Probably the thing to do to untangle this is to make
add_preferred_console() not be __init.  I just tested and that seems
to make everything happy.  Again, below is the first thing I
tried just for reference.

diff --git a/drivers/serial/suncore.c b/drivers/serial/suncore.c
index 707c5b0..a4cbd17 100644
--- a/drivers/serial/suncore.c
+++ b/drivers/serial/suncore.c
@@ -21,6 +21,8 @@
 
 #include <asm/prom.h>
 
+#define SUNCORE_CONSOLE
+
 #include "suncore.h"
 
 static int sunserial_current_minor = 64;
@@ -52,8 +54,9 @@ void sunserial_unregister_minors(struct uart_driver *drv, int count)
 }
 EXPORT_SYMBOL(sunserial_unregister_minors);
 
-int __init sunserial_console_match(struct console *con, struct device_node *dp,
-			    struct uart_driver *drv, int line)
+int __init sunserial_console_match(struct console *con,
+				   struct device_node *dp,
+				   struct uart_driver *drv, int line)
 {
 	int off;
 
@@ -74,7 +77,6 @@ int __init sunserial_console_match(struct console *con, struct device_node *dp,
 
 	return 1;
 }
-EXPORT_SYMBOL(sunserial_console_match);
 
 void
 sunserial_console_termios(struct console *con)
diff --git a/drivers/serial/suncore.h b/drivers/serial/suncore.h
index 042668a..de4dfb0 100644
--- a/drivers/serial/suncore.h
+++ b/drivers/serial/suncore.h
@@ -25,8 +25,17 @@ extern int suncore_mouse_baud_detection(unsigned char, int);
 extern int sunserial_register_minors(struct uart_driver *, int);
 extern void sunserial_unregister_minors(struct uart_driver *, int);
 
+#ifdef SUNCORE_CONSOLE
 extern int sunserial_console_match(struct console *, struct device_node *,
 				   struct uart_driver *, int);
 extern void sunserial_console_termios(struct console *);
+#else
+static inline int sunserial_console_match(struct console *con,
+					  struct device_node *dp,
+					  struct uart_driver *drv, int line)
+{
+	return 0;
+}
+#endif
 
 #endif /* !(_SERIAL_SUN_H) */
diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index be0fe15..67a0b4c 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -24,6 +24,8 @@
 #include <asm/of_device.h>
 #include <asm/irq.h>
 
+#define SUNCORE_CONSOLE
+
 #if defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
 #endif
diff --git a/drivers/serial/sunsab.c b/drivers/serial/sunsab.c
index 543f937..955d54b 100644
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -38,9 +38,12 @@
 #include <asm/prom.h>
 #include <asm/of_device.h>
 
-#if defined(CONFIG_SERIAL_SUNSAB_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#ifdef CONFIG_SERIAL_SUNSAB_CONSOLE
+#define SUNCORE_CONSOLE
+#ifdef CONFIG_MAGIC_SYSRQ
 #define SUPPORT_SYSRQ
 #endif
+#endif
 
 #include <linux/serial_core.h>
 
diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index 4e2302d..cbd97eb 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -41,9 +41,12 @@
 #include <asm/prom.h>
 #include <asm/of_device.h>
 
-#if defined(CONFIG_SERIAL_SUNSU_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#ifdef CONFIG_SERIAL_SUNSU_CONSOLE
+#define SUNCORE_CONSOLE
+#ifdef CONFIG_MAGIC_SYSRQ
 #define SUPPORT_SYSRQ
 #endif
+#endif
 
 #include <linux/serial_core.h>
 
diff --git a/drivers/serial/sunzilog.c b/drivers/serial/sunzilog.c
index cb2e405..d18d145 100644
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -38,9 +38,12 @@
 #include <asm/prom.h>
 #include <asm/of_device.h>
 
-#if defined(CONFIG_SERIAL_SUNZILOG_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#ifdef CONFIG_SERIAL_SUNZILOG_CONSOLE
+#define SUNCORE_CONSOLE
+#ifdef CONFIG_MAGIC_SYSRQ
 #define SUPPORT_SYSRQ
 #endif
+#endif
 
 #include <linux/serial_core.h>
 

