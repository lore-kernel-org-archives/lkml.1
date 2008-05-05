Return-Path: <linux-kernel-owner+w=401wt.eu-S1757193AbYEEHbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbYEEHbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbYEEHbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:31:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57920 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbYEEHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:31:03 -0400
Date: Mon, 5 May 2008 09:30:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Mohr <andi@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080505073030.GI3350@elte.hu>
References: <8287f540805041818g534c4e02qaadb0e749c5f3439@mail.gmail.com> <20080505053935.GA15734@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505053935.GA15734@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Mohr <andi@lisas.de> wrote:

> Hi,
> 
> probably related to the Alistair John Strachan media build breakage report:

>   LD      arch/x86/kernel/built-in.o
>   LD      drivers/built-in.o
> ld: drivers/media/built-in.o: No such file: No such file or directory
> make[2]: *** [drivers/built-in.o] Error 1

i reported and fixed that bug a week ago, see the "drivers/media build 
fix for modular builds" patch on lkml.

currently i've got 20 build fixes in my queue that are not yet upstream 
as of today's -git - see them below.

Some of them are integrated into subsystem trees already and they are 
all in the process of being reviewed and accepted or redone differently 
by their respective maintainers.

	Ingo

------->
Subject: video: STKWEBCAM fixes
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 29 15:11:29 CEST 2008

x86.git randconfig testing found these build bugs in -git:

 drivers/media/video/stk-webcam.c: In function 'stk_create_sysfs_files':
 drivers/media/video/stk-webcam.c:340: error: implicit declaration of function 'video_device_create_file'
 drivers/media/video/stk-webcam.c: In function 'stk_remove_sysfs_files':
 [...]
 drivers/media/video/stk-webcam.c: In function 'v4l_stk_mmap':
 drivers/media/video/stk-webcam.c:846: error: 'VM_WRITE' undeclared (first use in this function)
 [...]

config at:

  http://redhat.com/~mingo/misc/config-Tue_Apr_29_15_00_47_CEST_2008.bad

the reason was a missing include file, and a dependency on a deprecated
(but still in use) VIDEO_V4L1_COMPAT API.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/Kconfig      |    1 +
 drivers/media/video/stk-webcam.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux/drivers/media/video/Kconfig
===================================================================
--- linux.orig/drivers/media/video/Kconfig
+++ linux/drivers/media/video/Kconfig
@@ -883,6 +883,7 @@ config USB_ZR364XX
 config USB_STKWEBCAM
 	tristate "USB Syntek DC1125 Camera support"
 	depends on VIDEO_V4L2 && EXPERIMENTAL
+	select VIDEO_V4L1_COMPAT
 	---help---
 	  Say Y here if you want to use this type of camera.
 	  Supported devices are typically found in some Asus laptops,
Index: linux/drivers/media/video/stk-webcam.c
===================================================================
--- linux.orig/drivers/media/video/stk-webcam.c
+++ linux/drivers/media/video/stk-webcam.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/kref.h>
+#include <linux/mm.h>
 
 #include <linux/usb.h>
 #include <linux/vmalloc.h>

------->
Subject: usb: build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 30 19:44:03 CEST 2008

this config:

http://redhat.com/~mingo/misc/config-Wed_Apr_30_15_12_48_CEST_2008.bad

fails to build due to an #error. Turn that into a #warning instead
to not break randconfig builds unnecessarily.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/usb/cdc_subset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/net/usb/cdc_subset.c
===================================================================
--- linux.orig/drivers/net/usb/cdc_subset.c
+++ linux/drivers/net/usb/cdc_subset.c
@@ -218,7 +218,7 @@ static const struct driver_info	blob_inf
 /*-------------------------------------------------------------------------*/
 
 #ifndef	HAVE_HARDWARE
