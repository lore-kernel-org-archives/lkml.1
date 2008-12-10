Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYLJQ1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYLJQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 11:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYLJQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 11:27:14 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54078 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYLJQ1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 11:27:09 -0500
Date: Wed, 10 Dec 2008 17:26:59 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitri.vorobiev@movial.fi, dmitry.torokhov@gmail.com, dtor@mail.ru,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/28] drivers/input: Drop return value from platform_driver
 remove functions
Message-ID: <Pine.LNX.4.64.0812101726270.21998@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The return value of the remove function of a driver structure, and thus of
a platform_driver structure, is ultimately ignored, and is thus
unnecessary.  This patch removes the return value for the remove function
stored in a platform_driver structure.  For the files in this patch, the
return values are always 0.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
struct platform_driver I;
identifier a,f;
position p;
@@
I.remove = \(f@p\|a(f@p)\);

@void_called@
identifier r.f;
position p;
@@
f@p(...);

@called@
identifier r.f;
position p1 != void_called.p;
@@
f@p1(...)

@localfn@
identifier r.f;
@@
static int f(...) { ... }

@depends on !called && localfn@
struct platform_driver I;
identifier a,f;
position r.p;
@@

I.
- remove
+ remove_new
   = \(f@p\|a(f@p)\);

@depends on !called && localfn@
identifier r.f,i;
constant C;
expression E;
@@

