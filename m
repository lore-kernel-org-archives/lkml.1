Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXGPQse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXGPQse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932946AbXGPQsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:48:09 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:61292 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932707AbXGPQsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:48:07 -0400
Date: Mon, 16 Jul 2007 18:48:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] - Increase PNP_MAX_PORT. ACPI devices can have a lot IO
 resource declarations
Message-ID: <20070716184856.253203d8@hyperion.delvare>
In-Reply-To: <1184595667.19959.312.camel@queen.suse.de>
References: <1184595667.19959.312.camel@queen.suse.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, 16 Jul 2007 16:21:07 +0200, Thomas Renninger wrote:
> PNP0C02 devices normally have a lot more IO port declarations than
> currently defined in PNP_MAX_PORT
> 
> For checking, have a look at your disassembled DSDT, and look out for
> the _CRS function (and/or a ResourceTemplate often called CRS).
> 
> Here an  example:
> IO (Decode16,0x0010,             // Range Minimum
>              0x0010,             // Range Maximum
>              0x00,               // Alignment
>              0x10,               // Length
> )
> IO (Decode16,
>              0x0022,             // Range Minimum
>              0x0022,             // Range Maximum
>              0x00,               // Alignment
>              0x1E,               // Length
> )
> ...
> IO (Decode16,
>              0x0000,             // Range Minimum
>              0x0000,             // Range Maximum
>              0x00,               // Alignment
>              0x00,               // Length
> _Y06)
> IO (Decode16,
>              0x0000,             // Range Minimum
>              0x0000,             // Range Maximum
>              0x00,               // Alignment
>              0x00,               // Length
> _Y07)
> 
> The latter zeroed (_Y07) declarations are filled with dynamic values in
> _CRS and also need an PNP IO port reserved.
> 
> On this machine (x86_64 workstation) more then 20 IO resource
> declarations exist for one PNP0C02 device.
> It could be that the suggested 32 is still not big enough.

I just tested on my own workstation, and 8 wasn't enough for me either:
there are 12 resources listed for the PNP0C02 device on my workstation.

After applying your patch, I get the following differences in /proc/ioports:

--- ioports.before      2007-07-16 18:29:30.000000000 +0200
+++ ioports.after       2007-07-16 18:39:05.000000000 +0200
@@ -13,7 +13,8 @@
 01f0-01f7 : 0000:00:0f.0
   01f0-01f7 : ide0
 0290-0297 : f71805f
-  0295-0296 : f71805f
+  0290-0297 : pnp 00:03
+    0295-0296 : f71805f
 0376-0376 : 0000:00:0f.0
   0376-0376 : ide1
 0378-037a : parport0
@@ -21,6 +22,8 @@
 03f6-03f6 : 0000:00:0f.0
   03f6-03f6 : ide0
 03f8-03ff : serial
+04d0-04d1 : pnp 00:03
+0800-0805 : pnp 00:03
 0cf8-0cff : PCI conf1
 4000-407f : pnp 00:02
   4000-4003 : ACPI PM1a_EVT_BLK

> (...)
> ------------------
> 
> Increase PNP_MAX_PORT. ACPI devices can have a lot IO resource declarations
> 
> Also print a message if PNP_DEBUG is set if we run out of PNP_MAX_PORTS.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> ---
>  drivers/pnp/pnpacpi/rsparser.c |    3 ++-
>  include/linux/pnp.h            |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.22.1/include/linux/pnp.h
> ===================================================================
> --- linux-2.6.22.1.orig/include/linux/pnp.h
> +++ linux-2.6.22.1/include/linux/pnp.h
> @@ -14,7 +14,7 @@
>  #include <linux/errno.h>
>  #include <linux/mod_devicetable.h>
>  
> -#define PNP_MAX_PORT		8
> +#define PNP_MAX_PORT		32
>  #define PNP_MAX_MEM		4
>  #define PNP_MAX_IRQ		2
>  #define PNP_MAX_DMA		2
> Index: linux-2.6.22.1/drivers/pnp/pnpacpi/rsparser.c
> ===================================================================
> --- linux-2.6.22.1.orig/drivers/pnp/pnpacpi/rsparser.c
> +++ linux-2.6.22.1/drivers/pnp/pnpacpi/rsparser.c
> @@ -185,7 +185,8 @@ pnpacpi_parse_allocated_ioresource(struc
>  		}
>  		res->port_resource[i].start = io;
>  		res->port_resource[i].end = io + len - 1;
> -	}
> +	} else
> +		pnp_dbg("Run out of pnp ports - MAX_PNP_PORT must be increased");

PNP_MAX_PORT, not MAX_PNP_PORT.

>  }
>  
>  static void

I like this patch and I'd like to see it upstream soon. I think it can
even be improved:

* If we run out of pnp ports, we should print an error message rather
than a debug message. If it takes CONFIG_PNP_DEBUG=y to get reports
that the max is too low, we won't have many reports.

* Can we have similar messages for PNP_MAX_MEM, PNP_MAX_IRQ and
PNP_MAX_DMA? I think that we really want to know when we hit limits for
these too.

Thanks,
-- 
Jean Delvare
