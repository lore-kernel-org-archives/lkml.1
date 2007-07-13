Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbXGMDbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbXGMDbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbXGMDay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:30:54 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:20945 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756416AbXGMDax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:30:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ww7wVO6YQsvucsQWb0xXMfO+laa2RlFUVUd09OopMk467vIVVG4QkkgESDDN9jdKYcy0pTCVc2P146Wv4lRX63z6zPnhYy0gXKVWAF8Hseu241GFjm4OWRA9O8jmgZRH4JGjPPM1LTEEDsk6h0Z9evwm2ajXWbnQBl6OkQ46lek=  ;
X-YMail-OSG: YgH.iVAVM1kHuM.cYTHEDVnyF_aawMVtQQRc3Ytt8O26l45fohPGOGyoS5v.F8mDvCAx_Pynww--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.22-git] dev_vdbg(), available with -DVERBOSE_DEBUG
Date: Thu, 12 Jul 2007 20:30:49 -0700
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122030.49465.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This defines a dev_vdbg() call, which is enabled with -DVERBOSE_DEBUG.
When enabled, dev_vdbg() acts just like dev_dbg().  When disabled, it
is a NOP ... just like dev_dbg() without -DDEBUG.  The specific code
was moved out of a USB patch, but lots of drivers have similar support.

That is, code can now be written to use an additional level of debug
output, selected at compile time.  Many driver authors have found this
idiom to be very useful.  A typical usage model is for "normal" debug
messages to focus on fault paths and not be very "chatty", so that
those messages can be left on during normal operation without much of
a performance or syslog load.  On the other hand "verbose" messages
would be noisy enough that they wouldn't normally be enabled; they
might even affect timings enough to change system or driver behavior.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/core/driver.c |    7 -------
 include/linux/device.h    |   10 ++++++++++
 2 files changed, 10 insertions(+), 7 deletions(-)

--- g26.orig/drivers/usb/core/driver.c	2007-07-12 20:09:34.000000000 -0700
+++ g26/drivers/usb/core/driver.c	2007-07-12 20:11:35.000000000 -0700
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
 
--- g26.orig/include/linux/device.h	2007-07-12 20:09:16.000000000 -0700
+++ g26/include/linux/device.h	2007-07-12 20:11:13.000000000 -0700
@@ -572,6 +572,16 @@ dev_dbg(struct device * dev, const char 
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
