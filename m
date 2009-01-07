Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZAGAg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZAGAg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZAGAgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:36:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZAGAgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:36:46 -0500
Date: Tue, 6 Jan 2009 22:36:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 5 (multimedia #3)
Message-ID: <20090106223612.180e32f5@pedra.chehab.org>
In-Reply-To: <20090105120927.1f044f59.randy.dunlap@oracle.com>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
	<20090105120927.1f044f59.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 12:09:27 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 5 Jan 2009 17:35:17 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > This tree will not build a powerpc ppc4xx_defconfig due to a kvm problem.
> > 
> > Changes since 20090102:
> 
> 
> drivers/built-in.o: In function `cx88_call_i2c_clients':
> (.text+0x20af17): undefined reference to `videobuf_dvb_get_frontend'
> drivers/built-in.o: In function `cx8802_probe':
> cx88-mpeg.c:(.devinit.text+0x268c4): undefined reference to `videobuf_dvb_alloc_frontend'
> cx88-mpeg.c:(.devinit.text+0x268ea): undefined reference to `videobuf_dvb_dealloc_frontends'

This one were trickier. Patch enclosed.

Cheers,
Mauro

---

cx88: Fix some Kbuild troubles

As Randy Dunlap <randy.dunlap@oracle.com> reported, cx88 has some compilation issues:

drivers/built-in.o: In function `cx88_call_i2c_clients':
(.text+0x20af17): undefined reference to `videobuf_dvb_get_frontend'
drivers/built-in.o: In function `cx8802_probe':
cx88-mpeg.c:(.devinit.text+0x268c4): undefined reference to `videobuf_dvb_alloc_frontend'
cx88-mpeg.c:(.devinit.text+0x268ea): undefined reference to `videobuf_dvb_dealloc_frontends'

With those configs:

CONFIG_VIDEO_CX88=y
CONFIG_VIDEO_CX88_BLACKBIRD=y
CONFIG_VIDEO_CX88_DVB=m
CONFIG_DVB_CORE=m

After carefully examining the code, with the current code, several cx88 drivers
(cx8800, cx8802, cx88_dvb and cx88_blackbird) should be compiled as a module,
if one of them is marked as such. Just fixing Kconfig could create a very complex
set of rules. Also, this hides a problem with the current approach where the dvb
functionality weren't confined inside dvb module.

What happens is that:
	- cx88-i2c (part of cx8800) has some special rules if DVB;
	- cx88-mpeg (cx8802 module) has also part of DVB init code;
	- cx88-dvb has the rest of the dvb code;
	- cx88-blackbird can be used with cx88-mpeg, having cx88-dvb or not.

So, instead of doing some tricks at Kconfig and wait for a next breakage,
this patch moves the dvb code inside cx88-i2c and cx88-mpeg into cx88-dvb.

Another problem is that cx8802 were being compiled, even without cx88-dvb
and cx88-blackbird modules.

While on this code, let's fix also a reported problem:
http://www.linuxtv.org/pipermail/linux-dvb/2009-January/031225.html

A solution for the issue were proposed here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg00021.html

Thanks to Randy, Andy, Gregoire and Thomas for helping us to detect
and solve the issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index b0f8375..69ad968 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -69,6 +69,12 @@ config VIDEO_CX88_DVB
 	  To compile this driver as a module, choose M here: the
 	  module will be called cx88-dvb.
 
+config VIDEO_CX88_MPEG
+	tristate
+	depends on VIDEO_CX88_DVB
+	depends on VIDEO_CX88_BLACKBIRD
+	default y
+
 config VIDEO_CX88_VP3054
 	tristate "VP-3054 Secondary I2C Bus Support"
 	default m
diff --git a/drivers/media/video/cx88/Makefile b/drivers/media/video/cx88/Makefile
index 6ec30f2..b06b127 100644
--- a/drivers/media/video/cx88/Makefile
+++ b/drivers/media/video/cx88/Makefile
@@ -3,7 +3,8 @@ cx88xx-objs	:= cx88-cards.o cx88-core.o cx88-i2c.o cx88-tvaudio.o \
 cx8800-objs	:= cx88-video.o cx88-vbi.o
 cx8802-objs	:= cx88-mpeg.o
 
-obj-$(CONFIG_VIDEO_CX88) += cx88xx.o cx8800.o cx8802.o
+obj-$(CONFIG_VIDEO_CX88) += cx88xx.o cx8800.o
+obj-$(CONFIG_VIDEO_CX88_MPEG) += cx8802.o
 obj-$(CONFIG_VIDEO_CX88_ALSA) += cx88-alsa.o
 obj-$(CONFIG_VIDEO_CX88_BLACKBIRD) += cx88-blackbird.o
 obj-$(CONFIG_VIDEO_CX88_DVB) += cx88-dvb.o
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index da4dd49..613dfea 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -138,6 +138,28 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 	return ret;
 }
 
