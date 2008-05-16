Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYEPUTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYEPUTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYEPUS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:18:56 -0400
Received: from [158.64.110.160] ([158.64.110.160]:49399 "EHLO
	bonbons.gotdns.org" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754226AbYEPUSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:18:55 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2008 16:18:54 EDT
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] Input: i8042 - move Dritek quirk so it also gets applied on resume
Date: Fri, 16 May 2008 22:08:26 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805162208.27593.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, untested
X-SpamProbe: GOOD 0.0000012 885be6c61f25a4f2e8950b6c479862ee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the quirk from from i8042_probe() to i8042_enable_kbd_port()
which is also called during resume.

I think it is safe to ignore failure to enable dritek. I would also prefer not 
to fail complete keyboard initialisation if the extension fails.

---
The Dritek quirk is also required on resume from S2RAM, doing it only at probe
time is not sufficient.


Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
CC: Dmitry Torokhov <dtor@mail.ru>

diff -NurpP linux-2.6.25.4-orig/drivers/input/serio/i8042.c 
linux-2.6.25.4/drivers/input/serio/i8042.c
--- linux-2.6.25.4-orig/drivers/input/serio/i8042.c	2008-04-17 
04:49:44.000000000 +0200
+++ linux-2.6.25.4/drivers/input/serio/i8042.c	2008-05-16 21:37:12.000000000 
+0200
@@ -404,6 +404,15 @@ static int i8042_enable_kbd_port(void)
 		printk(KERN_ERR "i8042.c: Failed to enable KBD port.\n");
 		return -EIO;
 	}
+#ifdef CONFIG_X86
+	if (i8042_dritek) {
+		char param = 0x90;
+		int error = i8042_command(&param, 0x1059);
+		if (error)
+			printk(KERN_WARNING "Failed to enable DRITEK "
+			       "extension: %d\n", error);
+	}
+#endif
 
 	return 0;
 }
@@ -1171,14 +1179,6 @@ static int __devinit i8042_probe(struct 
 		if (error)
 			goto out_fail;
 	}
-#ifdef CONFIG_X86
-	if (i8042_dritek) {
-		char param = 0x90;
-		error = i8042_command(&param, 0x1059);
-		if (error)
-			goto out_fail;
-	}
-#endif
 /*
  * Ok, everything is ready, let's register all serio ports
  */

