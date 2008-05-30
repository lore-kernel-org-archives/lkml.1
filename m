Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbYE3WuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbYE3WuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbYE3Wte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:49:34 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:27817 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbYE3Wt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:49:29 -0400
Message-Id: <20080530224931.549456692@ldl.fc.hp.com>
References: <20080530224853.976744229@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 16:48:54 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [patch 01/15] serial: when guessing, check only active resources, not options
Content-Disposition: inline; filename=serial-pnp-check-current-resources-not-options
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given a completely unknown PNP device, if it happens to have
a modem-like string in its name and it matches a COM port
address, we assume it's a modem.

We used to check the address against all the possible resource
options for the device.  But the device is already configured
and enabled, so we only need to check the resources it is
actually using.  If we matched an address that wasn't currently
enabled, we would fail anyway as soon as we attempted to touch
the device at that address.

This removes a reference to the struct pnp_dev.{independent,dependent}
fields, which I will soon make private to the PNP subsystem.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/serial/8250_pnp.c
===================================================================
--- work10.orig/drivers/serial/8250_pnp.c	2008-05-13 11:28:48.000000000 -0600
+++ work10/drivers/serial/8250_pnp.c	2008-05-13 11:29:16.000000000 -0600
@@ -383,22 +383,19 @@ static int __devinit check_name(char *na
 	return 0;
 }
 
-static int __devinit check_resources(struct pnp_option *option)
+static int __devinit check_resources(struct pnp_dev *dev)
 {
-	struct pnp_option *tmp;
-	if (!option)
+	resource_size_t port, size;
+
+	if (!pnp_port_valid(dev, 0))
 		return 0;
 
-	for (tmp = option; tmp; tmp = tmp->next) {
-		struct pnp_port *port;
-		for (port = tmp->port; port; port = port->next)
-			if ((port->size == 8) &&
-			    ((port->min == 0x2f8) ||
-			     (port->min == 0x3f8) ||
-			     (port->min == 0x2e8) ||
-			     (port->min == 0x3e8)))
-				return 1;
-	}
+	port = pnp_port_start(dev, 0);
+	size = pnp_port_len(dev, 0);
+
+	if (size == 8 &&
+	    (port == 0x2f8 || port == 0x3f8 || port == 0x2e8 || port == 0x3e8))
+		return 1;
 
 	return 0;
 }
@@ -420,10 +417,7 @@ static int __devinit serial_pnp_guess_bo
 		(dev->card && check_name(dev->card->name))))
 			return -ENODEV;
 
-	if (check_resources(dev->independent))
-		return 0;
-
-	if (check_resources(dev->dependent))
+	if (check_resources(dev))
 		return 0;
 
 	return -ENODEV;

-- 
