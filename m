Return-Path: <linux-kernel-owner+w=401wt.eu-S932483AbZGPPbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbZGPPbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbZGPPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:31:37 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36613 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbZGPPbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:31:36 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] rt2x00: Fix chipset detection for rt2500usb
Date: Thu, 16 Jul 2009 16:28:11 +0100
Message-Id: <1247758091-14373-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.rc3.199.g24398
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit below changed the semantics of rt2x00_check_rev so that it no
longer checked the bottom 4 bits of the rev were non-zero.  During that
conversion this part of the check was not propogated to the rt2500usb
initialisation.

    commit 358623c22c9fd837b3b1b444377037f72553dc9f
    Author: Ivo van Doorn <ivdoorn@gmail.com>
    Date:   Tue May 5 19:46:08 2009 +0200

        rt2x00: Simplify rt2x00_check_rev

Without this check rt73 devices are miss recognised as rt2500 devices and
two drivers are loaded.  Preventing the device being used.  Reinstate this
check.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 66daf68..ce75426 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1550,7 +1550,9 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
 
-	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0)) {
+	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0) ||
+	    rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
+
 		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 		return -ENODEV;
 	}
-- 
1.6.3.rc3.199.g24398

