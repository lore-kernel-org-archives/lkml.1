Return-Path: <linux-kernel-owner+w=401wt.eu-S933505AbZHDWQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbZHDWQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933453AbZHDWPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:15:13 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:37716 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZHDWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:15:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAEtPeEqrR7MV/2dsb2JhbAC8RYgpkBcFhBg
X-IronPort-AV: E=Sophos;i="4.43,324,1246838400"; 
   d="scan'208";a="360440683"
Date: Tue, 4 Aug 2009 15:15:09 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: [PATCH 3/7 v6] initdev:kernel:Await console discovery
Message-ID: <20090804221509.GA9283@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait for the console device to become available or for it to be determined
that no console is attached a boot time.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 drivers/accessibility/braille/braille_console.c |    2 +
 kernel/printk.c                                 |   29 ++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
index d672cfe..6d1693f 100644
--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -378,6 +378,8 @@ int braille_register_console(struct console *console, int index,
 	braille_co = console;
 	register_keyboard_notifier(&keyboard_notifier_block);
 	register_vt_notifier(&vt_notifier_block);
+
+	initdev_registered(INITDEV_CONSOLE_TYPE);
 	return 0;
 }
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..7cdc91c 100644
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
+	initdev_wait(INITDEV_CONSOLE_TYPE, have_all_consoles);
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
+	initdev_registered(INITDEV_CONSOLE_TYPE);
 }
 EXPORT_SYMBOL(register_console);
 
