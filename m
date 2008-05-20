Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYETIDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYETIDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbYETICz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:02:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757070AbYETICw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:02:52 -0400
Date: Tue, 20 May 2008 10:02:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>,
       Patrick Boettcher <pb@linuxtv.org>
Subject: [patch] dvb/usb: input layer dependency fixes
Message-ID: <20080520080233.GA1668@elte.hu>
References: <20080516071029.GA13147@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516071029.GA13147@elte.hu>
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


testing of the -tip tree found the following build failures on 
2.6.26-rc3:

  drivers/built-in.o: In function `ttusb_dec_disconnect':
  ttusb_dec.c:(.text+0xa2c95): undefined reference to `input_unregister_device'

  drivers/built-in.o: In function `dvb_usb_read_remote_control':
  dvb-usb-remote.c:(.text+0xa6a94): undefined reference to `input_event'

with this config:

  http://redhat.com/~mingo/misc/config-Tue_May_20_03_48_57_CEST_2008.bad

these are due to the media/dvb/usb layer having dependencies on INPUT 
functionality, without having that spelled out in the Kconfig file.

this patch makes that dependency explicit (for the drivers affected), 
which solves the build error.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/dvb/dvb-usb/Kconfig   |    2 +-
 drivers/media/dvb/ttusb-dec/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/media/dvb/dvb-usb/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/dvb-usb/Kconfig
+++ linux/drivers/media/dvb/dvb-usb/Kconfig
@@ -1,6 +1,6 @@
 config DVB_USB
 	tristate "Support for various USB DVB devices"
-	depends on DVB_CORE && USB && I2C
+	depends on DVB_CORE && USB && I2C && INPUT
 	depends on HOTPLUG	# due to FW_LOADER
 	select FW_LOADER
 	help
Index: linux/drivers/media/dvb/ttusb-dec/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/ttusb-dec/Kconfig
+++ linux/drivers/media/dvb/ttusb-dec/Kconfig
@@ -1,6 +1,6 @@
 config DVB_TTUSB_DEC
 	tristate "Technotrend/Hauppauge USB DEC devices"
-	depends on DVB_CORE && USB
+	depends on DVB_CORE && USB && INPUT
 	depends on HOTPLUG	# due to FW_LOADER
 	select FW_LOADER
 	select CRC32
