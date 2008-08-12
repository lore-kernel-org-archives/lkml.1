Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbYHLSMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbYHLSMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYHLSM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:12:28 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18105 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYHLSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:12:28 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: pnp bug in 2.6.27-rc1 (ad1816a / mpu401 / parport_pc issue)
Date: Tue, 12 Aug 2008 12:10:51 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@osdl.org, perex@perex.cz, abelay@mit.edu,
       debian-kernel@lists.debian.org, linux-kernel@vger.kernel.org
References: <200808041531.10557.uwe.bugla@gmx.de> <200808111240.52005.bjorn.helgaas@hp.com> <200808121317.27323.uwe.bugla@gmx.de>
In-Reply-To: <200808121317.27323.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808121210.52589.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 05:17:26 am Uwe Bugla wrote:
> A bit more precise:
> 
> Case A:
> 
> 1. IRQs 7 and 5 reserved for ISA use only (in BIOS)
> 2. entry "options parport_pc io=0x378,0x278 irq=7,5" in 
> etc/modprobe.d/arch/i386 activated
> 
>   parport0 at port 0x378, irq 7
>   parport1 at port 0x278, irq 5
>   ad1816a at ports 0x200 (ns558pnp - gameport), 0x388 (OPL 2,3), SS at 0x500, 
> irq 10, dma 1 & 3
>   ad1816a MPU401 at port 0x300, irq disabled
> 
> Case B:
> same preconditions as above, but:
> 2. entry "options parport_pc io=0x378,0x278 irq=7,5" in 
> etc/modprobe.d/arch/i386 commented out
> 
>   parport0 at port 0x378, irq 7
>   parport1 at port 0x278, irq disabled (polling)
>   ad1816a at ports 0x200 (ns558pnp - gameport), 0x388 (OPL 2,3), SS at 0x500, 
> irq 5, dma 1 & 3
>   ad1816a MPU401 at port 0x300, irq 10

Thanks a lot for your detailed observations.

Your dmesg logs are still missing the interesting part at the beginning.
Can you find the entire log in /var/log/messages or something similar?

These lines are from your case C log, but the same thing probably
happened in case B:

  parport_pc 00:0a: reported by Plug and Play ACPI
  parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
  parport_pc 00:0a: driver attached
  parport1: PC-style at 0x278 [PCSPP(,...)]

We found parport0 via PNPACPI, but you mentioned that parport1 is a
non-PNP ISA card with jumpers on it.  In that case, the parport_pc
driver doesn't try to use an IRQ unless one is specified with a
module parameter.  It's possible the driver could guess somehow,
but I don't know enough to propose any changes here.

I think you could use "options parport_pc io=0x278 irq=5", i.e.,
you probably only need to tell the driver about the non-PNP
device.

> Case C:
> same preconditions as case B, but additionally:
> 1. no IRQs reserved for ISA use only (in BIOS)
> This option I would call "PNP pure"
> 
>   parport0 at port 0x378, irq 7
>   parport1 at port 0x278, irq disabled (polling)
>   ad1816a at ports 0x200 (ns558pnp), 0x388 (OPL 2,3), SS at 0x500, irq 5, dma 
> 1 & 3
>   ad1816a MPU401 at port 0x300, irq disabled

The only difference here is that the MPU has no IRQ.  You can see from
the log how all the possibilities (5, 7, 9, 10, 11, 15) are already
used by ad1816a, parport0, and some PCI devices.

With IRQs 5 & 7 reserved for ISA use, PCI device 00:08.0 (aic7xxx)
uses IRQ 11.  With no IRQs reserved, that device uses IRQ 10.  Without
the beginning of the log, I can't tell whether Linux or the BIOS
changed that assignment.

PNP is supposed to notice IRQs that are in use by active PNP
devices, as well as those that could possibly be used, so we can try
to avoid them when we configure PCI interrupt links.  But it looks
like some of this logic is missing from ISAPNP.  Can you try the
experimental patch below to see whether it helps?  It won't change
parport, of course, but you might get an MPU IRQ.

