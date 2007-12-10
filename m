Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXLJEw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXLJEw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXLJEwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:52:04 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:28972 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751998AbXLJEv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:51:58 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=0c2q6gZWMScqNbK/oY9HIgQwkY2aX7/z+pNAH2zy5f1hrM8k6FRwbqO3rMPuXz6jzR9ZoFMk9EP/4CxZ/lHbarliRQLAgpidGjVXpYUVVzJxWxqxQig9nhKQqQso6dmkJp7iroJY9Vvgsiz0qtc6kzZaq2kcK0WNavXQZd6onZY=  ;
X-YMail-OSG: 2SP_AngVM1n6f5d.Y2CiZQZS1PP_N0MOVInAFlUX5wzc3reh1NS0RgrZV8dmzYHeq7BwmD14Kg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc4-mm 3/6] gpiolib: implementor-oriented documentation
Date: Sun, 9 Dec 2007 20:39:49 -0800
User-Agent: KMail/1.9.6
References: <200712092022.14062.david-b@pacbell.net>
In-Reply-To: <200712092022.14062.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712092039.49618.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add some documentation highlighting implementors' views of the new gpiolib
stuff.  Such developers may be supporting new gpio controllers, platforms,
or boards.  Obviously there's often some overlap there, but the concerns
for each task aren't identical.

This also fixes a minor bug, which turned up as a discrepancy against
the documentation:  if a gpio_chip doesn't have a get() method, just
return zero when asked to read its value.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt |  103 ++++++++++++++++++++++++++++++++++++++++++++++---
 lib/gpiolib.c          |   29 +++++++++++++
 2 files changed, 126 insertions(+), 6 deletions(-)

--- a/Documentation/gpio.txt	2007-12-09 19:50:50.000000000 -0800
+++ b/Documentation/gpio.txt	2007-12-09 19:51:03.000000000 -0800
@@ -32,7 +32,7 @@ The exact capabilities of GPIOs vary bet
   - Input values are likewise readable (1, 0).  Some chips support readback
     of pins configured as "output", which is very useful in such "wire-OR"
     cases (to support bidirectional signaling).  GPIO controllers may have
-    input de-glitch logic, sometimes with software controls.
+    input de-glitch/debounce logic, sometimes with software controls.
 
   - Inputs can often be used as IRQ signals, often edge triggered but
     sometimes level triggered.  Such IRQs may be configurable as system
@@ -60,12 +60,13 @@ used on a board that's wired differently
 functionality can be very portable.  Other features are platform-specific,
 and that can be critical for glue logic.
 
