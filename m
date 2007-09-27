Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXI0HzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXI0HzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 03:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXI0HzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 03:55:04 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2694 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbXI0HzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 03:55:02 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: perex@suse.cz
Subject: [PATCH] sound: snd_register_device_for_dev fix
Date: Thu, 27 Sep 2007 09:54:57 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200709270954.57707.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now snd_register_device_for_dev() can oops when device_create() returns ERR_PTR(err).

Scenario:

preg->dev = device_create(...); /* fails */
if (preg->dev) /* contains ERR_PTR(err) */
	dev_set_drvdata(preg->dev, private_data);

and dev_set_drvdata() looks like this:

static inline void
dev_set_drvdata (struct device *dev, void *data)
{
	dev->driver_data = data; <--- boom
}

This patch should prevent that.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 sound/core/sound.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-2.6.23-rc8-mm1-a/sound/core/sound.c	2007-09-26 12:07:01.000000000 +0200
+++ linux-2.6.23-rc8-mm1-b/sound/core/sound.c	2007-09-27 09:36:47.000000000 +0200
@@ -266,6 +266,14 @@ int snd_register_device_for_dev(int type
 	snd_minors[minor] = preg;
 	preg->dev = device_create(sound_class, device, MKDEV(major, minor),
 				  "%s", name);
+	if (IS_ERR(preg->dev)) {
+		snd_minors[minor] = NULL;
+		mutex_unlock(&sound_mutex);
+		minor = PTR_ERR(preg->dev);
+		kfree(preg);
+		return minor;
+	}
+
 	if (preg->dev)
 		dev_set_drvdata(preg->dev, private_data);

