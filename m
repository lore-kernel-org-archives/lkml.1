Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZLGAdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZLGAdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbZLGAdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:33:37 -0500
Received: from kroah.org ([198.145.64.141]:34255 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758336AbZLGAMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:45 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:44 2009
Message-Id: <20091207000644.374616073@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Barry <seth@cyberseth.com>,
       Michael Krufky <mkrufky@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [025/119] V4L/DVB (13109): tda18271: fix signedness issue in tda18271_rf_tracking_filters_init
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13109-tda18271-fix-signedness-issue-in-tda18271_rf_tracking_filters_init.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Seth Barry <seth@cyberseth.com>

commit a57c1dcb93e43357ed3f666e5a2b5d5071dd3930 upstream.

While having tda18271 module set with debug=17 (cal & info prints) and
cal=0 (delay calibration process until first use) - I discovered that
during the calibration process, if the frequency test for 69750000
returned a bcal of 0 (see tda18721-fe.c in tda18271_powerscan func) that
the tuner wouldn't be able to pickup any of the frequencies in the range
(all the other frequencies bands returned bcal=1).  I spent some time
going over the code and the NXP's tda18271 spec (ver.4 of it i think) and
adding a lot of debug prints and walking/stepping through the calibration
process.  I found that when the powerscan fails to find a frequency, the
rf calibration is not run and the default value is supposed to be used in
its place (pulled from the RF_CAL_map table) - but something was getting
goofed up there.

Now, my c coding skills are very rusty, but i think root of the problem is
a signedness issue with the math operation for calculating the rf_a1 and
rf_a2 values in tda18271_rf_tracking_filters_init func, which results in
values like 20648 for rf_a1 (when it should probably have a value like 0,
or so slightly negative that it should be zero - this bad value for rf_a1
would in turn makes the approx calc within
tda18271c2_rf_tracking_filters_correction go out of whack).  The simplest
solution i found was to explicitly convert the signedness of the
denominator to avoid the implicit conversion.  The values placed into the
u32 rf_freq array should never exceed about 900mhz, so i think the s32 max
value shouldn't be an issue in this case.

I've tested it out a little, and even when i get a bcal=0 with the
modified code, the default calibration value gets used, rf_a1 is zero, and
the tuner seems to lock on the stream and mythtv seems to play it fine.

Signed-off-by: Seth Barry <seth@cyberseth.com>
Signed-off-by: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/common/tuners/tda18271-fe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -595,13 +595,13 @@ static int tda18271_rf_tracking_filters_
 		case RF2:
 			map[i].rf_a1 = (prog_cal[RF2] - prog_tab[RF2] -
 					prog_cal[RF1] + prog_tab[RF1]) /
-				((rf_freq[RF2] - rf_freq[RF1]) / 1000);
+				(s32)((rf_freq[RF2] - rf_freq[RF1]) / 1000);
 			map[i].rf2   = rf_freq[RF2] / 1000;
 			break;
 		case RF3:
 			map[i].rf_a2 = (prog_cal[RF3] - prog_tab[RF3] -
 					prog_cal[RF2] + prog_tab[RF2]) /
-				((rf_freq[RF3] - rf_freq[RF2]) / 1000);
+				(s32)((rf_freq[RF3] - rf_freq[RF2]) / 1000);
 			map[i].rf_b2 = prog_cal[RF2] - prog_tab[RF2];
 			map[i].rf3   = rf_freq[RF3] / 1000;
 			break;