-Plus, this doesn't define an implementation framework, just an interface.
+Plus, this doesn't require any implementation framework, just an interface.
 One platform might implement it as simple inline functions accessing chip
 registers; another might implement it by delegating through abstractions
 used for several very different kinds of GPIO controller.  (There is some
-library code supporting such an implementation strategy, but drivers acting
-as clients to the GPIO interface should not care how it's implemented.)
+optional code supporting such an implementation strategy, described later
+in this document, but drivers acting as clients to the GPIO interface must
+not care how it's implemented.)
 
 That said, if the convention is supported on their platform, drivers should
 use it when possible.  Platforms should declare GENERIC_GPIO support in
@@ -152,7 +153,7 @@ Use these calls to access such GPIOs:
 The values are boolean, zero for low, nonzero for high.  When reading the
 value of an output pin, the value returned should be what's seen on the
 pin ... that won't always match the specified output value, because of
-issues including wire-OR and output latencies.
+issues including open-drain signaling and output latencies.
 
 The get/set calls have no error returns because "invalid GPIO" should have
 been reported earlier from gpio_direction_*().  However, note that not all
@@ -328,3 +329,95 @@ a side effect of configuring an add-on b
 
 These calls are purely for kernel space, but a userspace API could be built
 on top of them.
+
+
+GPIO implementor's framework (OPTIONAL)
+=======================================
+As noted earlier, there is an optional implementation framework making it
+easier for platforms to support different kinds of GPIO controller using
+the same programming interface.
+
+As a debugging aid, if debugfs is available a /sys/kernel/debug/gpio file
+will be found there.  That will list all the controllers registered through
+this framework, and the state of the GPIOs currently in use.
+
+
+Controller Drivers: gpio_chip
+-----------------------------
+In this framework each GPIO controller is packaged as a "struct gpio_chip"
+with information common to each controller of that type:
+
+ - methods to establish GPIO direction
+ - methods used to access GPIO values
+ - flag saying whether calls to its methods may sleep
+ - optional debugfs dump method (showing extra state like pullup config)
+ - label for diagnostics
+
+There is also per-instance data, which may come from device.platform_data:
+the number of its first GPIO, and how many GPIOs it exposes.
+
+The code implementing a gpio_chip should support multiple instances of the
+controller, possibly using the driver model.  That code will configure each
+gpio_chip and issue gpiochip_add().  Removing a GPIO controller should be
+rare; use gpiochip_remove() when it is unavoidable.
+
+Normally a gpio_chip is part of an instance-specific structure with state
+not exposed by the GPIO interfaces, such as addressing, power management,
+and more.  Chips such as codecs will have complex non-GPIO state,
+
+Any debugfs dump method should normally ignore signals which haven't been
+requested as GPIOs.  They can use gpiochip_is_requested(), which returns
+either NULL or the label associated with that GPIO when it was requested.
+
+
+Platform Support
+----------------
+To support this framework, a platform's Kconfig will "select GPIO_LIB" and
+arrange that its <asm/gpio.h> then include <asm-generic/gpio.h> and define
+three functions: gpio_get_value(), gpio_set_value(), and gpio_cansleep().
+They may also want to provide a custom value for ARCH_NR_GPIOS.
+
+Trivial implementations of those functions can directly use framework
+code, which always dispatches through the gpio_chip:
+
+  #define gpio_get_value	__gpio_get_value
+  #define gpio_set_value	__gpio_set_value
+  #define gpio_cansleep		__gpio_cansleep
+
+Fancier implementations could instead define those as inline functions with
+logic optimizing access to specific SOC-based GPIOs.  For example, if the
+referenced GPIO is the constant "12", getting or setting its value could
+cost as little as two or three instructions, never sleeping.  When such an
+optimization is not possible those calls must delegate to the framework
+code, costing probably a few dozen instructions.  For bitbanged I/O, such
+instruction savings can be significant.
+
+For SOCs, platform-specific code defines and registers gpio_chip instances
+for each bank of on-chip GPIOs.  Those GPIOs should be numbered/labeled to
+match chip vendor documentation, and directly match board schematics.  They
+probably start at zero and go up to a platform-specific limit.  Such GPIOs
+are normally integrated into platform initialization so these GPIOs are
+always available, from arch_initcall() or earlier, and can serve as IRQs.
+
+
+Board Support
+-------------
+For external GPIO controllers -- such as I2C or SPI expanders, ASICs, multi
+function devices, FPGAs or CPLDs -- board-specific code is responsible for
+registering controller devices and ensuring their drivers know what GPIO
+numbers to use with gpiochip_add().  Their numbers usually start right after
+platform-specific GPIOs.
+
+For example, their I2C or SPI board_info structures would pass platform_data
+identifying the range of GPIOs that chip will expose.  The board setup code
+uses those structs to assign each GPIO expander chip a set of GPIOs; then the
+chip's driver passes that data to gpiochip_add() from probe().
+
+Initialization order can be important.  For example, when a device relies on
+an I2C-based GPIO, its probe() routine should only be called after that GPIO
+becomes available.  That probably means the device should not be registered
+until calls for that GPIO can work.  One way to address such dependencies is
+for such gpio_chip controllers to provide setup() and teardown() callbacks to
+board specific code; those board specific callbacks would register devices
+once all the necessary resources are available.
+
--- a/lib/gpiolib.c	2007-12-09 19:51:02.000000000 -0800
+++ b/lib/gpiolib.c	2007-12-09 19:51:03.000000000 -0800
@@ -356,16 +356,35 @@ EXPORT_SYMBOL_GPL(gpio_direction_output)
  * REVISIT when debugging, consider adding some instrumentation to ensure
  * that the GPIO was actually requested.
  */
+
+/**
+ * __gpio_get_value() - return a gpio's value
+ * @gpio: gpio whose value will be returned
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_get_value().
+ * It returns the zero or nonzero value provided by the associated
+ * gpio_chip.get() method; or zero if no such method is provided.
+ */
 int __gpio_get_value(unsigned gpio)
 {
 	struct gpio_chip	*chip;
 
 	chip = gpio_to_chip(gpio);
 	WARN_ON(extra_checks && chip->can_sleep);
-	return chip->get(chip, gpio - chip->base);
+	return chip->get ? chip->get(chip, gpio - chip->base) : 0;
 }
 EXPORT_SYMBOL_GPL(__gpio_get_value);
 
+/**
+ * __gpio_set_value() - assign a gpio's value
+ * @gpio: gpio whose value will be assigned
+ * @value: value to assign
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_set_value().
+ * It invokes the associated gpio_chip.set() method.
+ */
 void __gpio_set_value(unsigned gpio, int value)
 {
 	struct gpio_chip	*chip;
@@ -376,6 +395,14 @@ void __gpio_set_value(unsigned gpio, int
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
+/**
+ * __gpio_cansleep() - report whether gpio value access will sleep
+ * @gpio: gpio in question
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_cansleep().  It
+ * returns nonzero if access reading or writing the GPIO value can sleep.
+ */
 int __gpio_cansleep(unsigned gpio)
 {
 	struct gpio_chip	*chip;
