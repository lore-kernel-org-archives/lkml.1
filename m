Return-Path: <linux-kernel-owner+w=401wt.eu-S1030295AbXCCOiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030295AbXCCOiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:38:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030294AbXCCOhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:37:39 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:47373 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293AbXCCOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:37:07 -0500
Message-ID: <45E987DB.1070502@linuxtv.org>
Date: Sat, 03 Mar 2007 09:36:11 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: stable@kernel.org
CC: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.20.y PATCH 6/7] V4L: fix cx25840 firmware loading
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 15 Feb 2007 03:40:34 -0300
Subject: [PATCH] V4L: fix cx25840 firmware loading

Due to changes in the i2c handling in 2.6.20 this cx25840 bug surfaced,
causing the firmware load to fail for the ivtv driver. The correct
sequence is to first attach the i2c client, then use the client's
device to load the firmware.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(cherry picked from commit d55c7aec666658495e5b57a6b194c8c2a1ac255f)
---
 drivers/media/video/cx25840/cx25840-core.c     |    4 ++--
 drivers/media/video/cx25840/cx25840-firmware.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 7bb7589..2f29ba4 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -907,13 +907,13 @@ static int cx25840_detect_client(struct i2c_adapter *adapter, int address,
 	state->vbi_line_offset = 8;
 	state->id = id;
 
+	i2c_attach_client(client);
+
 	if (state->is_cx25836)
 		cx25836_initialize(client);
 	else
 		cx25840_initialize(client, 1);
 
-	i2c_attach_client(client);
-
 	return 0;
 }
 
diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
index 1958d40..0e86b9d 100644
--- a/drivers/media/video/cx25840/cx25840-firmware.c
+++ b/drivers/media/video/cx25840/cx25840-firmware.c
@@ -37,7 +37,7 @@
  */
 #define FWSEND 48
 
-#define FWDEV(x) &((x)->adapter->dev)
+#define FWDEV(x) &((x)->dev)
 
 static char *firmware = FWFILE;
 
