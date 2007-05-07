Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXEGOAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXEGOAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933973AbXEGOAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:00:00 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:56449 "EHLO
	aeryn.fluff.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920AbXEGN77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:59:59 -0400
X-Greylist: delayed 650 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 09:59:58 EDT
Date: Mon, 7 May 2007 13:49:06 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Subject: RFC: interrupt trigger flags from IRQ resource
Message-ID: <20070507134906.GA26296@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At least one driver (drivers/net/dm9000.c) could
do with being able to configure the trigger type
of the IRQ depending on the system it is connected
to. There are two methods for this, and requesting
comments on these solutions.

1) The platform data supplied with the device
   carries an unsigned long field with the
   IRQF_TRIGGER_xxx for the system.

2) The driver convers the flags passed in the
   IORESOURCE_IRQ into an IRQF_TRIGGERR_xxx.

Method (1) is fine on a per-driver basis, but
is not generic. I propose to show several methods
of acheiving (2) as follows:

a) Use the method proposed in [1] where there is
   a simple conversion of the IORESOURCE flags into
   IRQF_TRIGGER flags with a mask. This method is
   naive as it requres <linux/ioport.h> and
   <linux/interrupt.h> to agree.

   The patch supplied in [1] does not make an attempt 
   to do keep the two in sync.

   It could be cleaned up by changing interrupt.h
   to define IRQF_TRIGGER as the relevant IORESOURCE
   types. This however would still require checking
   the IRQF_TRIGGER and IRQF_xxx do not overlap.

b) Create a conversion function, such as irqf_from_resource()
   which converts the flags from the resource to the
   relevant IRQF flags. This method allows the code
   to compensate for drift between ioport.h and the
   interrupt.h files.

   Several implementations will be show below t
   detail how this method can be made reasonably
   optimal.

I belive <linux/interrupt.h> is the best place to
put this.

All compilation tests where done with gcc-4.0.2 compiling
2.6.21-git7 for ARM.

Method 1: Simple use of if and the | operator. This
results in output code looking very much like the
input, with 4 tests and 4 ORR instructions.

diff -urpN -X linux-2.6.21-git7/Documentation/dontdiff linux-2.6.21-git7/include/linux/interrupt.h linux-2.6.21-git7-flags1/include/linux/interrupt.h
--- linux-2.6.21-git7/include/linux/interrupt.h	2007-05-07 11:19:50.000000000 +0000
+++ linux-2.6.21-git7-flags1/include/linux/interrupt.h	2007-05-07 11:31:41.000000000 +0000
@@ -13,6 +13,7 @@
 #include <linux/irqflags.h>
 #include <linux/bottom_half.h>
 #include <linux/device.h>
