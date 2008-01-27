Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYA0RWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYA0RWs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYA0RWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:22:42 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51458 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYA0RWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:22:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 27 Jan 2008 18:21:56 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fail open() quickly if the node doesn't exist
 anymore
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
Message-ID: <tkrat.340b4530dff1f75a@s5r6.in-berlin.de>
References: <tkrat.e1db90404aee1115@s5r6.in-berlin.de>
 <tkrat.a4603d89e4c2fde1@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scenario:  Process A keeps the character device file of node N open.
N is being unplugged.  File /dev/fwN won't be destroyed as long as A
doesn't close it.  Now, process B opens /dev/fwN as well.  Previously
it would succeed but be unable to do any IO on it of course.  With this
patch, process B's open() will fail immediately with -ENODEV.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -616,8 +616,12 @@ struct fw_device *fw_device_from_devt(de
 
 	down_read(&idr_rwsem);
 	device = idr_find(&fw_device_idr, MINOR(devt));
-	if (device)
-		fw_device_get(device);
+	if (device) {
+		if (fw_device_is_shutdown(device))
+			device = NULL;
+		else
+			fw_device_get(device);
+	}
 	up_read(&idr_rwsem);
 
 	return device;

-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/

