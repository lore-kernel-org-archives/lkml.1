Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbYLGWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbYLGWcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYLGWcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:32:00 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38891 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792AbYLGWcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:32:00 -0500
Date: Sun, 7 Dec 2008 17:31:19 -0500 (EST)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Don't call snprintf() with overlapping input and output.
In-Reply-To: <alpine.DEB.2.00.0812070628001.13666@vinegar-pot.mit.edu>
Message-ID: <alpine.DEB.2.00.0812071727580.11053@vinegar-pot.mit.edu>
References: <alpine.DEB.2.00.0812070628001.13666@vinegar-pot.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of snprintf() to append to a buffer, as in
  snprintf(codec->name, sizeof(codec->name),
           "%s[%d]", codec->name, h->attached)
is not valid according to C99 ("If copying takes place between objects
that overlap, the behavior is undefined.").  It breaks at least in
userspace under gcc -D_FORTIFY_SOURCE.  Replace this construct with
  snprintf(codec->name + strlen(codec->name),
           sizeof(codec->name) - strlen(codec->name),
           "[%d]", h->attached);

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
---
 arch/mips/bcm47xx/prom.c               |    5 +++--
 drivers/input/joystick/analog.c        |    5 +++--
 drivers/input/misc/ati_remote.c        |    5 +++--
 drivers/media/video/zoran/videocodec.c |    5 +++--
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/mips/bcm47xx/prom.c b/arch/mips/bcm47xx/prom.c
index 079e33d..c91e3b2 100644
--- a/arch/mips/bcm47xx/prom.c
+++ b/arch/mips/bcm47xx/prom.c
@@ -118,8 +118,9 @@ static __init void prom_init_cmdline(void)
 			strcpy(buf, "uart0");

 		/* Compute the new command line */
-		snprintf(arcs_cmdline, CL_SIZE, "%s console=ttyS%c,115200",
-			 arcs_cmdline, buf[4]);
+		snprintf(arcs_cmdline + strlen(arcs_cmdline),
+			 CL_SIZE - strlen(arcs_cmdline),
+			 " console=ttyS%c,115200", buf[4]);
 	}
 }

diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 356b3a2..2fe178e 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -412,8 +412,9 @@ static void analog_name(struct analog *analog)
 		 hweight16(analog->mask & ANALOG_BTNS_GAMEPAD) + !!(analog->mask & ANALOG_HBTN_CHF) * 4);

 	if (analog->mask & ANALOG_HATS_ALL)
-		snprintf(analog->name, sizeof(analog->name), "%s %d-hat",
-			 analog->name, hweight16(analog->mask & ANALOG_HATS_ALL));
+		snprintf(analog->name + strlen(analog->name),
+			 sizeof(analog->name) - strlen(analog->name),
+			 " %d-hat", hweight16(analog->mask & ANALOG_HATS_ALL));

 	if (analog->mask & ANALOG_HAT_FCS)
 		strlcat(analog->name, " FCS", sizeof(analog->name));
diff --git a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remote.c
index e290fde..f46ce58 100644
--- a/drivers/input/misc/ati_remote.c
+++ b/drivers/input/misc/ati_remote.c
@@ -772,8 +772,9 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
 		strlcpy(ati_remote->name, udev->manufacturer, sizeof(ati_remote->name));

 	if (udev->product)
-		snprintf(ati_remote->name, sizeof(ati_remote->name),
-			 "%s %s", ati_remote->name, udev->product);
+		snprintf(ati_remote->name + strlen(ati_remote->name),
+			 sizeof(ati_remote->name) - strlen(ati_remote->name),
+			 " %s", udev->product);

 	if (!strlen(ati_remote->name))
 		snprintf(ati_remote->name, sizeof(ati_remote->name),
diff --git a/drivers/media/video/zoran/videocodec.c b/drivers/media/video/zoran/videocodec.c
index cf24956..dbcfaef 100644
--- a/drivers/media/video/zoran/videocodec.c
+++ b/drivers/media/video/zoran/videocodec.c
@@ -117,8 +117,9 @@ videocodec_attach (struct videocodec_master *master)
 			}
 			memcpy(codec, h->codec, sizeof(struct videocodec));

-			snprintf(codec->name, sizeof(codec->name),
-				 "%s[%d]", codec->name, h->attached);
+			snprintf(codec->name + strlen(codec->name),
+				 sizeof(codec->name) - strlen(codec->name),
+				 "[%d]", h->attached);
 			codec->master_data = master;
 			res = codec->setup(codec);
 			if (res == 0) {
-- 
1.6.0.4