+static void cx88_dvb_gate_ctrl(struct cx88_core  *core, int open)
+{
+	struct videobuf_dvb_frontends *f;
+	struct videobuf_dvb_frontend *fe;
+
+	if (!core->dvbdev)
+		return;
+
+	f = &core->dvbdev->frontends;
+
+	if (!f)
+		return;
+
+	if (f->gate <= 1) /* undefined or fe0 */
+		fe = videobuf_dvb_get_frontend(f, 1);
+	else
+		fe = videobuf_dvb_get_frontend(f, f->gate);
+
+	if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
+		fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
+}
+
 /* ------------------------------------------------------------------ */
 
 static int dvico_fusionhdtv_demod_init(struct dvb_frontend* fe)
@@ -597,12 +619,30 @@ static int dvb_register(struct cx8802_dev *dev)
 	struct cx88_core *core = dev->core;
 	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
 	int mfe_shared = 0; /* bus not shared by default */
+	int i;
 
 	if (0 != core->i2c_rc) {
 		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
 		goto frontend_detach;
 	}
 
+	if (!core->board.num_frontends)
+		return -EINVAL;
+
+	mutex_init(&dev->frontends.lock);
+	INIT_LIST_HEAD(&dev->frontends.felist);
+
+	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
+			 core->board.num_frontends);
+	for (i = 1; i <= core->board.num_frontends; i++) {
+		fe0 = videobuf_dvb_alloc_frontend(&dev->frontends, i);
+		if (!fe0) {
+			printk(KERN_ERR "%s() failed to alloc\n", __func__);
+			videobuf_dvb_dealloc_frontends(&dev->frontends);
+			goto frontend_detach;
+		}
+	}
+
 	/* Get the first frontend */
 	fe0 = videobuf_dvb_get_frontend(&dev->frontends, 1);
 	if (!fe0)
@@ -611,6 +651,9 @@ static int dvb_register(struct cx8802_dev *dev)
 	/* multi-frontend gate control is undefined or defaults to fe0 */
 	dev->frontends.gate = 0;
 
+	/* Sets the gate control callback to be used by i2c command calls */
+	core->gate_ctrl = cx88_dvb_gate_ctrl;
+
 	/* init frontend(s) */
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_DVB_T1:
@@ -1109,6 +1152,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		&dev->pci->dev, adapter_nr, mfe_shared);
 
 frontend_detach:
+	core->gate_ctrl = NULL;
 	videobuf_dvb_dealloc_frontends(&dev->frontends);
 	return -EINVAL;
 }
@@ -1270,6 +1314,8 @@ static int cx8802_dvb_remove(struct cx8802_driver *drv)
 
 	vp3054_i2c_remove(dev);
 
