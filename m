Return-Path: <linux-kernel-owner+w=401wt.eu-S936234AbXFGUmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936234AbXFGUmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933071AbXFGUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:42:00 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:39095 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbXFGUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:41:59 -0400
Date: Thu, 7 Jun 2007 13:41:57 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Michael Krufky <mkrufky@linuxtv.org>, linux-dvb@linuxtv.org,
       v4l-dvb-maintainer@linuxtv.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] drivers/media/dvb/b2c2/flexcop-dma.c uses
 PCI DMA API
In-Reply-To: <1181225452.4187.111.camel@gaivota>
Message-ID: <Pine.LNX.4.58.0706071147080.9347@shell2.speakeasy.net>
References: <Pine.LNX.4.64.0706062106150.30244@anakin> <1181220656.4187.64.camel@gaivota>
  <46681040.2010003@linuxtv.org> <1181225452.4187.111.camel@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Mauro Carvalho Chehab wrote:
> > Mauro,
> >
> > It appears that your change has caused the following build warning:
> >
> > WARNING: "b2c2_flexcop_debug"
> > [/home/mk/v4l-dvb-master/v4l/b2c2-flexcop-pci.ko] undefined!
>
> Weird, this error didn't appeared on my tests here.
>
> Ok, I'll work on fixing this.
>
> I have another alternative working only on Kconfig stuff, but this seems
> to be the cleaner one.

You probably had CONFIG_DVB_B2C2_FLEXCOP_DEBUG off, in which case the
debugging stuff isn't used.

The problem is that when flexcop-dma.c was part of b2c2-flexcop.ko, it used a
non-exported global called b2c2_flexcop_debug.

In flexcop-pci.c, there is a static global called debug, which is slightly
different.  They are both a set of bit flags but the flags are different.

Since the functions in flexcop-dma are only used by flexcop-pci, it makes much
more sense to make them part of the pci module instead of the common module.
It will effectively reduce the size of the flexcop-usb driver, since the
pci-only dma functions won't be loaded.

I see three ways to fix the debug symbol:

A) Export b2c2_flexcop_debug in flexcop.c, so that flexcop-dma.c can use it.
   The debug messages flexcop-dma writes will be controlled the same way they
   were before.

   But, this means some debug messages from b2c2-flexcop-pci.ko will be
   controlled by the debug parameter of b2c2-flexcop-pci.ko (those from
   flexcop-pci.c), and some (those from flexcop-dma.c) will be controlled by
   the debug parameter of b2c2-flexcop.ko.  IMHO, that's messed up.

B) Change flexcop-dma.c to use the debug parameter of flexcop-pci.c.  This
   means that parameter will need to change from static global to non-exported
   non-static global.

   The debug messages from flexcop-dma will now be controlled by the
   b2c2-flexcop-pci.ko debug parameter, since it's part of that module.

C) Do away with the separate debug parameter in flexcop-pci, and just export
   b2c2_flexcop_debug.  Both flexcop-pci and flexcop-usb debugging messages
   will be controlled by this parameter.  This makes the parameter and the
   code the simplest, but it's more limited.  Maybe someone just wants
   messages from the pci or usb module?  It also makes sense to me that
   messags printing by module X should be controlled by a parameter to module
   X.

Here is a patch that does just option B.  I have a couple other
patches too.
--------------------------------------------------------------------------
flexcop: Have flexcop-dma use the flexcop-pci debug parameter

From: Trent Piepho <xyzzy@speakeasy.org>

Another patch moved flexcop-dma.c from the flexcop common module
(b2c2-flexcop.ko) to the flexcop pci module (b2c2-flexcop-pci.ko), since it's
PCI specific.

Debug printing was controlled by b2c2-flexcop.ko's debug parameter, but now
that it's in b2c2-flexcop-pci.ko, it makes sense for debug printing to be
controlled by b2c2-flexcop-pci.ko's debug parameter.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>

diff --git a/linux/drivers/media/dvb/b2c2/flexcop-dma.c b/linux/drivers/media/dvb/b2c2/flexcop-dma.c
--- a/linux/drivers/media/dvb/b2c2/flexcop-dma.c
+++ b/linux/drivers/media/dvb/b2c2/flexcop-dma.c
@@ -5,7 +5,22 @@
  *
  * see flexcop.c for copyright information.
  */
