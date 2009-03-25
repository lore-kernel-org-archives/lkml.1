Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbZCYN6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbZCYN6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756412AbZCYN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:58:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46168 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbZCYN6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:58:07 -0400
From: Subrata Modak <tosubrata@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Sachin Sant <sachinp@in.ibm.com>, Subrata Modak <tosubrata@gmail.com>,
       netdev <netdev@vger.kernel.org>, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 25 Mar 2009 19:27:59 +0530
Message-Id: <20090325135759.4397.53055.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH] Re: Next March 25: net/netfilter/xt_LED build failure.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>Today's next randconfig build on x86 failed with following error.
>
>net/netfilter/xt_LED.c:40: error: field netfilter_led_trigger has incomplete type
>net/netfilter/xt_LED.c: In function led_timeout_callback:
>net/netfilter/xt_LED.c:78: warning: unused variable ledinternal
>net/netfilter/xt_LED.c: In function led_tg_check:
>net/netfilter/xt_LED.c:102: error: implicit declaration of function led_trigger_register
>net/netfilter/xt_LED.c: In function led_tg_destroy:
>net/netfilter/xt_LED.c:135: error: implicit declaration of function led_trigger_unregister
>
>CONFIG_LED_TRIGGER is not set.
>
>complete .config attached.

The following patch will solve the build problem reported by Sachin.
But would leave the following warnings. I hope we can ignore them:

net/netfilter/xt_LED.c: In function ‘led_timeout_callback’:
net/netfilter/xt_LED.c:78: warning: unused variable ‘ledinternal’
net/netfilter/xt_LED.c: In function ‘led_tg_check’:
net/netfilter/xt_LED.c:87: warning: unused variable ‘err’

Signed-Off-By: Subrata Modak<subrata@linux.vnet.ibm.com>
---

--- a/linux-2.6.29/include/linux/leds.h	2009-03-25 18:38:07.000000000 +0530
+++ b/linux-2.6.29/include/linux/leds.h	2009-03-25 18:24:55.000000000 +0530
@@ -73,9 +73,6 @@ extern void led_classdev_resume(struct l
 /*
  * LED Triggers
  */
-#ifdef CONFIG_LEDS_TRIGGERS
-
-#define TRIG_NAME_MAX 50
 
 struct led_trigger {
 	/* Trigger Properties */
@@ -91,6 +88,10 @@ struct led_trigger {
 	struct list_head  next_trig;
 };
 
+#ifdef CONFIG_LEDS_TRIGGERS
+
+#define TRIG_NAME_MAX 50
+
 /* Registration functions for complex triggers */
 extern int led_trigger_register(struct led_trigger *trigger);
 extern void led_trigger_unregister(struct led_trigger *trigger);
--- a/linux-2.6.29/net/netfilter/xt_LED.c	2009-03-25 18:38:08.000000000 +0530
+++ b/linux-2.6.29/net/netfilter/xt_LED.c	2009-03-25 18:26:55.000000000 +0530
@@ -99,6 +99,7 @@ static bool led_tg_check(const struct xt
 
 	ledinternal->netfilter_led_trigger.name = ledinfo->id;
 
+#ifdef CONFIG_LEDS_TRIGGERS
 	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
 	if (err) {
 		printk(KERN_CRIT KBUILD_MODNAME
@@ -108,7 +109,7 @@ static bool led_tg_check(const struct xt
 				": Trigger name is already in use.\n");
 		goto exit_alloc;
 	}
-
+#endif
 	/* See if we need to set up a timer */
 	if (ledinfo->delay > 0)
 		setup_timer(&ledinternal->timer, led_timeout_callback,
@@ -118,8 +119,10 @@ static bool led_tg_check(const struct xt
 
 	return true;
 
+#ifdef CONFIG_LEDS_TRIGGERS
 exit_alloc:
 	kfree(ledinternal);
+#endif
 
 	return false;
 }
@@ -132,7 +135,9 @@ static void led_tg_destroy(const struct 
 	if (ledinfo->delay > 0)
 		del_timer_sync(&ledinternal->timer);
 
+#ifdef CONFIG_LEDS_TRIGGERS
 	led_trigger_unregister(&ledinternal->netfilter_led_trigger);
+#endif
 	kfree(ledinternal);
 }

--
Regards--
Subrata
 
