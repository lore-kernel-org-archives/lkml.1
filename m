Return-Path: <linux-kernel-owner+w=401wt.eu-S936761AbXGRXaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936761AbXGRXaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936206AbXGRX1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:27:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:33058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936379AbXGRX05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/14] dev_vdbg(), available with -DVERBOSE_DEBUG
Date: Wed, 18 Jul 2007 16:25:45 -0700
Message-Id: <11848011842017-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848011802979-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
 <11848011731698-git-send-email-gregkh@suse.de>
 <1184801177102-git-send-email-gregkh@suse.de>
 <11848011802979-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

This defines a dev_vdbg() call, which is enabled with -DVERBOSE_DEBUG.
When enabled, dev_vdbg() acts just like dev_dbg().  When disabled, it is a
NOP ...  just like dev_dbg() without -DDEBUG.  The specific code was moved
out of a USB patch, but lots of drivers have similar support.

That is, code can now be written to use an additional level of debug
output, selected at compile time.  Many driver authors have found this
idiom to be very useful.  A typical usage model is for "normal" debug
messages to focus on fault paths and not be very "chatty", so that those
messages can be left on during normal operation without much of a
performance or syslog load.  On the other hand "verbose" messages would be
noisy enough that they wouldn't normally be enabled; they might even affect
timings enough to change system or driver behavior.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/driver.c |    7 -------
 include/linux/device.h    |   10 ++++++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 73c4936..6548574 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -29,13 +29,6 @@
 #include "hcd.h"
 #include "usb.h"
 
-#define VERBOSE_DEBUG	0
-
-#if VERBOSE_DEBUG
-#define dev_vdbg	dev_dbg
-#else
-#define dev_vdbg(dev, fmt, args...)	do { } while (0)
-#endif
 
 #ifdef CONFIG_HOTPLUG
 
diff --git a/include/linux/device.h b/include/linux/device.h
index be2debe..d9f0a57 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -572,6 +572,16 @@ dev_dbg(struct device * dev, const char * fmt, ...)
 }
 #endif
 
+#ifdef VERBOSE_DEBUG
+#define dev_vdbg	dev_dbg
+#else
+static inline int __attribute__ ((format (printf, 2, 3)))
+dev_vdbg(struct device * dev, const char * fmt, ...)
+{
+	return 0;
+}
+#endif
+
 #define dev_err(dev, format, arg...)		\
 	dev_printk(KERN_ERR , dev , format , ## arg)
 #define dev_info(dev, format, arg...)		\
-- 
1.5.2.2

