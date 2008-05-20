Return-Path: <linux-kernel-owner+w=401wt.eu-S1761706AbYETTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706AbYETTem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbYETTee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:34:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36145 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001AbYETTed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:34:33 -0400
Date: Tue, 20 May 2008 21:34:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>,
       Patrick Boettcher <pb@linuxtv.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [patch] video/dvb: fix MEDIA_TUNER && FW_LOADER build error
Message-ID: <20080520193409.GA14869@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


-tip testing found the following build failure:

  LD      .tmp_vmlinux1
  drivers/built-in.o: In function `generic_set_freq':
  tuner-xc2028.c:(.text+0xbd896): undefined reference to `request_firmware'
  tuner-xc2028.c:(.text+0xbdd7a): undefined reference to `release_firmware'
  drivers/built-in.o: In function `xc_load_fw_and_init_tuner':
  xc5000.c:(.text+0xc68e6): undefined reference to `request_firmware'
  xc5000.c:(.text+0xc6abe): undefined reference to `release_firmware'

with this config:

  http://redhat.com/~mingo/misc/config-Tue_May_20_18_11_34_CEST_2008.bad

the reason is another kconfig tool bug that has to be worked around in
the driver's Kconfig file: if FW_LOADER is selected in a second
dependency, that is not properly propagated up the dependencies.

in this case, FW_LOADER is selected from MEDIA_TUNER_XC2028:

  config MEDIA_TUNER_XC2028
        tristate "XCeive xc2028/xc3028 tuners"
        depends on VIDEO_MEDIA && I2C
        depends on HOTPLUG
        select FW_LOADER

which got selected by MEDIA_TUNER:

  config MEDIA_TUNER
        tristate
        default VIDEO_MEDIA && I2C
        depends on VIDEO_MEDIA && I2C
        select FW_LOADER if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG

but the kconfig tool did not pick up this second-order dependency and 
allowed CONFIG_FW_LOADER=m to be selected - in which case the build 
fails.

the workaround i found was to move the select of FW_LOADER one level up, 
so that the buggy kconfig tool can notice it and can act appropriately. 
This problem can probably be worked around in other ways as well, i went 
for the minimal fix.

Obviously, the kconfig tool should be fixed, it is not reasonable to 
expect driver authors to do manual dependency resolution (that kconfig 
itself already does) and uglify the Kconfig files. The kconfig tool did 
nothing to warn about this situation and did not prevent this faulty 
.config from being constructed.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/common/tuners/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/common/tuners/Kconfig
===================================================================
--- linux.orig/drivers/media/common/tuners/Kconfig
+++ linux/drivers/media/common/tuners/Kconfig
@@ -21,6 +21,7 @@ config MEDIA_TUNER
 	tristate
 	default VIDEO_MEDIA && I2C
 	depends on VIDEO_MEDIA && I2C
+	select FW_LOADER if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMIZE && HOTPLUG
 	select MEDIA_TUNER_MT20XX if !MEDIA_TUNER_CUSTOMIZE
