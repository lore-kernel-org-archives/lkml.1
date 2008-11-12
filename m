Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYKLAld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYKLAld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYKLA04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:56 -0500
Received: from kroah.org ([198.145.64.141]:42596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752246AbYKLA0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:55 -0500
Date: Tue, 11 Nov 2008 16:24:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Pavel Machek <pavel@suse.cz>
Subject: [patch 40/49] ARM: 5300/1: fixup spitz reset during boot
Message-ID: <20081112002418.GO10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="arm-5300-1-fixup-spitz-reset-during-boot.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Baryshkov <dbaryshkov@gmail.com>

commit 69fc7eed5f56bce15b239e5110de2575a6970df4 upstream

Some machines don't have the pullup/down on their reset
pin, so configuring the reset generating pin as input makes
them reset immediately. Fix that by making reset pin direction
configurable.

This fixes the boot problem on Sharp Zaurus c3000

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/include/mach/reset.h |    9 ++++++---
 arch/arm/mach-pxa/reset.c              |    9 ++++++---
 arch/arm/mach-pxa/spitz.c              |    2 +-
 arch/arm/mach-pxa/tosa.c               |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

--- a/arch/arm/mach-pxa/include/mach/reset.h
+++ b/arch/arm/mach-pxa/include/mach/reset.h
@@ -10,9 +10,12 @@
 extern unsigned int reset_status;
 extern void clear_reset_status(unsigned int mask);
 
-/*
- * register GPIO as reset generator
+/**
+ * init_gpio_reset() - register GPIO as reset generator
+ *
+ * @gpio - gpio nr
+ * @output - set gpio as out/low instead of input during normal work
  */
-extern int init_gpio_reset(int gpio);
+extern int init_gpio_reset(int gpio, int output);
 
 #endif /* __ASM_ARCH_RESET_H */
--- a/arch/arm/mach-pxa/reset.c
+++ b/arch/arm/mach-pxa/reset.c
@@ -20,7 +20,7 @@ static void do_hw_reset(void);
 
 static int reset_gpio = -1;
 
-int init_gpio_reset(int gpio)
+int init_gpio_reset(int gpio, int output)
 {
 	int rc;
 
@@ -30,9 +30,12 @@ int init_gpio_reset(int gpio)
 		goto out;
 	}
 
-	rc = gpio_direction_input(gpio);
+	if (output)
+		rc = gpio_direction_output(gpio, 0);
+	else
+		rc = gpio_direction_input(gpio);
 	if (rc) {
-		printk(KERN_ERR "Can't configure reset_gpio for input\n");
+		printk(KERN_ERR "Can't configure reset_gpio\n");
 		gpio_free(gpio);
 		goto out;
 	}
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -548,7 +548,7 @@ static void spitz_restart(char mode)
 
 static void __init common_init(void)
 {
-	init_gpio_reset(SPITZ_GPIO_ON_RESET);
+	init_gpio_reset(SPITZ_GPIO_ON_RESET, 1);
 	pm_power_off = spitz_poweroff;
 	arm_pm_restart = spitz_restart;
 
--- a/arch/arm/mach-pxa/tosa.c
+++ b/arch/arm/mach-pxa/tosa.c
@@ -781,7 +781,7 @@ static void __init tosa_init(void)
 	gpio_set_wake(MFP_PIN_GPIO1, 1);
 	/* We can't pass to gpio-keys since it will drop the Reset altfunc */
 
-	init_gpio_reset(TOSA_GPIO_ON_RESET);
+	init_gpio_reset(TOSA_GPIO_ON_RESET, 0);
 
 	pm_power_off = tosa_poweroff;
 	arm_pm_restart = tosa_restart;

-- 