-#error You need to configure some hardware for this driver
+#warning You need to configure some hardware for this driver
 #endif
 
 /*

------->
Subject: acpi: acpi_numa_init() build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 29 00:40:16 CEST 2008

x86.git testing found the following allyesconfig build error on
latest -git:

 drivers/acpi/numa.c: In function 'acpi_numa_init':
 drivers/acpi/numa.c:226: error: 'NR_NODE_MEMBLKS' undeclared (first use in this function)
 drivers/acpi/numa.c:226: error: (Each undeclared identifier is reported only once
 drivers/acpi/numa.c:226: error: for each function it appears in.)

with this config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_22_42_42_CEST_2008.bad

i suspect we dont want SRAT parsing when CONFIG_HAVE_ARCH_PARSE_SRAT
is unset - but the fix looks a bit ugly. Perhaps we should define
NR_NODE_MEMBLKS even in this case and just let the code fall back
to some sane behavior?

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/acpi/numa.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/acpi/numa.c
===================================================================
--- linux.orig/drivers/acpi/numa.c
+++ linux/drivers/acpi/numa.c
@@ -176,6 +176,7 @@ acpi_parse_processor_affinity(struct acp
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 static int __init
 acpi_parse_memory_affinity(struct acpi_subtable_header * header,
 			   const unsigned long end)
@@ -193,6 +194,7 @@ acpi_parse_memory_affinity(struct acpi_s
 
 	return 0;
 }
+#endif
 
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
@@ -221,9 +223,11 @@ int __init acpi_numa_init(void)
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
 				      acpi_parse_processor_affinity, NR_CPUS);
+#ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
 		acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 				      acpi_parse_memory_affinity,
 				      NR_NODE_MEMBLKS);
+#endif
 	}
 
 	/* SLIT: System Locality Information Table */

------->
Subject: acpi: fix drivers/acpi/glue.c build error
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 30 22:56:57 CEST 2008

x86.git testing found the following build bug:

  drivers/built-in.o: In function `acpi_rtc_init':
  glue.c:(.init.text+0x16c3): undefined reference to `pnp_bus_type'

