Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbXIDUx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbXIDUx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbXIDUxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:53:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:8146 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbXIDUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=i8M4RcwykvqarLh1niTNmb2hmSVN/zaryiGt2q5iy9pX1+J9JbOTV7nj2PU5U3Ugq8Hue8Vg7AVbk/nHIY1eY2nEChZxNtkEJCeyKZF7tgLTI6LX3nBTAJ/18REUYLHvxAPfhTsYQIQke8ZxINdRbx1H+t4IFfLOtymDWTHp7zc=
From: Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [PATCH 2.6.23-rc5] USB Mass Storage: limit "Rockchip ROCK MP3" device (071b:3203) max I/O to 64 sectors per command
Date: Tue, 4 Sep 2007 22:53:43 +0200
User-Agent: KMail/1.9.5
Cc: linux-usb-users@lists.sourceforge.net,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200709042253.43367.massimiliano.ghilardi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>

The MP3/MP4/AVI player "Rockchip ROCK MP3" is seen as a USB disk, but fails
if more than 128 sectors (64kB) are sent or requested in a single read or write
command, and disconnects from the USB bus.

Typical kernel log showing the problem is:

usb 3-1: reset high speed USB device using ehci_hcd and address 6
usb 3-1: reset high speed USB device using ehci_hcd and address 6
sd 14:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 32
sd 14:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
end_request: I/O error, dev sdb, sector 32
usb 3-1: USB disconnect, address 6

This patch works around the device limitation by adding "Rockchip ROCK MP3"
to unusual USB devices list and limiting data transfers to 64 sectors (32kB)
per command.
Tested on 2.6.23-rc5 (amd64).

Signed-off-by: Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>
---

 drivers/usb/storage/unusual_devs.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h	2007-09-01 17:08:55.000000000 +0200
+++ b/drivers/usb/storage/unusual_devs.h	2007-09-04 22:40:28.000000000 +0200
@@ -897,6 +897,22 @@
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Massimiliano Ghilardi <massimiliano.ghilardi@gmail.com>
+ * This USB MP3/AVI player device fails and disconnects if more than 128 sectors (64kB)
+ * are read/written in a single command, and may be present at least in the following products:
+ * 
+ * "Magnex Digital Video Panel DVP 1800"
+ * "MP4 AIGO 4GB SLOT SD"
+ * "Teclast TL-C260 MP3"
+ * "i.Meizu PMP MP3/MP4"
+ * "Speed MV8 MP4 Audio Player"
+ */
+UNUSUAL_DEV(  0x071b, 0x3203, 0x0100, 0x0100,
+		"RockChip",
+		"ROCK MP3",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64),
+
 /* Reported by Olivier Blondeau <zeitoun@gmail.com> */
 UNUSUAL_DEV(  0x0727, 0x0306, 0x0100, 0x0100,
 		"ATMEL",
