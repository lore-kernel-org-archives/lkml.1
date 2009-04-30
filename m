Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbZD3ALF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbZD3ALF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZD3AKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:10:51 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:43286 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282AbZD3AKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:10:50 -0400
X-IronPort-AV: E=Sophos;i="4.40,269,1238976000"; 
   d="scan'208";a="295452986"
Date: Wed, 29 Apr 2009 17:10:50 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 3/5] KERNEL: Wait for console to become available, v4
Message-ID: <20090430001050.GA3656@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-4; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch has been re-written to use the boot device synchronization
infrastructure. This ensures that we can detect that there is no console
attached as early as possible.

History
v4	Use new hotplug synchronization infrastructure. Include Braille
	console support.
v3.2	Use only a single new command line parameter by adding the possible
	value "forever".  Add message specifying the parameter to modify to
	increase the delay for console initialization
v3.1	Correct the abbreviation for milliseconds in
	Documentation/kernel-parameters.txt to be "ms", not "mS". Thanks to
	Peter Anvin for this.
v3	Increase the default delay to 1 second and add kernel command line
	parameters to override the default delay. Thanks to David Brownell for
	his helpful suggestions.
v2	Wait for the preferred console rather than any console. Make the
	delay interval a tunable.
v1	Initial version

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 drivers/accessibility/braille/braille_console.c |    3 ++
 kernel/printk.c                                 |   29 ++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
index d672cfe..4420ac3 100644
--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -35,6 +35,7 @@
 #include <linux/keyboard.h>
 #include <linux/kbd_kern.h>
 #include <linux/input.h>
+#include <linux/bootdev.h>
 
 MODULE_AUTHOR("samuel.thibault@ens-lyon.org");
 MODULE_DESCRIPTION("braille device");
@@ -378,6 +379,8 @@ int braille_register_console(struct console *console, int index,
 	braille_co = console;
 	register_keyboard_notifier(&keyboard_notifier_block);
 	register_vt_notifier(&vt_notifier_block);
+
+	bootdev_register(BOOTDEV_CONSOLE);
 	return 0;
 }
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..e6a9379 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/device.h>
 
 #include <asm/uaccess.h>
 
@@ -1075,8 +1076,10 @@ void console_unblank(void)
 
 /*
  * Return the console tty driver structure and its associated index
+ * @index:	Pointer to the device index
+ * Returns NULL if no driver available, otherwise a pointer to the TTY driver.
  */
-struct tty_driver *console_device(int *index)
+struct tty_driver *_console_device(int *index)
 {
 	struct console *c;
 	struct tty_driver *driver = NULL;
@@ -1094,6 +1097,29 @@ struct tty_driver *console_device(int *index)
 }
 
 /*
+ * Returns true if all specific consoles are registered, false otherwise
+ */
+static bool have_all_consoles(void)
+{
+	struct tty_driver *driver;
+	int		index;
+
+	driver = _console_device(&index);
+
+	return driver != NULL;
+}
+
+struct tty_driver *console_device(int *index)
+{
+	struct tty_driver *driver;
+	bootdev_wait(BOOTDEV_CONSOLE, have_all_consoles);
+
+	driver = _console_device(index);
+
+	return driver;
+}
+
+/*
  * Prevent further output on the passed console device so that (for example)
  * serial drivers can disable console output before suspending a port, and can
  * re-enable output afterwards.
@@ -1230,6 +1256,7 @@ void register_console(struct console *console)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+	bootdev_registered(BOOTDEV_CONSOLE);
 }
 EXPORT_SYMBOL(register_console);
 
