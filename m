Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbZELJcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbZELJcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932076AbZELJbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:31:20 -0400
Received: from araneidae.co.uk ([62.3.233.233]:2668 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462AbZELJbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:31:17 -0400
Date: Tue, 12 May 2009 10:31:07 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Eric Miao <eric.y.miao@gmail.com>
cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] XCEP PXA255 Processor Board
In-Reply-To: <f17812d70905110734o3bbb716fjabc61c748904b1ec@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0905121023100.25624@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905110928410.10720@venus.araneidae.co.uk>
 <f17812d70905110734o3bbb716fjabc61c748904b1ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="682240-586380448-1242120667=:25624"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--682240-586380448-1242120667=:25624
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

This is an updated patch in response to Eric Miao's comments.

On Mon, 11 May 2009, Eric Miao wrote:
> Please, separate the _defconfig into another patch. This makes
> code review difficult. (And relevant content removed from this mail)

Separate patch follows.

> I'd suggest gpio_to_irq(XCEP_ETH_GPIO) - thus defining XCEP_ETH_GPIO
> instead of XCEP_ETH_IRQ, which is confusing.
I've defined XCEP_ETH_IRQ as IRQ_GPIO0 which seems direct and clear=20
enough, I hope.

> You may want a PXA_CSx_... macro here for this magic number.
Done, here and elsewhere.

> I'm seeing the CPLD connected to one of the chip-select, which you may=20
> also add it here?
Hmm.  Seems reasonable enough but then it looks as if the CPLD's entry in=
=20
the IO map is bogus anyway, so I've removed that (but left the CS=20
definition, which seems wise).

> I'm not sure if the MFP needs to be initialized this early, moving this
> to xcep_init() would be better, at least to align with other platforms
> from my POV.
Done.

> > +MACHINE_START(XCEP, "Iskratel XCEP")
> > + =C2=A0 =C2=A0 =C2=A0 .phys_io =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 0x800000=
00,
> > + =C2=A0 =C2=A0 =C2=A0 .io_pg_offst =C2=A0 =C2=A0=3D 0xf8000000,
> ...... you sure this is correct? Please have a reference to other platfor=
ms.
Now this is very odd.  I've updated these two fields to conform to other=20
PXA architectures ... but it looks as if these fields don't actually make=
=20
any difference.  I dug a little, and the only place I could find them=20
being used is in arch/arm/kernel/head.S (as MACHINFO_PGOFFIO and _PHYSIO),=
=20
and only there if CONFIG_DEBUG_LL is defined.

> OK, this should be now encoded into the smc91x_platfdata, see
> zylonite.c or other boards for example.
Done.



Date: Wed, 18 Mar 2009 13:42:08 +0000
Subject: [PATCH 1/2] XCEP PXA255 Processor Board

Adds support for the XCEP processor from IskraTel.  This is a small
single board computer with an ARM XScale PXA255 processor, 32M flash,
64M RAM and an SMSC LAN91C111 network device.

This board is used in a series of electron beam position monitors used
in synchrotron light sources world wide.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 arch/arm/mach-pxa/Kconfig  |    6 ++
 arch/arm/mach-pxa/Makefile |    1 +
 arch/arm/mach-pxa/xcep.c   |  195 ++++++++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 202 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-pxa/xcep.c

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 17d3fbd..47e1dd5 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -460,6 +460,12 @@ config MACH_EZX_E2
 =09default y
 =09depends on PXA_EZX
=20
+config MACH_XCEP
+=09bool "Iskratel Electronics XCEP"
+=09select PXA25x
+=09select MTD_PHYSMAP
+=09select PXA_SSP
+
 endmenu
=20
 config PXA25x
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 682dbf4..ef553a3 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_PXA_EZX)           +=3D ezx.o
 obj-$(CONFIG_MACH_INTELMOTE2)   +=3D imote2.o
 obj-$(CONFIG_MACH_CSB726)=09+=3D csb726.o
 obj-$(CONFIG_CSB726_CSB701)=09+=3D csb701.o
