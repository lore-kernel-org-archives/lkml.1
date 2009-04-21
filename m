Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbZDUBMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbZDUBMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbZDUBLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:11:25 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:44688 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbZDUBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:11:21 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, gregkh@suse.de, kay.sievers@vrfy.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 3/4] input: set the device's name and copy it to private version
Date: Mon, 20 Apr 2009 21:17:15 -0300
Message-Id: <144d7cc77af406a1da178a50d9bc0b87b41d2884.1240272929.git.cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <9027a3b74e49f79b7138880e2cffd9bc2947ca21.1240272929.git.cascardo@holoscopio.com>
References: <1240273036-5995-1-git-send-email-cascardo@holoscopio.com>
 <2289cd3dcbe25046472d90cd0b25e57fbef92dc1.1240272929.git.cascardo@holoscopio.com>
 <9027a3b74e49f79b7138880e2cffd9bc2947ca21.1240272929.git.cascardo@holoscopio.com>
In-Reply-To: <cover.1240272928.git.cascardo@holoscopio.com>
References: <cover.1240272928.git.cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For evdev, joydev and mousedev, instead of formatting the name and
setting the device name, which will process the name for formatting
again, sets the device name and, then, copy it to the private version in
struct evdev, joydev and mousedev.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/input/evdev.c    |    4 ++--
 drivers/input/joydev.c   |    4 ++--
 drivers/input/mousedev.c |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 7a7a026..9ae6e0f 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -807,7 +807,8 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	mutex_init(&evdev->mutex);
 	init_waitqueue_head(&evdev->wait);
 
-	snprintf(evdev->name, sizeof(evdev->name), "event%d", minor);
+	dev_set_name(&evdev->dev, "event%d", minor);
+	strncpy(evdev->name, dev_name(&evdev->dev), sizeof(evdev->name));
 	evdev->exist = 1;
 	evdev->minor = minor;
 
@@ -816,7 +817,6 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
 	evdev->handle.handler = handler;
 	evdev->handle.private = evdev;
 
-	dev_set_name(&evdev->dev, evdev->name);
 	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
 	evdev->dev.class = &input_class;
 	evdev->dev.parent = &dev->dev;
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 4224f01..c216311 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -742,7 +742,8 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 	mutex_init(&joydev->mutex);
 	init_waitqueue_head(&joydev->wait);
 
-	snprintf(joydev->name, sizeof(joydev->name), "js%d", minor);
+	dev_set_name(&joydev->dev, "js%d", minor);
+	strncpy(joydev->name, dev_name(&joydev->dev), sizeof(joydev->name));
 	joydev->exist = 1;
 	joydev->minor = minor;
 
@@ -797,7 +798,6 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
 		}
 	}
 
-	dev_set_name(&joydev->dev, joydev->name);
 	joydev->dev.devt = MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + minor);
 	joydev->dev.class = &input_class;
 	joydev->dev.parent = &dev->dev;
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 17fd6d4..ceac911 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -863,10 +863,11 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	init_waitqueue_head(&mousedev->wait);
 
 	if (minor == MOUSEDEV_MIX)
-		strlcpy(mousedev->name, "mice", sizeof(mousedev->name));
+		dev_set_name(&mousedev->dev, "mice");
 	else
-		snprintf(mousedev->name, sizeof(mousedev->name),
-			 "mouse%d", minor);
+		dev_set_name(&mousedev->dev, "mouse%d", minor);
+	strncpy(mousedev->name, dev_name(&mousedev->dev),
+		sizeof(mousedev->name));
 
 	mousedev->minor = minor;
 	mousedev->exist = 1;
@@ -875,7 +876,6 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
 	mousedev->handle.handler = handler;
 	mousedev->handle.private = mousedev;
 
-	dev_set_name(&mousedev->dev, mousedev->name);
 	mousedev->dev.class = &input_class;
 	if (dev)
 		mousedev->dev.parent = &dev->dev;
-- 
1.6.2.3

