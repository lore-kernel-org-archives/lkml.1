Return-Path: <linux-kernel-owner+w=401wt.eu-S1757050AbZEKQhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbZEKQhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZEKQhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:37:00 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:48959 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbZEKQg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:36:59 -0400
Message-ID: <4A085455.5040108@oracle.com>
Date: Mon, 11 May 2009 09:37:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-media@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] v4l2: handle unregister for non-I2C builds
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
In-Reply-To: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.4A0853DE.029A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Build fails when CONFIG_I2C=n, so handle that case in the if block:

drivers/built-in.o: In function `v4l2_device_unregister':
(.text+0x157821): undefined reference to `i2c_unregister_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/v4l2-device.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20090511.orig/drivers/media/video/v4l2-device.c
+++ linux-next-20090511/drivers/media/video/v4l2-device.c
@@ -85,6 +85,7 @@ void v4l2_device_unregister(struct v4l2_
 	/* Unregister subdevs */
 	list_for_each_entry_safe(sd, next, &v4l2_dev->subdevs, list) {
 		v4l2_device_unregister_subdev(sd);
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 		if (sd->flags & V4L2_SUBDEV_FL_IS_I2C) {
 			struct i2c_client *client = v4l2_get_subdevdata(sd);
 
@@ -95,6 +96,7 @@ void v4l2_device_unregister(struct v4l2_
 			if (client)
 				i2c_unregister_device(client);
 		}
+#endif
 	}
 }
 EXPORT_SYMBOL_GPL(v4l2_device_unregister);


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
