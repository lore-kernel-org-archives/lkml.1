Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZGKUxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZGKUxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbZGKUxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:53:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbZGKUxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:53:36 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move arcfb's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:52:31 +0200
Message-Id: <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090711170548.GC5205@suse.de>
 <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to arcfb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/arcfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/arcfb.c b/drivers/video/arcfb.c
index c343169..01554d6 100644
--- a/drivers/video/arcfb.c
+++ b/drivers/video/arcfb.c
@@ -504,7 +504,7 @@ static struct fb_ops arcfb_ops = {
 	.fb_ioctl 	= arcfb_ioctl,
 };
 
-static int __init arcfb_probe(struct platform_device *dev)
+static int __devinit arcfb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int retval = -ENOMEM;
-- 
1.6.3.1

