Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbZBDHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbZBDHyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 02:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZBDHxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 02:53:55 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:35907 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751540AbZBDHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 02:53:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RQDb/YUy/pFidyo+eruSl+NFjXfqJNldUBJUr3RAtI7s3//IESJLBDmho2AWjk7u92hMGyw8SJCRpCzVefbnQQhxh4DWnbszuqjTP5/StfYp/qBvIscZdPM8bqLOns77ClSXZUGLy8gXGuWhIhtREyVsLcDtgWRNH7iLbZ95ez0=  ;
X-YMail-OSG: e6_V37EVM1l0NRKKa1wnwyMlSAb3YDMTI1rRSrkuxg792KrJVGRbqezq2xpw5Cb5xhhSmacJFMGhP8PK4XZvKaVJGFHl0IzDAznf0orgvKp1wO98dI4_zkBX0CrJgSjJMJk5B8kW6AlOqO1vdZnWS3iS6s9G1VsIJ7aL2xLNQh4ACLrByuWA6EqJHJCK1FJbx63XaE5Mhlq64nwvZv1fbYYBpECX0.ue3z4olQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.29-rc3] gpio:  gpio_{request,free}() now required (feature removal)
Date: Tue, 3 Feb 2009 14:35:22 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031435.22293.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

We want to phase out the GPIO "autorequest" mechanism in gpiolib
and require all callers to use gpio_request().  

 - Update feature-removal-schedule
 - Update the documentation now
 - Convert the relevant pr_warning() in gpiolib to a WARN()
   so folk using this mechanism get a noisy stack dump

Some drivers and board init code will probably need to change.
Implementations not using gpiolib will still be fine; they are
already required to implement gpio_{request,free}() stubs.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 Documentation/gpio.txt                     |   23 +++++++++--------------
 drivers/gpio/gpiolib.c                     |   12 ++++++++----
 3 files changed, 29 insertions(+), 18 deletions(-)

--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -335,3 +335,15 @@ Why:	In 2.6.18 the Secmark concept was i
 	Secmark, it is time to deprecate the older mechanism and start the
 	process of removing the old code.
 Who:	Paul Moore <paul.moore@hp.com>
+
+---------------------------
+
+What:	GPIO autorequest on gpio_direction_{input,output}() in gpiolib
+When:	February 2010
+Why:	All callers should use explicit gpio_request()/gpio_free().
+	The autorequest mechanism in gpiolib was provided mostly as a
+	migration aid for legacy GPIO interfaces (for SOC based GPIOs).
+	Those users have now largely migrated.  Platforms implementing
+	the GPIO interfaces without using gpiolib will see no changes.
+Who:	David Brownell <dbrownell@users.sourceforge.net>
+
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -123,7 +123,10 @@ platform-specific implementation issue.
 
 Using GPIOs
 -----------
-One of the first things to do with a GPIO, often in board setup code when
+The first thing a system should do with a GPIO is allocate it, using
+the gpio_request() call; see later.
+
+One of the next things to do with a GPIO, often in board setup code when
 setting up a platform_device using the GPIO, is mark its direction:
 
 	/* set as input or output, returning 0 or negative errno */
@@ -141,8 +144,8 @@ This helps avoid signal glitching during
 
 For compatibility with legacy interfaces to GPIOs, setting the direction
 of a GPIO implicitly requests that GPIO (see below) if it has not been
-requested already.  That compatibility may be removed in the future;
-explicitly requesting GPIOs is strongly preferred.
+requested already.  That compatibility is being removed from the optional
+gpiolib framework.
 
 Setting the direction can fail if the GPIO number is invalid, or when
 that particular GPIO can't be used in that mode.  It's generally a bad
@@ -195,7 +198,7 @@ This requires sleeping, which can't be d
 
 Platforms that support this type of GPIO distinguish them from other GPIOs
 by returning nonzero from this call (which requires a valid GPIO number,
-either explicitly or implicitly requested):
+which should have been previously allocated with gpio_request):
 
 	int gpio_cansleep(unsigned gpio);
 
@@ -212,10 +215,9 @@ for GPIOs that can't be accessed from IR
 same as the spinlock-safe calls.
 
 
-Claiming and Releasing GPIOs (OPTIONAL)
----------------------------------------
+Claiming and Releasing GPIOs
+----------------------------
 To help catch system configuration errors, two calls are defined.
-However, many platforms don't currently support this mechanism.
 
 	/* request GPIO, returning 0 or negative errno.
 	 * non-null labels may be useful for diagnostics.
@@ -244,13 +246,6 @@ Some platforms may also use knowledge ab
 power management, such as by powering down unused chip sectors and, more
 easily, gating off unused clocks.
 
-These two calls are optional because not not all current Linux platforms
-offer such functionality in their GPIO support; a valid implementation
-could return success for all gpio_request() calls.  Unlike the other calls,
-the state they represent doesn't normally match anything from a hardware
-register; it's just a software bitmap which clearly is not necessary for
-correct operation of hardware or (bug free) drivers.
-
 Note that requesting a GPIO does NOT cause it to be configured in any
 way; it just marks that GPIO as in use.  Separate code must handle any
 pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -69,20 +69,24 @@ static inline void desc_set_label(struct
  * those calls have no teeth) we can't avoid autorequesting.  This nag
  * message should motivate switching to explicit requests... so should
  * the weaker cleanup after faults, compared to gpio_request().
+ *
+ * NOTE: the autorequest mechanism is going away; at this point it's
+ * only "legal" in the sense that (old) code using it won't break yet,
+ * but instead only triggers a WARN() stack dump.
  */
 static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 {
-	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
-		struct gpio_chip *chip = desc->chip;
-		int gpio = chip->base + offset;
+	const struct gpio_chip *chip = desc->chip;
+	const int gpio = chip->base + offset;
 
+	if (WARN(test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0,
+			"autorequest GPIO-%d\n", gpio)) {
 		if (!try_module_get(chip->owner)) {
 			pr_err("GPIO-%d: module can't be gotten \n", gpio);
 			clear_bit(FLAG_REQUESTED, &desc->flags);
 			/* lose */
 			return -EIO;
 		}
-		pr_warning("GPIO-%d autorequested\n", gpio);
 		desc_set_label(desc, "[auto]");
 		/* caller must chip->request() w/o spinlock */
 		if (chip->request)
