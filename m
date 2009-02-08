Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZBHSxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZBHSxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZBHSw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:52:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:53622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbZBHSw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:52:57 -0500
Date: Sun, 8 Feb 2009 10:43:14 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, jkosina@suse.cz,
       mchehab@infradead.org
Subject: [PATCH 3/3] use the new request_module_nowait() in drivers/media
Message-ID: <20090208104314.4e74e6a8@infradead.org>
In-Reply-To: <20090208104201.6124ab6a@infradead.org>
References: <20090208104201.6124ab6a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2311993ceed96ec0bb023419120d9aeada205242 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 1 Feb 2009 12:02:39 -0800
Subject: [PATCH] use the new request_module_nowait() in drivers/media

Several drivers/media/video drivers use keventd to load modules
to avoid the "load a module from the module init code" deadlock.

Now that we have request_module_nowait() this can be simplified
greatly.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/media/video/bt8xx/bttv-driver.c    |    8 +-------
 drivers/media/video/bt8xx/bttvp.h          |    3 ---
 drivers/media/video/cx88/cx88-mpeg.c       |   14 +++-----------
 drivers/media/video/cx88/cx88.h            |    1 -
 drivers/media/video/em28xx/em28xx-cards.c  |   17 ++++-------------
 drivers/media/video/em28xx/em28xx.h        |    2 --
 drivers/media/video/saa7134/saa7134-core.c |   19 ++++++-------------
 drivers/media/video/saa7134/saa7134.h      |    2 --
 8 files changed, 14 insertions(+), 52 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index c71f394..f470318 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -175,15 +175,9 @@ static DEVICE_ATTR(card, S_IRUGO, show_card, NULL);
 /* ----------------------------------------------------------------------- */
 /* dvb auto-load setup                                                     */
 #if defined(CONFIG_MODULES) && defined(MODULE)
-static void request_module_async(struct work_struct *work)
-{
-	request_module("dvb-bt8xx");
-}
-
 static void request_modules(struct bttv *dev)
 {
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+	request_module_async("dvb-bt8xx");
 }
 #else
 #define request_modules(dev)
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 199a4d2..767d483 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -439,9 +439,6 @@ struct bttv {
 	unsigned int users;
 	struct bttv_fh init;
 
-	/* used to make dvb-bt8xx autoloadable */
-	struct work_struct request_module_wk;
-
 	/* Default (0) and current (1) video capturing and overlay
 	   cropping parameters in bttv_tvnorm.cropcap units. Protected
 	   by bttv.lock. */
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index b295b76..7215344 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -50,20 +50,12 @@ MODULE_PARM_DESC(debug,"enable debug messages [mpeg]");
 	printk(KERN_DEBUG "%s/2-mpeg: " fmt, core->name, ## arg)
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
-static void request_module_async(struct work_struct *work)
+static void request_modules(struct cx8802_dev *dev)
 {
-	struct cx8802_dev *dev=container_of(work, struct cx8802_dev, request_module_wk);
-
 	if (dev->core->board.mpeg & CX88_MPEG_DVB)
-		request_module("cx88-dvb");
+		request_module_async("cx88-dvb");
 	if (dev->core->board.mpeg & CX88_MPEG_BLACKBIRD)
-		request_module("cx88-blackbird");
-}
-
-static void request_modules(struct cx8802_dev *dev)
-{
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+		request_module_async("cx88-blackbird");
 }
 #else
 #define request_modules(dev)
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index 6025fdd..242cd62 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -510,7 +510,6 @@ struct cx8802_dev {
 
 	/* List of attached drivers */
 	struct list_head	   drvlist;
-	struct work_struct	   request_module_wk;
 };
 
 /* ----------------------------------------------------------- */
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 3b3ca3f..890f209 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -1809,24 +1809,15 @@ void em28xx_card_setup(struct em28xx *dev)
 
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
-static void request_module_async(struct work_struct *work)
+static void request_modules(struct em28xx *dev)
 {
-	struct em28xx *dev = container_of(work,
-			     struct em28xx, request_module_wk);
-
 	if (dev->has_audio_class)
-		request_module("snd-usb-audio");
+		request_module_async("snd-usb-audio");
 	else if (dev->has_alsa_audio)
-		request_module("em28xx-alsa");
+		request_module_async("em28xx-alsa");
 
 	if (dev->board.has_dvb)
-		request_module("em28xx-dvb");
-}
-
-static void request_modules(struct em28xx *dev)
-{
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+		request_module_async("em28xx-dvb");
 }
 #else
 #define request_modules(dev)
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index dd2cd36..164a543 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -498,8 +498,6 @@ struct em28xx {
 	enum em28xx_dev_state state;
 	enum em28xx_io_method io;
 
-	struct work_struct         request_module_wk;
-
 	/* locks */
 	struct mutex lock;
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 99221d7..753836c 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -149,23 +149,16 @@ void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value)
 /* delayed request_module                                      */
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
-
-static void request_module_async(struct work_struct *work){
-	struct saa7134_dev* dev = container_of(work, struct saa7134_dev, request_module_wk);
+static void request_submodules(struct saa7134_dev *dev)
+{
 	if (card_is_empress(dev))
-		request_module("saa7134-empress");
+		request_module_async("saa7134-empress");
 	if (card_is_dvb(dev))
-		request_module("saa7134-dvb");
+		request_module_async("saa7134-dvb");
 	if (alsa)
-		request_module("saa7134-alsa");
+		request_module_async("saa7134-alsa");
 	if (oss)
-		request_module("saa7134-oss");
-}
-
-static void request_submodules(struct saa7134_dev *dev)
-{
-	INIT_WORK(&dev->request_module_wk, request_module_async);
-	schedule_work(&dev->request_module_wk);
+		request_module_async("saa7134-oss");
 }
 
 #else
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 14ee265..d13d16f 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -482,8 +482,6 @@ struct saa7134_dev {
 	struct mutex               lock;
 	spinlock_t                 slock;
 	struct v4l2_prio_state     prio;
-	/* workstruct for loading modules */
-	struct work_struct request_module_wk;
 
 	/* insmod option/autodetected */
 	int                        autodetected;
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
