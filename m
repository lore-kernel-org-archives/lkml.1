Return-Path: <linux-kernel-owner+w=401wt.eu-S1756065AbZBEOma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065AbZBEOma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZBEOmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:42:09 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:64376 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZBEOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hc7425KEv4HM8Y+UUvbW7iALlj9NzWchVRUJY9hIXUHfNFXhUH4VEZiFga3653XyKe
         5o8HaJ/kJMEc+B/oD7hjFTT+KF4xZHLRXhQ52vEomMz2vKCNMTVt1Sna/rtXvUCU8TET
         0lWkJ6ESWvLyQoCbUMOJ/322ON/afAHg+Hrjc=
MIME-Version: 1.0
Date: Thu, 5 Feb 2009 15:41:55 +0100
Message-ID: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
Subject: [PATCH]: Cleanup: Remove gcc format string warnings when compiling 
	with -Wformat-security (was: Re: [PATCH] Kbuild: Disable the 
	-Wformat-security gcc flag)
From: Floris Kraak <randakar@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 7:37 AM, Roland Dreier <rdreier@cisco.com> wrote:
>  > Just how many of these warnings are showing up? In the cases you
>  > posted it's presumably no problem, but if the string could either a)
>  > be potentially set by a malicious user or b) accidentally contain
>  > printk format characters then this code has a risk that things could
>  > blow up..
>
> I get ~150 of them on an x86 allyesconfig build here (see below).  Many
> but not all are trivial; some at least appear to be passing in strings
> that come from random hardware/firmware or DNS names etc (ie there's at
> least a chance of a '%'); and I didn't exhaustively audit to make sure
> none of them could print something from an unprivileged user.
>

Here's the patch that I get when I blindly patch every single location
that emits this warning.
As noted before in some cases I'm not 100% sure this is the right way
to go about it but it certainly is the KISS solution.

If needed I can attempt to split this monster into 135 patches but
given my limited experience with the tools involved a little help on
how to go about creating such a series would be appreciated ;-)

---
Cleanup: Remove gcc format string warnings when compiling with -Wformat-security

When compiling the kernel with an allyesconfig and the gcc flags
-Wformat and -Wformat-security the build process emits 135 warnings
along these lines:

init/main.c:557: warning: format not a string literal and no format arguments
init/initramfs.c:582: warning: format not a string literal and no
format arguments
arch/x86/kernel/dumpstack.c:115: warning: format not a string literal
and no format arguments
...

While many of these warnings are harmless - the format string is
statically set within the kernel itself and is known to not contain
any format qualifiers - a number of them are potentially less so.
This patch fixes all known call sites emitting this warning.

Signed-off-by: Floris Kraak <randakar@gmail.com>
---
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 6b1f6f6..ec288b9 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -112,7 +112,7 @@ print_context_stack(struct thread_info *tinfo,
 static void
 print_trace_warning_symbol(void *data, char *msg, unsigned long symbol)
 {
-	printk(data);
+	printk("%s", data);
 	print_symbol(msg, symbol);
 	printk("\n");
 }
@@ -134,7 +134,7 @@ static int print_trace_stack(void *data, char *name)
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	touch_nmi_watchdog();
-	printk(data);
+	printk("%s", data);
 	printk_address(addr, reliable);
 }

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index e858268..6476824 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1174,8 +1174,8 @@ u64 __init e820_hole_size(u64 start, u64 end)

 static void early_panic(char *msg)
 {
-	early_printk(msg);
-	panic(msg);
+	early_printk("%s", msg);
+	panic("%s", msg);
 }

 static int userdef __initdata;
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 7c41e74..e4e236f 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -424,7 +424,8 @@ static struct crypto_template
*__crypto_lookup_template(const char *name)

 struct crypto_template *crypto_lookup_template(const char *name)
 {
-	return try_then_request_module(__crypto_lookup_template(name), name);
+	return try_then_request_module(__crypto_lookup_template(name),
+					"%s", name);
 }
 EXPORT_SYMBOL_GPL(crypto_lookup_template);

diff --git a/crypto/api.c b/crypto/api.c
index 9975a7b..a9d6f0d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -216,7 +216,7 @@ struct crypto_alg *crypto_larval_lookup(const char
*name, u32 type, u32 mask)
 	type &= mask;

 	alg = try_then_request_module(crypto_alg_lookup(name, type, mask),
-				      name);
+				      "%s", name);
 	if (alg)
 		return crypto_is_larval(alg) ? crypto_larval_wait(alg) : alg;

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index d29e06b..161ceb2 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -544,7 +544,7 @@ static inline int cryptd_create_thread(struct
cryptd_state *state,
 	mutex_init(&state->mutex);
 	crypto_init_queue(&state->queue, CRYPTD_MAX_QLEN);

-	state->task = kthread_run(fn, state, name);
+	state->task = kthread_run(fn, state, "%s", name);
 	if (IS_ERR(state->task))
 		return PTR_ERR(state->task);

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index e1c7611..e9304dd 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -979,7 +979,7 @@ static void xdump( u_char*  cp, int  length, char*  prefix )
                 }
         sprintf( pBuf, "\n" );
         // SPrint(prntBuf);
-        printk(prntBuf);
+        printk("%s", prntBuf);
         count += col;
         pBuf = prntBuf;
     }