this tries to use PNP bus infrastructure even in the !PNP case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/acpi/glue.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -299,6 +299,7 @@ static void rtc_wake_off(struct device *
 
 static struct cmos_rtc_board_info rtc_info;
 
+#ifdef CONFIG_PNP
 
 /* PNP devices are registered in a subsys_initcall();
  * ACPI specifies the PNP IDs to use.
@@ -360,4 +361,6 @@ static int __init acpi_rtc_init(void)
 /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
 fs_initcall(acpi_rtc_init);
 
+#endif /* CONFIG_PNP */
+
 #endif

------->
Subject: usb: fix build error in drivers/usb/c67x00/c67x00-ll-hpi.c
From: Ingo Molnar <mingo@elte.hu>
Date: Sat May 03 10:36:43 CEST 2008

x86.git testing found this build bug:

 drivers/usb/c67x00/c67x00-ll-hpi.c: In function 'll_recv_msg':
 drivers/usb/c67x00/c67x00-ll-hpi.c:243: error: 'HZ' undeclared (first use in this function)
 drivers/usb/c67x00/c67x00-ll-hpi.c:243: error: (Each undeclared identifier is reported only once
 drivers/usb/c67x00/c67x00-ll-hpi.c:243: error: for each function it appears in.)

with this config:

 http://redhat.com/~mingo/misc/config-Sat_May__3_11_56_37_CEST_2008.bad

the fix is trivial.

I suspect this driver got its HZ definition from some implicit
include file dependency before. Make it more spelled out by
including jiffies.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/usb/c67x00/c67x00-ll-hpi.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/usb/c67x00/c67x00-ll-hpi.c
===================================================================
--- linux.orig/drivers/usb/c67x00/c67x00-ll-hpi.c
+++ linux/drivers/usb/c67x00/c67x00-ll-hpi.c
@@ -23,6 +23,7 @@
 
 #include <asm/byteorder.h>
 #include <linux/io.h>
+#include <linux/jiffies.h>
 #include <linux/usb/c67x00.h>
 #include "c67x00.h"
 

------->
Subject: video: build fix for drivers/media/video/mt9v022.c
From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build bug:

  CC [M]  drivers/media/video/mt9v022.o
  drivers/media/video/mt9v022.c: In function 'bus_switch_request':
  drivers/media/video/mt9v022.c:199: error: implicit declaration of function 'gpio_is_valid'
  drivers/media/video/mt9v022.c:201: error: implicit declaration of function 'gpio_request'
  drivers/media/video/mt9v022.c:207: error: implicit declaration of function 'gpio_direction_output'
  drivers/media/video/mt9v022.c:211: error: implicit declaration of function 'gpio_free'
  drivers/media/video/mt9v022.c: In function 'bus_switch_act':
  drivers/media/video/mt9v022.c:237: error: implicit declaration of function 'gpio_set_value_cansleep'
  make[2]: *** [drivers/media/video] Error 2
  make[1]: *** [drivers/media] Error 2
  make[1]: *** Waiting for unfinished jobs....
  make: *** [drivers] Error 2

with this config:

   http://redhat.com/~mingo/misc/config-Sat_May__3_16_08_39_CEST_2008.bad

the bug was that the driver uses GPIO functionality but only includes
the interface definitions for the CONFIG_MT9M001_PCA9536_SWITCH case,
which was not set in this config.

The fix is to include linux/gpio.h unconditionally. (this is a small
cleanup as well as it removes and #ifdef is more robust than an
inclusion of asm/gpio.h)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/mt9v022.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/drivers/media/video/mt9v022.c
===================================================================
--- linux.orig/drivers/media/video/mt9v022.c
+++ linux/drivers/media/video/mt9v022.c
@@ -13,15 +13,12 @@
 #include <linux/i2c.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
+#include <linux/gpio.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-#include <asm/gpio.h>
-#endif
-
 /* mt9v022 i2c address 0x48, 0x4c, 0x58, 0x5c
  * The platform has to define i2c_board_info
  * and call i2c_register_board_info() */

------->
Subject: irda: PNP support for drivers/net/irda/nsc-ircc.c
From: Ingo Molnar <mingo@elte.hu>
Date: Sat May 03 21:21:13 CEST 2008

x86.git testing found the following build failure in latest -git:

 drivers/built-in.o: In function `nsc_ircc_pnp_probe':
 nsc-ircc.c:(.text+0xdf1b6): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf1d4): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf1ee): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf237): undefined reference to `pnp_get_resource'
 nsc-ircc.c:(.text+0xdf24c): undefined reference to `pnp_get_resource'
 drivers/built-in.o:nsc-ircc.c:(.text+0xdf266): more undefined references to `pnp_get_resource' follow
 make: *** [.tmp_vmlinux1] Error 1

triggered via this config:

  http://redhat.com/~mingo/misc/config-Sat_May__3_20_53_13_CEST_2008.bad

while generally most users will have PNP enabled, drivers can support
non-PNP build mode too - and most drivers implement it. That is typically
done by providing a dummy pnp_driver structure that will not probe anything.

The fallback routines in the driver will handle this dumber mode of
operation too.

This patch implements that. I have not tested whether this actually
works on real hardware so take care. It does resolve the build bug.

[ Another solution that is used by a few drivers is to exclude the driver
  in the Kconfig if PNP is disabled, via "depends on PNP", but this would
  limit the availability of the driver needlessly. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/irda/nsc-ircc.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/net/irda/nsc-ircc.c
===================================================================
--- linux.orig/drivers/net/irda/nsc-ircc.c
+++ linux/drivers/net/irda/nsc-ircc.c
@@ -100,7 +100,9 @@ static int nsc_ircc_probe_39x(nsc_chip_t
 static int nsc_ircc_init_108(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_338(nsc_chip_t *chip, chipio_t *info);
 static int nsc_ircc_init_39x(nsc_chip_t *chip, chipio_t *info);
+#ifdef CONFIG_PNP
 static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id);
+#endif
 
 /* These are the known NSC chips */
 static nsc_chip_t chips[] = {
@@ -156,9 +158,11 @@ static const struct pnp_device_id nsc_ir
 MODULE_DEVICE_TABLE(pnp, nsc_ircc_pnp_table);
 
 static struct pnp_driver nsc_ircc_pnp_driver = {
+#ifdef CONFIG_PNP
 	.name = "nsc-ircc",
 	.id_table = nsc_ircc_pnp_table,
 	.probe = nsc_ircc_pnp_probe,
+#endif
 };
 
 /* Some prototypes */
@@ -916,6 +920,7 @@ static int nsc_ircc_probe_39x(nsc_chip_t
 	return 0;
 }
 
+#ifdef CONFIG_PNP
 /* PNP probing */
 static int nsc_ircc_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *id)
 {
@@ -952,6 +957,7 @@ static int nsc_ircc_pnp_probe(struct pnp
 
 	return 0;
 }
+#endif
 
 /*
  * Function nsc_ircc_setup (info)

------->
Subject: mt9: fix2
From: Ingo Molnar <mingo@elte.hu>
Date: Sat May 03 21:46:51 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/mt9m001.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/drivers/media/video/mt9m001.c
===================================================================
--- linux.orig/drivers/media/video/mt9m001.c
+++ linux/drivers/media/video/mt9m001.c
@@ -12,15 +12,12 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/log2.h>
+#include <linux/gpio.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/soc_camera.h>
 
-#ifdef CONFIG_MT9M001_PCA9536_SWITCH
-#include <asm/gpio.h>
-#endif
-
 /* mt9m001 i2c address 0x5d
  * The platform has to define i2c_board_info
  * and call i2c_register_board_info() */

------->
Subject: Re: media/video/sound build fix, TEA5761/TEA5767
From: Takashi Iwai <tiwai@suse.de>
Date: Wed, 30 Apr 2008 13:11:31 +0200

At Wed, 30 Apr 2008 13:01:15 +0200,
Ingo Molnar wrote:
>
>
> x86.git randconfig testing found the following new build error in latest
> -git:
>
>  drivers/built-in.o: In function `v4l2_i2c_drv_attach_legacy':
>  tuner-core.c:(.text+0x1a829d): undefined reference to `v4l2_i2c_attach'
>  drivers/built-in.o: In function `tuner_command':
>  tuner-core.c:(.text+0x1a971c): undefined reference to `v4l_printk_ioctl'
>
> the reason appears to be that the TEA5761/TEA5767 tuner code is
> dependent on (legacy?) V4L infrastructure like v4l2_i2c_attach, by
> virtue of drivers/media/video/tuner-core.c including
> media/v4l2-i2c-drv-legacy.h and ./sound/i2c/other/Makefile doing:
>
>   snd-tea575x-tuner-objs := tea575x-tuner.o
>
> for now i solved this via adding a VIDEO_V4L2_COMMON dependency to
> MEDIA_TUNER - which solves the build problem by excluding these drivers
> - but i suspect there might be a better fix as well that does not
> restrict the selectability of these drivers.

IMO, it's the reverse selection from sound to V4L that makes things
complicated.  I believe it's better to fix it as a normal dependency.

How about the patch below?

Takashi

Fix kconfig dependency mess of fm801-tea575x

FM801-tea575x tuner has a reverse selection to V4L1 and this causes
dependency problem.  The patch simplifies the dependency with a
normal depend on VIDEO_V4L1.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
---
 sound/pci/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux/sound/pci/Kconfig
===================================================================
--- linux.orig/sound/pci/Kconfig
+++ linux/sound/pci/Kconfig
@@ -515,21 +515,18 @@ config SND_FM801
 config SND_FM801_TEA575X_BOOL
 	bool "ForteMedia FM801 + TEA5757 tuner"
 	depends on SND_FM801
+	depends on VIDEO_V4L1=y || VIDEO_V4L1=SND_FM801
 	help
 	  Say Y here to include support for soundcards based on the ForteMedia
 	  FM801 chip with a TEA5757 tuner connected to GPIO1-3 pins (Media
 	  Forte SF256-PCS-02) into the snd-fm801 driver.
 
-	  This will enable support for the old V4L1 API.
-
 config SND_FM801_TEA575X
 	# depends on 0
 	# VIDEO_DEV build bug re-reported on Fri Feb  1 13:03:44 CET 2008
 	tristate
 	depends on SND_FM801_TEA575X_BOOL
 	default SND_FM801
-	select VIDEO_V4L1
-	select VIDEO_DEV
 
 config SND_HDA_INTEL
 	tristate "Intel HD Audio"

------->
Subject: media/video/sound build fix, TEA5761/TEA5767
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 30 12:44:02 CEST 2008

x86.git randconfig testing found the following build error:

drivers/built-in.o: In function `v4l2_i2c_drv_attach_legacy':
tuner-core.c:(.text+0x1a829d): undefined reference to `v4l2_i2c_attach'
drivers/built-in.o: In function `tuner_command':
tuner-core.c:(.text+0x1a971c): undefined reference to `v4l_printk_ioctl'

the reason is that the TEA5761/TEA5767 tuner code is dependent on
(legacy?) V4L infrastructure like v4l2_i2c_attach, by virtue of
drivers/media/video/tuner-core.c including media/v4l2-i2c-drv-legacy.h
and ./sound/i2c/other/Makefile doing:

  snd-tea575x-tuner-objs := tea575x-tuner.o

for now i solved this via adding a VIDEO_V4L2_COMMON dependency
to MEDIA_TUNER - but i suspect there might be a better fix as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/common/tuners/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/common/tuners/Kconfig
===================================================================
--- linux.orig/drivers/media/common/tuners/Kconfig
+++ linux/drivers/media/common/tuners/Kconfig
@@ -20,7 +20,7 @@ config MEDIA_ATTACH
 config MEDIA_TUNER
 	tristate
 	default DVB_CORE || VIDEO_DEV
-	depends on DVB_CORE || VIDEO_DEV
+	depends on (DVB_CORE || VIDEO_DEV) && VIDEO_V4L2_COMMON && I2C
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMIZE

------->
Subject: video: build fix for drivers/media/video/au0828
From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build failure in v2.6.26-rc1:

  MODPOST 424 modules
  ERROR: "tveeprom_hauppauge_analog" [drivers/media/video/au0828/au0828.ko] undefined!
  ERROR: "tveeprom_read" [drivers/media/video/au0828/au0828.ko] undefined!

with this config:

  http://redhat.com/~mingo/misc/config-Sat_May__3_22_28_58_CEST_2008.bad

this patch does what other video drivers do to utilize the VIDEO_TVEEPROM
functionality (and this resolves the build problem) - but i have not checked
it on real hardware and i have not checked whether the fix is complete.

Other drivers seem to do a wider range of selections, so some items might
still be missing - just not triggered with this specific config.
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/au0828/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/video/au0828/Kconfig
===================================================================
--- linux.orig/drivers/media/video/au0828/Kconfig
+++ linux/drivers/media/video/au0828/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_AU0828
 	tristate "Auvitek AU0828 support"
        depends on VIDEO_DEV && I2C && INPUT && DVB_CORE
 	select I2C_ALGOBIT
+	select VIDEO_TVEEPROM
 	select DVB_AU8522 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_XC5000 if !DVB_FE_CUSTOMIZE
 	---help---

------->
Subject: fix SOC_CAMERA_MT9M001 build bug
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Apr 28 13:51:58 CEST 2008

with this randconfig:

  http://redhat.com/~mingo/misc/config-Mon_Apr_28_13_25_34_CEST_2008.bad

  CONFIG_SOC_CAMERA_MT9M001=y
  CONFIG_SOC_CAMERA_MT9V022=y
  # CONFIG_I2C is not set

the build fails:

drivers/built-in.o: In function `reg_read':
mt9m001.c:(.text+0x140a87): undefined reference to `i2c_smbus_read_word_data'
drivers/built-in.o: In function `reg_write':
mt9m001.c:(.text+0x140b6e): undefined reference to `i2c_smbus_write_word_data'
drivers/built-in.o: In function `reg_read':
mt9v022.c:(.text+0x1413a7): undefined reference to `i2c_smbus_read_word_data'
drivers/built-in.o: In function `reg_write':
mt9v022.c:(.text+0x1414ce): undefined reference to `i2c_smbus_write_word_data'
drivers/built-in.o: In function `mt9m001_mod_init':
mt9m001.c:(.init.text+0x158a8): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `mt9v022_mod_init':
mt9v022.c:(.init.text+0x158b8): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `mt9m001_mod_exit':
mt9m001.c:(.exit.text+0x1656): undefined reference to `i2c_del_driver'
drivers/built-in.o: In function `mt9v022_mod_exit':
mt9v022.c:(.exit.text+0x1666): undefined reference to `i2c_del_driver'

due to missing I2C dependency.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/media/video/Kconfig
===================================================================
--- linux.orig/drivers/media/video/Kconfig
+++ linux/drivers/media/video/Kconfig
@@ -908,6 +908,7 @@ config SOC_CAMERA
 config SOC_CAMERA_MT9M001
 	tristate "mt9m001 support"
 	depends on SOC_CAMERA
+	depends on I2C
 	select GPIO_PCA953X if MT9M001_PCA9536_SWITCH
 	help
 	  This driver supports MT9M001 cameras from Micron, monochrome
@@ -923,6 +924,7 @@ config MT9M001_PCA9536_SWITCH
 config SOC_CAMERA_MT9V022
 	tristate "mt9v022 support"
 	depends on SOC_CAMERA
+	depends on I2C
 	select GPIO_PCA953X if MT9V022_PCA9536_SWITCH
 	help
 	  This driver supports MT9V022 cameras from Micron

------->
Subject: dvb: fix3
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Apr 28 23:22:13 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/cx23885/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/media/video/cx23885/Kconfig
===================================================================
--- linux.orig/drivers/media/video/cx23885/Kconfig
+++ linux/drivers/media/video/cx23885/Kconfig
@@ -9,6 +9,8 @@ config VIDEO_CX23885
 	select VIDEO_IR
 	select VIDEOBUF_DVB
 	select VIDEO_CX25840
+	select VIDEO_CX2341X
+	select DVB_DIB7000P
 	select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE

------->
Subject: drivers/media build fix for modular builds
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 30 09:36:42 CEST 2008

fix build bug:

  LD      kernel/built-in.o
  LD      drivers/built-in.o
  ld: drivers/media/built-in.o: No such file: No such file or directory

which happens if all media drivers are modular:

  http://redhat.com/~mingo/misc/config-Wed_Apr_30_09_24_48_CEST_2008.bad

In that case there's no obj-y rule connecting all the built-in.o files and
the link tree breaks.

the fix is to add a guaranteed obj-y rule for the core vmlinux to build.
(which results in an empty object file if all media drivers are modular)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/Makefile |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/media/Makefile
===================================================================
--- linux.orig/drivers/media/Makefile
+++ linux/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+obj-y := common/
+
 obj-$(CONFIG_VIDEO_MEDIA) += common/
 
 # Since hybrid devices are here, should be compiled if DVB and/or V4L

------->
Subject: rt2x00: fix.pach
From: Ingo Molnar <mingo@elte.hu>
Date: Sat May 03 23:55:04 CEST 2008

breaks the build with: config-Sat_May__3_23_38_24_CEST_2008.bad

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/wireless/rt2x00/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/net/wireless/rt2x00/Kconfig
===================================================================
--- linux.orig/drivers/net/wireless/rt2x00/Kconfig
+++ linux/drivers/net/wireless/rt2x00/Kconfig
@@ -1,6 +1,7 @@
 config RT2X00
 	tristate "Ralink driver support"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	depends on BROKEN_BUILD
 	---help---
 	  This will enable the experimental support for the Ralink drivers,
 	  developed in the rt2x00 project <http://rt2x00.serialmonkey.com>.

------->
Subject: irda: !PNP support for drivers/net/irda/smsc-ircc2.c
From: Ingo Molnar <mingo@elte.hu>
Date: Sun May 04 00:12:12 CEST 2008

x86.git testing found this build bug on v2.6.26-rc1:

  ERROR: "pnp_get_resource" [drivers/net/irda/smsc-ircc2.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

the driver did not anticipate the case of !CONFIG_PNP which is rare but
still possible. Instead of restricting the driver to PNP-only in the
Kconfig space, add the (trivial) dummy struct pnp_driver that other
drivers use in the !PNP case. The driver itself can in theory be
initialized on !PNP too in certain cases, via smsc_ircc_legacy_probe().

Patch only minimally build tested, i dont have this hardware.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/irda/smsc-ircc2.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/drivers/net/irda/smsc-ircc2.c
===================================================================
--- linux.orig/drivers/net/irda/smsc-ircc2.c
+++ linux/drivers/net/irda/smsc-ircc2.c
@@ -376,6 +376,7 @@ MODULE_DEVICE_TABLE(pnp, smsc_ircc_pnp_t
 
 static int pnp_driver_registered;
 
+#ifdef CONFIG_PNP
 static int __init smsc_ircc_pnp_probe(struct pnp_dev *dev,
 				      const struct pnp_device_id *dev_id)
 {
@@ -402,7 +403,9 @@ static struct pnp_driver smsc_ircc_pnp_d
 	.id_table	= smsc_ircc_pnp_table,
 	.probe		= smsc_ircc_pnp_probe,
 };
-
+#else /* CONFIG_PNP */
+static struct pnp_driver smsc_ircc_pnp_driver;
+#endif
 
 /*******************************************************************************
  *

------->
Subject: sysfs: build fix
From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build failure on v2.6.26-rc1:

  In file included from include/linux/kobject.h:22,
                   from include/linux/module.h:17,
                   from include/linux/crypto.h:22,
                   from arch/x86/kernel/asm-offsets_32.c:8,
                   from arch/x86/kernel/asm-offsets.c:3:
  include/linux/sysfs.h:201: error: redefinition of 'sysfs_update_group'
  include/linux/sysfs.h:195: error: previous definition of 'sysfs_update_group' was here
  make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
  make: *** [prepare0] Error 2

with the following config:

    http://redhat.com/~mingo/misc/config-Sun_May__4_07_09_30_CEST_2008.bad

the reason is the duplicate definition of the sysfs_update_group()
inline function.

The duplication was a merge error: it was added via -mm by commit
v2.6.25-7262-g2850699, "sysfs: sysfs_update_group stub for CONFIG_SYSFS=n",
but shortly before that the same commit was already merged upstream via
the sysfs tree, with commit v2.6.25-7211-g1cbfb7a.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sysfs.h |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/include/linux/sysfs.h
===================================================================
--- linux.orig/include/linux/sysfs.h
+++ linux/include/linux/sysfs.h
@@ -190,12 +190,6 @@ static inline int sysfs_create_group(str
 	return 0;
 }
 
-static inline int sysfs_update_group(struct kobject *kobj,
-				const struct attribute_group *grp)
-{
-	return 0;
-}
-
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {

------->
Subject: build fix for sound/drivers/pcsp/pcsp.c
From: Ingo Molnar <mingo@elte.hu>

x86.git testing found the following build error in v2.6.26-rc1:

  sound/drivers/pcsp/pcsp.c: In function 'pcsp_suspend':
  sound/drivers/pcsp/pcsp.c:201: error: implicit declaration of function 'snd_pcm_suspend_all'

with the following config:

  http://redhat.com/~mingo/misc/config-Sun_May__4_19_20_01_CEST_2008.bad

the reason is the .suspend callback - which is defined even in the case
of !CONFIG_PM. Undefine it for that case, like other platform drivers do.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/drivers/pcsp/pcsp.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/sound/drivers/pcsp/pcsp.c
===================================================================
--- linux.orig/sound/drivers/pcsp/pcsp.c
+++ linux/sound/drivers/pcsp/pcsp.c
@@ -194,6 +194,7 @@ static void pcsp_stop_beep(struct snd_pc
 	spin_unlock_irq(&chip->substream_lock);
 }
 
+#ifdef CONFIG_PM
 static int pcsp_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct snd_pcsp *chip = platform_get_drvdata(dev);
@@ -201,6 +202,7 @@ static int pcsp_suspend(struct platform_
 	snd_pcm_suspend_all(chip->pcm);
 	return 0;
 }
+#endif
 
 static void pcsp_shutdown(struct platform_device *dev)
 {
@@ -215,7 +217,9 @@ static struct platform_driver pcsp_platf
 	},
 	.probe		= pcsp_probe,
 	.remove		= __devexit_p(pcsp_remove),
+#ifdef CONFIG_PM
 	.suspend	= pcsp_suspend,
+#endif
 	.shutdown	= pcsp_shutdown,
 };
 

------->
Subject: video: cinergyT2 build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Sun May 04 22:22:06 CEST 2008

x86.git testing found the following build bug:

  drivers/built-in.o: In function `cinergyt2_probe':
  cinergyT2.c:(.text+0xb6117): undefined reference to `input_allocate_device'
  cinergyT2.c:(.text+0xb6230): undefined reference to `input_register_device'
  cinergyT2.c:(.text+0xb623d): undefined reference to `input_free_device'

with the following config:

  http://redhat.com/~mingo/misc/config-Sun_May__4_22_06_54_CEST_2008.bad

The reason for the bug is that the cinergyT2 driver depends on
CONFIG_INPUT functionality, but if INPUT is modular it's still
possible to build CONFIG_DVB_CINERGYT2=y - which leads to missing
symbols.

The solution is to make DVB_CINERGYT2 dependent on INPUT.

[ This solves the build problem - i have not tested the driver on this card. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/dvb/cinergyT2/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/dvb/cinergyT2/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/cinergyT2/Kconfig
+++ linux/drivers/media/dvb/cinergyT2/Kconfig
@@ -1,6 +1,6 @@
 config DVB_CINERGYT2
 	tristate "Terratec CinergyT2/qanu USB2 DVB-T receiver"
-	depends on DVB_CORE && USB
+	depends on DVB_CORE && USB && INPUT
 	help
 	  Support for "TerraTec CinergyT2" USB2.0 Highspeed DVB Receivers
 
