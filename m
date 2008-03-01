Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbYCAWJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbYCAWJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 17:09:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYCAWI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 17:08:57 -0500
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:3616 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYCAWI4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 17:08:56 -0500
X-Greylist: delayed 1886 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 17:08:56 EST
Date: 01 Mar 2008 22:37:26 +0100
From: Wojciech Migda <wojtek.golf@interia.pl>
Subject: [PATCH] V4L/DVB: tuner and radio addresses are missing for the PixelView PlayTV card
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 89.187.248.13
X-Mailer: PSE
Message-Id: <20080301213726.A99937190A9@f36.poczta.interia.pl>
X-EMID: dbb40acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wojciech Migda <wojtek.golf@interia.pl>

the PixelView PlayTV card definition structure was missing initialization of the tuner_addr and radio_addr fields. As a result it was impossible to have the tuner initialized using parameters specified while loading the bttv.ko module. This regression became visible after the v4l rearrangements introduced somewhere around 2.6.15 kernel version. The root cause for the tuner initialization failure is located in the attach_inform function in the bttv-i2c.c file. There at the very beginning the addr variable holding the tuner device address is initialized with the value taken from the bttv_tvcards array. For the PixelView PlayTV card the tuner address field (and the radio address as well) was uninitialized, and thus equal 0. Later in that function execution of the TUNER_SET_TYPE_ADDR tuner command is guarded with check for the tuner address either equal ADDR_UNSET, or client->addr. Since both are non-zero (the latter in case of   the card owned by me at the runtime is equal 0x61) the TUNER_SET_TYPE_ADDR command is not executed, and consequently in the tuner_attach function in the tuner-core.c file call to i2c_attach_client does not result in assigning the tuner type variable with the requested value. Providing initialization of the tuner_addr and radio_addr with ADDR_UNSET values as it is already done for other tv cards defined in bttv-cards.c ensures that the tuner initialization is done correctly, just as it used to be in the 2.6.14 kernel.


        Developer's Certificate of Origin 1.1

        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or

        (b) The contribution is based upon previous work that, to the best
            of my knowledge, is covered under an appropriate open source
            license and I have the right under that license to submit that
            work with modifications, whether created in whole or in part
            by me, under the same open source license (unless I am
            permitted to submit under a different license), as indicated
            in the file; or

        (c) The contribution was provided directly to me by some other
            person who certified (a), (b) or (c) and I have not modified
            it.

        (d) I understand and agree that this project and the contribution
            are public and that a record of the contribution (including all
            personal information I submit with it, including my sign-off) is
            maintained indefinitely and may be redistributed consistent with
            this project or the open source license(s) involved.


        Signed-off-by: Wojciech Migda <wojtek.golf@interia.pl>

---

--- drivers/media/video/bt8xx/bttv-cards.c.orig	2007-07-08 23:32:17.000000000 +0000
+++ drivers/media/video/bt8xx/bttv-cards.c	2008-03-01 20:48:19.183306298 +0000
@@ -588,6 +588,8 @@ struct tvcard bttv_tvcards[] = {
 		.needs_tvaudio	= 1,
 		.pll		= PLL_28,
 		.tuner_type	= -1,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
 	},
 	[BTTV_BOARD_WINVIEW_601] = {
 		.name		= "Leadtek WinView 601",



----------------------------------------------------------------------
Asy i Cieniasy pilkarskiej ekstraklasy
kliknij >> http://link.interia.pl/f1d27

