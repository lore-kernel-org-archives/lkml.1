Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYELKNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYELKNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbYELKM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:12:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35544 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348AbYELKM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:12:57 -0400
Date: Mon, 12 May 2008 12:12:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Oliver Endriss <o.endriss@gmx.de>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Johannes Stezenbach <js@linuxtv.org>
Subject: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump firmware
	build error fix
Message-ID: <20080512101231.GA11755@elte.hu>
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


x86.git testing found the following build failure in 2.6.26-rc2:

  drivers/media/dvb/ttpci/fdump "/usr/lib/hotplug/firmware/dvb-ttpci-01.fw" dvb_ttpci_fw drivers/media/dvb/ttpci/av7110_firm.h
  firmware file '/usr/lib/hotplug/firmware/dvb-ttpci-01.fw' not found
  make[4]: *** [drivers/media/dvb/ttpci/av7110_firm.h] Error 255
  make[3]: *** [drivers/media/dvb/ttpci] Error 2

in this config:

  http://redhat.com/~mingo/misc/config-Mon_May_12_11_29_29_CEST_2008.bad

the reason for the build bug is that the driver's Kconfig ignores the 
PREVENT_FIRMWARE_BUILD=y config setting and tries to build the firmware 
which (like other firmware build methods) relies on a non-upstream 
firmware blob. The fix is to make the firmware build depend on 
!PREVENT_FIRMWARE_BUILD.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/dvb/ttpci/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/dvb/ttpci/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/ttpci/Kconfig
+++ linux/drivers/media/dvb/ttpci/Kconfig
@@ -33,7 +33,7 @@ config DVB_AV7110
 
 config DVB_AV7110_FIRMWARE
 	bool "Compile AV7110 firmware into the driver"
-	depends on DVB_AV7110 && !STANDALONE
+	depends on DVB_AV7110 && !STANDALONE && !PREVENT_FIRMWARE_BUILD
 	default y if DVB_AV7110=y
 	help
 	  The AV7110 firmware is normally loaded by the firmware hotplug manager.
