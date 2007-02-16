Return-Path: <linux-kernel-owner+w=401wt.eu-S1946318AbXBPXl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946318AbXBPXl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946311AbXBPXj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:28 -0500
Received: from ns.suse.de ([195.135.220.2]:39568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946300AbXBPXjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/10] pcmcia: some class_device fallout
Date: Fri, 16 Feb 2007 15:37:35 -0800
Message-Id: <11716690833227-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <11716690802025-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de> <11716690633694-git-send-email-gregkh@suse.de> <11716690662679-git-send-email-gregkh@suse.de> <11716690692008-git-send-email-gregkh@suse.de> <1171669073246-git-send-email-gregkh@suse.de> <1171669076436-git-send-email-gregkh@suse.de> <11716690802025-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

As found on some arm defconfigs.

I only looked at how original patch changes things and other patches fix
compilation. ;-)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pcmcia/at91_cf.c    |    2 +-
 drivers/pcmcia/soc_common.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
index b318628..99baabc 100644
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -277,7 +277,7 @@ static int __init at91_cf_probe(struct platform_device *pdev)
 		board->det_pin, board->irq_pin);
 
 	cf->socket.owner = THIS_MODULE;
-	cf->socket.dev.dev = &pdev->dev;
+	cf->socket.dev.parent = &pdev->dev;
 	cf->socket.ops = &at91_cf_ops;
 	cf->socket.resource_ops = &pccard_static_ops;
 	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index d2a3bea..aa7779d 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -478,7 +478,7 @@ dump_bits(char **p, const char *prefix, unsigned int val, struct bittbl *bits, i
  *
  * Returns: the number of characters added to the buffer
  */
-static ssize_t show_status(struct device *dev, char *buf)
+static ssize_t show_status(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct soc_pcmcia_socket *skt =
 		container_of(dev, struct soc_pcmcia_socket, socket.dev);
@@ -501,7 +501,7 @@ static ssize_t show_status(struct device *dev, char *buf)
 
 	return p-buf;
 }
-static CLASS_DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
 
 
 static struct pccard_operations soc_common_pcmcia_operations = {
@@ -660,7 +660,7 @@ int soc_common_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops
 
 		skt->socket.ops = &soc_common_pcmcia_operations;
 		skt->socket.owner = ops->owner;
-		skt->socket.dev.dev = dev;
+		skt->socket.dev.parent = dev;
 
 		init_timer(&skt->poll_timer);
 		skt->poll_timer.function = soc_common_pcmcia_poll_event;
@@ -747,7 +747,7 @@ int soc_common_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops
 
 		add_timer(&skt->poll_timer);
 
-		device_create_file(&skt->socket.dev, &device_attr_status);
+		device_create_file(&skt->socket.dev, &dev_attr_status);
 	}
 
 	dev_set_drvdata(dev, sinfo);
-- 
1.5.0

