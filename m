Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYEYKbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYEYKbi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762648AbYEYKYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43348 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762592AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Tyler Trafford <ttrafford@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 04/28] cx25840: treat firmware data as const
Message-Id: <E1K0DO1-0007D2-3d@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:33 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/media/video/cx25840/cx25840-firmware.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
index 620d295..5c08ede 100644
--- a/drivers/media/video/cx25840/cx25840-firmware.c
+++ b/drivers/media/video/cx25840/cx25840-firmware.c
@@ -79,7 +79,7 @@ static int check_fw_load(struct i2c_client *client, int size)
 	return 0;
 }
 
-static int fw_write(struct i2c_client *client, u8 *data, int size)
+static int fw_write(struct i2c_client *client, const u8 *data, int size)
 {
 	if (i2c_master_send(client, data, size) < size) {
 		v4l_err(client, "firmware load i2c failure\n");
@@ -93,7 +93,8 @@ int cx25840_loadfw(struct i2c_client *client)
 {
 	struct cx25840_state *state = i2c_get_clientdata(client);
 	const struct firmware *fw = NULL;
-	u8 buffer[4], *ptr;
+	u8 buffer[FWSEND];
+	const u8 *ptr;
 	int size, retval;
 
 	if (state->is_cx23885)
@@ -108,6 +109,8 @@ int cx25840_loadfw(struct i2c_client *client)
 
 	buffer[0] = 0x08;
 	buffer[1] = 0x02;
+
+	/* Do we really need to do the first two bytes first? */
 	buffer[2] = fw->data[0];
 	buffer[3] = fw->data[1];
 	retval = fw_write(client, buffer, 4);
@@ -118,19 +121,21 @@ int cx25840_loadfw(struct i2c_client *client)
 	}
 
 	size = fw->size - 2;
-	ptr = fw->data;
+	ptr = fw->data + 2;
 	while (size > 0) {
-		ptr[0] = 0x08;
-		ptr[1] = 0x02;
-		retval = fw_write(client, ptr, min(FWSEND, size + 2));
+		int len = min(FWSEND - 2, size);
+
+		memcpy(buffer + 2, ptr, len);
+
+		retval = fw_write(client, ptr, len + 2);
 
 		if (retval < 0) {
 			release_firmware(fw);
 			return retval;
 		}
 
-		size -= FWSEND - 2;
-		ptr += FWSEND - 2;
+		size -= len;
+		ptr += len;
 	}
 
 	end_fw_load(client);
-- 
1.5.4.5

