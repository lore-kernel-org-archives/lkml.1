Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZJPRUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZJPRUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbZJPRUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:20:33 -0400
Received: from kroah.org ([198.145.64.141]:48667 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbZJPRSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:43 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:07 2009
Message-Id: <20091016171207.294878903@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Johannes Berg <johannes@sipsolutions.net>, Takashi Iwai <tiwai@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [39/46] ALSA: Dont assume i2c device probing always succeeds
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=alsa-don-t-assume-i2c-device-probing-always-succeeds.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 18c4078489fe064cc0ed08be3381cf2f26657f5f upstream.

The client->driver pointer can be NULL when i2c-device probing fails
in i2c_new_device().  This patch adds the NULL checks for client->driver
and return the error instead of blind assumption of driver availability.

Reported-by: Tim Shepard <shep@alum.mit.edu>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/sound/aoa/codecs/tas.c
+++ b/sound/aoa/codecs/tas.c
@@ -897,6 +897,15 @@ static int tas_create(struct i2c_adapter *adapter,
 	client = i2c_new_device(adapter, &info);
 	if (!client)
 		return -ENODEV;
+	/*
+	 * We know the driver is already loaded, so the device should be
+	 * already bound. If not it means binding failed, and then there
+	 * is no point in keeping the device instantiated.
+	 */
+	if (!client->driver) {
+		i2c_unregister_device(client);
+		return -ENODEV;
+	}
 
 	/*
 	 * Let i2c-core delete that device on driver removal.
diff --git a/sound/ppc/keywest.c b/sound/ppc/keywest.c
index 835fa19..bb6819a 100644
--- a/sound/ppc/keywest.c
+++ b/sound/ppc/keywest.c
@@ -59,6 +59,18 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
 	strlcpy(info.type, "keywest", I2C_NAME_SIZE);
 	info.addr = keywest_ctx->addr;
 	keywest_ctx->client = i2c_new_device(adapter, &info);
+	if (!keywest_ctx->client)
+		return -ENODEV;
+	/*
+	 * We know the driver is already loaded, so the device should be
+	 * already bound. If not it means binding failed, and then there
+	 * is no point in keeping the device instantiated.
+	 */
+	if (!keywest_ctx->client->driver) {
+		i2c_unregister_device(keywest_ctx->client);
+		keywest_ctx->client = NULL;
+		return -ENODEV;
+	}
 	
 	/*
 	 * Let i2c-core delete that device on driver removal.