- int
+ void
       f(...) {
  <...
(
-  return \(C\|i\);
+  return;
|
-  return E;
+  E;
+  return;
)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/input/keyboard/aaed2000_kbd.c        |    6 ++----
 drivers/input/keyboard/bf54x-keys.c          |    6 ++----
 drivers/input/keyboard/corgikbd.c            |    6 ++----
 drivers/input/keyboard/gpio_keys.c           |    6 ++----
 drivers/input/keyboard/jornada680_kbd.c      |    6 ++----
 drivers/input/keyboard/jornada720_kbd.c      |    6 ++----
 drivers/input/keyboard/omap-keypad.c         |    6 ++----
 drivers/input/keyboard/pxa27x_keypad.c       |    5 ++---
 drivers/input/keyboard/sh_keysc.c            |    5 ++---
 drivers/input/keyboard/spitzkbd.c            |    6 ++----
 drivers/input/keyboard/tosakbd.c             |    6 ++----
 drivers/input/misc/cobalt_btns.c             |    6 ++----
 drivers/input/misc/ixp4xx-beeper.c           |    6 ++----
 drivers/input/misc/m68kspkr.c                |    6 ++----
 drivers/input/misc/pcspkr.c                  |    6 ++----
 drivers/input/misc/sgi_btns.c                |    6 ++----
 drivers/input/misc/wistron_btns.c            |    6 ++----
 drivers/input/mouse/gpio_mouse.c             |    6 ++----
 drivers/input/serio/at32psif.c               |    6 ++----
 drivers/input/serio/ct82c710.c               |    6 ++----
 drivers/input/serio/i8042.c                  |    6 ++----
 drivers/input/serio/maceps2.c                |    6 ++----
 drivers/input/serio/q40kbd.c                 |    6 ++----
 drivers/input/serio/rpckbd.c                 |    5 ++---
 drivers/input/touchscreen/atmel_tsadcc.c     |    6 ++----
 drivers/input/touchscreen/corgi_ts.c         |    5 ++---
 drivers/input/touchscreen/jornada720_ts.c    |    6 ++----
 drivers/input/touchscreen/mainstone-wm97xx.c |    5 ++---
 drivers/input/touchscreen/ucb1400_ts.c       |    5 ++---
 29 files changed, 58 insertions(+), 110 deletions(-)

diff --git a/drivers/input/keyboard/aaed2000_kbd.c b/drivers/input/keyboard/aaed2000_kbd.c
index 18222a6..dd83247 100644
--- a/drivers/input/keyboard/aaed2000_kbd.c
+++ b/drivers/input/keyboard/aaed2000_kbd.c
@@ -145,15 +145,13 @@ static int __devinit aaedkbd_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __devexit aaedkbd_remove(struct platform_device *pdev)
+static void __devexit aaedkbd_remove(struct platform_device *pdev)
 {
 	struct aaedkbd *aaedkbd = platform_get_drvdata(pdev);
 
 	input_unregister_polled_device(aaedkbd->poll_dev);
 	input_free_polled_device(aaedkbd->poll_dev);
 	kfree(aaedkbd);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -161,7 +159,7 @@ MODULE_ALIAS("platform:aaed2000-keyboard");
 
 static struct platform_driver aaedkbd_driver = {
 	.probe		= aaedkbd_probe,
-	.remove		= __devexit_p(aaedkbd_remove),
+	.remove_new	= __devexit_p(aaedkbd_remove),
 	.driver		= {
 		.name	= "aaed2000-keyboard",
 		.owner	= THIS_MODULE,
diff --git a/drivers/input/keyboard/bf54x-keys.c b/drivers/input/keyboard/bf54x-keys.c
index 1928401..8e2d705 100644
--- a/drivers/input/keyboard/bf54x-keys.c
+++ b/drivers/input/keyboard/bf54x-keys.c
@@ -338,7 +338,7 @@ out:
 	return error;
 }
 
-static int __devexit bfin_kpad_remove(struct platform_device *pdev)
+static void __devexit bfin_kpad_remove(struct platform_device *pdev)
 {
 	struct bfin_kpad_platform_data *pdata = pdev->dev.platform_data;
 	struct bf54x_kpad *bf54x_kpad = platform_get_drvdata(pdev);
@@ -354,8 +354,6 @@ static int __devexit bfin_kpad_remove(struct platform_device *pdev)
 	kfree(bf54x_kpad->keycode);
 	kfree(bf54x_kpad);
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -397,7 +395,7 @@ struct platform_driver bfin_kpad_device_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= bfin_kpad_probe,
-	.remove		= __devexit_p(bfin_kpad_remove),
+	.remove_new	= __devexit_p(bfin_kpad_remove),
 	.suspend	= bfin_kpad_suspend,
 	.resume		= bfin_kpad_resume,
 };
diff --git a/drivers/input/keyboard/corgikbd.c b/drivers/input/keyboard/corgikbd.c
index c8ed065..36aa9bb 100644
--- a/drivers/input/keyboard/corgikbd.c
+++ b/drivers/input/keyboard/corgikbd.c
@@ -368,7 +368,7 @@ static int __init corgikbd_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int corgikbd_remove(struct platform_device *pdev)
+static void corgikbd_remove(struct platform_device *pdev)
 {
 	int i;
 	struct corgikbd *corgikbd = platform_get_drvdata(pdev);
@@ -382,13 +382,11 @@ static int corgikbd_remove(struct platform_device *pdev)
 	input_unregister_device(corgikbd->input);
 
 	kfree(corgikbd);
-
-	return 0;
 }
 
 static struct platform_driver corgikbd_driver = {
 	.probe		= corgikbd_probe,
-	.remove		= corgikbd_remove,
+	.remove_new	= corgikbd_remove,
 	.suspend	= corgikbd_suspend,
 	.resume		= corgikbd_resume,
 	.driver		= {
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 05f3f43..9fa35dc 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -182,7 +182,7 @@ static int __devinit gpio_keys_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __devexit gpio_keys_remove(struct platform_device *pdev)
+static void __devexit gpio_keys_remove(struct platform_device *pdev)
 {
 	struct gpio_keys_platform_data *pdata = pdev->dev.platform_data;
 	struct gpio_keys_drvdata *ddata = platform_get_drvdata(pdev);
@@ -200,8 +200,6 @@ static int __devexit gpio_keys_remove(struct platform_device *pdev)
 	}
 
 	input_unregister_device(input);
-
-	return 0;
 }
 
 
@@ -248,7 +246,7 @@ static int gpio_keys_resume(struct platform_device *pdev)
 
 static struct platform_driver gpio_keys_device_driver = {
 	.probe		= gpio_keys_probe,
-	.remove		= __devexit_p(gpio_keys_remove),
+	.remove_new	= __devexit_p(gpio_keys_remove),
 	.suspend	= gpio_keys_suspend,
 	.resume		= gpio_keys_resume,
 	.driver		= {
diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index 781fc61..8f720d4 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -239,7 +239,7 @@ static int __devinit jornada680kbd_probe(struct platform_device *pdev)
 
 }
 
-static int __devexit jornada680kbd_remove(struct platform_device *pdev)
+static void __devexit jornada680kbd_remove(struct platform_device *pdev)
 {
 	struct jornadakbd *jornadakbd = platform_get_drvdata(pdev);
 
@@ -247,8 +247,6 @@ static int __devexit jornada680kbd_remove(struct platform_device *pdev)
 	input_unregister_polled_device(jornadakbd->poll_dev);
 	input_free_polled_device(jornadakbd->poll_dev);
 	kfree(jornadakbd);
-
-	return 0;
 }
 
 static struct platform_driver jornada680kbd_driver = {
@@ -257,7 +255,7 @@ static struct platform_driver jornada680kbd_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe	= jornada680kbd_probe,
-	.remove	= __devexit_p(jornada680kbd_remove),
+	.remove_new = __devexit_p(jornada680kbd_remove),
 };
 
 static int __init jornada680kbd_init(void)
diff --git a/drivers/input/keyboard/jornada720_kbd.c b/drivers/input/keyboard/jornada720_kbd.c
index 4e016d8..7d51f93 100644
--- a/drivers/input/keyboard/jornada720_kbd.c
+++ b/drivers/input/keyboard/jornada720_kbd.c
@@ -150,7 +150,7 @@ static int __devinit jornada720_kbd_probe(struct platform_device *pdev)
 	return err;
 };
 
-static int __devexit jornada720_kbd_remove(struct platform_device *pdev)
+static void __devexit jornada720_kbd_remove(struct platform_device *pdev)
 {
 	struct jornadakbd *jornadakbd = platform_get_drvdata(pdev);
 
@@ -158,8 +158,6 @@ static int __devexit jornada720_kbd_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	input_unregister_device(jornadakbd->input);
 	kfree(jornadakbd);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -171,7 +169,7 @@ static struct platform_driver jornada720_kbd_driver = {
 		.owner	= THIS_MODULE,
 	 },
 	.probe   = jornada720_kbd_probe,
-	.remove  = __devexit_p(jornada720_kbd_remove),
+	.remove_new = __devexit_p(jornada720_kbd_remove),
 };
 
 static int __init jornada720_kbd_init(void)
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 69e674e..3549244 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -426,7 +426,7 @@ err1:
 	return -EINVAL;
 }
 
-static int omap_kp_remove(struct platform_device *pdev)
+static void omap_kp_remove(struct platform_device *pdev)
 {
 	struct omap_kp *omap_kp = platform_get_drvdata(pdev);
 
@@ -452,13 +452,11 @@ static int omap_kp_remove(struct platform_device *pdev)
 	input_unregister_device(omap_kp->input);
 
 	kfree(omap_kp);
-
-	return 0;
 }
 
 static struct platform_driver omap_kp_driver = {
 	.probe		= omap_kp_probe,
-	.remove		= omap_kp_remove,
+	.remove_new	= omap_kp_remove,
 	.suspend	= omap_kp_suspend,
 	.resume		= omap_kp_resume,
 	.driver		= {
diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 6d30c6d..903b18f 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -546,7 +546,7 @@ failed_free:
 	return error;
 }
 
-static int __devexit pxa27x_keypad_remove(struct platform_device *pdev)
+static void __devexit pxa27x_keypad_remove(struct platform_device *pdev)
 {
 	struct pxa27x_keypad *keypad = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -566,7 +566,6 @@ static int __devexit pxa27x_keypad_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 	kfree(keypad);
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -574,7 +573,7 @@ MODULE_ALIAS("platform:pxa27x-keypad");
 
 static struct platform_driver pxa27x_keypad_driver = {
 	.probe		= pxa27x_keypad_probe,
-	.remove		= __devexit_p(pxa27x_keypad_remove),
+	.remove_new	= __devexit_p(pxa27x_keypad_remove),
 	.suspend	= pxa27x_keypad_suspend,
 	.resume		= pxa27x_keypad_resume,
 	.driver		= {
diff --git a/drivers/input/keyboard/sh_keysc.c b/drivers/input/keyboard/sh_keysc.c
index c600ab7..c742636 100644
--- a/drivers/input/keyboard/sh_keysc.c
+++ b/drivers/input/keyboard/sh_keysc.c
@@ -220,7 +220,7 @@ static int __devinit sh_keysc_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __devexit sh_keysc_remove(struct platform_device *pdev)
+static void __devexit sh_keysc_remove(struct platform_device *pdev)
 {
 	struct sh_keysc_priv *priv = platform_get_drvdata(pdev);
 
@@ -232,7 +232,6 @@ static int __devexit sh_keysc_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 	kfree(priv);
-	return 0;
 }
 
 
@@ -241,7 +240,7 @@ static int __devexit sh_keysc_remove(struct platform_device *pdev)
 
 struct platform_driver sh_keysc_device_driver = {
 	.probe		= sh_keysc_probe,
-	.remove		= __devexit_p(sh_keysc_remove),
+	.remove_new	= __devexit_p(sh_keysc_remove),
 	.suspend	= sh_keysc_suspend,
 	.resume		= sh_keysc_resume,
 	.driver		= {
diff --git a/drivers/input/keyboard/spitzkbd.c b/drivers/input/keyboard/spitzkbd.c
index c48b76a..afc84bc 100644
--- a/drivers/input/keyboard/spitzkbd.c
+++ b/drivers/input/keyboard/spitzkbd.c
@@ -444,7 +444,7 @@ static int __init spitzkbd_probe(struct platform_device *dev)
 	return err;
 }
 
-static int spitzkbd_remove(struct platform_device *dev)
+static void spitzkbd_remove(struct platform_device *dev)
 {
 	int i;
 	struct spitzkbd *spitzkbd = platform_get_drvdata(dev);
@@ -464,13 +464,11 @@ static int spitzkbd_remove(struct platform_device *dev)
 	input_unregister_device(spitzkbd->input);
 
 	kfree(spitzkbd);
-
-	return 0;
 }
 
 static struct platform_driver spitzkbd_driver = {
 	.probe		= spitzkbd_probe,
-	.remove		= spitzkbd_remove,
+	.remove_new	= spitzkbd_remove,
 	.suspend	= spitzkbd_suspend,
 	.resume		= spitzkbd_resume,
 	.driver		= {
diff --git a/drivers/input/keyboard/tosakbd.c b/drivers/input/keyboard/tosakbd.c
index 677276b..fde8e61 100644
--- a/drivers/input/keyboard/tosakbd.c
+++ b/drivers/input/keyboard/tosakbd.c
@@ -378,7 +378,7 @@ fail:
 	return error;
 }
 
-static int __devexit tosakbd_remove(struct platform_device *dev)
+static void __devexit tosakbd_remove(struct platform_device *dev)
 {
 	int i;
 	struct tosakbd *tosakbd = platform_get_drvdata(dev);
@@ -396,13 +396,11 @@ static int __devexit tosakbd_remove(struct platform_device *dev)
 	input_unregister_device(tosakbd->input);
 
 	kfree(tosakbd);
-
-	return 0;
 }
 
 static struct platform_driver tosakbd_driver = {
 	.probe		= tosakbd_probe,
-	.remove		= __devexit_p(tosakbd_remove),
+	.remove_new	= __devexit_p(tosakbd_remove),
 	.suspend	= tosakbd_suspend,
 	.resume		= tosakbd_resume,
 	.driver		= {
diff --git a/drivers/input/misc/cobalt_btns.c b/drivers/input/misc/cobalt_btns.c
index 2adf9cb..3a0eb2b 100644
--- a/drivers/input/misc/cobalt_btns.c
+++ b/drivers/input/misc/cobalt_btns.c
@@ -134,7 +134,7 @@ static int __devinit cobalt_buttons_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
+static void __devexit cobalt_buttons_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct buttons_dev *bdev = dev_get_drvdata(dev);
@@ -144,8 +144,6 @@ static int __devexit cobalt_buttons_remove(struct platform_device *pdev)
 	iounmap(bdev->reg);
 	kfree(bdev);
 	dev_set_drvdata(dev, NULL);
-
-	return 0;
 }
 
 MODULE_AUTHOR("Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>");
@@ -156,7 +154,7 @@ MODULE_ALIAS("platform:Cobalt buttons");
 
 static struct platform_driver cobalt_buttons_driver = {
 	.probe	= cobalt_buttons_probe,
-	.remove	= __devexit_p(cobalt_buttons_remove),
+	.remove_new = __devexit_p(cobalt_buttons_remove),
 	.driver	= {
 		.name	= "Cobalt buttons",
 		.owner	= THIS_MODULE,
diff --git a/drivers/input/misc/ixp4xx-beeper.c b/drivers/input/misc/ixp4xx-beeper.c
index 9946d73..f454461 100644
--- a/drivers/input/misc/ixp4xx-beeper.c
+++ b/drivers/input/misc/ixp4xx-beeper.c
@@ -135,7 +135,7 @@ static int __devinit ixp4xx_spkr_probe(struct platform_device *dev)
 	return err;
 }
 
-static int __devexit ixp4xx_spkr_remove(struct platform_device *dev)
+static void __devexit ixp4xx_spkr_remove(struct platform_device *dev)
 {
 	struct input_dev *input_dev = platform_get_drvdata(dev);
 	unsigned int pin = (unsigned int) input_get_drvdata(input_dev);
@@ -148,8 +148,6 @@ static int __devexit ixp4xx_spkr_remove(struct platform_device *dev)
 	ixp4xx_spkr_control(pin, 0);
 
 	free_irq(IRQ_IXP4XX_TIMER2, dev);
-
-	return 0;
 }
 
 static void ixp4xx_spkr_shutdown(struct platform_device *dev)
@@ -168,7 +166,7 @@ static struct platform_driver ixp4xx_spkr_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ixp4xx_spkr_probe,
-	.remove		= __devexit_p(ixp4xx_spkr_remove),
+	.remove_new	= __devexit_p(ixp4xx_spkr_remove),
 	.shutdown	= ixp4xx_spkr_shutdown,
 };
 
diff --git a/drivers/input/misc/m68kspkr.c b/drivers/input/misc/m68kspkr.c
index 0c64d9b..470af5b 100644
--- a/drivers/input/misc/m68kspkr.c
+++ b/drivers/input/misc/m68kspkr.c
@@ -80,7 +80,7 @@ static int __devinit m68kspkr_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit m68kspkr_remove(struct platform_device *dev)
+static void __devexit m68kspkr_remove(struct platform_device *dev)
 {
 	struct input_dev *input_dev = platform_get_drvdata(dev);
 
@@ -88,8 +88,6 @@ static int __devexit m68kspkr_remove(struct platform_device *dev)
 	platform_set_drvdata(dev, NULL);
 	/* turn off the speaker */
 	m68kspkr_event(NULL, EV_SND, SND_BELL, 0);
-
-	return 0;
 }
 
 static void m68kspkr_shutdown(struct platform_device *dev)
@@ -104,7 +102,7 @@ static struct platform_driver m68kspkr_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= m68kspkr_probe,
-	.remove		= __devexit_p(m68kspkr_remove),
+	.remove_new	= __devexit_p(m68kspkr_remove),
 	.shutdown	= m68kspkr_shutdown,
 };
 
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index 43aaa5c..8220614 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -101,7 +101,7 @@ static int __devinit pcspkr_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit pcspkr_remove(struct platform_device *dev)
+static void __devexit pcspkr_remove(struct platform_device *dev)
 {
 	struct input_dev *pcspkr_dev = platform_get_drvdata(dev);
 
@@ -109,8 +109,6 @@ static int __devexit pcspkr_remove(struct platform_device *dev)
 	platform_set_drvdata(dev, NULL);
 	/* turn off the speaker */
 	pcspkr_event(NULL, EV_SND, SND_BELL, 0);
-
-	return 0;
 }
 
 static int pcspkr_suspend(struct platform_device *dev, pm_message_t state)
@@ -132,7 +130,7 @@ static struct platform_driver pcspkr_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= pcspkr_probe,
-	.remove		= __devexit_p(pcspkr_remove),
+	.remove_new	= __devexit_p(pcspkr_remove),
 	.suspend	= pcspkr_suspend,
 	.shutdown	= pcspkr_shutdown,
 };
diff --git a/drivers/input/misc/sgi_btns.c b/drivers/input/misc/sgi_btns.c
index be3a15f..1e8d2b4 100644
--- a/drivers/input/misc/sgi_btns.c
+++ b/drivers/input/misc/sgi_btns.c
@@ -142,7 +142,7 @@ static int __devinit sgi_buttons_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __devexit sgi_buttons_remove(struct platform_device *pdev)
+static void __devexit sgi_buttons_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct buttons_dev *bdev = dev_get_drvdata(dev);
@@ -151,13 +151,11 @@ static int __devexit sgi_buttons_remove(struct platform_device *pdev)
 	input_free_polled_device(bdev->poll_dev);
 	kfree(bdev);
 	dev_set_drvdata(dev, NULL);
-
-	return 0;
 }
 
 static struct platform_driver sgi_buttons_driver = {
 	.probe	= sgi_buttons_probe,
-	.remove	= __devexit_p(sgi_buttons_remove),
+	.remove_new = __devexit_p(sgi_buttons_remove),
 	.driver	= {
 		.name	= "sgibtns",
 		.owner	= THIS_MODULE,
diff --git a/drivers/input/misc/wistron_btns.c b/drivers/input/misc/wistron_btns.c
index 7c8957d..69c1d5b 100644
--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -1316,14 +1316,12 @@ static int __devinit wistron_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit wistron_remove(struct platform_device *dev)
+static void __devexit wistron_remove(struct platform_device *dev)
 {
 	wistron_led_remove();
 	input_unregister_polled_device(wistron_idev);
 	input_free_polled_device(wistron_idev);
 	bios_detach();
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1363,7 +1361,7 @@ static struct platform_driver wistron_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= wistron_probe,
-	.remove		= __devexit_p(wistron_remove),
+	.remove_new	= __devexit_p(wistron_remove),
 	.suspend	= wistron_suspend,
 	.resume		= wistron_resume,
 };
diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 72cf5e3..9375ef6 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -150,7 +150,7 @@ static int __init gpio_mouse_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __devexit gpio_mouse_remove(struct platform_device *pdev)
+static void __devexit gpio_mouse_remove(struct platform_device *pdev)
 {
 	struct input_polled_dev *input = platform_get_drvdata(pdev);
 	struct gpio_mouse_platform_data *pdata = input->private;
@@ -166,15 +166,13 @@ static int __devexit gpio_mouse_remove(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:gpio_mouse");
 
 struct platform_driver gpio_mouse_device_driver = {
-	.remove		= __devexit_p(gpio_mouse_remove),
+	.remove_new	= __devexit_p(gpio_mouse_remove),
 	.driver		= {
 		.name	= "gpio_mouse",
 		.owner	= THIS_MODULE,
diff --git a/drivers/input/serio/at32psif.c b/drivers/input/serio/at32psif.c
index 41fda8c..9272616 100644
--- a/drivers/input/serio/at32psif.c
+++ b/drivers/input/serio/at32psif.c
@@ -300,7 +300,7 @@ out:
 	return ret;
 }
 
-static int __exit psif_remove(struct platform_device *pdev)
+static void __exit psif_remove(struct platform_device *pdev)
 {
 	struct psif *psif = platform_get_drvdata(pdev);
 
@@ -314,8 +314,6 @@ static int __exit psif_remove(struct platform_device *pdev)
 	kfree(psif);
 
 	platform_set_drvdata(pdev, NULL);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -349,7 +347,7 @@ static int psif_resume(struct platform_device *pdev)
 #endif
 
 static struct platform_driver psif_driver = {
-	.remove		= __exit_p(psif_remove),
+	.remove_new	= __exit_p(psif_remove),
 	.driver		= {
 		.name	= "atmel_psif",
 	},
diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index d1380fc..c22a6c7 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -193,11 +193,9 @@ static int __devinit ct82c710_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit ct82c710_remove(struct platform_device *dev)
+static void __devexit ct82c710_remove(struct platform_device *dev)
 {
 	serio_unregister_port(ct82c710_port);
-
-	return 0;
 }
 
 static struct platform_driver ct82c710_driver = {
@@ -206,7 +204,7 @@ static struct platform_driver ct82c710_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= ct82c710_probe,
-	.remove		= __devexit_p(ct82c710_remove),
+	.remove_new	= __devexit_p(ct82c710_remove),
 };
 
 
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 170f71e..6cb14fc 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1215,13 +1215,11 @@ static int __devinit i8042_probe(struct platform_device *dev)
 	return error;
 }
 
-static int __devexit i8042_remove(struct platform_device *dev)
+static void __devexit i8042_remove(struct platform_device *dev)
 {
 	i8042_unregister_ports();
 	i8042_free_irqs();
 	i8042_controller_reset();
-
-	return 0;
 }
 
 static struct platform_driver i8042_driver = {
@@ -1230,7 +1228,7 @@ static struct platform_driver i8042_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= i8042_probe,
-	.remove		= __devexit_p(i8042_remove),
+	.remove_new	= __devexit_p(i8042_remove),
 	.shutdown	= i8042_shutdown,
 #ifdef CONFIG_PM
 	.suspend	= i8042_suspend,
diff --git a/drivers/input/serio/maceps2.c b/drivers/input/serio/maceps2.c
index 558200e..63678c6 100644
--- a/drivers/input/serio/maceps2.c
+++ b/drivers/input/serio/maceps2.c
@@ -152,12 +152,10 @@ static int __devinit maceps2_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit maceps2_remove(struct platform_device *dev)
+static void __devexit maceps2_remove(struct platform_device *dev)
 {
 	serio_unregister_port(maceps2_port[0]);
 	serio_unregister_port(maceps2_port[1]);
-
-	return 0;
 }
 
 static struct platform_driver maceps2_driver = {
@@ -166,7 +164,7 @@ static struct platform_driver maceps2_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= maceps2_probe,
-	.remove		= __devexit_p(maceps2_remove),
+	.remove_new	= __devexit_p(maceps2_remove),
 };
 
 static int __init maceps2_init(void)
diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index e36a090..621d38d 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -133,11 +133,9 @@ static int __devinit q40kbd_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit q40kbd_remove(struct platform_device *dev)
+static void __devexit q40kbd_remove(struct platform_device *dev)
 {
 	serio_unregister_port(q40kbd_port);
-
-	return 0;
 }
 
 static struct platform_driver q40kbd_driver = {
@@ -146,7 +144,7 @@ static struct platform_driver q40kbd_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= q40kbd_probe,
-	.remove		= __devexit_p(q40kbd_remove),
+	.remove_new	= __devexit_p(q40kbd_remove),
 };
 
 static int __init q40kbd_init(void)
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 7f36edd..52205a7 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -127,16 +127,15 @@ static int __devinit rpckbd_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __devexit rpckbd_remove(struct platform_device *dev)
+static void __devexit rpckbd_remove(struct platform_device *dev)
 {
 	struct serio *serio = platform_get_drvdata(dev);
 	serio_unregister_port(serio);
-	return 0;
 }
 
 static struct platform_driver rpckbd_driver = {
 	.probe		= rpckbd_probe,
-	.remove		= __devexit_p(rpckbd_remove),
+	.remove_new	= __devexit_p(rpckbd_remove),
 	.driver		= {
 		.name	= "kart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index a89a6a8..bd3c6c3 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -294,7 +294,7 @@ err_free_mem:
 	return err;
 }
 
-static int __devexit atmel_tsadcc_remove(struct platform_device *pdev)
+static void __devexit atmel_tsadcc_remove(struct platform_device *pdev)
 {
 	struct atmel_tsadcc *ts_dev = dev_get_drvdata(&pdev->dev);
 	struct resource *res;
@@ -311,13 +311,11 @@ static int __devexit atmel_tsadcc_remove(struct platform_device *pdev)
 	clk_put(ts_dev->clk);
 
 	kfree(ts_dev);
-
-	return 0;
 }
 
 static struct platform_driver atmel_tsadcc_driver = {
 	.probe		= atmel_tsadcc_probe,
-	.remove		= __devexit_p(atmel_tsadcc_remove),
+	.remove_new	= __devexit_p(atmel_tsadcc_remove),
 	.driver		= {
 		.name	= "atmel_tsadcc",
 	},
diff --git a/drivers/input/touchscreen/corgi_ts.c b/drivers/input/touchscreen/corgi_ts.c
index 65202c9..750c08f 100644
--- a/drivers/input/touchscreen/corgi_ts.c
+++ b/drivers/input/touchscreen/corgi_ts.c
@@ -343,7 +343,7 @@ static int __init corgits_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int corgits_remove(struct platform_device *pdev)
+static void corgits_remove(struct platform_device *pdev)
 {
 	struct corgi_ts *corgi_ts = platform_get_drvdata(pdev);
 
@@ -352,12 +352,11 @@ static int corgits_remove(struct platform_device *pdev)
 	corgi_ts->machinfo->put_hsync();
 	input_unregister_device(corgi_ts->input);
 	kfree(corgi_ts);
-	return 0;
 }
 
 static struct platform_driver corgits_driver = {
 	.probe		= corgits_probe,
-	.remove		= corgits_remove,
+	.remove_new	= corgits_remove,
 	.suspend	= corgits_suspend,
 	.resume		= corgits_resume,
 	.driver		= {
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index c8b7e8a..23dce3c 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -148,7 +148,7 @@ static int __devinit jornada720_ts_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int __devexit jornada720_ts_remove(struct platform_device *pdev)
+static void __devexit jornada720_ts_remove(struct platform_device *pdev)
 {
 	struct jornada_ts *jornada_ts = platform_get_drvdata(pdev);
 
@@ -156,8 +156,6 @@ static int __devexit jornada720_ts_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	input_unregister_device(jornada_ts->dev);
 	kfree(jornada_ts);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -165,7 +163,7 @@ MODULE_ALIAS("platform:jornada_ts");
 
 static struct platform_driver jornada720_ts_driver = {
 	.probe		= jornada720_ts_probe,
-	.remove		= __devexit_p(jornada720_ts_remove),
+	.remove_new	= __devexit_p(jornada720_ts_remove),
 	.driver		= {
 		.name	= "jornada_ts",
 		.owner	= THIS_MODULE,
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index ba64875..c21685c 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -265,17 +265,16 @@ static int mainstone_wm97xx_probe(struct platform_device *pdev)
 	return wm97xx_register_mach_ops(wm, &mainstone_mach_ops);
 }
 
-static int mainstone_wm97xx_remove(struct platform_device *pdev)
+static void mainstone_wm97xx_remove(struct platform_device *pdev)
 {
 	struct wm97xx *wm = platform_get_drvdata(pdev);
 
 	wm97xx_unregister_mach_ops(wm);
-	return 0;
 }
 
 static struct platform_driver mainstone_wm97xx_driver = {
 	.probe = mainstone_wm97xx_probe,
-	.remove = mainstone_wm97xx_remove,
+	.remove_new = mainstone_wm97xx_remove,
 	.driver = {
 		.name = "wm97xx-touch",
 	},
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 5498662..1d039f9 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -404,13 +404,12 @@ err:
 
 }
 
-static int ucb1400_ts_remove(struct platform_device *dev)
+static void ucb1400_ts_remove(struct platform_device *dev)
 {
 	struct ucb1400_ts *ucb = dev->dev.platform_data;
 
 	free_irq(ucb->irq, ucb);
 	input_unregister_device(ucb->ts_idev);
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -435,7 +434,7 @@ static int ucb1400_ts_resume(struct platform_device *dev)
 
 static struct platform_driver ucb1400_ts_driver = {
 	.probe	= ucb1400_ts_probe,
-	.remove	= ucb1400_ts_remove,
+	.remove_new = ucb1400_ts_remove,
 	.resume	= ucb1400_ts_resume,
 	.driver	= {
 		.name	= "ucb1400_ts",
