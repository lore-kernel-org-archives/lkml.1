Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbXDLT22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbXDLT22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbXDLT22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:28:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:40889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXDLT21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:28:27 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add keyboard blink driver
Date: Thu, 12 Apr 2007 21:28:08 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200704121727.27892.ak@novell.com> <20070412121028.d7e5c4b6.akpm@linux-foundation.org>
In-Reply-To: <20070412121028.d7e5c4b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704122128.08869.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 21:10:28 Andrew Morton wrote:
> On Thu, 12 Apr 2007 17:27:27 +0200
> Andi Kleen <ak@novell.com> wrote:
> 
> > Add a blink driver for debugging
> > 
> > Simple driver that blinks the keyboard LEDs when loaded. Useful
> > for checking that the kernel is still alive or for crashdumping.
> > The kdump kernel currently typically doesn't give any feedback
> > on the screen because it often cannot reinitialize the graphics
> > state. This patch allows it to at least show blinking lights
> > like panic.
> 
> OK..
> 
> > --- /dev/null
> > +++ linux/drivers/misc/blink.c
> > @@ -0,0 +1,26 @@
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/timer.h>
> > +#include <linux/jiffies.h>
> > +
> > +static void do_blink(unsigned long data);
> > +
> > +static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
> > +
> > +static void do_blink(unsigned long data)
> > +{
> > +	static long count;
> > +	panic_blink(count++);
> > +	blink_timer.expires = jiffies + msecs_to_jiffies(1);
> > +	add_timer(&blink_timer);
> > +}
> > +
> > +static int blink_init(void)
> > +{
> > +	printk(KERN_INFO "Enabling keyboard blinking\n");
> > +	do_blink(0);
> > +	return 0;
> > +}
> > +
> > +module_init(blink_init);
> 
> panic_blink is NULL in lots of setups.  `modprobe blink' will be deadly.

Oops sorry -- i must somehow have sent an old patch. I had fixed this of course
Ahh, quilt refresh was missing.

See the new patch.
 
> I wonder if this facility would be more effective if it were to use
> schedule_delayed_work().  That way, we're using more of the kernel and it
> will more reliably detect kernel deadness.
 
Hmm, maybe

-Andi

Add a blink driver for debugging

Simple driver that blinks the keyboard LEDs when loaded. Useful
for checking that the kernel is still alive or for crashdumping

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/misc/Kconfig  |    9 +++++++++
 drivers/misc/Makefile |    1 +
 drivers/misc/blink.c  |   26 ++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

Index: linux-2.6.21-rc6-test/drivers/misc/Kconfig
===================================================================
--- linux-2.6.21-rc6-test.orig/drivers/misc/Kconfig
+++ linux-2.6.21-rc6-test/drivers/misc/Kconfig
@@ -122,4 +122,13 @@ config SONY_LAPTOP
 
 	  Read <file:Documentation/sony-laptop.txt> for more information.
 
+config BLINK
+	tristate "Keyboard blink driver"
+	help
+	  Driver that when loaded will blink the keyboard LEDs continuously.
+	  This is useful for debugging and for kernels that cannot necessarily
+	  output something to the screen like kexec kernels to give the user
+	  a visual indication that the kernel is doing something.
+
+
 endmenu
Index: linux-2.6.21-rc6-test/drivers/misc/Makefile
===================================================================
--- linux-2.6.21-rc6-test.orig/drivers/misc/Makefile
+++ linux-2.6.21-rc6-test/drivers/misc/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_TIFM_CORE)       	+= tifm_c
 obj-$(CONFIG_TIFM_7XX1)       	+= tifm_7xx1.o
 obj-$(CONFIG_SGI_IOC4)		+= ioc4.o
 obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
+obj-$(CONFIG_BLINK)		+= blink.o
Index: linux-2.6.21-rc6-test/drivers/misc/blink.c
===================================================================
--- /dev/null
+++ linux-2.6.21-rc6-test/drivers/misc/blink.c
@@ -0,0 +1,27 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+
+static void do_blink(unsigned long data);
+
+static DEFINE_TIMER(blink_timer, do_blink, 0 ,0);
+
+static void do_blink(unsigned long data)
+{
+	static long count;
+	if (panic_blink)
+		panic_blink(count++);
+	blink_timer.expires = jiffies + msecs_to_jiffies(1);
+	add_timer(&blink_timer);
+}
+
+static int blink_init(void)
+{
+	printk(KERN_INFO "Enabling keyboard blinking\n");
+	do_blink(0);
+	return 0;
+}
+
+module_init(blink_init);
+
