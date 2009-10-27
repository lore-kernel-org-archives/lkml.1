Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZJ0XZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZJ0XZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 19:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZJ0XZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 19:25:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45091 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756831AbZJ0XZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 19:25:26 -0400
Date: Wed, 28 Oct 2009 00:25:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091027232521.GA16782@elf.ucw.cz>
References: <20091022091333.GA31023@elf.ucw.cz>
 <20091026234332.GB26583@kroah.com>
 <20091027001702.GA5019@elf.ucw.cz>
 <20091027030039.GA6195@kroah.com>
 <20091027081921.GG5019@elf.ucw.cz>
 <20091027165750.GA24477@kroah.com>
 <20091027193330.GB19379@elf.ucw.cz>
 <20091027204445.GA28878@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027204445.GA28878@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > What is so wrong with wakelocks? They are just nops in this case.
> 
> Are they really?  Then why is the whole large file needed?

It is probably not, I went to "submit vendor code, then clean it up"
mode. CONFIG_HAS_WAKELOCK should be disabled, so it basically stubs
itself out.

> > 2) you submit it
> 
> Wait, it has to BUILD!  This code has never been able to be built.  Only
> after I disabled it from the CONFIG_ANDROID have I noticed this, which
> is my fault.  But it needs to get fixed, and taking a bunch of code in
> addition to the mess we have now, seems like the wrong way to do it.

It seems to be the only reasonable way. gpio is used from all the
other stuff, and removing it is not really an option.

> > Now, I see that wakelocks are show-stopper for merging into kernel
> > proper, but what is the problem for staging? We merged drivers with
> > OS_MEMORY_ALLOCATE(); wakelocks are just nops in this case.
> > 
> > Could we please clean this driver in-tree? (Wakelocks are already nops
> > due to #ifdef magic, cleaning them incrementally is easy.)
> 
> With this patch, will it build properly?

Its certainly way closer to building... it builds for me, with
something like below; platform devices really are initialized from
board-* files and get passed parameters.

I should get some sleep now, I'll take closer look tommorow.

									Pavel

diff --git a/arch/arm/mach-msm/include/mach/board.h b/arch/arm/mach-msm/include/mach/board.h
index 264d62e..9e68db2 100644
--- a/arch/arm/mach-msm/include/mach/board.h
+++ b/arch/arm/mach-msm/include/mach/board.h
@@ -35,4 +61,50 @@ void __init msm_init_irq(void);
 void __init msm_init_gpio(void);
 void __init msm_clock_init(void);
 
+struct msm_camera_io_ext {
+	uint32_t mdcphy;
+	uint32_t mdcsz;
+	uint32_t appphy;
+	uint32_t appsz;
+};
+
+struct msm_camera_device_platform_data {
+	void (*camera_gpio_on) (void);
+	void (*camera_gpio_off)(void);
+	struct msm_camera_io_ext ioext;
+};
+
+#ifdef CONFIG_SENSORS_MT9T013
+struct msm_camera_legacy_device_platform_data {
+	int sensor_reset;
+	int sensor_pwd;
+	int vcm_pwd;
+	void (*config_gpio_on) (void);
+	void (*config_gpio_off)(void);
+};
+#endif
+
+#define MSM_CAMERA_FLASH_NONE 0
+#define MSM_CAMERA_FLASH_LED  1
+
+struct msm_camera_sensor_info {
+	const char *sensor_name;
+	int sensor_reset;
+	int sensor_pwd;
+	int vcm_pwd;
+	int mclk;
+	int flash_type;
+	struct msm_camera_device_platform_data *pdata;
+};
+
+struct snd_endpoint {
+	int id;
+	const char *name;
+};
+
+struct msm_snd_endpoints {
+	struct snd_endpoint *endpoints;
+	unsigned num;
+};
+
 #endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 2f7b4c8..8b88e4a 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -116,6 +116,7 @@
 
 #define MSM_AD5_PHYS          0xAC000000
 #define MSM_AD5_SIZE          (SZ_1M*13)
+#define MSM_AD5_BASE          IOMEM(0xE0300000)
 
 
 #endif


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