> "If the parallel ports only have 5 and 7 as IRQ possibilities, I
> can imagine how loading the ad1816a driver first might claim those
> IRQs, leaving them unavailable for parport_pc."
> 
> Yes and No.
> IRQ 7 for parport 0 is out of discussion, as it is the traditional standard 
> for the first parport.
> The traditional problem causing system crashes in earlier times was that both
> sound card and parport 1 would claim IRQ 5. The decision to put the second 
> parport into polling mode
> while the PnP sound card grabs IRQ 5 is wrong.

I don't think the kernel has enough information to make a different
decision.  The kernel doesn't know anything about the configuration
of the non-PNP ISA card.  I think you'd have to use a boot parameter
like "pnp_reserve_irq=5" to tell Linux that it can't use IRQ 5 when
it configures the sound card.

> ...
> My only criticism within the desired case C (no additional screwing around 
> done by user)
> consists of two points:
> 1. I'd prefer the second parport running with IRQ 5 instead of in polling 
> mode.

Yes, that would be good.  But I think the only way to achieve this
reliably is to use the "pnp_reserve_irq=5" kernel parameter and the
"options parport_pc io=0x278 irq=5" module parameter.  Otherwise the
kernel doesn't know how the jumpers on the ISA parport card are set.

> 2. the state of MPU 401 is OK so far, but the messages are highly annoying:
> 
> pnp: the driver 'mpu 401' has been registered
> MPU-401 device not found or device busy
> pnp: the driver 'mpu 401' has been unregistered

I think we ought to just remove this message completely and add a
new message when the driver claims a device, something like the
attached patch does.

> ...
> 5. And if you expect some enlighting help from Documentation/sound/alsa/ALSA-
> Configuration.txt then you are completely
> lost in space.

I find Linux sound completely incomprehensible myself.  Fortunately,
it's easy for me to live without it :-)

Bjorn


diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index 101a835..27596f0 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/isapnp.h>
 #include <linux/mutex.h>
+#include <linux/pci.h>
 #include <asm/io.h>
 
 #include "../base.h"
@@ -110,6 +111,7 @@ MODULE_LICENSE("GPL");
 static unsigned char isapnp_checksum_value;
 static DEFINE_MUTEX(isapnp_cfg_mutex);
 static int isapnp_csn_count;
+static int isapnp_get_resources(struct pnp_dev *dev);
 
 /* some prototypes */
 
@@ -421,7 +423,7 @@ static struct pnp_dev *__init isapnp_parse_device(struct pnp_card *card,
 	dev->capabilities |= PNP_READ;
 	dev->capabilities |= PNP_WRITE;
 	dev->capabilities |= PNP_DISABLE;
-	pnp_init_resources(dev);
+	isapnp_get_resources(dev);
 	return dev;
 }
 
@@ -920,6 +922,8 @@ static int isapnp_get_resources(struct pnp_dev *dev)
 	}
 	for (i = 0; i < ISAPNP_MAX_IRQ; i++) {
 		ret = isapnp_read_word(ISAPNP_CFG_IRQ + (i << 1)) >> 8;
+		if (ret)
+			pcibios_penalize_isa_irq(ret, 1);
 		pnp_add_irq_resource(dev, ret,
 				     ret == 0 ? IORESOURCE_DISABLED : 0);
 	}
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index 5b996f3..61c6157 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -124,6 +124,8 @@ static int __devinit snd_mpu401_probe(struct platform_device *devptr)
 		return err;
 	}
 	platform_set_drvdata(devptr, card);
+	dev_info(&devptr->dev, "MPU401 UART at port %#lx, IRQ %d\n",
+		 port[dev], irq[dev]);
 	return 0;
 }
 
@@ -206,6 +208,8 @@ static int __devinit snd_mpu401_pnp_probe(struct pnp_dev *pnp_dev,
 		pnp_set_drvdata(pnp_dev, card);
 		snd_mpu401_devices++;
 		++dev;
+		dev_info(&pnp_dev->dev, "MPU401 UART at port %#lx, IRQ %d\n",
+			 port[dev], irq[dev]);
 		return 0;
 	}
 	return -ENODEV;
@@ -271,9 +275,6 @@ static int __init alsa_card_mpu401_init(void)
 		pnp_registered = 1;
 
 	if (!snd_mpu401_devices) {
-#ifdef MODULE
-		printk(KERN_ERR "MPU-401 device not found or device busy\n");
-#endif
 		snd_mpu401_unregister_all();
 		return -ENODEV;
 	}
