Return-Path: <linux-kernel-owner+w=401wt.eu-S934571AbZLGAbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571AbZLGAbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbZLGAMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:54 -0500
Received: from kroah.org ([198.145.64.141]:34261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758349AbZLGAMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:44 2009
Message-Id: <20091207000644.555026790@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henk Vergonet <Henk.Vergonet@gmail.com>,
       Michael Krufky <mkrufky@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [026/119] V4L/DVB (13107): tda18271: fix overflow in FM radio frequency calculation
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13107-tda18271-fix-overflow-in-fm-radio-frequency-calculation.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Krufky <mkrufky@kernellabs.com>

commit 4d8317876d5f53ef792e90f89d8f162d7bca5c81 upstream.

Multiplication by 62500 causes an overflow in the 32 bit freq variable,
which is later divided by 1000 when using FM radio.

This patch prevents the overflow by scaling the frequency value correctly
upfront.  Thanks to Henk Vergonet for spotting the problem and providing
a preliminary patch, which this changeset was based upon.

Cc: Henk Vergonet <Henk.Vergonet@gmail.com>
Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/common/tuners/tda18271-fe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -963,12 +963,12 @@ static int tda18271_set_analog_params(st
 	struct tda18271_std_map_item *map;
 	char *mode;
 	int ret;
-	u32 freq = params->frequency * 62500;
+	u32 freq = params->frequency * 125 *
+		((params->mode == V4L2_TUNER_RADIO) ? 1 : 1000) / 2;
 
 	priv->mode = TDA18271_ANALOG;
 
 	if (params->mode == V4L2_TUNER_RADIO) {
-		freq = freq / 1000;
 		map = &std_map->fm_radio;
 		mode = "fm";
 	} else if (params->std & V4L2_STD_MN) {


