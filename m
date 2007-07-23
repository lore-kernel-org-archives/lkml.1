Return-Path: <linux-kernel-owner+w=401wt.eu-S1764476AbXGWKVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764476AbXGWKVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 06:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbXGWKVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 06:21:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44108 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXGWKVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 06:21:39 -0400
Date: Mon, 23 Jul 2007 11:21:34 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Markus <lists4me@web.de>,
       Andre Noll <maan@systemlinux.org>, acpi4asus-user@lists.sourceforge.net,
       Corentin Chary <corentincj@iksaif.net>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Gabriel C <nix.or.die@googlemail.com>, Netdev <netdev@vger.kernel.org>,
       Stephen Hemminger <shemminger@osdl.org>, Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [1/2] 2.6.23-rc1: known regressions
Message-ID: <20070723102134.GF21668@ftp.linux.org.uk>
References: <46A47932.8000709@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A47932.8000709@googlemail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 11:47:30AM +0200, Michal Piotrowski wrote:
> Subject         : drivers/misc/asus-laptop.c:*: error: 'struct led_classdev' has no member named 'class_dev'
> References      : http://lkml.org/lkml/2007/7/22/299
> Last known good : ?
> Submitter       : Gabriel C <nix.or.die@googlemail.com>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

>From 2a7e1148a9d3ee860dc2650c9a45288b120e250f Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Mon, 23 Jul 2007 06:20:22 -0400
Subject: [PATCH] Fix failure exits in asus-laptop

Fallout from f8a7c6fe14f556ca8eeddce258cb21392d0c3a2f.  However, looking
at it shows that checks done in ASUS_LED_UNREGISTER() can't trigger
at all (we never get to asus_led_exit() if registration fails) and
if that registration fails, we actually leak stuff.  IOW, it's worse
than just replacing class_dev with dev in there - the tests themselves
had been papering over the lousy cleanup logics.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/asus-laptop.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

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

