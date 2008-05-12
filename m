Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbYELKR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbYELKR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbYELKRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:17:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:29268 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbYELKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=kQ70lcvFeU8CTTAYvUBVLfqcOALH6U9EPwcKMCDXn1TOt8Si3KlT2USeGFBOQHigNOfVTDMcsgGUfjJ8Tl9u0DEiW99HT5glG2vSfSv9PKcDUX5sqMOhtp9FwSFhVCMwP2UpUHP8qPq2pJ7iIG5vWw4W7FID7sOTo4CLuuZGZoo=
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, dmitry.torokhov@gmail.com,
       philipp.zabel@gmail.com
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Date: Mon, 12 May 2008 18:17:17 +0800
Message-Id: <1210587437-9751-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

It's an actual deficiency in the hardware that we can't address,
so it needs to be worked around in software.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/input/keyboard/gpio_keys.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index bbd00c3..d856eb9 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -26,6 +26,18 @@
 
 #include <asm/gpio.h>
 
+#if defined(CONFIG_BLACKFIN) && !defined(BF548_FAMILY)
+
+/*
+ * On some Blackfin CPUs reading edge triggered
+ * GPIOs doesn't return the current value
+ */
+
+#define GPIOKEYS_EDGE_SENSE(x) set_gpio_edge(gpio, x)
+#else
+#define GPIOKEYS_EDGE_SENSE(x) do {} while (0)
+#endif
+
 static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 {
 	int i;
@@ -39,8 +51,9 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 
 		if (irq == gpio_to_irq(gpio)) {
 			unsigned int type = button->type ?: EV_KEY;
+			GPIOKEYS_EDGE_SENSE(0);
 			int state = (gpio_get_value(gpio) ? 1 : 0) ^ button->active_low;
-
+			GPIOKEYS_EDGE_SENSE(1);
 			input_event(input, type, button->code, !!state);
 			input_sync(input);
 			return IRQ_HANDLED;
-- 
1.5.5

