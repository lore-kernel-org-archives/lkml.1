Return-Path: <linux-kernel-owner+w=401wt.eu-S1764847AbXJSQwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764847AbXJSQwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 12:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbXJSQv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 12:51:56 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:48499 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760870AbXJSQvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 12:51:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: linux-pcmcia@lists.infradead.org
Subject: PCMCIA driver resource allocation
Date: Fri, 19 Oct 2007 10:51:51 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191051.51686.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Question 1: Does the linux-pcmcia list still exist?  It's in MAINTAINERS:

  PCMCIA SUBSYSTEM
  P:      Linux PCMCIA Team
  L:      linux-pcmcia@lists.infradead.org
  L:      http://lists.infradead.org/mailman/listinfo/linux-pcmcia
  T:      git kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
  S:      Maintained

but the archive: http://lists.infradead.org/mailman/listinfo/linux-pcmcia
seems dead.

Question 2: Documentation/pcmcia/driver-changes.txt says drivers should
now claim their own resources:

  * Resource management. (as of 2.6.8)
     Although the PCMCIA subsystem will allocate resources for cards,
     it no longer marks these resources busy. This means that driver
     authors are now responsible for claiming your resources as per
     other drivers in Linux.

But I don't see any drivers that do that.  It looks like there should
be a bunch of changes like the one below.  Is there a reason these
changes didn't happen, other than just lack of interest?

Bjorn


Index: work3/drivers/net/wireless/orinoco.h
===================================================================
--- work3.orig/drivers/net/wireless/orinoco.h	2007-10-18 10:56:34.000000000 -0600
+++ work3/drivers/net/wireless/orinoco.h	2007-10-18 13:22:06.000000000 -0600
@@ -57,6 +57,7 @@
 	struct iw_statistics wstats;
 
 	/* Hardware control variables */
+	struct resource *io_resource;
 	hermes_t hw;
 	u16 txfid;
 
Index: work3/drivers/net/wireless/orinoco_cs.c
===================================================================
--- work3.orig/drivers/net/wireless/orinoco_cs.c	2007-10-18 10:56:34.000000000 -0600
+++ work3/drivers/net/wireless/orinoco_cs.c	2007-10-18 13:22:44.000000000 -0600
@@ -296,6 +296,10 @@
 	/* We initialize the hermes structure before completing PCMCIA
 	 * configuration just in case the interrupt handler gets
 	 * called. */
+	priv->io_resource = request_region(link->io.BasePort1,
+					   link->io.NumPorts1, DRIVER_NAME);
+	if (!priv->io_resource)
+		goto cs_failed;
 	mem = ioport_map(link->io.BasePort1, link->io.NumPorts1);
 	if (!mem)
 		goto cs_failed;
@@ -366,6 +370,10 @@
 	pcmcia_disable_device(link);
 	if (priv->hw.iobase)
 		ioport_unmap(priv->hw.iobase);
+	if (priv->io_resource) {
+		release_resource(priv->io_resource);
+		priv->io_resource = NULL;
+	}
 }				/* orinoco_cs_release */
 
 static int orinoco_cs_suspend(struct pcmcia_device *link)
