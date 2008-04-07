Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYDGUeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYDGUeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYDGUdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:33:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYDGUdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:33:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 7 Apr 2008 22:33:35 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-ohci: conditionally log busReset interrupts
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
In-Reply-To: <tkrat.953b0a6b5de4794b@s5r6.in-berlin.de>
Message-ID: <tkrat.f295cee296185297@s5r6.in-berlin.de>
References: <200804041705.16864.jwilson@redhat.com>
 <200804071228.15292.jwilson@redhat.com>
 <tkrat.18969adb4d4aaefb@s5r6.in-berlin.de>
 <200804071254.00197.jwilson@redhat.com>
 <tkrat.953b0a6b5de4794b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debug option to watch bus reset interrupt events.  Half of this
patch is taken from Jarod Wilson's first version of the JMicron fix.

BusReset interrupts are only generated if the respective module
parameter flag was set before the controller is being initialized.  We
keep this event masked otherwise to reduce IRQ load in normal operation
and to avoid potential problems with buggy chips.

Note, this is unlike the other IRQ events whose logging can be enabled
any time after chip initialization.  This and the influence on what
interrupts the chip generates is why I added an extra flag for it.

Also, reorder the debug parameter flags according to their perceived
usefulness.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This could be merged into "firewire: debug interrupt events" before
mainline commit.

 drivers/firewire/fw-ohci.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -240,24 +240,32 @@ static char ohci_driver_name[] = KBUILD_
 
 #ifdef CONFIG_FIREWIRE_OHCI_DEBUG
 
-#define OHCI_PARAM_DEBUG_IRQS		1
+#define OHCI_PARAM_DEBUG_AT_AR		1
 #define OHCI_PARAM_DEBUG_SELFIDS	2
-#define OHCI_PARAM_DEBUG_AT_AR		4
+#define OHCI_PARAM_DEBUG_IRQS		4
+#define OHCI_PARAM_DEBUG_BUSRESETS	8 /* only effective before chip init */
 
 static int param_debug;
 module_param_named(debug, param_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
-	", IRQs = "		__stringify(OHCI_PARAM_DEBUG_IRQS)
-	", self-IDs = "		__stringify(OHCI_PARAM_DEBUG_SELFIDS)
 	", AT/AR events = "	__stringify(OHCI_PARAM_DEBUG_AT_AR)
+	", self-IDs = "		__stringify(OHCI_PARAM_DEBUG_SELFIDS)
+	", IRQs = "		__stringify(OHCI_PARAM_DEBUG_IRQS)
+	", busReset events = "	__stringify(OHCI_PARAM_DEBUG_BUSRESETS)
 	", or a combination, or all = -1)");
 
 static void log_irqs(u32 evt)
 {
-	if (likely(!(param_debug & OHCI_PARAM_DEBUG_IRQS)))
+	if (likely(!(param_debug &
+			(OHCI_PARAM_DEBUG_IRQS | OHCI_PARAM_DEBUG_BUSRESETS))))
+		return;
+
+	if (!(param_debug & OHCI_PARAM_DEBUG_IRQS) &&
+	    !(evt & OHCI1394_busReset))
 		return;
 
-	printk(KERN_DEBUG KBUILD_MODNAME ": IRQ %08x%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	printk(KERN_DEBUG KBUILD_MODNAME ": IRQ "
+	       "%08x%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 	       evt,
 	       evt & OHCI1394_selfIDComplete	? " selfID"		: "",
 	       evt & OHCI1394_RQPkt		? " AR_req"		: "",
@@ -270,12 +278,13 @@ static void log_irqs(u32 evt)
 	       evt & OHCI1394_cycleTooLong	? " cycleTooLong"	: "",
 	       evt & OHCI1394_cycle64Seconds	? " cycle64Seconds"	: "",
 	       evt & OHCI1394_regAccessFail	? " regAccessFail"	: "",
+	       evt & OHCI1394_busReset		? " busReset"		: "",
 	       evt & ~(OHCI1394_selfIDComplete | OHCI1394_RQPkt |
 		       OHCI1394_RSPkt | OHCI1394_reqTxComplete |
 		       OHCI1394_respTxComplete | OHCI1394_isochRx |
 		       OHCI1394_isochTx | OHCI1394_postedWriteErr |
 		       OHCI1394_cycleTooLong | OHCI1394_cycle64Seconds |
-		       OHCI1394_regAccessFail)
+		       OHCI1394_regAccessFail | OHCI1394_busReset)
 						? " ?"			: "");
 }
 
@@ -1328,7 +1337,8 @@ static irqreturn_t irq_handler(int irq, 
 	if (!event || !~event)
 		return IRQ_NONE;
 
-	reg_write(ohci, OHCI1394_IntEventClear, event);
+	/* busReset must not be cleared yet, see OHCI 1.1 clause 7.2.3.2 */
+	reg_write(ohci, OHCI1394_IntEventClear, event & ~OHCI1394_busReset);
 	log_irqs(event);
 
 	if (event & OHCI1394_selfIDComplete)
@@ -1467,6 +1477,8 @@ static int ohci_enable(struct fw_card *c
 		  OHCI1394_postedWriteErr | OHCI1394_cycleTooLong |
 		  OHCI1394_cycle64Seconds | OHCI1394_regAccessFail |
 		  OHCI1394_masterIntEnable);
+	if (param_debug & OHCI_PARAM_DEBUG_BUSRESETS)
+		reg_write(ohci, OHCI1394_IntMaskSet, OHCI1394_busReset);
 
 	/* Activate link_on bit and contender bit in our self ID packets.*/
 	if (ohci_update_phy_reg(card, 4, 0,

-- 
Stefan Richter
-=====-==--- -=-- --===
http://arcgraph.de/sr/

