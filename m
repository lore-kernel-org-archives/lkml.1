Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZDNJm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZDNJm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 05:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZDNJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 05:39:48 -0400
Received: from mx1.emlix.com ([193.175.82.87]:49154 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZDNJjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 05:39:42 -0400
From: Johannes Weiner <jw@emlix.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org
Subject: [patch 02/12] xtensa: register gpio chip before use
Date: Tue, 14 Apr 2009 11:41:10 +0200
Message-Id: <1239702080-14355-3-git-send-email-jw@emlix.com>
In-Reply-To: <1239702080-14355-1-git-send-email-jw@emlix.com>
References: <1239702080-14355-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform initialization sets up the LED heartbeat that is controlled
via GPIO.  Requesting the GPIO pins fails, however, as the chip is
only initialized later by a device_initcall().

Fix this up by exporting the initialization function.  Let the
platform set up the chip before it starts using it.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 arch/xtensa/platforms/s6105/setup.c               |    3 +++
 arch/xtensa/variants/s6000/gpio.c                 |    3 +--
 arch/xtensa/variants/s6000/include/variant/gpio.h |    6 ++++++
 3 files changed, 10 insertions(+), 2 deletions(-)
 create mode 100644 arch/xtensa/variants/s6000/include/variant/gpio.h

diff --git a/arch/xtensa/platforms/s6105/setup.c b/arch/xtensa/platforms/s6105/setup.c
index ae041d5..855ddea 100644
--- a/arch/xtensa/platforms/s6105/setup.c
+++ b/arch/xtensa/platforms/s6105/setup.c
@@ -10,6 +10,8 @@
 #include <asm/bootparam.h>
 
 #include <variant/hardware.h>
+#include <variant/gpio.h>
+
 #include <platform/gpio.h>
 
 void platform_halt(void)
@@ -47,6 +49,7 @@ void __init platform_setup(char **cmdline)
 
 void __init platform_init(bp_tag_t *first)
 {
+	s6_gpio_init();
 	gpio_request(GPIO_LED1_NGREEN, "led1_green");
 	gpio_request(GPIO_LED1_RED, "led1_red");
 	gpio_direction_output(GPIO_LED1_NGREEN, 1);
diff --git a/arch/xtensa/variants/s6000/gpio.c b/arch/xtensa/variants/s6000/gpio.c
index 33a8d95..79317fd 100644
--- a/arch/xtensa/variants/s6000/gpio.c
+++ b/arch/xtensa/variants/s6000/gpio.c
@@ -64,8 +64,7 @@ static struct gpio_chip gpiochip = {
 	.exported = 0, /* no exporting to userspace */
 };
 
-static int gpio_init(void)
+int s6_gpio_init(void)
 {
 	return gpiochip_add(&gpiochip);
 }
-device_initcall(gpio_init);
diff --git a/arch/xtensa/variants/s6000/include/variant/gpio.h b/arch/xtensa/variants/s6000/include/variant/gpio.h
new file mode 100644
index 0000000..8327f62
--- /dev/null
+++ b/arch/xtensa/variants/s6000/include/variant/gpio.h
@@ -0,0 +1,6 @@
+#ifndef _XTENSA_VARIANT_S6000_GPIO_H
+#define _XTENSA_VARIANT_S6000_GPIO_H
+
+extern int s6_gpio_init(void);
+
+#endif /* _XTENSA_VARIANT_S6000_GPIO_H */
-- 
1.6.2.107.ge47ee

