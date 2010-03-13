Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936287Ab0CMBOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:14:18 -0500
Received: from kroah.org ([198.145.64.141]:46590 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935313Ab0CMAac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:32 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.748295913@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [006/145] V4L/DVB: bttv: Move I2C IR initialization
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jean Delvare <khali@linux-fr.org>

commit 2434466432464110b5307757e0285dd41f15512e upstream.

Move I2C IR initialization from just after I2C bus setup to right
before non-I2C IR initialization. This avoids the case where an I2C IR
device is blocking audio support (at least the PV951 suffers from
this). It is also more logical to group IR support together,
regardless of the connectivity.

This fixes bug #15184:
http://bugzilla.kernel.org/show_bug.cgi?id=15184

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/bt8xx/bttv-driver.c |    1 +
 drivers/media/video/bt8xx/bttv-i2c.c    |    8 ++++++--
 drivers/media/video/bt8xx/bttvp.h       |    1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4468,6 +4468,7 @@ static int __devinit bttv_probe(struct p
 		request_modules(btv);
 	}
 
+	init_bttv_i2c_ir(btv);
 	bttv_input_init(btv);
 
 	/* everything is fine */
--- a/drivers/media/video/bt8xx/bttv-i2c.c
+++ b/drivers/media/video/bt8xx/bttv-i2c.c
@@ -388,7 +388,12 @@ int __devinit init_bttv_i2c(struct bttv
 	if (0 == btv->i2c_rc && i2c_scan)
 		do_i2c_scan(btv->c.v4l2_dev.name, &btv->i2c_client);
 
-	/* Instantiate the IR receiver device, if present */
+	return btv->i2c_rc;
+}
+
+/* Instantiate the I2C IR receiver device, if present */
+void __devinit init_bttv_i2c_ir(struct bttv *btv)
+{
 	if (0 == btv->i2c_rc) {
 		struct i2c_board_info info;
 		/* The external IR receiver is at i2c address 0x34 (0x35 for
@@ -408,7 +413,6 @@ int __devinit init_bttv_i2c(struct bttv
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
 		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
 	}
-	return btv->i2c_rc;
 }
 
 int __devexit fini_bttv_i2c(struct bttv *btv)
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -279,6 +279,7 @@ extern unsigned int bttv_debug;
 extern unsigned int bttv_gpio;
 extern void bttv_gpio_tracking(struct bttv *btv, char *comment);
 extern int init_bttv_i2c(struct bttv *btv);
+extern void init_bttv_i2c_ir(struct bttv *btv);
 extern int fini_bttv_i2c(struct bttv *btv);
 
 #define bttv_printk if (bttv_verbose) printk


