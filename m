Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYHUHR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYHUHR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYHUHRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:17:50 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:46674 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYHUHRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=ebgFL2E0kJs+v2A87fFNlLmBpnOoOGFP8C8AFPrg4I55fNoIcmQU6sG2OH8m3EJhHv
         H+aAp5tsBU83iiTFMUPERFShNV+dn4uuDMzjvb7Khvw27DUaZDAW7PYv/8j8qI81kaPB
         g+iLNc3zW03mqd87uGTiDRCuFQLt+XupBWhnY=
Date: Thu, 21 Aug 2008 09:17:50 +0200
To: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org
Subject: [RESEND][RFC][PATCH] leds: fix oops race in led trigger
	registration
Message-ID: <20080821071750.GA8046@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I resubmit this, which was posted a month ago, with no responses from
the maintainer (and no recent fixes in this area either). I have not
tested it myself, but I am reasonably confident that this is an
obviously correct fix. I guess it would not hurt to exercise it as well.

Zdenek: Have recent kernels also been showing this behaviour? Did the
patch fix the problem for you? You said something about a new issue
showing up, do you think that was related to this patch?

Also, just one question (since I'm newbie at this): Is it dangerous to
register the &dev_attr_trigger device file before we put the device on
the list or initialize it completely? If so, the initialization should
probably be moved all to the top before the file is made public.


Vegard


>From ed99f8da46d90fa7ff058e1d8912d3abc7d6b3ca Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 21 Aug 2008 08:39:06 +0200
Subject: [PATCH] leds: fix oops race in led trigger registration

Zdenek Kabelac reported:
> I'm getting this oops while using 64bit kernel and running mostly
> 32bit system.
> This one happens sometimes during boot - unpredictible - usually
> once in 15 boots.

> BUG: spinlock bad magic on CPU#1, modprobe/815
>  lock: ffffffffa014f350, .magic: 00000000, .owner: modprobe/815, .owner_cpu: 1
> Pid: 815, comm: modprobe Not tainted 2.6.26 #44
>
> Call Trace:
>  [<ffffffff81060a87>] ? put_lock_stats+0x27/0x30
>  [<ffffffff81186c02>] spin_bug+0xa2/0xf0
>  [<ffffffff81186c71>] _raw_spin_unlock+0x21/0xa0
>  [<ffffffff812fa57f>] _spin_unlock_irqrestore+0x2f/0x90
>  [<ffffffff8117f36d>] __down_write_trylock+0x3d/0x60
>  [<ffffffff812f8c30>] down_write+0x40/0x70
>  [<ffffffff81263c17>] led_trigger_register+0xb7/0x110
>  [<ffffffff81263cae>] led_trigger_register_simple+0x3e/0x80
>  [<ffffffffa009b36e>] :mmc_core:mmc_add_host+0x3e/0x80

I find it likely that the cause of this is the fact that the cdev is
added to the list of leds before init_rwsem() is called. So we fix
this by reordering the initialization code a little. The fact that it
also happens unpredictably is also the sign of a race.

Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/leds/led-class.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 559a408..44d13ac 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -113,13 +113,6 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	if (rc)
 		goto err_out;
 
-	/* add to the list of leds */
-	down_write(&leds_list_lock);
-	list_add_tail(&led_cdev->node, &leds_list);
-	up_write(&leds_list_lock);
-
-	led_update_brightness(led_cdev);
-
 #ifdef CONFIG_LEDS_TRIGGERS
 	init_rwsem(&led_cdev->trigger_lock);
 
@@ -130,6 +123,13 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	led_trigger_set_default(led_cdev);
 #endif
 
+	led_update_brightness(led_cdev);
+
+	/* add to the list of leds */
+	down_write(&leds_list_lock);
+	list_add_tail(&led_cdev->node, &leds_list);
+	up_write(&leds_list_lock);
+
 	printk(KERN_INFO "Registered led device: %s\n",
 			led_cdev->name);
 
@@ -138,7 +138,6 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 #ifdef CONFIG_LEDS_TRIGGERS
 err_out_led_list:
 	device_remove_file(led_cdev->dev, &dev_attr_brightness);
-	list_del(&led_cdev->node);
 #endif
 err_out:
 	device_unregister(led_cdev->dev);
-- 
1.5.5.1