+#include <linux/ioport.h>
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
@@ -92,6 +93,22 @@ extern int devm_request_irq(struct devic
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
+static inline unsigned long irqf_from_resource(unsigned long flags)
+{
+	unsigned long result = 0;
+
+	if (flags & IORESOURCE_IRQ_HIGHEDGE)
+		result |= IRQF_TRIGGER_RISING;
+	if (flags & IORESOURCE_IRQ_LOWEDGE)
+		result |= IRQF_TRIGGER_FALLING;
+	if (flags & IORESOURCE_IRQ_HIGHLEVEL)
+		result |= IRQF_TRIGGER_HIGH;
+	if (flags & IORESOURCE_IRQ_LOWLEVEL)
+		result |= IRQF_TRIGGER_LOW;
+
+	return result;
+}
+
 /*
  * On lockdep we dont want to enable hardirqs in hardirq
  * context. Use local_irq_enable_in_hardirq() to annotate

Method 2: Use tests with flag equality to try and persuade
the compiler to optimised out any equal flags to a simple
mask and logical-or.

This example results in a single ORR instruction after
loading the resource flags.

diff -urpN -X linux-2.6.21-git7/Documentation/dontdiff linux-2.6.21-git7/include/linux/interrupt.h linux-2.6.21-git7-flags2/include/linux/interrupt.h
--- linux-2.6.21-git7/include/linux/interrupt.h	2007-05-07 11:19:50.000000000 +0000
+++ linux-2.6.21-git7-flags2/include/linux/interrupt.h	2007-05-07 13:11:48.000000000 +0000
@@ -13,6 +13,7 @@
 #include <linux/irqflags.h>
 #include <linux/bottom_half.h>
 #include <linux/device.h>
+#include <linux/ioport.h>
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
@@ -92,6 +93,39 @@ extern int devm_request_irq(struct devic
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
+/* convert resource flags to irq trigger type */
+
+static inline unsigned long irqf_from_resource(unsigned long flags)
+{
+	unsigned long result = 0;
+
+	if (IORESOURCE_IRQ_HIGHEDGE != IRQF_TRIGGER_RISING &&
+	    flags & IORESOURCE_IRQ_HIGHEDGE)
+		result |= IRQF_TRIGGER_RISING;
+	else
+		result |= flags & IRQF_TRIGGER_RISING;
+
+	if (IORESOURCE_IRQ_LOWEDGE != IRQF_TRIGGER_FALLING &&
+	    flags & IORESOURCE_IRQ_LOWEDGE)
+		result |= IRQF_TRIGGER_FALLING;
+	else
+		result |= flags & IRQF_TRIGGER_FALLING;
+
+	if (IORESOURCE_IRQ_HIGHLEVEL != IRQF_TRIGGER_HIGH &&
+	    flags & IORESOURCE_IRQ_HIGHLEVEL)
+		result |= IRQF_TRIGGER_HIGH;
+	else
+		result |= flags & IRQF_TRIGGER_HIGH;
+	
+	if (IORESOURCE_IRQ_LOWLEVEL != IRQF_TRIGGER_LOW &&
+	    flags & IORESOURCE_IRQ_LOWLEVEL)
+		result |= IRQF_TRIGGER_LOW;
+	else
+		result |= flags & IRQF_TRIGGER_LOW;
+
+	return result;
+}
+
 /*
  * On lockdep we dont want to enable hardirqs in hardirq
  * context. Use local_irq_enable_in_hardirq() to annotate


Method 3: This is method 2, using a macro to make the
conversion. This produces the same code as #2, but with
less room for mistakes in the conversion.

diff -urpN -X linux-2.6.21-git7/Documentation/dontdiff linux-2.6.21-git7/include/linux/interrupt.h linux-2.6.21-git7-flags3/include/linux/interrupt.h
--- linux-2.6.21-git7/include/linux/interrupt.h	2007-05-07 11:19:50.000000000 +0000
+++ linux-2.6.21-git7-flags3/include/linux/interrupt.h	2007-05-07 13:25:47.000000000 +0000
@@ -13,6 +13,7 @@
 #include <linux/irqflags.h>
 #include <linux/bottom_half.h>
 #include <linux/device.h>
+#include <linux/ioport.h>
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
@@ -92,6 +93,24 @@ extern int devm_request_irq(struct devic
 			    const char *devname, void *dev_id);
 extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
 
+/* convert resource flags to irq trigger type */
+
+#define irqf_convert(_irqf, _resf)				\
+	((_irqf) != (_resf) ? (flags & (_resf) ? (_irqf) : 0) :	\
+				((flags & (_resf))))
+
+static inline unsigned long irqf_from_resource(unsigned long flags)
+{
+	unsigned long result;
+
+	result  = irqf_convert(IRQF_TRIGGER_RISING, IORESOURCE_IRQ_HIGHEDGE);
+	result |= irqf_convert(IRQF_TRIGGER_FALLING, IORESOURCE_IRQ_LOWEDGE);
+	result |= irqf_convert(IRQF_TRIGGER_HIGH, IORESOURCE_IRQ_HIGHLEVEL);
+	result |= irqf_convert(IRQF_TRIGGER_LOW, IORESOURCE_IRQ_LOWLEVEL);
+
+	return result;
+}
+
 /*
  * On lockdep we dont want to enable hardirqs in hardirq
  * context. Use local_irq_enable_in_hardirq() to annotate


My choice would be either 2 or 3. I would like input on what to
name the function, and any comments on where this could be used
other than in drivers/net/dm9000.c


References:

[1] http://www.mail-archive.com/netdev@vger.kernel.org/msg21428.html



