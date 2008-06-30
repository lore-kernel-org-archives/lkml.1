Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYF3Du6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYF3Du6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 23:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYF3Duu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 23:50:50 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:23115 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751869AbYF3Duu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 23:50:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:To:Subject:Cc:Content-Disposition:From:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=CmvvaTvfTPaf3J1jxd2CpoVhxpV6ol6rs4c6OEpZh8q8oRpVpCKOf+LYO2kxuwzPioqkn68MPzH74Ksp276uXZaGCsDs4v0tIo0qSAXy7nMZLWOmhQv/XAdmA/envMSuwmQsHh/jHEElnT5McN0u03wj5/yjnI4q0JgGBL22fjQ=  ;
X-YMail-OSG: 6SfUq.oVM1lX_2aLjVWvcQSsEjtYE_TqkZ7.curdcPTjPnoUmyJB2wm8c1bUBa5OGy_EjjE_0bxBSlYqJjOg3xATnqIGYbJmbQ174u6WRqmvKA3wc0UhdhHg0vFuG5V8Vkc-
X-Yahoo-Newman-Property: ymail-3
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc6-mm] gpio: updates to sysfs support
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: David Brownell <david-b@pacbell.net>
Date: Sun, 29 Jun 2008 20:50:45 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806292050.45405.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update and bugfix the patch adding sysfs GPIO support:

  * Bugfix:  the test initializing the IS_OUT flag for output-only
    GPIOs had the sense inverted.

  * Update:  when gpio_chip.dev is provided, list it in the debugfs
    dump.  Device nodes are unique; the "label" isn't.

The bug of course caused output-only GPIOs to misbehave, but it also
made just-exported (or generally:  only-requested) GPIOs always appear
to be outputs in sysfs and debugfs.  That's wrong more often than it's
right, although it gets corrected when the direction is assigned.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpiolib.c	2008-06-17 23:15:17.000000000 -0700
+++ b/drivers/gpio/gpiolib.c	2008-06-18 09:48:32.000000000 -0700
@@ -685,7 +685,14 @@ int gpiochip_add(struct gpio_chip *chip)
 	if (status == 0) {
 		for (id = base; id < base + chip->ngpio; id++) {
 			gpio_desc[id].chip = chip;
-			gpio_desc[id].flags = chip->direction_input
+
+			/* REVISIT:  most hardware initializes GPIOs as
+			 * inputs (often with pullups enabled) so power
+			 * usage is minimized.  Linux code should set the
+			 * gpio direction first thing; but until it does,
+			 * we may expose the wrong direction in sysfs.
+			 */
+			gpio_desc[id].flags = !chip->direction_input
 				? (1 << FLAG_IS_OUT)
 				: 0;
 		}
@@ -1108,17 +1115,28 @@ static int gpiolib_show(struct seq_file 
 	/* REVISIT this isn't locked against gpio_chip removal ... */
 
 	for (gpio = 0; gpio_is_valid(gpio); gpio++) {
+		struct device *dev;
+
 		if (chip == gpio_desc[gpio].chip)
 			continue;
 		chip = gpio_desc[gpio].chip;
 		if (!chip)
 			continue;
 
-		seq_printf(s, "%sGPIOs %d-%d, %s%s:\n",
+		seq_printf(s, "%sGPIOs %d-%d",
 				started ? "\n" : "",
-				chip->base, chip->base + chip->ngpio - 1,
-				chip->label ? : "generic",
-				chip->can_sleep ? ", can sleep" : "");
+				chip->base, chip->base + chip->ngpio - 1);
+		dev = chip->dev;
+		if (dev)
+			seq_printf(s, ", %s/%s",
+				dev->bus ? dev->bus->name : "no-bus",
+				dev->bus_id);
+		if (chip->label)
+			seq_printf(s, ", %s", chip->label);
+		if (chip->can_sleep)
+			seq_printf(s, ", can sleep");
+		seq_printf(s, ":\n");
+
 		started = 1;
 		if (chip->dbg_show)
 			chip->dbg_show(s, chip);
