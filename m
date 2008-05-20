Return-Path: <linux-kernel-owner+w=401wt.eu-S935224AbYETPgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224AbYETPgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765663AbYETPdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:33:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33929 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbYETPdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:33:08 -0400
Date: Tue, 20 May 2008 17:32:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>,
       Patrick Boettcher <pb@linuxtv.org>, Steven Toth <stoth@hauppauge.com>
Subject: [patch] fix build error in
	drivers/media/video/cx23885/cx23885-dvb.c
Message-ID: <20080520153248.GA13562@elte.hu>
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


testing of the -tip tree found the following module build failure on 
latest -git:

    Building modules, stage 2.
    MODPOST 421 modules
    ERROR: "dib7000p_attach" [drivers/media/video/cx23885/cx23885.ko] undefined!
    make[1]: *** [__modpost] Error 1
    make: *** [modules] Error 2

with the following config:

    http://redhat.com/~mingo/misc/config-Tue_May_20_17_13_32_CEST_2008.bad

the problem is caused that ./drivers/media/video/cx23885/cx23885-dvb.c
depends on a DVB_DIB7000P symbol (dib7000p_attach), but its Kconfig rule
only selects it if DVB_FE_CUSTOMISE is enabled:

       select DVB_DIB7000P if !DVB_FE_CUSTOMISE

the minimal fix found is to select the DVB frontend driver unconditionally.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/video/cx23885/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/video/cx23885/Kconfig
===================================================================
--- linux.orig/drivers/media/video/cx23885/Kconfig
+++ linux/drivers/media/video/cx23885/Kconfig
@@ -11,7 +11,7 @@ config VIDEO_CX23885
 	select VIDEOBUF_DVB
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
-	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
+	select DVB_DIB7000P
 	select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1409 if !DVB_FE_CUSTOMISE
 	select DVB_LGDT330X if !DVB_FE_CUSTOMISE