diff --git a/drivers/base/attribute_container.c
b/drivers/base/attribute_container.c
index b9cda05..e0f7859 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -167,7 +167,7 @@ attribute_container_add_device(struct device *dev,
 		ic->classdev.parent = get_device(dev);
 		ic->classdev.class = cont->class;
 		cont->class->dev_release = attribute_container_release;
-		dev_set_name(&ic->classdev, dev_name(dev));
+		dev_set_name(&ic->classdev, "%s", dev_name(dev));
 		if (fn)
 			fn(cont, dev, &ic->classdev);
 		else
diff --git a/drivers/base/core.c b/drivers/base/core.c
index f3eae63..218e9c4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1247,7 +1247,7 @@ struct device *__root_device_register(const char
*name, struct module *owner)
 	if (!root)
 		return ERR_PTR(err);

-	err = dev_set_name(&root->dev, name);
+	err = dev_set_name(&root->dev, "%s", name);
 	if (err) {
 		kfree(root);
 		return ERR_PTR(err);
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 44699d9..660a39c 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -315,7 +315,7 @@ static int fw_register_device(struct device
**dev_p, const char *fw_name,
 	fw_priv->timeout.data = (u_long) fw_priv;
 	init_timer(&fw_priv->timeout);

-	dev_set_name(f_dev, dev_name(device));
+	dev_set_name(f_dev, "%s", dev_name(device));
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 349a101..030d638 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -244,7 +244,7 @@ int platform_device_add(struct platform_device *pdev)
 	if (pdev->id != -1)
 		dev_set_name(&pdev->dev, "%s.%d", pdev->name,  pdev->id);
 	else
-		dev_set_name(&pdev->dev, pdev->name);
+		dev_set_name(&pdev->dev, "%s", pdev->name);

 	for (i = 0; i < pdev->num_resources; i++) {
 		struct resource *p, *r = &pdev->resource[i];
diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index c98c31e..736ecf7 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -137,7 +137,7 @@ int sysdev_class_register(struct sysdev_class * cls)
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
-	kobject_set_name(&cls->kset.kobj, cls->name);
+	kobject_set_name(&cls->kset.kobj, "%s", cls->name);
 	return kset_register(&cls->kset);
 }

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 200efc4..ec4eede 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -286,7 +286,7 @@ aoechr_init(void)
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
 		device_create(aoe_class, NULL,
 			      MKDEV(AOE_MAJOR, chardevs[i].minor), NULL,
-			      chardevs[i].name);
+			      "%s", chardevs[i].name);

 	return 0;
 }
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 34f80fa..010c38b 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -654,7 +654,8 @@ static int nbd_ioctl(struct block_device *bdev,
fmode_t mode,
 			return -EBUSY;
 		if (!lo->file)
 			return -EINVAL;
-		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
+		thread = kthread_create(nbd_thread, lo,
+					"%s", lo->disk->disk_name);
 		if (IS_ERR(thread))
 			return PTR_ERR(thread);
 		wake_up_process(thread);
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index cceace6..2e68188 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3376,7 +3376,7 @@ static int cdrom_print_info(const char *header,
int val, char *info,
 	struct cdrom_device_info *cdi;
 	int ret;

-	ret = scnprintf(info + *pos, max_size - *pos, header);
+	ret = scnprintf(info + *pos, max_size - *pos, "%s", header);
 	if (!ret)
 		return 1;

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 3586b3b..ba3bf43 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -991,7 +991,7 @@ static int __init chr_dev_init(void)
 	for (i = 0; i < ARRAY_SIZE(devlist); i++)
 		device_create(mem_class, NULL,
 			      MKDEV(MEM_MAJOR, devlist[i].minor), NULL,
-			      devlist[i].name);
+			      "%s", devlist[i].name);

 	return 0;
 }
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index bc84e12..22ccf6b 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2847,7 +2847,7 @@ struct device *tty_register_device(struct
tty_driver *driver, unsigned index,
 	else
 		tty_line_name(driver, index, name);

-	return device_create(tty_class, device, dev, NULL, name);
+	return device_create(tty_class, device, dev, NULL, "%s", name);
 }
 EXPORT_SYMBOL(tty_register_device);

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b55cb67..a0d3c60 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -241,7 +241,7 @@ void cpufreq_debug_printk(unsigned int type, const
char *prefix,
 		len += vsnprintf(&s[len], (256 - len), fmt, args);
 		va_end(args);

-		printk(s);
+		printk("%s", s);

 		WARN_ON(len < 5);
 	}
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 633e1a1..8ae5f52 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1292,7 +1292,7 @@ static int adt7470_probe(struct i2c_client *client,

 	init_completion(&data->auto_update_stop);
 	data->auto_update = kthread_run(adt7470_update_thread, client,
-					dev_name(data->hwmon_dev));
+					"%s", dev_name(data->hwmon_dev));
 	if (IS_ERR(data->auto_update))
 		goto exit_unregister;

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ce0818a..965c2d5 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -647,7 +647,7 @@ static int ide_register_port(ide_hwif_t *hwif)
 	int ret;

 	/* register with global device tree */
-	dev_set_name(&hwif->gendev, hwif->name);
+	dev_set_name(&hwif->gendev, "%s", hwif->name);
 	hwif->gendev.driver_data = hwif;
 	if (hwif->gendev.parent == NULL)
 		hwif->gendev.parent = hwif->dev;
@@ -661,7 +661,7 @@ static int ide_register_port(ide_hwif_t *hwif)
 	}

 	hwif->portdev = device_create(ide_port_class, &hwif->gendev,
-				      MKDEV(0, 0), hwif, hwif->name);
+				      MKDEV(0, 0), hwif, "%s", hwif->name);
 	if (IS_ERR(hwif->portdev)) {
 		ret = PTR_ERR(hwif->portdev);
 		device_unregister(&hwif->gendev);
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index b43f7d3..4d55571 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -778,7 +778,7 @@ int ib_device_register_sysfs(struct ib_device *device)
 	class_dev->class      = &ib_class;
 	class_dev->driver_data = device;
 	class_dev->parent     = device->dma_device;
-	dev_set_name(class_dev, device->name);
+	dev_set_name(class_dev, "%s", device->name);

 	INIT_LIST_HEAD(&device->port_list);

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c
b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 2317398..1e35f00 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -2449,7 +2449,7 @@ static int init_cdev(int minor, char *name,
const struct file_operations *fops,

 	cdev->owner = THIS_MODULE;
 	cdev->ops = fops;
-	kobject_set_name(&cdev->kobj, name);
+	kobject_set_name(&cdev->kobj, "%s", name);

 	ret = cdev_add(cdev, dev, 1);
 	if (ret < 0) {
@@ -2459,7 +2459,7 @@ static int init_cdev(int minor, char *name,
const struct file_operations *fops,
 		goto err_cdev;
 	}

-	device = device_create(ipath_class, NULL, dev, NULL, name);
+	device = device_create(ipath_class, NULL, dev, NULL, "%s", name);

 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index ed8baa0..42982c3 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -819,7 +819,7 @@ static int evdev_connect(struct input_handler
*handler, struct input_dev *dev,
 	evdev->handle.handler = handler;
 	evdev->handle.private = evdev;

-	dev_set_name(&evdev->dev, evdev->name);
+	dev_set_name(&evdev->dev, "%s", evdev->name);
 	evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
 	evdev->dev.class = &input_class;
 	evdev->dev.parent = &dev->dev;
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 6f23662..8a7b67f 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -800,7 +800,7 @@ static int joydev_connect(struct input_handler
*handler, struct input_dev *dev,
 		}
 	}

-	dev_set_name(&joydev->dev, joydev->name);
+	dev_set_name(&joydev->dev, "%s", joydev->name);
 	joydev->dev.devt = MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + minor);
 	joydev->dev.class = &input_class;
 	joydev->dev.parent = &dev->dev;
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index ef99a7e..de3eaed 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -878,7 +878,7 @@ static struct mousedev *mousedev_create(struct
input_dev *dev,
 	mousedev->handle.handler = handler;
 	mousedev->handle.private = mousedev;

-	dev_set_name(&mousedev->dev, mousedev->name);
+	dev_set_name(&mousedev->dev, "%s", mousedev->name);
 	mousedev->dev.class = &input_class;
 	if (dev)
 		mousedev->dev.parent = &dev->dev;
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 7d005a3..29face8 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1370,7 +1370,7 @@ static ssize_t
show_tabletDiagnosticMessage(struct device *dev, struct device_at
 	default:
 		return 0;
 	}
-	return snprintf(buf, PAGE_SIZE, retMsg);
+	return snprintf(buf, PAGE_SIZE, "%s", retMsg);
 }

 static DEVICE_ATTR(diagnostic, S_IRUGO, show_tabletDiagnosticMessage, NULL);
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c
b/drivers/isdn/mISDN/dsp_pipeline.c
index 18cf87c..0b51eb0 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -101,7 +101,7 @@ int mISDN_dsp_element_register(struct
mISDN_dsp_element *elem)
 	entry->dev.class = elements_class;
 	entry->dev.release = mISDN_dsp_dev_release;
 	dev_set_drvdata(&entry->dev, elem);
-	dev_set_name(&entry->dev, elem->name);
+	dev_set_name(&entry->dev, "%s", elem->name);
 	ret = device_register(&entry->dev);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to register %s\n",
diff --git a/drivers/media/video/cx2341x.c b/drivers/media/video/cx2341x.c
index cbbe47f..7dca1eb 100644
--- a/drivers/media/video/cx2341x.c
+++ b/drivers/media/video/cx2341x.c
@@ -471,7 +471,7 @@ static int cx2341x_ctrl_query_fill(struct
v4l2_queryctrl *qctrl,
 	qctrl->step = step;
 	qctrl->default_value = def;
 	qctrl->reserved[0] = qctrl->reserved[1] = 0;
-	snprintf(qctrl->name, sizeof(qctrl->name), name);
+	snprintf(qctrl->name, sizeof(qctrl->name), "%s", name);
 	return 0;
 }

diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index fa304e5..42ccab0 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -1967,7 +1967,7 @@ static void pvr2_hdw_setup_low(struct pvr2_hdw *hdw)
 	if (!pvr2_hdw_dev_ok(hdw)) return;

 	for (idx = 0; idx < hdw->hdw_desc->client_modules.cnt; idx++) {
-		request_module(hdw->hdw_desc->client_modules.lst[idx]);
+		request_module("%s", hdw->hdw_desc->client_modules.lst[idx]);
 	}

 	if (!hdw->hdw_desc->flag_no_powerup) {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c
b/drivers/media/video/pvrusb2/pvrusb2-std.c
index ca9f83a..c18091e 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-std.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-std.c
@@ -216,7 +216,7 @@ unsigned int pvr2_std_id_to_str(char *bufPtr,
unsigned int bufSize,
 			bufSize -= c2;
 			bufPtr += c2;
 			c2 = scnprintf(bufPtr,bufSize,
-				       ip->name);
+				       "%s", ip->name);
 			c1 += c2;
 			bufSize -= c2;
 			bufPtr += c2;
diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 5aeccb3..3dc3520 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -1913,7 +1913,8 @@ static int tvaudio_probe(struct i2c_client
*client, const struct i2c_device_id *
 		init_timer(&chip->wt);
 		chip->wt.function = chip_thread_wake;
 		chip->wt.data     = (unsigned long)chip;
-		chip->thread = kthread_run(chip_thread, chip, client->name);
+		chip->thread = kthread_run(chip_thread, chip,
+						"%s", client->name);
 		if (IS_ERR(chip->thread)) {
 			v4l2_warn(sd, "failed to create kthread\n");
 			chip->thread = NULL;
diff --git a/drivers/media/video/v4l2-common.c
b/drivers/media/video/v4l2-common.c
index b8f2be8..f816485 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -555,7 +555,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl
*qctrl, s32 min, s32 max, s32 ste
 	qctrl->step = step;
 	qctrl->default_value = def;
 	qctrl->reserved[0] = qctrl->reserved[1] = 0;
-	snprintf(qctrl->name, sizeof(qctrl->name), name);
+	snprintf(qctrl->name, sizeof(qctrl->name), "%s", name);
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_query_fill);
@@ -720,7 +720,8 @@ int v4l2_ctrl_query_menu(struct v4l2_querymenu
*qmenu, struct v4l2_queryctrl *qc
 	for (i = 0; i < qmenu->index && menu_items[i]; i++) ;
 	if (menu_items[i] == NULL || menu_items[i][0] == '\0')
 		return -EINVAL;
-	snprintf(qmenu->name, sizeof(qmenu->name), menu_items[qmenu->index]);
+	snprintf(qmenu->name, sizeof(qmenu->name),
+		"%s", menu_items[qmenu->index]);
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_query_menu);
@@ -738,7 +739,7 @@ int v4l2_ctrl_query_menu_valid_items(struct
v4l2_querymenu *qmenu, const u32 *id
 	while (*ids != V4L2_CTRL_MENU_IDS_END) {
 		if (*ids++ == qmenu->index) {
 			snprintf(qmenu->name, sizeof(qmenu->name),
-				       menu_items[qmenu->index]);
+				       "%s", menu_items[qmenu->index]);
 			return 0;
 		}
 	}
diff --git a/drivers/media/video/zoran/zoran_card.c
b/drivers/media/video/zoran/zoran_card.c
index 5d2f090..ab8c700 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -1418,7 +1418,7 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	}

 	if (i2c_dec_name) {
-		result = request_module(i2c_dec_name);
+		result = request_module("%s", i2c_dec_name);
 		if (result < 0) {
 			dprintk(1,
 				KERN_ERR
@@ -1438,7 +1438,7 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	}

 	if (i2c_enc_name) {
-		result = request_module(i2c_enc_name);
+		result = request_module("%s", i2c_enc_name);
 		if (result < 0) {
 			dprintk(1,
 				KERN_ERR
@@ -1462,7 +1462,7 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	if (zr->card.video_codec) {
 		codec_name = codecid_to_modulename(zr->card.video_codec);
 		if (codec_name) {
-			result = request_module(codec_name);
+			result = request_module("%s", codec_name);
 			if (result) {
 				dprintk(1,
 					KERN_ERR
@@ -1474,7 +1474,7 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	if (zr->card.video_vfe) {
 		vfe_name = codecid_to_modulename(zr->card.video_vfe);
 		if (vfe_name) {
-			result = request_module(vfe_name);
+			result = request_module("%s", vfe_name);
 			if (result < 0) {
 				dprintk(1,
 					KERN_ERR
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 3cf61ec..74a78d4 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -119,7 +119,7 @@ enclosure_register(struct device *dev, const char
*name, int components,
 	edev->edev.class = &enclosure_class;
 	edev->edev.parent = get_device(dev);
 	edev->cb = cb;
-	dev_set_name(&edev->edev, name);
+	dev_set_name(&edev->edev, "%s", name);
 	err = device_register(&edev->edev);
 	if (err)
 		goto err;
@@ -256,7 +256,7 @@ enclosure_component_register(struct enclosure_device *edev,
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
 	if (name)
-		dev_set_name(cdev, name);
+		dev_set_name(cdev, "%s", name);
 	else
 		dev_set_name(cdev, "%u", number);

diff --git a/drivers/mtd/chips/gen_probe.c b/drivers/mtd/chips/gen_probe.c
index e2dc964..1946af7 100644
--- a/drivers/mtd/chips/gen_probe.c
+++ b/drivers/mtd/chips/gen_probe.c
@@ -212,7 +212,8 @@ static inline struct mtd_info
*cfi_cmdset_unknown(struct map_info *map,

 	probe_function = __symbol_get(probename);
 	if (!probe_function) {
-		request_module(probename + sizeof(MODULE_SYMBOL_PREFIX) - 1);
+		request_module("%s",
+			probename + sizeof(MODULE_SYMBOL_PREFIX) - 1);
 		probe_function = __symbol_get(probename);
 	}

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 4048db8..f55d780 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -848,7 +848,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int
ubi_num, int vid_hdr_offset)
 	if (err)
 		goto out_nofree;

-	ubi->bgt_thread = kthread_create(ubi_thread, ubi, ubi->bgt_name);
+	ubi->bgt_thread = kthread_create(ubi_thread, ubi, "%s", ubi->bgt_name);
 	if (IS_ERR(ubi->bgt_thread)) {
 		err = PTR_ERR(ubi->bgt_thread);
 		ubi_err("cannot spawn \"%s\", error %d", ubi->bgt_name,
diff --git a/drivers/net/3c59x.c b/drivers/net/3c59x.c
index cdbbb62..ed66c3d 100644
--- a/drivers/net/3c59x.c
+++ b/drivers/net/3c59x.c
@@ -1015,7 +1015,7 @@ static int __devinit vortex_probe1(struct device *gendev,
 	struct eisa_device *edev = NULL;

 	if (!printed_version) {
-		printk (version);
+		printk("%s", version);
 		printed_version = 1;
 	}

@@ -2883,7 +2883,7 @@ static void vortex_get_drvinfo(struct net_device *dev,
 		strcpy(info->bus_info, pci_name(VORTEX_PCI(vp)));
 	} else {
 		if (VORTEX_EISA(vp))
-			sprintf(info->bus_info, dev_name(vp->gendev));
+			sprintf(info->bus_info, "%s", dev_name(vp->gendev));
 		else
 			sprintf(info->bus_info, "EISA 0x%lx %d",
 					dev->base_addr, dev->irq);
diff --git a/drivers/net/acenic.c b/drivers/net/acenic.c
index 9589d62..c39ce35 100644
--- a/drivers/net/acenic.c
+++ b/drivers/net/acenic.c
@@ -500,7 +500,7 @@ static int __devinit acenic_probe_one(struct pci_dev *pdev,

 	/* we only display this string ONCE */
 	if (!boards_found)
-		printk(version);
+		printk("%s", version);

 	if (pci_enable_device(pdev))
 		goto fail_free_netdev;
diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
index 6445ced..d6da3f1 100644
--- a/drivers/net/defxx.c
+++ b/drivers/net/defxx.c
@@ -531,7 +531,7 @@ static int __devinit dfx_register(struct device *bdev)

 	if (!version_disp) {	/* display version info if adapter is found */
 		version_disp = 1;	/* set display flag to TRUE so that */
-		printk(version);	/* we only display this string ONCE */
+		printk("%s", version);	/* we only display this string ONCE */
 	}

 	dev = alloc_fddidev(sizeof(*bp));
diff --git a/drivers/net/eql.c b/drivers/net/eql.c
index 4012569..9364ab2 100644
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -584,7 +584,7 @@ static int __init eql_init_module(void)
 {
 	int err;

-	printk(version);
+	printk("%s", version);

 	dev_eql = alloc_netdev(sizeof(equalizer_t), "eql", eql_setup);
 	if (!dev_eql)
diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
index daf7272..26c8b5c 100644
--- a/drivers/net/fealnx.c
+++ b/drivers/net/fealnx.c
@@ -503,7 +503,7 @@ static int __devinit fealnx_init_one(struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	card_idx++;
diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 5b910cf..f9b4b5d 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -923,7 +923,7 @@ static int reg_delay(struct net_device *dev, int
offset, u32 mask, u32 target,
 		delaymax -= delay;
 		if (delaymax < 0) {
 			if (msg)
-				printk(msg);
+				printk("%s", msg);
 			return 1;
 		}
 	} while ((readl(base + offset) & mask) != target);
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index 7e8b3c5..21010e0 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -601,7 +601,7 @@ static int __devinit hamachi_init_one (struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	if (pci_enable_device(pdev)) {
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 2d40898..f977bb6 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -797,7 +797,7 @@ static int __init sixpack_init_driver(void)
 {
 	int status;

-	printk(msg_banner);
+	printk("%s", msg_banner);

 	/* Register the provided line protocol discipline */
 	if ((status = tty_register_ldisc(N_6PACK, &sp_ldisc)) != 0)
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 46f8f33..fc9e6af 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -614,7 +614,7 @@ static int __init bpq_init_driver(void)

 	register_netdevice_notifier(&bpq_dev_notifier);

-	printk(banner);
+	printk("%s", banner);

 	return 0;
 }
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index bbdb311..5df26ef 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -991,10 +991,10 @@ static int __init mkiss_init_driver(void)
 {
 	int status;

-	printk(banner);
+	printk("%s", banner);

 	if ((status = tty_register_ldisc(N_AX25, &ax_ldisc)) != 0)
-		printk(msg_regfail);
+		printk("%s", msg_regfail);

 	return status;
 }
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 5407f74..37eda03 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1114,7 +1114,7 @@ static int __init yam_init_driver(void)
 	int i, err;
 	char name[IFNAMSIZ];

-	printk(yam_drvinfo);
+	printk("%s", yam_drvinfo);

 	for (i = 0; i < NR_PORTS; i++) {
 		sprintf(name, "yam%d", i);
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index c5dec54..19938d6 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -813,7 +813,7 @@ static int __devinit natsemi_probe1 (struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	i = pci_enable_device(pdev);
diff --git a/drivers/net/ne2k-pci.c b/drivers/net/ne2k-pci.c
index f090d3b..19cccd4 100644
--- a/drivers/net/ne2k-pci.c
+++ b/drivers/net/ne2k-pci.c
@@ -231,7 +231,7 @@ static int __devinit ne2k_pci_init_one (struct
pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	fnd_cnt++;
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 0afa720..de9fb96 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -1713,7 +1713,7 @@ static void axdev_setup(struct net_device *dev)
 {
 	struct ei_device *ei_local;
 	if (ei_debug > 1)
-		printk(version_8390);
+		printk("%s", version_8390);

 	ei_local = (struct ei_device *)netdev_priv(dev);
 	spin_lock_init(&ei_local->page_lock);
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 811a637..68f0a30 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -98,7 +98,7 @@ int mdiobus_register(struct mii_bus *bus)
 	bus->dev.parent = bus->parent;
 	bus->dev.class = &mdio_bus_class;
 	bus->dev.groups = NULL;
-	dev_set_name(&bus->dev, bus->id);
+	dev_set_name(&bus->dev, "%s", bus->id);

 	err = device_register(&bus->dev);
 	if (err) {
diff --git a/drivers/net/rrunner.c b/drivers/net/rrunner.c
index d890829..a4c9c22 100644
--- a/drivers/net/rrunner.c
+++ b/drivers/net/rrunner.c
@@ -134,7 +134,7 @@ static int __devinit rr_init_one(struct pci_dev *pdev,
 		/* set display flag to TRUE so that */
 		/* we only display this string ONCE */
 		version_disp = 1;
-		printk(version);
+		printk("%s", version);
 	}

 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &pci_latency);
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index be4465b..9b42659 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -425,7 +425,7 @@ static int __devinit sis900_probe(struct pci_dev *pci_dev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	/* setup various bits in PCI command register */
diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index da3a76b..4a39b5a 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -682,7 +682,7 @@ static int __devinit starfire_init_one(struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	card_idx++;
diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index feaf0e0..b580743 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -486,7 +486,7 @@ static int __devinit sundance_probe1 (struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	if (pci_enable_device(pdev))
diff --git a/drivers/net/tulip/de4x5.c b/drivers/net/tulip/de4x5.c
index 6418f74..aa034f5 100644
--- a/drivers/net/tulip/de4x5.c
+++ b/drivers/net/tulip/de4x5.c
@@ -1265,7 +1265,7 @@ de4x5_hw_init(struct net_device *dev, u_long
iobase, struct device *gendev)
     }

     if (de4x5_debug & DEBUG_VERSION) {
-	printk(version);
+	printk("%s", version);
     }

     /* The DE4X5-specific entries in the device structure. */
diff --git a/drivers/net/tulip/dmfe.c b/drivers/net/tulip/dmfe.c
index 2e5c999..d5d021b 100644
--- a/drivers/net/tulip/dmfe.c
+++ b/drivers/net/tulip/dmfe.c
@@ -375,7 +375,7 @@ static int __devinit dmfe_init_one (struct pci_dev *pdev,
 	DMFE_DBUG(0, "dmfe_init_one()", 0);

 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);

 	/* Init network device */
 	dev = alloc_etherdev(sizeof(*db));
@@ -2188,7 +2188,7 @@ static int __init dmfe_init_module(void)
 {
 	int rc;

-	printk(version);
+	printk("%s", version);
 	printed_version = 1;

 	DMFE_DBUG(0, "init_module() ", debug);
diff --git a/drivers/net/tulip/uli526x.c b/drivers/net/tulip/uli526x.c
index 030e02e..d340b5c 100644
--- a/drivers/net/tulip/uli526x.c
+++ b/drivers/net/tulip/uli526x.c
@@ -274,7 +274,7 @@ static int __devinit uli526x_init_one (struct pci_dev *pdev,
 	ULI526X_DBUG(0, "uli526x_init_one()", 0);

 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);

 	/* Init network device */
 	dev = alloc_etherdev(sizeof(*db));
@@ -1816,7 +1816,7 @@ MODULE_PARM_DESC(mode, "ULi M5261/M5263: Bit 0:
10/100Mbps, bit 2: duplex, bit 8
 static int __init uli526x_init_module(void)
 {

-	printk(version);
+	printk("%s", version);
 	printed_version = 1;

 	ULI526X_DBUG(0, "init_module() ", debug);
diff --git a/drivers/net/tulip/winbond-840.c b/drivers/net/tulip/winbond-840.c
index f467bf8..9de1885 100644
--- a/drivers/net/tulip/winbond-840.c
+++ b/drivers/net/tulip/winbond-840.c
@@ -1663,7 +1663,7 @@ static struct pci_driver w840_driver = {

 static int __init w840_init(void)
 {
-	printk(version);
+	printk("%s", version);
 	return pci_register_driver(&w840_driver);
 }

diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
index 3b8e632..736c88c 100644
--- a/drivers/net/via-rhine.c
+++ b/drivers/net/via-rhine.c
@@ -652,7 +652,7 @@ static int __devinit rhine_init_one(struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	io_size = 256;
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 5b61b3e..0f4e51a 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -438,7 +438,7 @@ static int __init lapbeth_init_driver(void)

 	register_netdevice_notifier(&lapbeth_dev_notifier);

-	printk(banner);
+	printk("%s", banner);

 	return 0;
 }
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index fc4322c..b604b1f 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1884,7 +1884,8 @@ static int airo_open(struct net_device *dev) {

 	if (ai->wifidev != dev) {
 		clear_bit(JOB_DIE, &ai->jobs);
-		ai->airo_thread_task = kthread_run(airo_thread, dev, dev->name);
+		ai->airo_thread_task = kthread_run(airo_thread, dev,
+						"%s", dev->name);
 		if (IS_ERR(ai->airo_thread_task))
 			return (int)PTR_ERR(ai->airo_thread_task);

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c788bad..c8e7769 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2005,9 +2005,9 @@ static void b43_print_fw_helptext(struct b43_wl
*wl, bool error)
 	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
 	       "and download the latest firmware (version 4).\n";
 	if (error)
-		b43err(wl, text);
+		b43err(wl, "%s", text);
 	else
-		b43warn(wl, text);
+		b43warn(wl, "%s", text);
 }

 static int do_request_fw(struct b43_wldev *dev,
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c
b/drivers/net/wireless/hostap/hostap_ioctl.c
index c40fdf4..db5a4b4 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -3269,7 +3269,7 @@ static int prism2_ioctl_siwencodeext(struct
net_device *dev,

 	ops = lib80211_get_crypto_ops(alg);
 	if (ops == NULL) {
-		request_module(module);
+		request_module("%s", module);
 		ops = lib80211_get_crypto_ops(alg);
 	}
 	if (ops == NULL) {
diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c
b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 31ea3ab..8ab3122 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -608,7 +608,7 @@ int ieee80211_wx_set_encodeext(struct
ieee80211_device *ieee,

 	ops = lib80211_get_crypto_ops(alg);
 	if (ops == NULL) {
-		request_module(module);
+		request_module("%s", module);
 		ops = lib80211_get_crypto_ops(alg);
 	}
 	if (ops == NULL) {
diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index 2f1645d..557bad8 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -390,7 +390,7 @@ static int __devinit yellowfin_init_one(struct
pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk(version);
+		printk("%s", version);
 #endif

 	i = pci_enable_device(pdev);
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 0391d75..2d175fb 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -317,7 +317,8 @@ return_fib:
 			kthread_stop(dev->thread);
 			ssleep(1);
 			dev->aif_thread = 0;
-			dev->thread = kthread_run(aac_command_thread, dev, dev->name);
+			dev->thread = kthread_run(aac_command_thread, dev,
+							"%s", dev->name);
 			ssleep(1);
 		}
 		if (f.wait) {
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index d24c267..63bbcd5 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1220,7 +1220,8 @@ static int _aac_reset_adapter(struct aac_dev
*aac, int forced)
 		if ((retval = pci_set_dma_mask(aac->pdev, DMA_32BIT_MASK)))
 			goto out;
 	if (jafo) {
-		aac->thread = kthread_run(aac_command_thread, aac, aac->name);
+		aac->thread = kthread_run(aac_command_thread, aac,
+					"%s", aac->name);
 		if (IS_ERR(aac->thread)) {
 			retval = PTR_ERR(aac->thread);
 			goto out;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 7507d8b..e85e170 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2896,7 +2896,7 @@ static int asc_prt_line(char *buf, int buflen,
char *fmt, ...)
 	ret = vsprintf(s, fmt, args);
 	BUG_ON(ret >= ASC_PRTLINE_SIZE);
 	if (buf == NULL) {
-		(void)printk(s);
+		(void)printk("%s", s);
 		ret = 0;
 	} else {
 		ret = min(buflen, ret);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d57566b..365bc79 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1830,7 +1830,7 @@ static void sd_probe_async(void *data,
async_cookie_t cookie)
 	device_initialize(&sdkp->dev);
 	sdkp->dev.parent = &sdp->sdev_gendev;
 	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
+	dev_set_name(&sdkp->dev, "%s", dev_name(&sdp->sdev_gendev));

 	if (device_add(&sdkp->dev))
 		goto out_free_index;
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8f0bd3f..59a150f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2537,7 +2537,7 @@ static void sg_proc_debug_helper(struct seq_file
*s, Sg_device * sdp)
 				else
 					cp = "     ";
 			}
-			seq_printf(s, cp);
+			seq_printf(s, "%s", cp);
 			blen = srp->data.bufflen;
 			usg = srp->data.k_use_sg;
 			seq_printf(s, srp->done ?
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 42f4e66..df85621 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1755,7 +1755,7 @@ static int uart_line_info(char *buf, struct
uart_driver *drv, int i)
 			stat_buf[0] = ' ';
 		strcat(stat_buf, "\n");

-		ret += sprintf(buf + ret, stat_buf);
+		ret += sprintf(buf + ret, "%s", stat_buf);
 	} else {
 		strcat(buf, "\n");
 		ret++;
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index fbea856..ba8dbf4 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -1031,7 +1031,7 @@ static int usbatm_heavy_init(struct usbatm_data *instance)
 	struct task_struct *t;

 	t = kthread_create(usbatm_do_heavy_init, instance,
-			instance->driver->driver_name);
+			"%s", instance->driver->driver_name);
 	if (IS_ERR(t)) {
 		usb_err(instance, "%s: failed to create kernel_thread (%ld)!\n",
 				__func__, PTR_ERR(t));
@@ -1086,7 +1086,8 @@ int usbatm_usb_probe(struct usb_interface *intf,
const struct usb_device_id *id,
 	/* public fields */

 	instance->driver = driver;
-	snprintf(instance->driver_name, sizeof(instance->driver_name),
driver->driver_name);
+	snprintf(instance->driver_name, sizeof(instance->driver_name),
+		"%s", driver->driver_name);

 	instance->usb_dev = usb_dev;
 	instance->usb_intf = intf;
diff --git a/drivers/usb/storage/libusual.c b/drivers/usb/storage/libusual.c
index f970b27..a44c524 100644
--- a/drivers/usb/storage/libusual.c
+++ b/drivers/usb/storage/libusual.c
@@ -187,7 +187,7 @@ static int usu_probe_thread(void *arg)
 	unsigned long flags;

 	mutex_lock(&usu_probe_mutex);
-	rc = request_module(bias_names[type]);
+	rc = request_module("%s", bias_names[type]);
 	spin_lock_irqsave(&usu_lock, flags);
 	if (rc == 0 && (st->fls & USU_MOD_FL_PRESENT) == 0) {
 		/*
diff --git a/drivers/uwb/lc-dev.c b/drivers/uwb/lc-dev.c
index e9fe1bb..a885606 100644
--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -437,7 +437,7 @@ void uwbd_dev_onair(struct uwb_rc *rc, struct
uwb_beca_e *bce)
 	uwb_dev_init(uwb_dev);		/* This sets refcnt to one, we own it */
 	uwb_dev->mac_addr = *bce->mac_addr;
 	uwb_dev->dev_addr = bce->dev_addr;
-	dev_set_name(&uwb_dev->dev, macbuf);
+	dev_set_name(&uwb_dev->dev, "%s", macbuf);
 	result = uwb_dev_add(uwb_dev, &rc->uwb_dev.dev, rc);
 	if (result < 0) {
 		dev_err(dev, "new device %s: cannot instantiate device\n",
diff --git a/drivers/video/backlight/backlight.c
b/drivers/video/backlight/backlight.c
index 157057c..71d65fb 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -244,7 +244,7 @@ struct backlight_device
*backlight_device_register(const char *name,
 	new_bd->dev.class = backlight_class;
 	new_bd->dev.parent = parent;
 	new_bd->dev.release = bl_device_release;
-	dev_set_name(&new_bd->dev, name);
+	dev_set_name(&new_bd->dev, "%s", name);
 	dev_set_drvdata(&new_bd->dev, devdata);

 	rc = device_register(&new_bd->dev);
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index b644947..306ba00 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -208,7 +208,7 @@ struct lcd_device *lcd_device_register(const char
*name, struct device *parent,
 	new_ld->dev.class = lcd_class;
 	new_ld->dev.parent = parent;
 	new_ld->dev.release = lcd_device_release;
-	dev_set_name(&new_ld->dev, name);
+	dev_set_name(&new_ld->dev, "%s", name);
 	dev_set_drvdata(&new_ld->dev, devdata);

 	rc = device_register(&new_ld->dev);
diff --git a/drivers/video/output.c b/drivers/video/output.c
index 5e6439a..82a5bb5 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -96,7 +96,7 @@ struct output_device *video_output_register(const char *name,
 	new_dev->props = op;
 	new_dev->dev.class = &video_output_class;
 	new_dev->dev.parent = dev;
-	dev_set_name(&new_dev->dev, name);
+	dev_set_name(&new_dev->dev, "%s", name);
 	dev_set_drvdata(&new_dev->dev, devdata);
 	ret_code = device_register(&new_dev->dev);
 	if (ret_code) {
diff --git a/drivers/xen/xenbus/xenbus_probe.c
b/drivers/xen/xenbus/xenbus_probe.c
index 773d1cf..7e481a4 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -507,7 +507,7 @@ int xenbus_probe_node(struct xen_bus_type *bus,
 	if (err)
 		goto fail;

-	dev_set_name(&xendev->dev, devname);
+	dev_set_name(&xendev->dev, "%s", devname);

 	/* Register with generic device framework. */
 	err = device_register(&xendev->dev);
diff --git a/fs/dquot.c b/fs/dquot.c
index bca3cac..7ad42c6 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -172,7 +172,7 @@ static struct quota_format_type *find_quota_format(int id)
 		spin_unlock(&dq_list_lock);
 		
 		for (qm = 0; module_names[qm].qm_fmt_id &&
module_names[qm].qm_fmt_id != id; qm++);
-		if (!module_names[qm].qm_fmt_id ||
request_module(module_names[qm].qm_mod_name))
+		if (!module_names[qm].qm_fmt_id || request_module("%s",
module_names[qm].qm_mod_name))
 			return NULL;

 		spin_lock(&dq_list_lock);
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6b983ae..a98a091 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -898,7 +898,7 @@ void gfs2_print_dbg(struct seq_file *seq, const
char *fmt, ...)
 	if (seq) {
 		struct gfs2_glock_iter *gi = seq->private;
 		vsprintf(gi->string, fmt, args);
-		seq_printf(seq, gi->string);
+		seq_printf(seq, "%s", gi->string);
 	} else {
 		printk(KERN_ERR " ");
 		vprintk(fmt, args);
diff --git a/fs/gfs2/locking.c b/fs/gfs2/locking.c
index 523243a..7a9df7f 100644
--- a/fs/gfs2/locking.c
+++ b/fs/gfs2/locking.c
@@ -177,7 +177,7 @@ retry:
 		if (!try && capable(CAP_SYS_MODULE)) {
 			try = 1;
 			mutex_unlock(&lmh_lock);
-			request_module(proto_name);
+			request_module("%s", proto_name);
 			goto retry;
 		}
 		printk(KERN_INFO "GFS2: can't find protocol %s\n", proto_name);
diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 64f1c31..0c22c3c 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -300,7 +300,7 @@ int lockd_up(void)
 	svc_sock_update_bufs(serv);
 	serv->sv_maxconn = nlm_max_connections;

-	nlmsvc_task = kthread_run(lockd, nlmsvc_rqst, serv->sv_name);
+	nlmsvc_task = kthread_run(lockd, nlmsvc_rqst, "%s", serv->sv_name);
 	if (IS_ERR(nlmsvc_task)) {
 		error = PTR_ERR(nlmsvc_task);
 		svc_exit_thread(nlmsvc_rqst);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6d72024..21e5ca4 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -452,7 +452,7 @@ void register_disk(struct gendisk *disk)

 	ddev->parent = disk->driverfs_dev;

-	dev_set_name(ddev, disk->disk_name);
+	dev_set_name(ddev, "%s", disk->disk_name);

 	/* delay uevents, until we scanned partition table */
 	ddev->uevent_suppress = 1;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 1182b66..ab5e228 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -422,7 +422,7 @@ static int ubifs_show_options(struct seq_file *s,
struct vfsmount *mnt)

 	if (c->mount_opts.override_compr) {
 		seq_printf(s, ",compr=");
-		seq_printf(s, ubifs_compr_name(c->mount_opts.compr_type));
+		seq_printf(s, "%s", ubifs_compr_name(c->mount_opts.compr_type));
 	}

 	return 0;
@@ -1201,7 +1201,7 @@ static int mount_ubifs(struct ubifs_info *c)
 			goto out_cbuf;

 		/* Create background thread */
-		c->bgt = kthread_create(ubifs_bg_thread, c, c->bgt_name);
+		c->bgt = kthread_create(ubifs_bg_thread, c, "%s", c->bgt_name);
 		if (IS_ERR(c->bgt)) {
 			err = PTR_ERR(c->bgt);
 			c->bgt = NULL;
@@ -1554,7 +1554,7 @@ static int ubifs_remount_rw(struct ubifs_info *c)
 	ubifs_create_buds_lists(c);

 	/* Create background thread */
-	c->bgt = kthread_create(ubifs_bg_thread, c, c->bgt_name);
+	c->bgt = kthread_create(ubifs_bg_thread, c, "%s", c->bgt_name);
 	if (IS_ERR(c->bgt)) {
 		err = PTR_ERR(c->bgt);
 		c->bgt = NULL;
diff --git a/init/initramfs.c b/init/initramfs.c
index d9c941c..aa2a250 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -579,7 +579,7 @@ static int __init populate_rootfs(void)
 	char *err = unpack_to_rootfs(__initramfs_start,
 			 __initramfs_end - __initramfs_start, 0);
 	if (err)
-		panic(err);
+		panic("%s", err);
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
diff --git a/init/main.c b/init/main.c
index 8442094..78fc0d8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -554,7 +554,7 @@ asmlinkage void __init start_kernel(void)
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk("%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f76db9d..83f4129 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2443,7 +2443,7 @@ void cpuset_print_task_mems_allowed(struct
task_struct *tsk)

 	dentry = task_cs(tsk)->css.cgroup->dentry;
 	spin_lock(&cpuset_buffer_lock);
-	snprintf(cpuset_name, CPUSET_NAME_LEN,
+	snprintf(cpuset_name, CPUSET_NAME_LEN, "%s",
 		 dentry ? (const char *)dentry->d_name.name : "/");
 	nodelist_scnprintf(cpuset_nodelist, CPUSET_NODELIST_LEN,
 			   tsk->mems_allowed);
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 2399888..ab981cb 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -714,7 +714,7 @@ static int __init test_suspend(void)
 	if (pony)
 		rtc = rtc_class_open(pony);
 	if (!rtc) {
-		printk(warn_no_rtc);
+		printk("%s", warn_no_rtc);
 		goto done;
 	}

diff --git a/lib/kobject.c b/lib/kobject.c
index 0487d1f..a1682ef 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -794,7 +794,7 @@ static struct kset *kset_create(const char *name,
 	kset = kzalloc(sizeof(*kset), GFP_KERNEL);
 	if (!kset)
 		return NULL;
-	kobject_set_name(&kset->kobj, name);
+	kobject_set_name(&kset->kobj, "%s", name);
 	kset->uevent_ops = uevent_ops;
 	kset->kobj.parent = parent_kobj;

diff --git a/net/802/psnap.c b/net/802/psnap.c
index 70980ba..10f1fe6 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -103,7 +103,7 @@ static int __init snap_init(void)
 	snap_sap = llc_sap_open(0xAA, snap_rcv);

 	if (!snap_sap)
-		printk(snap_err_msg);
+		printk("%s", snap_err_msg);

 	return 0;
 }
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 5abce07..8c55482 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1891,7 +1891,7 @@ static int __init atalk_init(void)
 	(void)sock_register(&atalk_family_ops);
 	ddp_dl = register_snap_client(ddp_snap_id, atalk_rcv);
 	if (!ddp_dl)
-		printk(atalk_err_snap);
+		printk("%s", atalk_err_snap);

 	dev_add_pack(&ltalk_packet_type);
 	dev_add_pack(&ppptalk_packet_type);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 6ac29a4..9ba3cd1 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -496,7 +496,7 @@ int netdev_register_kobject(struct net_device *net)
 	dev->groups = groups;

 	BUILD_BUG_ON(BUS_ID_SIZE < IFNAMSIZ);
-	dev_set_name(dev, net->name);
+	dev_set_name(dev, "%s", net->name);

 #ifdef CONFIG_SYSFS
 	*groups++ = &netstat_group;
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index cf0e184..90bc10c 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -2374,7 +2374,7 @@ static int __init decnet_init(void)
 {
 	int rc;

-	printk(banner);
+	printk("%s", banner);

 	rc = proto_register(&dn_proto, 1);
 	if (rc != 0)
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 5079dfb..983843f 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -833,7 +833,7 @@ static int __init ipip_init(void)
 {
 	int err;

-	printk(banner);
+	printk("%s", banner);

 	if (xfrm4_tunnel_register(&ipip_handler, AF_INET)) {
 		printk(KERN_INFO "ipip init: can't register tunnel\n");
diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index b6e70f9..5aecae0 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -1999,21 +1999,21 @@ static int __init ipx_init(void)
 	if (pEII_datalink)
 		dev_add_pack(&ipx_dix_packet_type);
 	else
-		printk(ipx_EII_err_msg);
+		printk("%s", ipx_EII_err_msg);

 	p8023_datalink = make_8023_client();
 	if (p8023_datalink)
 		dev_add_pack(&ipx_8023_packet_type);
 	else
-		printk(ipx_8023_err_msg);
+		printk("%s", ipx_8023_err_msg);

 	p8022_datalink = register_8022_client(ipx_8022_type, ipx_rcv);
 	if (!p8022_datalink)
-		printk(ipx_llc_err_msg);
+		printk("%s", ipx_llc_err_msg);

 	pSNAP_datalink = register_snap_client(ipx_snap_id, ipx_rcv);
 	if (!pSNAP_datalink)
-		printk(ipx_snap_err_msg);
+		printk("%s", ipx_snap_err_msg);

 	register_netdevice_notifier(&ipx_dev_notifier);
 	ipx_register_sysctl();
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 56fd85a..1ae72e5 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -1137,17 +1137,17 @@ static int __init llc2_init(void)
 	llc_ui_sap_last_autoport = LLC_SAP_DYN_START;
 	rc = llc_proc_init();
 	if (rc != 0) {
-		printk(llc_proc_err_msg);
+		printk("%s", llc_proc_err_msg);
 		goto out_unregister_llc_proto;
 	}
 	rc = llc_sysctl_init();
 	if (rc) {
-		printk(llc_sysctl_err_msg);
+		printk("%s", llc_sysctl_err_msg);
 		goto out_proc;
 	}
 	rc = sock_register(&llc_ui_family_ops);
 	if (rc) {
-		printk(llc_sock_err_msg);
+		printk("%s", llc_sock_err_msg);
 		goto out_sysctl;
 	}
 	llc_add_pack(LLC_DEST_SAP, llc_sap_handler);
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 6be5d4e..1ed9505 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -873,7 +873,7 @@ int start_sync_thread(int state, char *mcast_ifn,
__u8 syncid)
 	tinfo->sock = sock;
 	tinfo->buf = buf;

-	task = kthread_run(threadfn, tinfo, name);
+	task = kthread_run(threadfn, tinfo, "%s", name);
 	if (IS_ERR(task)) {
 		result = PTR_ERR(task);
 		goto outtinfo;
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c
b/net/netfilter/nf_conntrack_proto_dccp.c
index 8fcf176..6b6d335 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -447,7 +447,8 @@ static bool dccp_new(struct nf_conn *ct, const
struct sk_buff *skb,

 out_invalid:
 	if (LOG_INVALID(net, IPPROTO_DCCP))
-		nf_log_packet(nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL, msg);
+		nf_log_packet(nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL,
+				"%s", msg);
 	return false;
 }

@@ -593,7 +594,7 @@ static int dccp_error(struct net *net, struct sk_buff *skb,

 out_invalid:
 	if (LOG_INVALID(net, IPPROTO_DCCP))
-		nf_log_packet(pf, 0, skb, NULL, NULL, NULL, msg);
+		nf_log_packet(pf, 0, skb, NULL, NULL, NULL, "%s", msg);
 	return -NF_ACCEPT;
 }

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c51fed4..6a8af11 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -665,7 +665,8 @@ svc_set_num_threads(struct svc_serv *serv, struct
svc_pool *pool, int nrservs)
 		}

 		__module_get(serv->sv_module);
-		task = kthread_create(serv->sv_function, rqstp, serv->sv_name);
+		task = kthread_create(serv->sv_function, rqstp,
+				"%s", serv->sv_name);
 		if (IS_ERR(task)) {
 			error = PTR_ERR(task);
 			module_put(serv->sv_module);
diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index 3ddaff4..dfd9c01 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -800,7 +800,7 @@ int tipc_bclink_init(void)
 	tipc_link_set_queue_limits(bcl, BCLINK_WIN_DEFAULT);
 	bcl->b_ptr = &bcbearer->bearer;
 	bcl->state = WORKING_WORKING;
-	sprintf(bcl->name, tipc_bclink_name);
+	sprintf(bcl->name, "%s", tipc_bclink_name);

 	if (BCLINK_LOG_BUF_SIZE) {
 		char *pb = kmalloc(BCLINK_LOG_BUF_SIZE, GFP_ATOMIC);
diff --git a/net/tipc/dbg.c b/net/tipc/dbg.c
index 29ecae8..532cf68 100644
--- a/net/tipc/dbg.c
+++ b/net/tipc/dbg.c
@@ -258,7 +258,7 @@ void tipc_printf(struct print_buf *pb, const char *fmt, ...)
 	}

 	if (pb->echo)
-		printk(print_string);
+		printk("%s", print_string);

 	spin_unlock_bh(&print_lock);
 }
@@ -278,7 +278,7 @@ static void print_to_console(char *crs, int len)
 		char c = crs[sz];

 		crs[sz] = 0;
-		printk((const char *)crs);
+		printk("%s", (const char *)crs);
 		crs[sz] = c;
 		rest -= sz;
 		crs += sz;
@@ -325,7 +325,7 @@ void tipc_dump_dbg(struct print_buf *pb, const
char *fmt, ...)
 	spin_lock_bh(&print_lock);

 	FORMAT(print_string, len, fmt);
-	printk(print_string);
+	printk("%s", print_string);

 	printk("\n---- Start of %s log dump ----\n\n",
 	       (pb == TIPC_LOG) ? "global" : "local");
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 20d98c5..f659411 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -703,7 +703,7 @@ struct sk_buff *tipc_node_get_links(const void
*req_tlv_area, int req_tlv_space)

 	link_info.dest = htonl(tipc_own_addr & 0xfffff00);
 	link_info.up = htonl(1);
-	sprintf(link_info.str, tipc_bclink_name);
+	sprintf(link_info.str, "%s", tipc_bclink_name);
 	tipc_cfg_append_tlv(buf, TIPC_TLV_LINK_INFO, &link_info, sizeof(link_info));

 	/* Add TLVs for any other links in scope */
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 8ca2be3..a6869b8 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2446,7 +2446,7 @@ static void snd_seq_info_dump_subscribers(struct
snd_info_buffer *buffer,
 		up_read(&group->list_mutex);
 		return;
 	}
-	snd_iprintf(buffer, msg);
+	snd_iprintf(buffer, "%s", msg);
 	list_for_each(p, &group->list_head) {
 		if (is_src)
 			s = list_entry(p, struct snd_seq_subscribers, src_list);
diff --git a/sound/drivers/opl3/opl3_seq.c b/sound/drivers/opl3/opl3_seq.c
index 2d33f53..aeb9e91 100644
--- a/sound/drivers/opl3/opl3_seq.c
+++ b/sound/drivers/opl3/opl3_seq.c
@@ -235,7 +235,7 @@ static int snd_opl3_seq_new_device(struct
snd_seq_device *dev)
 	sprintf(name, "OPL%i FM synth", opl_ver);
 	client = opl3->seq_client =
 		snd_seq_create_kernel_client(opl3->card, opl3->seq_dev_num,
-					     name);
+					     "%s", name);
 	if (client < 0)
 		return client;

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b7bba7d..fbc2d69 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -597,7 +597,7 @@ find_codec_preset(struct hda_codec *codec)
 		else
 			snprintf(name, sizeof(name), "snd-hda-codec-id:%04x*",
 				 (codec->vendor_id >> 16) & 0xffff);
-		request_module(name);
+		request_module("%s", name);
 		mod_requested++;
 		goto again;
 	}
diff --git a/sound/pci/korg1212/korg1212.c b/sound/pci/korg1212/korg1212.c
index 5f8006b..37c4efb 100644
--- a/sound/pci/korg1212/korg1212.c
+++ b/sound/pci/korg1212/korg1212.c
@@ -2059,7 +2059,7 @@ static void snd_korg1212_proc_read(struct
snd_info_entry *entry,
 	int n;
 	struct snd_korg1212 *korg1212 = entry->private_data;

-	snd_iprintf(buffer, korg1212->card->longname);
+	snd_iprintf(buffer, "%s", korg1212->card->longname);
 	snd_iprintf(buffer, " (index #%d)\n", korg1212->card->number + 1);
 	snd_iprintf(buffer, "\nGeneral settings\n");
 	snd_iprintf(buffer, "    period size: %Zd bytes\n", K1212_PERIOD_BYTES);
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index e7ef3a1..6ddf23c 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1470,7 +1470,7 @@ snd_rme32_proc_read(struct snd_info_entry *
entry, struct snd_info_buffer *buffe

 	rme32->rcreg = readl(rme32->iobase + RME32_IO_CONTROL_REGISTER);

-	snd_iprintf(buffer, rme32->card->longname);
+	snd_iprintf(buffer, "%s", rme32->card->longname);
 	snd_iprintf(buffer, " (index #%d)\n", rme32->card->number + 1);

 	snd_iprintf(buffer, "\nGeneral settings\n");
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index 3fdd488..82f7e02 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -1670,7 +1670,7 @@ snd_rme96_proc_read(struct snd_info_entry
*entry, struct snd_info_buffer *buffer
 	
 	rme96->rcreg = readl(rme96->iobase + RME96_IO_CONTROL_REGISTER);

-	snd_iprintf(buffer, rme96->card->longname);
+	snd_iprintf(buffer, "%s", rme96->card->longname);
 	snd_iprintf(buffer, " (index #%d)\n", rme96->card->number + 1);

 	snd_iprintf(buffer, "\nGeneral settings\n");
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 2b302bb..3ca1c2a 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -222,7 +222,7 @@ static int sound_insert_unit(struct sound_unit
**list, const struct file_operati
 		sprintf(s->name, "sound/%s%d", name, r / SOUND_STEP);

 	device_create(sound_class, dev, MKDEV(SOUND_MAJOR, s->unit_minor),
-		      NULL, s->name+6);
+		      NULL, "%s", s->name+6);
 	return r;

  fail:


Regards,
Floris
---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson
