Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbXLJEwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbXLJEwn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXLJEwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:52:02 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:28968 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751211AbXLJEv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:51:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=dfK5f1pvH10P+3AkztL4T8oZ1X98N5xfm7ckpyWJJFYqM/t+Q91/B4hf7dC4KLZId24TfLBsuf+jSP/zPUh540g+NQLuOHtfKL2Lxa4emznqeuqCD/JMD08vfnDKRjQJNUir5SSXZ6M8AAqEEfhUtrMCLpzKGK1WIA61xbJ+QIE=  ;
X-YMail-OSG: d7DlNsAVM1mMcp_d00e8_JIiH3VYueMbshKmBR2cmt1nN.0TfTYU9ScPgaSddzTw9uCVVlKa9w--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc4-mm 2/6] gpiolib: more CONFIG_DEBUG_GPIO diagnostics
Date: Sun, 9 Dec 2007 20:39:38 -0800
User-Agent: KMail/1.9.6
Cc: Tzachi Perelstein <tzachi@marvell.com>
References: <200712092022.14062.david-b@pacbell.net>
In-Reply-To: <200712092022.14062.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712092039.38917.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Update gpiolib behavior with CONFIG_DEBUG_GPIO to include messages
on some fault paths that are common during bringup:  gpiochip_add,
gpio_request, and the two gpio_direction_* calls.

Also morph that CONFIG symbol into compile-time -DDEBUG.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Tzachi Perelstein <tzachi@marvell.com>
---
 lib/Kconfig.debug |   10 ++++++----
 lib/Makefile      |    4 ++++
 lib/gpiolib.c     |   33 ++++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 9 deletions(-)

--- a/lib/Kconfig.debug	2007-12-09 19:50:50.000000000 -0800
+++ b/lib/Kconfig.debug	2007-12-09 19:51:02.000000000 -0800
@@ -160,10 +160,12 @@ config DEBUG_GPIO
 	bool "Debug GPIO calls"
 	depends on DEBUG_KERNEL && GPIO_LIB
 	help
-	  Say Y here to add some extra checks to GPIO calls, ensuring that
-	  GPIOs have been properly initialized before they are used and
-	  that sleeping calls aren't made from nonsleeping contexts.  This
-	  can make bitbanged serial protocols slower.
+	  Say Y here to add some extra checks and diagnostics to GPIO calls.
+	  The checks help ensure that GPIOs have been properly initialized
+	  before they are used and that sleeping calls aren't made from
+	  nonsleeping contexts.  They can make bitbanged serial protocols
+	  slower.  The diagnostics help catch the type of setup errors
+	  that are most common when setting up new platforms or boards.
 
 config DEBUG_SLAB_LEAK
 	bool "Memory leak debugging"
--- a/lib/Makefile	2007-12-09 19:50:50.000000000 -0800
+++ b/lib/Makefile	2007-12-09 19:51:02.000000000 -0800
@@ -68,6 +68,10 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-i
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
+ifeq ($(CONFIG_DEBUG_GPIO),y)
+CFLAGS_gpiolib.o += -DDEBUG
+endif
+
 lib-$(CONFIG_GPIO_LIB) += gpiolib.o
 
 hostprogs-y	:= gen_crc32table
--- a/lib/gpiolib.c	2007-12-09 19:50:59.000000000 -0800
+++ b/lib/gpiolib.c	2007-12-09 19:51:02.000000000 -0800
@@ -20,9 +20,12 @@
 
 
 /* When debugging, extend minimal trust to callers and platform code.
+ * Also emit diagnostic messages that may help initial bringup, when
+ * board setup or driver bugs are most common.
+ *
  * Otherwise, minimize overhead in what may be bitbanging codepaths.
  */
-#ifdef	CONFIG_DEBUG_GPIO
+#ifdef	DEBUG
 #define	extra_checks	1
 #else
 #define	extra_checks	0
@@ -48,8 +51,11 @@ struct gpio_desc {
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
 
-/* Warn when drivers omit gpio_request() calls -- legal but
- * ill-advised when setting direction, and otherwise illegal.
+/* Warn when drivers omit gpio_request() calls -- legal but ill-advised
+ * when setting direction, and otherwise illegal.  Until board setup code
+ * and drivers use explicit requests everywhere (which won't happen when
+ * those calls have no teeth) we can't avoid autorequesting.  This nag
+ * message should motivate switching to explicit requests...
  */
 static void gpio_ensure_requested(struct gpio_desc *desc)
 {
@@ -86,8 +92,10 @@ int gpiochip_add(struct gpio_chip *chip)
 	 * dynamic allocation.  We don't currently support that.
 	 */
 
-	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS)
-		return -EINVAL;
+	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS) {
+		status = -EINVAL;
+		goto fail;
+	}
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
@@ -106,6 +114,12 @@ int gpiochip_add(struct gpio_chip *chip)
 	}
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
+fail:
+	/* failures here can mean systems won't boot... */
+	if (status)
+		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
+			chip->base, chip->base + chip->ngpio,
+			chip->label ? : "generic");
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
@@ -172,6 +186,9 @@ int gpio_request(unsigned gpio, const ch
 		status = -EBUSY;
 
 done:
+	if (status)
+		pr_debug("gpio_request: gpio-%d (%s) status %d\n",
+			gpio, label ? : "?", status);
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
@@ -272,6 +289,9 @@ int gpio_direction_input(unsigned gpio)
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__FUNCTION__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_input);
@@ -307,6 +327,9 @@ int gpio_direction_output(unsigned gpio,
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__FUNCTION__, gpio, status);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
