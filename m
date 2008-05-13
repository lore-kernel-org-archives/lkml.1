Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYEMRel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYEMRel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYEMRed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:34:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbYEMRec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:34:32 -0400
Date: Tue, 13 May 2008 19:34:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: [patch] CONFIG_VIDEO_IR=y build fix
Message-ID: <20080513173414.GA8205@elte.hu>
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


the -tip tree's auto-testing tools found the following build failure on 
v2.6.26-rc2:

 drivers/built-in.o: In function `ir_input_key_event':
 ir-functions.c:(.text+0x5c5c2): undefined reference to `input_event'
 ir-functions.c:(.text+0x5c5d0): undefined reference to `input_event'

with this config:

  http://redhat.com/~mingo/misc/config-Tue_May_13_19_01_02_CEST_2008.bad

this is another Kconfig build system quirk: a built-in media driver
selected VIDEO_IR, which becames CONFIG_VIDEO_IR=y,
despite CONFIG_INPUT=m.

The kconfig tool should have automatically detected this case and should 
either have upgraded CONFIG_INPUT to CONFIG_INPUT=y (and all its 
dependencies) transparently, or should have warned about the problematic 
select. The kconfig tool has all the information needed, there's no need 
for human intervention in such a case and there's no need to uglify the 
code.

This patch hacks this kconfig tool bug around by adding an INPUT 
dependency to the drivers that select VIDEO_IR.

This method is fundamentally fragile because it does not address the 
root of the problem (kconfig tool's suckiness) and will lead to similar 
trivial bugs in the future as well. The Kconfig sections around these 
drivers are rather ugly already due to similar dependency escallations. 

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/dvb/ttpci/Kconfig  |    2 +-
 drivers/media/video/cx18/Kconfig |    2 +-
 drivers/media/video/ivtv/Kconfig |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/media/dvb/ttpci/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/ttpci/Kconfig
+++ linux/drivers/media/dvb/ttpci/Kconfig
@@ -99,7 +99,7 @@ config DVB_BUDGET
 
 config DVB_BUDGET_CI
 	tristate "Budget cards with onboard CI connector"
-	depends on DVB_BUDGET_CORE && I2C
+	depends on DVB_BUDGET_CORE && I2C && INPUT
 	select DVB_STV0297 if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
Index: linux/drivers/media/video/cx18/Kconfig
===================================================================
--- linux.orig/drivers/media/video/cx18/Kconfig
+++ linux/drivers/media/video/cx18/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX18
 	tristate "Conexant cx23418 MPEG encoder support"
-	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && INPUT && EXPERIMENTAL
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_IR
Index: linux/drivers/media/video/ivtv/Kconfig
===================================================================
--- linux.orig/drivers/media/video/ivtv/Kconfig
+++ linux/drivers/media/video/ivtv/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_IVTV
 	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
-	depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C && EXPERIMENTAL
+	depends on VIDEO_V4L1 && VIDEO_V4L2 && PCI && I2C && INPUT && EXPERIMENTAL
 	select I2C_ALGOBIT
 	select FW_LOADER
 	select VIDEO_IR
