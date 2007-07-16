Return-Path: <linux-kernel-owner+w=401wt.eu-S1760345AbXGPOV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbXGPOV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbXGPOVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:21:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:49252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbXGPOVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:21:17 -0400
Subject: [PATCH] - Increase PNP_MAX_PORT. ACPI devices can have a lot IO
	resource declarations
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Bernhard Walle <bwalle@suse.de>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Mon, 16 Jul 2007 16:21:07 +0200
Message-Id: <1184595667.19959.312.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PNP0C02 devices normally have a lot more IO port declarations than
currently defined in PNP_MAX_PORT

For checking, have a look at your disassembled DSDT, and look out for
the _CRS function (and/or a ResourceTemplate often called CRS).

Here an  example:
IO (Decode16,0x0010,             // Range Minimum
             0x0010,             // Range Maximum
             0x00,               // Alignment
             0x10,               // Length
)
IO (Decode16,
             0x0022,             // Range Minimum
             0x0022,             // Range Maximum
             0x00,               // Alignment
             0x1E,               // Length
)
...
IO (Decode16,
             0x0000,             // Range Minimum
             0x0000,             // Range Maximum
             0x00,               // Alignment
             0x00,               // Length
_Y06)
IO (Decode16,
             0x0000,             // Range Minimum
             0x0000,             // Range Maximum
             0x00,               // Alignment
             0x00,               // Length
_Y07)

The latter zeroed (_Y07) declarations are filled with dynamic values in
_CRS and also need an PNP IO port reserved.

On this machine (x86_64 workstation) more then 20 IO resource
declarations exist for one PNP0C02 device.
It could be that the suggested 32 is still not big enough.

Most of the ports are below 0x100, which get ignored by the pnp layer
anyways (cmp. with drivers/pnp/system.c:reserve_resources_of_dev() ).
These could already be ignore in
drivers/pnp/pnpacpi/rsparser.c:pnpacpi_parse_allocated_ioresource()
not filling up PNP_MAX_PORTs, but this is not that nice and probably
will get reverted at some later point when standard PC hardware (below
0x100, pics, kbd, timer, dma, ...) also gets requested by ACPI
sublayers.


I also wonder whether other limits like:
 #define PNP_MAX_MEM        4
 #define PNP_MAX_IRQ        2
 #define PNP_MAX_DMA        2
could get exceeded with pnpacpi?

I don't know what the theoretical max for ports on one device is, but
IMO the static array should get something dynamically allocated?

Something like:

+++ linux-2.6.22.1/include/linux/pnp.h
@@ -14,7 +14,7 @@
-#define PNP_MAX_PORT           8
+#define PNP_MAX_PORT           256

 struct pnp_resource_table {
-       struct resource port_resource[PNP_MAX_PORT];
+       struct resource *port_resource[PNP_MAX_PORT];
        struct resource mem_resource[PNP_MAX_MEM];

or
-       struct resource port_resource[PNP_MAX_PORT];
+       struct resource **port_resource;

and then k(z)alloc the resource structs...

BTW: This was the reason why:
  50e0-50ef : amd756_smbus
got not reserved on the patch:
"Identify native drivers and ACPI subsystem accessing the same
resources"
I sent some days ago. In 2.6.18 it seems this got handled (correctly) by
/drivers/acpi/motherboard which got replaced with pnpacpi system driver.

This would be the less intrusive short term fix:

------------------

Increase PNP_MAX_PORT. ACPI devices can have a lot IO resource declarations

Also print a message if PNP_DEBUG is set if we run out of PNP_MAX_PORTS.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pnp/pnpacpi/rsparser.c |    3 ++-
 include/linux/pnp.h            |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.22.1/include/linux/pnp.h
===================================================================
--- linux-2.6.22.1.orig/include/linux/pnp.h
+++ linux-2.6.22.1/include/linux/pnp.h
@@ -14,7 +14,7 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		8
+#define PNP_MAX_PORT		32
 #define PNP_MAX_MEM		4
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
Index: linux-2.6.22.1/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.22.1.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6.22.1/drivers/pnp/pnpacpi/rsparser.c
@@ -185,7 +185,8 @@ pnpacpi_parse_allocated_ioresource(struc
 		}
 		res->port_resource[i].start = io;
 		res->port_resource[i].end = io + len - 1;
-	}
+	} else
+		pnp_dbg("Run out of pnp ports - MAX_PNP_PORT must be increased");
 }
 
 static void



