Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbXGWNg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbXGWNg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbXGWNgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:36:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42980 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbXGWNgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:36:07 -0400
Date: Mon, 23 Jul 2007 14:36:00 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, acpi4asus-u@pimp.vs19.net,
       Gabriel C <nix.or.die@googlemail.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [1/2] 2.6.23-rc1: known regressions
Message-ID: <20070723133600.GI21668@ftp.linux.org.uk>
References: <46A47932.8000709@googlemail.com> <Pine.LNX.4.58.0707230404290.5535@shell2.speakeasy.net> <20070723112557.GG21668@ftp.linux.org.uk> <1185196327.6148.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185196327.6148.51.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 02:12:07PM +0100, Richard Purdie wrote:
> Fix the leak where asus-led registration fails half way through.
 
Frankly, I don't think that any post-factum checks are needed.  We
should just bail out at the point of failure.  See the patch posted
earlier...  BTW, your variant does destroy_workqueue() when no
create_singlethreaded_workqueue() had been called.  FWIW, here's
the patch I'm talking about:

diff --git a/drivers/misc/asus-laptop.c b/drivers/misc/asus-laptop.c
index f753060..6b89854 100644
--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -1067,19 +1067,16 @@ static void asus_backlight_exit(void)
 }
 
 #define  ASUS_LED_UNREGISTER(object)				\
-	if(object##_led.class_dev				\
-	   && !IS_ERR(object##_led.class_dev))			\
-		led_classdev_unregister(&object##_led)
+	led_classdev_unregister(&object##_led)
 
 static void asus_led_exit(void)
 {
+	destroy_workqueue(led_workqueue);
 	ASUS_LED_UNREGISTER(mled);
 	ASUS_LED_UNREGISTER(tled);
 	ASUS_LED_UNREGISTER(pled);
 	ASUS_LED_UNREGISTER(rled);
 	ASUS_LED_UNREGISTER(gled);
-
-	destroy_workqueue(led_workqueue);
 }
 
 static void __exit asus_laptop_exit(void)
@@ -1135,29 +1132,42 @@ static int asus_led_init(struct device *dev)
 
 	rv = ASUS_LED_REGISTER(mled, dev);
 	if (rv)
-		return rv;
+		goto out;
 
 	rv = ASUS_LED_REGISTER(tled, dev);
 	if (rv)
-		return rv;
+		goto out1;
 
 	rv = ASUS_LED_REGISTER(rled, dev);
 	if (rv)
-		return rv;
+		goto out2;
 
 	rv = ASUS_LED_REGISTER(pled, dev);
 	if (rv)
-		return rv;
+		goto out3;
 
 	rv = ASUS_LED_REGISTER(gled, dev);
 	if (rv)
-		return rv;
+		goto out4;
 
 	led_workqueue = create_singlethread_workqueue("led_workqueue");
 	if (!led_workqueue)
-		return -ENOMEM;
+		goto out5;
 
 	return 0;
+out5:
+	rv = -ENOMEM;
+	ASUS_LED_UNREGISTER(gled);
+out4:
+	ASUS_LED_UNREGISTER(pled);
+out3:
+	ASUS_LED_UNREGISTER(rled);
+out2:
+	ASUS_LED_UNREGISTER(tled);
+out1:
+	ASUS_LED_UNREGISTER(mled);
+out:
+	return rv;
 }
 
 static int __init asus_laptop_init(void)
-- 
1.5.3.GIT

