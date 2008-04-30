Return-Path: <linux-kernel-owner+w=401wt.eu-S1762001AbYD3LWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762001AbYD3LWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYD3LWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:22:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53965 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbYD3LWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:22:23 -0400
Date: Wed, 30 Apr 2008 13:21:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: [patch, -git] media/video/sound build fix, TEA5761/TEA5767
Message-ID: <20080430112138.GA11844@elte.hu>
References: <20080430110115.GA5633@elte.hu> <s5hiqxzwqak.wl%tiwai@suse.de> <20080430111516.GA9954@elte.hu> <20080430111803.GA11628@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430111803.GA11628@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> it now fails with another randconfig:
> 
>    http://redhat.com/~mingo/misc/config-Wed_Apr_30_13_13_26_CEST_2008.bad
> 
> i've added back my hack to keep things rolling. (Note: i've got some 
> media drivers hacks in this tree too so maybe one of them has a 
> side-effect)

FYI, below are the 7 fixes in this area that i've queued up so far. Let 
me know if i should drop any of them.

	Ingo

----------------------->
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
Subject: video: fix3
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 30 11:44:58 CEST 2008

x86.git randconfig testing found a build failure on latest -git:

 drivers/built-in.o: In function `set_type':
 tuner-core.c:(.text+0x2a9a26): undefined reference to `tea5761_attach'
 tuner-core.c:(.text+0x2a9d05): undefined reference to `tda9887_attach'
 tuner-core.c:(.text+0x2a9d51): undefined reference to `xc2028_attach'
 tuner-core.c:(.text+0x2a9e22): undefined reference to `tda829x_attach'
 tuner-core.c:(.text+0x2a9e3f): undefined reference to `microtune_attach'
 drivers/built-in.o: In function `tuner_probe':
 tuner-core.c:(.text+0x2aa18a): undefined reference to `tda829x_probe'
 tuner-core.c:(.text+0x2aa302): undefined reference to `tea5761_autodetection'

with the following config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_10_21_40_CEST_2008.bad

the problem is caused by the drivers/media/common/tuners/ subdirectory
not being part of the kbuild hierarchy anymore, due to commit
7c91f0624 ("V4L/DVB(7767): Move tuners to common/tuners").

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/common/Makefile |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/common/Makefile
===================================================================
--- linux.orig/drivers/media/common/Makefile
+++ linux/drivers/media/common/Makefile
@@ -2,6 +2,7 @@ saa7146-objs    := saa7146_i2c.o saa7146
 saa7146_vv-objs := saa7146_fops.o saa7146_video.o saa7146_hlp.o saa7146_vbi.o
 ir-common-objs  := ir-functions.o ir-keymaps.o
 
+obj-y += tuners/
 obj-$(CONFIG_VIDEO_SAA7146) += saa7146.o
 obj-$(CONFIG_VIDEO_SAA7146_VV) += saa7146_vv.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
Subject: sound/video: sound/i2c/other/tea575x-tuner.c build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 29 22:40:31 CEST 2008

fix build failure triggered by this config:

 http://redhat.com/~mingo/misc/config-Tue_Apr_29_22_33_36_CEST_2008.bad

sound/i2c/other/tea575x-tuner.c: In function 'snd_tea575x_ioctl':
sound/i2c/other/tea575x-tuner.c:95: error: 'VIDIOCGCAP' undeclared (first use in this function)
sound/i2c/other/tea575x-tuner.c:95: error: (Each undeclared identifier is reported only once
sound/i2c/other/tea575x-tuner.c:95: error: for each function it appears in.)
sound/i2c/other/tea575x-tuner.c:97: error: storage size of 'v' isn't known

that code still depends on VIDEO_V4L1_COMPAT APIs.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/pci/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/sound/pci/Kconfig
===================================================================
--- linux.orig/sound/pci/Kconfig
+++ linux/sound/pci/Kconfig
@@ -527,6 +527,7 @@ config SND_FM801_TEA575X
 	tristate
 	depends on SND_FM801_TEA575X_BOOL
 	default SND_FM801
+	select VIDEO_V4L1_COMPAT
 
 config SND_HDA_INTEL
 	tristate "Intel HD Audio"
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
