Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbXHAX2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbXHAX2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXHAX14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:27:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:21803 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbXHAX1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AdYHL3nbl0SWVEeXo2FdweNmmWuQCZbsWdMREJl+8o+/FBK4yQNr5GE6GXQKjqQzLCya2zI4X4SMFf/1tBB0Y5esr1fKDYEZvz19UWqAcqA2ZlM8jK5WDRgs/Uhje2k9Z7PpNIhLeem5WLHp0tAShGYEkPUbScQrVoAZAagIHsI=
Message-ID: <a9e22dff0708011627y2768a3e8gdfb7bff6fccc8cea@mail.gmail.com>
Date: Thu, 2 Aug 2007 02:27:55 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]hpet and rtc max_user_freq predefine in Kconfig
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think users should be able to set max_user_freq values for rtc and
hpet during kernel configuration. The default value is set to 1024
with this patch.
The default value of 64 is really too small for modern multimedia apps.
Besides, this patch fixes link on intel hpet spec.


Signed-off-by: Milinevsky Dmitry <niam.niam@gmail.com>

diff -Nupar linux-2.6.22-cfs-19/drivers/char/hpet.c
linux-2.6.22-cfs-19.niam/drivers/char/hpet.c
--- linux-2.6.22-cfs-19/drivers/char/hpet.c	2007-07-10 20:57:20.000000000 +0300
+++ linux-2.6.22-cfs-19.niam/drivers/char/hpet.c	2007-08-02
01:34:54.000000000 +0300
@@ -44,9 +44,9 @@
 /*
  * The High Precision Event Timer driver.
  * This driver is closely modelled after the rtc.c driver.
- * http://www.intel.com/hardwaredesign/hpetspec.htm
+ * http://www.intel.com/technology/architecture/hpetspec.htm
  */
-#define	HPET_USER_FREQ	(64)
+#define	HPET_USER_FREQ	(CONFIG_HPET_MAX_USER_FREQ)
 #define	HPET_DRIFT	(500)

 #define HPET_RANGE_SIZE		1024	/* from HPET spec */
diff -Nupar linux-2.6.22-cfs-19/drivers/char/Kconfig
linux-2.6.22-cfs-19.niam/drivers/char/Kconfig
--- linux-2.6.22-cfs-19/drivers/char/Kconfig	2007-07-10 20:57:15.000000000 +0300
+++ linux-2.6.22-cfs-19.niam/drivers/char/Kconfig	2007-08-02
01:33:33.000000000 +0300
@@ -791,6 +791,13 @@ config RTC
 	  To compile this driver as a module, choose M here: the
 	  module will be called rtc.

+config RTC_MAX_USER_FREQ
+	int "User interrupt frequency"
+	depends on RTC
+	default "1024"
+	help
+	  Default value of user interrupt frequency(/proc/sys/dev/rtc/max-user-freq).
+
 config SGI_DS1286
 	tristate "SGI DS1286 RTC support"
 	depends on SGI_IP22
@@ -1022,6 +1029,13 @@ config HPET
 	  open selects one of the timers supported by the HPET.  The timers are
 	  non-periodic and/or periodic.

+config HPET_MAX_USER_FREQ
+	int "User interrupt frequency"
+	depends on HPET
+	default "1024"
+	help
+	  Default value of user interrupt frequency(/proc/sys/dev/hpet/max-user-freq).
+
 config HPET_RTC_IRQ
 	bool "HPET Control RTC IRQ" if !HPET_EMULATE_RTC
 	default n
diff -Nupar linux-2.6.22-cfs-19/drivers/char/rtc.c
linux-2.6.22-cfs-19.niam/drivers/char/rtc.c
--- linux-2.6.22-cfs-19/drivers/char/rtc.c	2007-07-10 20:57:15.000000000 +0300
+++ linux-2.6.22-cfs-19.niam/drivers/char/rtc.c	2007-08-02
01:33:48.000000000 +0300
@@ -191,7 +191,7 @@ static int rtc_proc_open(struct inode *i
 static unsigned long rtc_status = 0;	/* bitmapped status byte.	*/
 static unsigned long rtc_freq = 0;	/* Current periodic IRQ rate	*/
 static unsigned long rtc_irq_data = 0;	/* our output to the world	*/
-static unsigned long rtc_max_user_freq = 64; /* > this, need
CAP_SYS_RESOURCE */
+static unsigned long rtc_max_user_freq = CONFIG_RTC_MAX_USER_FREQ; /*
> this, need CAP_SYS_RESOURCE */

 #ifdef RTC_IRQ
 /*
