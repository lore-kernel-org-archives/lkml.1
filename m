Return-Path: <linux-kernel-owner+w=401wt.eu-S935183AbYETWkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbYETWkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934996AbYETWgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:36:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:39909 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290AbYETWgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:36:17 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 09/13] SOUND: fix race in device_create
Date: Tue, 20 May 2008 15:34:56 -0700
Message-Id: <1211322900-12705-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080520223237.GA12383@suse.de>
References: <20080520223237.GA12383@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race from when a device is created with device_create() and
then the drvdata is set with a call to dev_set_drvdata() in which a
sysfs file could be open, yet the drvdata will be NULL, causing all
sorts of bad things to happen.

This patch fixes the problem by using the new function,
device_create_drvdata().

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/core/sound.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/core/sound.c b/sound/core/sound.c
index 812f91b..6c8ab48 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -259,8 +259,9 @@ int snd_register_device_for_dev(int type, struct snd_card *card, int dev,
 		return minor;
 	}
 	snd_minors[minor] = preg;
-	preg->dev = device_create(sound_class, device, MKDEV(major, minor),
-				  "%s", name);
+	preg->dev = device_create_drvdata(sound_class, device,
+					  MKDEV(major, minor),
+					  private_data, "%s", name);
 	if (IS_ERR(preg->dev)) {
 		snd_minors[minor] = NULL;
 		mutex_unlock(&sound_mutex);
@@ -269,9 +270,6 @@ int snd_register_device_for_dev(int type, struct snd_card *card, int dev,
 		return minor;
 	}
 
-	if (preg->dev)
-		dev_set_drvdata(preg->dev, private_data);
-
 	mutex_unlock(&sound_mutex);
 	return 0;
 }
-- 
1.5.5.1

