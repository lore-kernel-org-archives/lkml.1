Return-Path: <linux-kernel-owner+w=401wt.eu-S937399AbZFPGHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937399AbZFPGHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936036AbZFPFwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:52:10 -0400
Received: from kroah.org ([198.145.64.141]:48431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935913AbZFPFvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pcmcia@lists.infradead.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 46/64] pcmcia: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:35 -0700
Message-Id: <1245131213-24168-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Cc: linux-pcmcia@lists.infradead.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pcmcia/ds.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 8f2bb01..304ff6d 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -394,7 +394,7 @@ static int pcmcia_device_probe(struct device * dev)
 	p_drv = to_pcmcia_drv(dev->driver);
 	s = p_dev->socket;
 
-	/* The PCMCIA code passes the match data in via dev->driver_data
+	/* The PCMCIA code passes the match data in via dev_set_drvdata(dev)
 	 * which is an ugly hack. Once the driver probe is called it may
 	 * and often will overwrite the match data so we must save it first
 	 *
@@ -404,7 +404,7 @@ static int pcmcia_device_probe(struct device * dev)
 	 * call which will then check whether there are two
 	 * pseudo devices, and if not, add the second one.
 	 */
-	did = p_dev->dev.driver_data;
+	did = dev_get_drvdata(&p_dev->dev);
 
 	ds_dev_dbg(1, dev, "trying to bind to %s\n", p_drv->drv.name);
 
@@ -499,7 +499,7 @@ static int pcmcia_device_remove(struct device * dev)
 	 * pseudo multi-function card, we need to unbind
 	 * all devices
 	 */
-	did = p_dev->dev.driver_data;
+	did = dev_get_drvdata(&p_dev->dev);
 	if (did && (did->match_flags & PCMCIA_DEV_ID_MATCH_DEVICE_NO) &&
 	    (p_dev->socket->device_count != 0) &&
 	    (p_dev->device_no == 0))
@@ -978,7 +978,7 @@ static inline int pcmcia_devmatch(struct pcmcia_device *dev,
 			return 0;
 	}
 
-	dev->dev.driver_data = (void *) did;
+	dev_set_drvdata(&dev->dev, did);
 
 	return 1;
 }
-- 
1.6.3.2

