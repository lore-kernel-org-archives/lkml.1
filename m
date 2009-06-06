Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZFFCei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZFFCei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 22:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZFFCeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 22:34:16 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:55021 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZFFCeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 22:34:04 -0400
X-IronPort-AV: E=Sophos;i="4.41,314,1241395200"; 
   d="scan'208";a="195713281"
Date: Fri, 5 Jun 2009 19:34:07 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
Subject: [PATCH 3/7] initdev:kernel:Await console discovery, v6
Message-ID: <20090606023407.GA5695@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait for the console device to become available.

History
v6	Changed BOOTDEV_* to INITDEV_*.
v5.1	Corrected call to initdev_register() to be initdev_registered().
v5	Change bootdev_* to initdev_*.
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
 