+obj-$(CONFIG_MACH_XCEP)         +=3D xcep.o
=20
 # Support for blinky lights
 led-y :=3D leds.o
diff --git a/arch/arm/mach-pxa/xcep.c b/arch/arm/mach-pxa/xcep.c
new file mode 100644
index 0000000..17920ed
--- /dev/null
+++ b/arch/arm/mach-pxa/xcep.c
@@ -0,0 +1,195 @@
+/*  linux/arch/arm/mach-pxa/xcep.c
+ *
+ *  Support for the Iskratel Electronics XCEP platform.
+ *
+ *  Author:     Ales Bardorfer <ales@i-tech.si>
+ *  Updates by: Matej Kenda <matej.kenda@hermes-softlab.com>
+ *  Created:    June 2006
+ *  Copyright:  (C) 2006 Instrumentation Technologies
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/sysdev.h>
+#include <linux/major.h>
+#include <linux/fb.h>
+#include <linux/interrupt.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/i2c.h>
+#include <linux/smc91x.h>
+
+#include <asm/setup.h>
+#include <asm/memory.h>
+#include <asm/mach-types.h>
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm/sizes.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/flash.h>
+
+#include <mach/pxa2xx-regs.h>
+#include <mach/mfp-pxa25x.h>
+#include <mach/udc.h>
+#include <mach/irda.h>
+#include <mach/pxafb.h>
+#include <mach/mmc.h>
+#include <mach/i2c.h>
+
+#include "generic.h"
+
+
+#define XCEP_ETH_PHYS=09=09(PXA_CS3_PHYS + 0x00000300)
+#define XCEP_ETH_PHYS_END=09(PXA_CS3_PHYS + 0x000fffff)
+#define XCEP_ETH_ATTR=09=09(PXA_CS3_PHYS + 0x02000000)
+#define XCEP_ETH_ATTR_END=09(PXA_CS3_PHYS + 0x020fffff)
+#define XCEP_ETH_IRQ=09=09IRQ_GPIO0
+
+/*  XCEP CPLD base */
+#define XCEP_CPLD_BASE=09=090xf0000000
+
+
+/* Flash partitions. */
+
+static struct mtd_partition xcep_partitions[] =3D {
+=09{
+=09=09.name =3D=09=09"Bootloader",
+=09=09.size =3D=09=090x00040000,
+=09=09.offset =3D=090,
+=09=09.mask_flags =3D=09MTD_WRITEABLE  /* force read-only */
+=09}, {
+=09=09.name =3D=09=09"Bootloader ENV",
+=09=09.size =3D=09=090x00040000,
+=09=09.offset =3D=090x00040000,
+=09=09.mask_flags =3D=09MTD_WRITEABLE  /* force read-only */
+=09}, {
+=09=09.name =3D=09=09"Kernel",
+=09=09.size =3D=09=090x00100000,
+=09=09.offset =3D=090x00080000,
+=09}, {
+=09=09.name =3D=09=09"Rescue fs",
+=09=09.size =3D=09=090x00280000,
+=09=09.offset =3D=090x00180000,
+=09}, {
+=09=09.name =3D=09=09"Filesystem",
+=09=09.size =3D=09=09MTDPART_SIZ_FULL,
+=09=09.offset =3D=090x00400000
+=09}
+};
+
+static struct physmap_flash_data xcep_flash_data[] =3D {
+=09{
+=09=09.width=09=09=3D 4,=09=09/* bankwidth in bytes */
+=09=09.parts=09=09=3D xcep_partitions,
+=09=09.nr_parts=09=3D ARRAY_SIZE(xcep_partitions)
+=09}
+};
+
+static struct resource flash_resource =3D {
+=09.start=09=3D PXA_CS0_PHYS,
+=09.end=09=3D PXA_CS0_PHYS + SZ_32M - 1,
+=09.flags=09=3D IORESOURCE_MEM,
+};
+
+static struct platform_device flash_device =3D {
+=09.name=09=3D "physmap-flash",
+=09.id=09=3D 0,
+=09.dev =09=3D {
+=09=09.platform_data =3D xcep_flash_data,
+=09},
+=09.resource =3D &flash_resource,
+=09.num_resources =3D 1,
+};
+
+
+
+/* SMC LAN91C111 network controller. */
+
+static struct resource smc91x_resources[] =3D {
+=09[0] =3D {
+=09=09.name=09=3D "smc91x-regs",
+=09=09.start=09=3D XCEP_ETH_PHYS,
+=09=09.end=09=3D XCEP_ETH_PHYS_END,
+=09=09.flags=09=3D IORESOURCE_MEM,
+=09},
+=09[1] =3D {
+=09=09.start=09=3D XCEP_ETH_IRQ,
+=09=09.end=09=3D XCEP_ETH_IRQ,
+=09=09.flags=09=3D IORESOURCE_IRQ,
+=09},
+=09[2] =3D {
+=09=09.name=09=3D "smc91x-attrib",
+=09=09.start=09=3D XCEP_ETH_ATTR,
+=09=09.end=09=3D XCEP_ETH_ATTR_END,
+=09=09.flags=09=3D IORESOURCE_MEM,
+=09},
+};
+
+static struct smc91x_platdata xcep_smc91x_info =3D {
+=09.flags=09=3D SMC91X_USE_32BIT | SMC91X_NOWAIT | SMC91X_USE_DMA,
+};
+
+static struct platform_device smc91x_device =3D {
+=09.name=09=09=3D "smc91x",
+=09.id=09=09=3D -1,
+=09.num_resources=09=3D ARRAY_SIZE(smc91x_resources),
+=09.resource=09=3D smc91x_resources,
+=09.dev=09=09=3D {
+=09=09.platform_data =3D &xcep_smc91x_info,
+=09},
+};
+
+
+static struct platform_device *devices[] __initdata =3D {
+=09&flash_device,
+=09&smc91x_device,
+};
+
+
+/* We have to state that there are HWMON devices on the I2C bus on XCEP.
+ * Drivers for HWMON verify capabilities of the adapter when loading and
+ * refuse to attach if the adapter doesn't support HWMON class of devices.
+ * See also Documentation/i2c/porting-clients. */
+static struct i2c_pxa_platform_data xcep_i2c_platform_data  =3D {
+=09.class =3D I2C_CLASS_HWMON
+};
+
+
+static mfp_cfg_t xcep_pin_config[] __initdata =3D {
+    GPIO79_nCS_3,=09/* SMC 91C111 chip select. */
+    GPIO80_nCS_4,=09/* CPLD chip select. */
+};
+
+
+static void __init xcep_init(void)
+{
+=09pxa2xx_mfp_config(ARRAY_AND_SIZE(xcep_pin_config));
+=09/* See Intel XScale Developer's Guide for details */
+=09/* Set RDF and RDN to appropriate values (chip select 3 (smc91x)) */
+=09MSC1 =3D (MSC1 & 0xffff) | 0xD5540000;
+=09/* Set RDF and RDN to appropriate values (chip select 5 (fpga)) */
+=09MSC2 =3D (MSC2 & 0xffff) | 0x72A00000;
+
+=09platform_add_devices(ARRAY_AND_SIZE(devices));
+=09pxa_set_i2c_info(&xcep_i2c_platform_data);
+}
+
+MACHINE_START(XCEP, "Iskratel XCEP")
+=09.phys_io=09=3D 0x40000000,
+=09.io_pg_offst=09=3D (io_p2v(0x40000000) >> 18) & 0xfffc,
+=09.boot_params=09=3D 0xa0000100,
+=09.init_machine=09=3D xcep_init,
+=09.map_io=09=09=3D pxa_map_io,
+=09.init_irq=09=3D pxa25x_init_irq,
+=09.timer=09=09=3D &pxa_timer,
+MACHINE_END
--=20
1.6.1.3

--682240-586380448-1242120667=:25624--
