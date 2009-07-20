Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZGTUU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZGTUU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZGTUU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:20:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752537AbZGTUU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:20:56 -0400
Date: Mon, 20 Jul 2009 13:19:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net, bjorn.helgaas@hp.com,
       cascardo@holoscopio.com, Alessandro Zummo <a.zummo@towertech.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] RTC: mark if rtc-cmos drivers were successfully
 registered.
Message-Id: <20090720131959.3b157627.akpm@linux-foundation.org>
In-Reply-To: <1246766879-5784-1-git-send-email-cascardo@holoscopio.com>
References: <1246766879-5784-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Jul 2009 01:07:59 -0300
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> rtc-cmos has two drivers, one PNP and one platform. When PNP has not
> succeeded probing, platform is registered. However, it tries to
> unregister both drivers unconditionally, instead of only unregistering
> those that were successfully registered. Fix that with a boolean
> variable for each driver indicating whether registering was successful.

OK, thanks.  

This came up a few weeks ago - the kernel was actually crashing deep
down in the driver core, when a not-registered device was unregistered.

I believe Kay was planning on making the driver core more robust, so
that crash shouldn't be happening any more.  Kay, can you please confirm
that thsi got fixed?


But we still shouldn't be unregistering a not-registered driver, and
the patch looks to be a suitable way of preventing that.

Alternatively, we could declare that unregistering a not-registered
driver is a permissible thing for a subsytem to do.  It doesn't sound
like a good idea though - we'd lose runtime checking opportunities.


 drivers/rtc/rtc-cmos.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-mark-if-rtc-cmos-drivers-were-successfully-registered drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-mark-if-rtc-cmos-drivers-were-successfully-registered
+++ a/drivers/rtc/rtc-cmos.c
@@ -1174,23 +1174,34 @@ static struct platform_driver cmos_platf
 	}
 };
 
+#ifdef CONFIG_PNP
+static bool pnp_driver_registered;
+#endif
+static bool platform_driver_registered;
+
 static int __init cmos_init(void)
 {
 	int retval = 0;
 
 #ifdef	CONFIG_PNP
-	pnp_register_driver(&cmos_pnp_driver);
+	retval = pnp_register_driver(&cmos_pnp_driver);
+	if (retval == 0)
+		pnp_driver_registered = true;
 #endif
 
-	if (!cmos_rtc.dev)
+	if (!cmos_rtc.dev) {
 		retval = platform_driver_probe(&cmos_platform_driver,
 					       cmos_platform_probe);
+		if (retval == 0)
+			platform_driver_registered = true;
+	}
 
 	if (retval == 0)
 		return 0;
 
 #ifdef	CONFIG_PNP
-	pnp_unregister_driver(&cmos_pnp_driver);
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&cmos_pnp_driver);
 #endif
 	return retval;
 }
@@ -1199,9 +1210,11 @@ module_init(cmos_init);
 static void __exit cmos_exit(void)
 {
 #ifdef	CONFIG_PNP
-	pnp_unregister_driver(&cmos_pnp_driver);
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&cmos_pnp_driver);
 #endif
-	platform_driver_unregister(&cmos_platform_driver);
+	if (platform_driver_registered)
+		platform_driver_unregister(&cmos_platform_driver);
 }
 module_exit(cmos_exit);
 
_


