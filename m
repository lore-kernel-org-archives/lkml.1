Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbXKRKNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbXKRKNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXKRKMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:12:48 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:32991 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXKRKMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:12:44 -0500
Message-Id: <20071118101155.881152613@mail.of.borg>
References: <20071118101002.730422886@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:10:04 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [patch 2/3] Amiga zorro bus: Add missing zorro_device_remove()
Content-Disposition: inline; filename=zorro-add-missing-zorro_device_remove.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

Amiga zorro bus: Add missing zorro_device_remove(). Without this ifconfig and
/proc/net/dev oops after unloading a Zorro network device driver module.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/zorro/zorro-driver.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/zorro/zorro-driver.c
+++ b/drivers/zorro/zorro-driver.c
@@ -60,6 +60,20 @@ static int zorro_device_probe(struct dev
 }
 
 
+static int zorro_device_remove(struct device *dev)
+{
+	struct zorro_dev *z = to_zorro_dev(dev);
+	struct zorro_driver *drv = to_zorro_driver(dev->driver);
+
+	if (drv) {
+		if (drv->remove)
+			drv->remove(z);
+		z->driver = NULL;
+	}
+	return 0;
+}
+
+
     /**
      *  zorro_register_driver - register a new Zorro driver
      *  @drv: the driver structure to register
@@ -128,6 +142,7 @@ struct bus_type zorro_bus_type = {
 	.name	= "zorro",
 	.match	= zorro_bus_match,
 	.probe	= zorro_device_probe,
+	.remove	= zorro_device_remove,
 };
 
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

