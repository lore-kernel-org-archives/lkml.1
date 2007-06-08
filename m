Return-Path: <linux-kernel-owner+w=401wt.eu-S969069AbXFHSTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969069AbXFHSTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762787AbXFHSS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:18:57 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:43258 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762861AbXFHSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:18:56 -0400
Date: Fri, 8 Jun 2007 11:18:55 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Michael Krufky <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org,
       v4l-dvb-maintainer@linuxtv.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] drivers/media/dvb/b2c2/flexcop-dma.c uses
 PCI DMA API
In-Reply-To: <1181305820.3877.52.camel@gaivota>
Message-ID: <Pine.LNX.4.58.0706081109210.9347@shell2.speakeasy.net>
References: <Pine.LNX.4.64.0706062106150.30244@anakin>  <1181220656.4187.64.camel@gaivota>
 <46681040.2010003@linuxtv.org>  <1181225452.4187.111.camel@gaivota> 
 <Pine.LNX.4.58.0706071147080.9347@shell2.speakeasy.net> <1181305820.3877.52.camel@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Mauro Carvalho Chehab wrote:
> Hi Trent,
>
> > Here is a patch that does just option B.  I have a couple other
> > patches too.
>
> Tracking the flexcop, I've arrived on a similar patch to yours, but this
> approach will duplicate some debug macros. This is somewhat ugly. Since
> we need this fix for a late -rc, I think that the better for now is to
> use an optional code on Makefile that will add flexcop-dma to
> b2c2-flexcop only if flexcop pci support is selected. The end result is
> very simple, and will solve the issue.

That is a simple way to solve the issue.  My patch was just the simplest
one that made flexcop-dma work inside the flexcop-pci module, which is more
complex, but a better way overall I think.  I had another patch that
removed the duplicated macros.  The patch series is here:
http://linuxtv.org/hg/~tap/flexcop

Maybe it would be ok for 2.6.23?  I'll post the two new patches inline so
they're easier to look at.

-----------------------------------------------------------------
flexcop: remove unnecessary exports

From: Trent Piepho <xyzzy@speakeasy.org>

flexcop-dma.c used to be part of b2c2-flexcop.ko, and all its exported
functions were only used by b2c2-flexcop-pci.ko.  Now it's part of
b2c2-flexcop-pci, so none of its functions need to be exported anymore.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff --git a/linux/drivers/media/dvb/b2c2/flexcop-dma.c b/linux/drivers/media/dvb/b2c2/flexcop-dma.c
--- a/linux/drivers/media/dvb/b2c2/flexcop-dma.c
+++ b/linux/drivers/media/dvb/b2c2/flexcop-dma.c
@@ -43,14 +43,12 @@ int flexcop_dma_allocate(struct pci_dev
 	}
 	return -ENOMEM;
 }
-EXPORT_SYMBOL(flexcop_dma_allocate);

 void flexcop_dma_free(struct flexcop_dma *dma)
 {
 	pci_free_consistent(dma->pdev, dma->size*2,dma->cpu_addr0, dma->dma_addr0);
 	memset(dma,0,sizeof(struct flexcop_dma));
 }
