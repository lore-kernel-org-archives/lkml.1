Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbYL0MA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbYL0MA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 07:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYL0MAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 07:00:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbYL0MAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 07:00:47 -0500
Date: Sat, 27 Dec 2008 13:00:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: [patch] fix warning in drivers/media/dvb/dvb-usb/af9005-fe.c
Message-ID: <20081227120020.GA8660@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org> <20081225081907.GA4628@elte.hu> <20081225212459.4c7e31b4@caramujo.chehab.org> <20081226090220.GF755@elte.hu> <20081226111324.3fbb804b@caramujo.chehab.org> <20081226132426.GA26953@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081226132426.GA26953@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> here's that commit again, standalone, with the crash in 
> af9005_usb_module_init() embedded. Unfortunately i dont have the .config 
> anymore and the crash log is half a year old. I have re-enabled the 
> driver in tip/master so if the crash still triggers i should see it 
> within 1-2 days and i can do a fuller bugreport.

no crashes or build failures so far, so it's looking good!

There's one new compiler warning that i had to fix - but that's all. Find 
the patch attached below.

Btw., there's a handful of warning fixes i carry in tip/warnings/* topic 
branches - you can find them in tip/master via:

  http://people.redhat.com/mingo/tip.git/README

the ones affecting drivers/media/ are:

  f3e67e2: fix warning in drivers/media/video/usbvision/usbvision-i2c.c
  491af31: fix warning in drivers/media/video/cx18/cx18-mailbox.c
  728342a: fix warnings in drivers/media/dvb/ttusb-dec/ttusb_dec.c
  4dda565: fix warning in drivers/media/dvb/frontends/drx397xD.c
  a2e4f4a: fix warning in drivers/media/common/tuners/mxl5007t.c
  8317adf: fix warning in drivers/media/dvb/dvb-usb/anysee.c

this one appears to be GCC warning about a real bug:

  8317adf: fix warning in drivers/media/dvb/dvb-usb/anysee.c

the others are fixes for false positives - i reviewed the affected code 
paths and each commit log includes the analysis about why it is a false 
positive.

You might ask, how did these drivers/media/ commits get into tip/master? 
It is a side-effect of us keeping tip/master continuously -Werror clean 
for 32-bit and 64-bit x86 on allyes/allno/allmod and randconfigs as well, 
Those warning fixes (for the whole kernel - including drivers/media/) go 
into the tip/warnings/* branches.

Please have a look and git-cherry-pick the above commits if they are still 
relevant to your tree and if you agree with them. Thanks,

	Ingo

------------------------->
Subject: fix warning in drivers/media/dvb/dvb-usb/af9005-fe.c
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Dec 27 12:49:36 CET 2008

this warning:

  drivers/media/dvb/dvb-usb/af9005-fe.c: In function ‘af9005_fe_refresh_state’:
  drivers/media/dvb/dvb-usb/af9005-fe.c:223: warning: ‘loc_abort_count’ may be used uninitialized in this function

triggers because GCC does not recognize the (complex but correct) error flow
between:

     - af9005_fe_refresh_state() and af9005_get_post_vit_err_cw_count()

Annotate it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
---
 drivers/media/dvb/dvb-usb/af9005-fe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/dvb/dvb-usb/af9005-fe.c
===================================================================
--- linux.orig/drivers/media/dvb/dvb-usb/af9005-fe.c
+++ linux/drivers/media/dvb/dvb-usb/af9005-fe.c
@@ -220,7 +220,7 @@ static int af9005_get_post_vit_ber(struc
 				   u16 * abort_count)
 {
 	u32 loc_cw_count = 0, loc_err_count;
-	u16 loc_abort_count;
+	u16 uninitialized_var(loc_abort_count);
 	int ret;
 
 	ret =