-#include "flexcop.h"
+#define FC_LOG_PREFIX "flexcop-pci"
+#include "flexcop-common.h"
+
+#ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
+#define dprintk(level,args...) \
+	do { if ((b2c2_flexcop_pci_debug & level)) printk(args); } while (0)
+#define DEBSTATUS ""
+#else
+#define dprintk(level,args...)
+#define DEBSTATUS " (debugging is not enabled)"
+#endif
+
+#define deb_info(args...)  dprintk(0x01,args)
+#define deb_reg(args...)   dprintk(0x02,args)
+
+extern int b2c2_flexcop_pci_debug;

 int flexcop_dma_allocate(struct pci_dev *pdev, struct flexcop_dma *dma, u32 size)
 {
@@ -88,8 +103,8 @@ int flexcop_dma_xfer_control(struct flex
 	v0x0 = fc->read_ibi_reg(fc,r0x0);
 	v0xc = fc->read_ibi_reg(fc,r0xc);

-	deb_rdump("reg: %03x: %x\n",r0x0,v0x0.raw);
-	deb_rdump("reg: %03x: %x\n",r0xc,v0xc.raw);
+	deb_reg("reg: %03x: %x\n",r0x0,v0x0.raw);
+	deb_reg("reg: %03x: %x\n",r0xc,v0xc.raw);

 	if (index & FC_DMA_SUBADDR_0)
 		v0x0.dma_0x0.dma_0start = onoff;
@@ -100,8 +115,8 @@ int flexcop_dma_xfer_control(struct flex
 	fc->write_ibi_reg(fc,r0x0,v0x0);
 	fc->write_ibi_reg(fc,r0xc,v0xc);

-	deb_rdump("reg: %03x: %x\n",r0x0,v0x0.raw);
-	deb_rdump("reg: %03x: %x\n",r0xc,v0xc.raw);
+	deb_reg("reg: %03x: %x\n",r0x0,v0x0.raw);
+	deb_reg("reg: %03x: %x\n",r0xc,v0xc.raw);
 	return 0;
 }
 EXPORT_SYMBOL(flexcop_dma_xfer_control);
@@ -178,7 +193,7 @@ int flexcop_dma_control_packet_irq(struc
 {
 	flexcop_ibi_value v = fc->read_ibi_reg(fc,ctrl_208);

-	deb_rdump("reg: %03x: %x\n",ctrl_208,v.raw);
+	deb_reg("reg: %03x: %x\n",ctrl_208,v.raw);
 	if (no & FC_DMA_1)
 		v.ctrl_208.DMA1_Size_IRQ_Enable_sig = onoff;

@@ -186,7 +201,7 @@ int flexcop_dma_control_packet_irq(struc
 		v.ctrl_208.DMA2_Size_IRQ_Enable_sig = onoff;

 	fc->write_ibi_reg(fc,ctrl_208,v);
-	deb_rdump("reg: %03x: %x\n",ctrl_208,v.raw);
+	deb_reg("reg: %03x: %x\n",ctrl_208,v.raw);

 	return 0;
 }
diff --git a/linux/drivers/media/dvb/b2c2/flexcop-pci.c b/linux/drivers/media/dvb/b2c2/flexcop-pci.c
--- a/linux/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/linux/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -19,7 +19,7 @@ MODULE_PARM_DESC(irq_chk_intv, "set the

 #ifdef CONFIG_DVB_B2C2_FLEXCOP_DEBUG
 #define dprintk(level,args...) \
-	do { if ((debug & level)) printk(args); } while (0)
+	do { if ((b2c2_flexcop_pci_debug & level)) printk(args); } while (0)
 #define DEBSTATUS ""
 #else
 #define dprintk(level,args...)
@@ -32,8 +32,8 @@ MODULE_PARM_DESC(irq_chk_intv, "set the
 #define deb_irq(args...)   dprintk(0x08,args)
 #define deb_chk(args...)   dprintk(0x10,args)

-static int debug = 0;
-module_param(debug, int, 0644);
+int b2c2_flexcop_pci_debug = 0;
+module_param_named(debug, b2c2_flexcop_pci_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (1=info,2=regs,4=TS,8=irqdma (|-able))." DEBSTATUS);

 #define DRIVER_VERSION "0.1"