-EXPORT_SYMBOL(flexcop_dma_free);

 int flexcop_dma_config(struct flexcop_device *fc,
 		struct flexcop_dma *dma,
@@ -78,7 +76,6 @@ int flexcop_dma_config(struct flexcop_de

 	return 0;
 }
-EXPORT_SYMBOL(flexcop_dma_config);

 /* start the DMA transfers, but not the DMA IRQs */
 int flexcop_dma_xfer_control(struct flexcop_device *fc,
@@ -119,7 +116,6 @@ int flexcop_dma_xfer_control(struct flex
 	deb_reg("reg: %03x: %x\n",r0xc,v0xc.raw);
 	return 0;
 }
-EXPORT_SYMBOL(flexcop_dma_xfer_control);

 static int flexcop_dma_remap(struct flexcop_device *fc,
 		flexcop_dma_index_t dma_idx,
@@ -148,7 +144,6 @@ int flexcop_dma_control_size_irq(struct
 	fc->write_ibi_reg(fc,ctrl_208,v);
 	return 0;
 }
-EXPORT_SYMBOL(flexcop_dma_control_size_irq);

 int flexcop_dma_control_timer_irq(struct flexcop_device *fc,
 		flexcop_dma_index_t no,
@@ -165,7 +160,6 @@ int flexcop_dma_control_timer_irq(struct
 	fc->write_ibi_reg(fc,ctrl_208,v);
 	return 0;
 }
-EXPORT_SYMBOL(flexcop_dma_control_timer_irq);

 /* 1 cycles = 1.97 msec */
 int flexcop_dma_config_timer(struct flexcop_device *fc,
@@ -182,7 +176,6 @@ int flexcop_dma_config_timer(struct flex
 	fc->write_ibi_reg(fc,r,v);
 	return 0;
 }
-EXPORT_SYMBOL(flexcop_dma_config_timer);

 #if 0

@@ -205,7 +198,6 @@ int flexcop_dma_control_packet_irq(struc

 	return 0;
 }
-EXPORT_SYMBOL(flexcop_dma_control_packet_irq);

 int flexcop_dma_config_packet_count(struct flexcop_device *fc,
 		flexcop_dma_index_t dma_idx,
@@ -220,6 +212,5 @@ int flexcop_dma_config_packet_count(stru
 	fc->write_ibi_reg(fc,r,v);
 	return 0;
 }
-EXPORT_SYMBOL(flexcop_dma_config_packet_count);

 #endif  /*  0  */
----------------------------------------------------------------------------
flexcop: clean up debug printing functions

From: Trent Piepho <xyzzy@speakeasy.org>

Common debug macro definitions from flexcop-pci.c and flexcop-dma.c are moved
into a new header named flexcop-pci.h.  This header has the flexcop-pci
version of the code that is in flexcop.h.

The debug macro in both flexcop-pci.h and flexcop.h is changed so that it adds
a message level (KERN_DEBUG) to the messages as well as the driver prefix.  In
effect this:
	printk("i2c success\n")
is changed to this:
	printk(KERN_DEBUG "b2c2-flexcop: " "i2c success\n")

The flexcop.h file was checking "__FLEXCOP_H__" but defining "__FLEXCOP_H___",
with an extra underscore.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff --git a/linux/drivers/media/dvb/b2c2/flexcop-dma.c b/linux/drivers/media/dvb/b2c2/flexcop-dma.c
--- a/linux/drivers/media/dvb/b2c2/flexcop-dma.c
+++ b/linux/drivers/media/dvb/b2c2/flexcop-dma.c
@@ -5,22 +5,7 @@
  *
  * see flexcop.c for copyright information.
  */
-#define FC_LOG_PREFIX "flexcop-pci"
-#include "flexcop-common.h"
-
-#ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
-#define dprintk(level,args...) \
-	do { if ((b2c2_flexcop_pci_debug & level)) printk(args); } while (0)
-#define DEBSTATUS ""
-#else
-#define dprintk(level,args...)
-#define DEBSTATUS " (debugging is not enabled)"
-#endif
-
-#define deb_info(args...)  dprintk(0x01,args)
-#define deb_reg(args...)   dprintk(0x02,args)
-
-extern int b2c2_flexcop_pci_debug;
+#include "flexcop-pci.h"

 int flexcop_dma_allocate(struct pci_dev *pdev, struct flexcop_dma *dma, u32 size)
 {
diff --git a/linux/drivers/media/dvb/b2c2/flexcop-pci.c b/linux/drivers/media/dvb/b2c2/flexcop-pci.c
--- a/linux/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/linux/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -6,8 +6,7 @@
  * see flexcop.c for copyright information.
  */

-#define FC_LOG_PREFIX "flexcop-pci"
-#include "flexcop-common.h"
+#include "flexcop-pci.h"

 static int enable_pid_filtering = 1;
 module_param(enable_pid_filtering, int, 0444);
@@ -16,21 +15,6 @@ static int irq_chk_intv;
 static int irq_chk_intv;
 module_param(irq_chk_intv, int, 0644);
 MODULE_PARM_DESC(irq_chk_intv, "set the interval for IRQ watchdog (currently just debugging).");
-
-#ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
-#define dprintk(level,args...) \
-	do { if ((b2c2_flexcop_pci_debug & level)) printk(args); } while (0)
-#define DEBSTATUS ""
-#else
-#define dprintk(level,args...)
-#define DEBSTATUS " (debugging is not enabled)"
-#endif
-
-#define deb_info(args...)  dprintk(0x01,args)
-#define deb_reg(args...)   dprintk(0x02,args)
-#define deb_ts(args...)    dprintk(0x04,args)
-#define deb_irq(args...)   dprintk(0x08,args)
-#define deb_chk(args...)   dprintk(0x10,args)

 int b2c2_flexcop_pci_debug = 0;
 module_param_named(debug, b2c2_flexcop_pci_debug, int, 0644);
diff --git a/linux/drivers/media/dvb/b2c2/flexcop-pci.h b/linux/drivers/media/dvb/b2c2/flexcop-pci.h
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/dvb/b2c2/flexcop-pci.h
@@ -0,0 +1,33 @@
+/*
+ * This file is part of linux driver the digital TV devices equipped with B2C2 FlexcopII(b)/III
+ *
+ * flexcop-pci.h - private header file for all flexcop-pci source files.
+ *
+ * see flexcop.c for copyright information.
+ */
+#ifndef __FLEXCOP_PCI_H__
+#define __FLEXCOP_PCI_H__
+
+#define FC_LOG_PREFIX "flexcop-pci"
+#include "flexcop-common.h"
+
+extern int b2c2_flexcop_pci_debug;
+
+#ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
+#define dprintk(level,fmt,args...) \
+	do { if ((b2c2_flexcop_pci_debug & level)) \
+		printk(KERN_DEBUG FC_LOG_PREFIX ": " fmt, ## args); \
+	} while (0)
+#define DEBSTATUS ""
+#else
+#define dprintk(level,fmt,args...)
+#define DEBSTATUS " (debugging is not enabled)"
+#endif
+
+#define deb_info(args...)  dprintk(0x01,args)
+#define deb_reg(args...)   dprintk(0x02,args)
+#define deb_ts(args...)    dprintk(0x04,args)
+#define deb_irq(args...)   dprintk(0x08,args)
+#define deb_chk(args...)   dprintk(0x10,args)
+
+#endif
diff --git a/linux/drivers/media/dvb/b2c2/flexcop.h b/linux/drivers/media/dvb/b2c2/flexcop.h
--- a/linux/drivers/media/dvb/b2c2/flexcop.h
+++ b/linux/drivers/media/dvb/b2c2/flexcop.h
@@ -6,7 +6,7 @@
  * see flexcop.c for copyright information.
  */
 #ifndef __FLEXCOP_H__
-#define __FLEXCOP_H___
+#define __FLEXCOP_H__

 #define FC_LOG_PREFIX "b2c2-flexcop"
 #include "flexcop-common.h"
@@ -15,10 +15,12 @@ extern int b2c2_flexcop_debug;

 /* debug */
 #ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
-#define dprintk(level,args...) \
-	do { if ((b2c2_flexcop_debug & level)) printk(args); } while (0)
+#define dprintk(level,fmt,args...) \
+	do { if ((b2c2_flexcop_debug & level)) \
+		printk(KERN_DEBUG FC_LOG_PREFIX ": " fmt, ## args); \
+	} while (0)
 #else
-#define dprintk(level,args...)
+#define dprintk(level,fmt,args...)
 #endif

 #define deb_info(args...)  dprintk(0x01,args)
