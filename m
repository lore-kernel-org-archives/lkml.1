Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbZIPWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbZIPWdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbZIPWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:33:11 -0400
Received: from kroah.org ([198.145.64.141]:40963 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197AbZIPWcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:03 2009
Message-Id: <20090916222903.134440464@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 16/24] sound: oxygen: work around MCE when changing volume
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=sound-oxygen-work-around-mce-when-changing-volume.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit f1bc07af9a9edc5c1d4bdd971f7099316ed2e405 upstream.

When the volume is changed continuously (e.g., when the user drags a
volume slider with the mouse), the driver does lots of I2C writes.
Apparently, the sound chip can get confused when we poll the I2C status
register too much, and fails to complete a read from it.  On the PCI-E
models, the PCI-E/PCI bridge gets upset by this and generates a machine
check exception.

To avoid this, this patch replaces the polling with an unconditional
wait that is guaranteed to be long enough.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Tested-by: Johann Messner <johann.messner at jku.at>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/oxygen_io.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/sound/pci/oxygen/oxygen_io.c
+++ b/sound/pci/oxygen/oxygen_io.c
@@ -215,17 +215,8 @@ EXPORT_SYMBOL(oxygen_write_spi);
 
 void oxygen_write_i2c(struct oxygen *chip, u8 device, u8 map, u8 data)
 {
-	unsigned long timeout;
-
 	/* should not need more than about 300 us */
-	timeout = jiffies + msecs_to_jiffies(1);
-	do {
-		if (!(oxygen_read16(chip, OXYGEN_2WIRE_BUS_STATUS)
-		      & OXYGEN_2WIRE_BUSY))
-			break;
-		udelay(1);
-		cond_resched();
-	} while (time_after_eq(timeout, jiffies));
+	msleep(1);
 
 	oxygen_write8(chip, OXYGEN_2WIRE_MAP, map);
 	oxygen_write8(chip, OXYGEN_2WIRE_DATA, data);