+	core->gate_ctrl = NULL;
+
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-i2c.c b/drivers/media/video/cx88/cx88-i2c.c
index 1ab691d..c0ff230 100644
--- a/drivers/media/video/cx88/cx88-i2c.c
+++ b/drivers/media/video/cx88/cx88-i2c.c
@@ -116,30 +116,16 @@ static int detach_inform(struct i2c_client *client)
 
 void cx88_call_i2c_clients(struct cx88_core *core, unsigned int cmd, void *arg)
 {
-#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
-	struct videobuf_dvb_frontends *f = &core->dvbdev->frontends;
-	struct videobuf_dvb_frontend *fe = NULL;
-#endif
 	if (0 != core->i2c_rc)
 		return;
 
-#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
-	if (core->dvbdev && f) {
-		if(f->gate <= 1) /* undefined or fe0 */
-			fe = videobuf_dvb_get_frontend(f, 1);
-		else
-			fe = videobuf_dvb_get_frontend(f, f->gate);
+	if (core->gate_ctrl)
+		core->gate_ctrl(core, 1);
 
-		if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
-			fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, 1);
+	i2c_clients_command(&core->i2c_adap, cmd, arg);
 
-		i2c_clients_command(&core->i2c_adap, cmd, arg);
-
-		if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
-			fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, 0);
-	} else
-#endif
-		i2c_clients_command(&core->i2c_adap, cmd, arg);
+	if (core->gate_ctrl)
+		core->gate_ctrl(core, 0);
 }
 
 static const struct i2c_algo_bit_data cx8800_i2c_algo_template = {
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 59164fc..b295b76 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -787,6 +787,9 @@ static int __devinit cx8802_probe(struct pci_dev *pci_dev,
 	dev->pci = pci_dev;
 	dev->core = core;
 
+	/* Maintain a reference so cx88-video can query the 8802 device. */
+	core->dvbdev = dev;
+
 	err = cx8802_init_common(dev);
 	if (err != 0)
 		goto fail_free;
@@ -794,32 +797,6 @@ static int __devinit cx8802_probe(struct pci_dev *pci_dev,
 	INIT_LIST_HEAD(&dev->drvlist);
 	list_add_tail(&dev->devlist,&cx8802_devlist);
 
-#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
-	mutex_init(&dev->frontends.lock);
-	INIT_LIST_HEAD(&dev->frontends.felist);
-
-	if (core->board.num_frontends) {
-		struct videobuf_dvb_frontend *fe;
-		int i;
-
-		printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
-			core->board.num_frontends);
-		for (i = 1; i <= core->board.num_frontends; i++) {
-			fe = videobuf_dvb_alloc_frontend(&dev->frontends, i);
-			if(fe == NULL) {
-				printk(KERN_ERR "%s() failed to alloc\n",
-					__func__);
-				videobuf_dvb_dealloc_frontends(&dev->frontends);
-				err = -ENOMEM;
-				goto fail_free;
-			}
-		}
-	}
-#endif
-
-	/* Maintain a reference so cx88-video can query the 8802 device. */
-	core->dvbdev = dev;
-
 	/* now autoload cx88-dvb or cx88-blackbird */
 	request_modules(dev);
 	return 0;
@@ -827,6 +804,7 @@ static int __devinit cx8802_probe(struct pci_dev *pci_dev,
  fail_free:
 	kfree(dev);
  fail_core:
+	core->dvbdev = NULL;
 	cx88_core_put(core,pci_dev);
 	return err;
 }
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index eb9ce30..60a8b31 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -302,6 +302,7 @@ struct cx88_dmaqueue {
 	struct btcx_riscmem    stopper;
 	u32                    count;
 };
+struct cx88_core;
 
 struct cx88_core {
 	struct list_head           devlist;
@@ -334,7 +335,8 @@ struct cx88_core {
 
 	/* config info -- dvb */
 #if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
-	int 			   (*prev_set_voltage)(struct dvb_frontend* fe, fe_sec_voltage_t voltage);
+	int 			   (*prev_set_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
+	void			   (*gate_ctrl)(struct cx88_core  *core, int open);
 #endif
 
 	/* state info */
