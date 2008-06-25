Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYFYJvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYFYJvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYFYJvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:51:00 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:2617 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbYFYJu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xbd0o1YIzCfZ4xL/XdTyQcoRWhipwVzfrwL+2r40fpeb4SHEJMvxx8l5EKLz5ovxc2
         zQqLkhZqEiFcGRM3Y6g1WpDsznjs9U4j4NFIXgpKfMX3fjS9QJbhwkuFLUt2LD/3fr1z
         ln33jVE73oi6IvroGhBFQCJjqJXaeXlMISf9g=
Date: Wed, 25 Jun 2008 13:50:46 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH] leds: make sure led->trigger is valid before calling
	trigger->activate
Message-ID: <20080625095046.GB6950@doriath.ww600.siemens.net>
References: <20080619114847.GA13752@doriath.ww600.siemens.net> <20080624140235.ef3f4d52.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624140235.ef3f4d52.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 02:02:35PM -0700, Andrew Morton wrote:
> 
> The changelog tells us what the patch does, but it doesn't tell us
> why it does it.
> 
> This matters.  For a start, there is no way in which I (at least)
> am able to determine whether this change is needed in 2.6.26 nor
> in 2.6.25.x.

I hope this is better. This isn't an 2.6.25.x material. And probably not
an 2.6.26.

>From 4ce3598c6ce5e6b529a05432b18996a99cc5bf0d Mon Sep 17 00:00:00 2001
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
Date: Wed, 25 Jun 2008 13:48:07 +0400
Subject: [PATCH] leds: make sure led->trigger is valid before calling trigger->activate

This is necessary if one wants to use the led->trigger field during
trigger activation for a led (e.g. to set up the state of the led).
No current drivers depend on this.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/leds/led-triggers.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 0f242b3..f910eaf 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -111,16 +111,17 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
 			flags);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
+		led_cdev->trigger = NULL;
 		led_set_brightness(led_cdev, LED_OFF);
 	}
 	if (trigger) {
 		write_lock_irqsave(&trigger->leddev_list_lock, flags);
 		list_add_tail(&led_cdev->trig_list, &trigger->led_cdevs);
 		write_unlock_irqrestore(&trigger->leddev_list_lock, flags);
+		led_cdev->trigger = trigger;
 		if (trigger->activate)
 			trigger->activate(led_cdev);
 	}
-	led_cdev->trigger = trigger;
 }
 EXPORT_SYMBOL_GPL(led_trigger_set);
 
-- 
1.5.5.4


-- 
With best wishes
Dmitry

