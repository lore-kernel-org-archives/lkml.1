Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbYETSDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbYETSDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYETSDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:03:05 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:41611 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYETSDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:03:04 -0400
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH] gpiolib: Fix off by one errors
Date: Tue, 20 May 2008 10:58:04 -0700
Message-Id: <1211306284-22469-1-git-send-email-xyzzy@speakeasy.org>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last gpio belonging to a chip is chip->base + chip->ngpios - 1.  Some
places in the code, but not all, forgot the critical minus one.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
---
 drivers/gpio/gpiolib.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 7f138c6..beaf6b3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -127,7 +127,7 @@ int __init gpiochip_reserve(int start, int ngpio)
 	unsigned long flags;
 	int i;
 
-	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio))
+	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio - 1))
 		return -EINVAL;
 
 	spin_lock_irqsave(&gpio_lock, flags);
@@ -170,7 +170,7 @@ int gpiochip_add(struct gpio_chip *chip)
 	unsigned	id;
 	int		base = chip->base;
 
-	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio))
+	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
 			&& base >= 0) {
 		status = -EINVAL;
 		goto fail;
@@ -207,7 +207,7 @@ fail:
 	/* failures here can mean systems won't boot... */
 	if (status)
 		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
-			chip->base, chip->base + chip->ngpio,
+			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
 	return status;
 }
-- 
1.5.4.1

