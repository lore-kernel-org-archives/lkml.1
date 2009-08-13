Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZHMTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZHMTro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZHMTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:44 -0400
Received: from kroah.org ([198.145.64.141]:36691 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbZHMTrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:42 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:36 2009
Message-Id: <20090813194335.880835446@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michele Jr De Candia <michele.decandia@valueteam.com>,
       Rodolfo Giometti <giometti@linux.it>, Jean Delvare <khali@linux-fr.org>
Subject: [patch 03/28] i2c/tsl2550: Fix lux value in dark environment
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=i2c-tsl2550-fix-lux-value-in-dark-environment.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michele Jr De Candia <michele.decandia@valueteam.com>

commit 96f699ad09c8b3c55cd229506a9add0047838e3e upstream.

I've tested TSL2550 driver and I've found a bug: when light is off,
returned value from tsl2550_calculate_lux function is -1 when it should
be 0 (sensor correctly read that light was off).

I think the bug is that a zero c0 value (approximated value of ch0) is
misinterpreted as an error.

Signed-off-by: Michele Jr De Candia <michele.decandia@valueteam.com>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/chips/tsl2550.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/i2c/chips/tsl2550.c
+++ b/drivers/i2c/chips/tsl2550.c
@@ -27,7 +27,7 @@
 #include <linux/delay.h>
 
 #define TSL2550_DRV_NAME	"tsl2550"
-#define DRIVER_VERSION		"1.1.1"
+#define DRIVER_VERSION		"1.1.2"
 
 /*
  * Defines
@@ -189,13 +189,16 @@ static int tsl2550_calculate_lux(u8 ch0,
 	u8 r = 128;
 
 	/* Avoid division by 0 and count 1 cannot be greater than count 0 */
-	if (c0 && (c1 <= c0))
-		r = c1 * 128 / c0;
+	if (c1 <= c0)
+		if (c0) {
+			r = c1 * 128 / c0;
+
+			/* Calculate LUX */
+			lux = ((c0 - c1) * ratio_lut[r]) / 256;
+		} else
+			lux = 0;
 	else
-		return -1;
-
-	/* Calculate LUX */
-	lux = ((c0 - c1) * ratio_lut[r]) / 256;
+		return -EAGAIN;
 
 	/* LUX range check */
 	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;


