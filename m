Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYIRPRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYIRPRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbYIRPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:17:32 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:9304 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754236AbYIRPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:17:31 -0400
Date: Thu, 18 Sep 2008 19:17:29 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Message-ID: <20080918151729.GA31187@oksana.dev.rtsoft.ru>
References: <20080918151659.GA20140@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080918151659.GA20140@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need this function to write platform-specific hooks to deal
with pin's dedicated functions. Quite obviously this will work only
for the platforms with 1-to-1 GPIO to PIN mapping.

This is stopgap solution till we think out and implement a proper
api (pinlib?).

p.s. This patch actually exports gpio_desc and places gpio_to_chip
into the asm-generic/gpio.h as `static inline'. This is needed
to not cause function calls for this trivial translation.

Also, the patch does not export FLAG_*s... the names are too
generic, and nobody is using them outside of gpiolib.c.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c     |   16 ++--------------
 include/asm-generic/gpio.h |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8d29405..fb36a90 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -40,9 +40,6 @@
  */
 static DEFINE_SPINLOCK(gpio_lock);
 
-struct gpio_desc {
-	struct gpio_chip	*chip;
-	unsigned long		flags;
 /* flag symbols are bit numbers */
 #define FLAG_REQUESTED	0
 #define FLAG_IS_OUT	1
@@ -50,11 +47,8 @@ struct gpio_desc {
 #define FLAG_EXPORT	3	/* protected by sysfs_lock */
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
 
-#ifdef CONFIG_DEBUG_FS
-	const char		*label;
-#endif
-};
-static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
+struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
+EXPORT_SYMBOL_GPL(gpio_desc);
 
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
 {
@@ -80,12 +74,6 @@ static void gpio_ensure_requested(struct gpio_desc *desc)
 	}
 }
 
-/* caller holds gpio_lock *OR* gpio is marked as requested */
-static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
-{
-	return gpio_desc[gpio].chip;
-}
-
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
 static int gpiochip_find_base(int ngpio)
 {
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 0f99ad3..88962f0 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -81,6 +81,23 @@ struct gpio_chip {
 	unsigned		exported:1;
 };
 
+struct gpio_desc {
+	struct gpio_chip	*chip;
+	unsigned long		flags;
+
+#ifdef CONFIG_DEBUG_FS
+	const char		*label;
+#endif
+};
+
+extern struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
+
+/* caller holds gpio_lock *OR* gpio is marked as requested */
+static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
+{
+	return gpio_desc[gpio].chip;
+}
+
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
 extern int __must_check gpiochip_reserve(int start, int ngpio);
-- 
1.5.6.3

