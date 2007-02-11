Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbXBKIQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbXBKIQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 03:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXBKIQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 03:16:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:1979 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbXBKIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 03:16:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=WAX4pw3lcy/+aJeNax9X/4huQovEUIkVkTC7au0P/f8ZWe9L0VtS1aumBdg1Qt2X2kKoUFpKw+NjryLf2lWCKoXKp3k+fwMKGJqVAzGdHwIB0N7obpyuVUBuR075+nEITIZpBlHk7E0zKakrmjZ52pAW8jjIHdGTluWX3447Smc=
Date: Sun, 11 Feb 2007 11:16:36 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: some class_device fallout
Message-ID: <20070211081636.GB16712@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As found on some arm defconfigs.

I only looked at how original patch changes things and other patches fix
compilation. ;-)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/pcmcia/at91_cf.c    |    2 +-
 drivers/pcmcia/soc_common.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -478,7 +478,7 @@ dump_bits(char **p, const char *prefix, 
  *
  * Returns: the number of characters added to the buffer
  */
-static ssize_t show_status(struct device *dev, char *buf)
+static ssize_t show_status(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct soc_pcmcia_socket *skt =
 		container_of(dev, struct soc_pcmcia_socket, socket.dev);
@@ -501,7 +501,7 @@ static ssize_t show_status(struct device
 
 	return p-buf;
 }
-static CLASS_DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
 
 
 static struct pccard_operations soc_common_pcmcia_operations = {
@@ -660,7 +660,7 @@ int soc_common_drv_pcmcia_probe(struct d
 
 		skt->socket.ops = &soc_common_pcmcia_operations;
 		skt->socket.owner = ops->owner;
-		skt->socket.dev.dev = dev;
+		skt->socket.dev.parent = dev;
 
 		init_timer(&skt->poll_timer);
 		skt->poll_timer.function = soc_common_pcmcia_poll_event;
@@ -747,7 +747,7 @@ int soc_common_drv_pcmcia_probe(struct d
 
 		add_timer(&skt->poll_timer);
 
-		device_create_file(&skt->socket.dev, &device_attr_status);
+		device_create_file(&skt->socket.dev, &dev_attr_status);
 	}
 
 	dev_set_drvdata(dev, sinfo);
--- a/drivers/pcmcia/at91_cf.c
+++ b/drivers/pcmcia/at91_cf.c
@@ -278,7 +278,7 @@ static int __init at91_cf_probe(struct p
 		board->det_pin, board->irq_pin);
 
 	cf->socket.owner = THIS_MODULE;
-	cf->socket.dev.dev = &pdev->dev;
+	cf->socket.dev.parent = &pdev->dev;
 	cf->socket.ops = &at91_cf_ops;
 	cf->socket.resource_ops = &pccard_static_ops;
 	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP

