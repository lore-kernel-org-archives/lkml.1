Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYGPMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYGPMSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 08:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYGPMSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 08:18:46 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:37277 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYGPMSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 08:18:45 -0400
Date: Wed, 16 Jul 2008 14:18:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Linux I2C <i2c@lm-sensors.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [crash, bisected] I2C,  kobject (ffff81003e8c4160): tried to
 init an initialized object
Message-ID: <20080716141826.1d88d05e@hyperion.delvare>
In-Reply-To: <20080716120801.3e9b4c80@hyperion.delvare>
References: <20080714224945.629446fa@hyperion.delvare>
	<20080716082352.GA30483@elte.hu>
	<20080716110702.3ca61eb2@hyperion.delvare>
	<20080716120801.3e9b4c80@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, John,

Thanks a lot for reporting this bug quickly, BTW.

On Wed, 16 Jul 2008 12:08:01 +0200, Jean Delvare wrote:
> On Wed, 16 Jul 2008 11:07:02 +0200, Jean Delvare wrote:
> > On Wed, 16 Jul 2008 10:23:52 +0200, Ingo Molnar wrote:
> > > 
> > > * Jean Delvare <khali@linux-fr.org> wrote:
> > > 
> > > >       i2c-nforce2: Add support for multiplexing on the Tyan S4985
> > > 
> > > -tip random boot testing started triggering the following upstream boot 
> > > crash, starting two days ago when the i2c tree was merged:
> > > 
> > > [   11.772002] kobject (ffff81003e8c4160): tried to init an initialized object, something is seriously wrong.
> > > [   11.784004] Pid: 1, comm: swapper Not tainted 2.6.26-00007-g279e902-dirty #19896
> > > [   11.793651] 
> > > [   11.793651] Call Trace:
> > > [   11.793651]  [<ffffffff8054471a>] kobject_init+0x7a/0x80
> > > [   11.798969]  [<ffffffff805f0f9d>] device_initialize+0x2d/0xd0
> > > [   11.806323]  [<ffffffff805f19a1>] device_register+0x11/0x20
> > > [   11.811903]  [<ffffffff8087ee3b>] i2c_register_adapter+0xab/0x1d0
> > > [   11.817666]  [<ffffffff8087f0e6>] i2c_add_adapter+0x96/0xb0
> > > [   11.823761]  [<ffffffff81196372>] nforce2_s4985_init+0x272/0x370
> > > [   11.829358]  [<ffffffff8027516a>] ? getnstimeofday+0x3a/0xc0
> > > [   11.835365]  [<ffffffff802728ba>] ? ktime_get_ts+0x4a/0x60
> > > [   11.840853]  [<ffffffff81196100>] ? nforce2_s4985_init+0x0/0x370
> > > [   11.846859]  [<ffffffff81160aa3>] kernel_init+0x123/0x300
> > > [   11.852261]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
> > > [   11.857957]  [<ffffffff80228548>] child_rip+0xa/0x12
> > > [   11.863781]  [<ffffffff81160140>] ? early_idt_handler+0x0/0x74
> > > [   11.868757]  [<ffffffff81160980>] ? kernel_init+0x0/0x300
> > > [   11.874160]  [<ffffffff8022853e>] ? child_rip+0x0/0x12
> > > [   11.879989] 
> > > [   11.881141] general protection fault: 0000 [1] SMP 
> > > [   11.881141] CPU 1 
> 
> Good news: I can reproduce this locally. Stay tuned...

OK, here's the fix. I'll push it to Linus later today, unless someone
objects. I've tested it on a board without multiplexing. It would be
great if someone could now test on a board with multiplexing, just to
make sure I didn't break anything. Ulrich?

* * * * *

From: Jean Delvare <khali@linux-fr.org>
Subject: i2c: Clear i2c_adapter.dev on adapter removal

Clear i2c_adapter.dev on adapter removal. This makes it possible to
re-add the adapter at a later point, which some drivers
(i2c-amd756-s4882, i2c-nforce2-s4985) actually do.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/busses/i2c-amd756-s4882.c  |   27 +++++++++++++--------------
 drivers/i2c/busses/i2c-nforce2-s4985.c |   31 +++++++++++++++----------------
 drivers/i2c/i2c-core.c                 |    4 ++++
 3 files changed, 32 insertions(+), 30 deletions(-)

--- linux-2.6.27-rc0.orig/drivers/i2c/i2c-core.c	2008-07-16 13:13:00.000000000 +0200
+++ linux-2.6.27-rc0/drivers/i2c/i2c-core.c	2008-07-16 13:27:48.000000000 +0200
@@ -654,6 +654,10 @@ int i2c_del_adapter(struct i2c_adapter *
 
 	dev_dbg(&adap->dev, "adapter [%s] unregistered\n", adap->name);
 
+	/* Clear the device structure in case this adapter is ever going to be
+	   added again */
+	memset(&adap->dev, 0, sizeof(adap->dev));
+
  out_unlock:
 	mutex_unlock(&core_lock);
 	return res;
--- linux-2.6.27-rc0.orig/drivers/i2c/busses/i2c-nforce2-s4985.c	2008-07-16 10:41:52.000000000 +0200
+++ linux-2.6.27-rc0/drivers/i2c/busses/i2c-nforce2-s4985.c	2008-07-16 13:58:43.000000000 +0200
@@ -150,6 +150,16 @@ static int __init nforce2_s4985_init(voi
 	int i, error;
 	union i2c_smbus_data ioconfig;
 
+	/* Configure the PCA9556 multiplexer */
+	ioconfig.byte = 0x00; /* All I/O to output mode */
+	error = i2c_smbus_xfer(nforce2_smbus, 0x18, 0, I2C_SMBUS_WRITE, 0x03,
+			       I2C_SMBUS_BYTE_DATA, &ioconfig);
+	if (error) {
+		dev_err(&nforce2_smbus->dev, "PCA9556 configuration failed\n");
+		error = -EIO;
+		goto ERROR0;
+	}
+
 	/* Unregister physical bus */
 	if (!nforce2_smbus)
 		return -ENODEV;
@@ -191,24 +201,13 @@ static int __init nforce2_s4985_init(voi
 	s4985_algo[3].smbus_xfer = nforce2_access_virt3;
 	s4985_algo[4].smbus_xfer = nforce2_access_virt4;
 
-	/* Configure the PCA9556 multiplexer */
-	ioconfig.byte = 0x00; /* All I/O to output mode */
-	error = nforce2_smbus->algo->smbus_xfer(nforce2_smbus, 0x18, 0,
-						I2C_SMBUS_WRITE, 0x03,
-						I2C_SMBUS_BYTE_DATA, &ioconfig);
-	if (error) {
-		dev_err(&nforce2_smbus->dev, "PCA9556 configuration failed\n");
-		error = -EIO;
-		goto ERROR3;
-	}
-
 	/* Register virtual adapters */
 	for (i = 0; i < 5; i++) {
 		error = i2c_add_adapter(s4985_adapter + i);
 		if (error) {
-			dev_err(&nforce2_smbus->dev,
-				"Virtual adapter %d registration "
-				"failed, module not inserted\n", i);
+			printk(KERN_ERR "i2c-nforce2-s4985: "
+			       "Virtual adapter %d registration "
+			       "failed, module not inserted\n", i);
 			for (i--; i >= 0; i--)
 				i2c_del_adapter(s4985_adapter + i);
 			goto ERROR3;
@@ -245,8 +244,8 @@ static void __exit nforce2_s4985_exit(vo
 
 	/* Restore physical bus */
 	if (i2c_add_adapter(nforce2_smbus))
-		dev_err(&nforce2_smbus->dev, "Physical bus restoration "
-			"failed\n");
+		printk(KERN_ERR "i2c-nforce2-s4985: "
+		       "Physical bus restoration failed\n");
 }
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
--- linux-2.6.27-rc0.orig/drivers/i2c/busses/i2c-amd756-s4882.c	2008-07-16 10:41:52.000000000 +0200
+++ linux-2.6.27-rc0/drivers/i2c/busses/i2c-amd756-s4882.c	2008-07-16 13:58:25.000000000 +0200
@@ -155,6 +155,16 @@ static int __init amd756_s4882_init(void
 	int i, error;
 	union i2c_smbus_data ioconfig;
 
+	/* Configure the PCA9556 multiplexer */
+	ioconfig.byte = 0x00; /* All I/O to output mode */
+	error = i2c_smbus_xfer(&amd756_smbus, 0x18, 0, I2C_SMBUS_WRITE, 0x03,
+			       I2C_SMBUS_BYTE_DATA, &ioconfig);
+	if (error) {
+		dev_err(&amd756_smbus.dev, "PCA9556 configuration failed\n");
+		error = -EIO;
+		goto ERROR0;
+	}
+
 	/* Unregister physical bus */
 	error = i2c_del_adapter(&amd756_smbus);
 	if (error) {
@@ -198,22 +208,11 @@ static int __init amd756_s4882_init(void
 	s4882_algo[3].smbus_xfer = amd756_access_virt3;
 	s4882_algo[4].smbus_xfer = amd756_access_virt4;
 
-	/* Configure the PCA9556 multiplexer */
-	ioconfig.byte = 0x00; /* All I/O to output mode */
-	error = amd756_smbus.algo->smbus_xfer(&amd756_smbus, 0x18, 0,
-					      I2C_SMBUS_WRITE, 0x03,
-					      I2C_SMBUS_BYTE_DATA, &ioconfig);
-	if (error) {
-		dev_err(&amd756_smbus.dev, "PCA9556 configuration failed\n");
-		error = -EIO;
-		goto ERROR3;
-	}
-
 	/* Register virtual adapters */
 	for (i = 0; i < 5; i++) {
 		error = i2c_add_adapter(s4882_adapter+i);
 		if (error) {
-			dev_err(&amd756_smbus.dev,
+			printk(KERN_ERR "i2c-amd756-s4882: "
 			       "Virtual adapter %d registration "
 			       "failed, module not inserted\n", i);
 			for (i--; i >= 0; i--)
@@ -252,8 +251,8 @@ static void __exit amd756_s4882_exit(voi
 
 	/* Restore physical bus */
 	if (i2c_add_adapter(&amd756_smbus))
-		dev_err(&amd756_smbus.dev, "Physical bus restoration "
-			"failed\n");
+		printk(KERN_ERR "i2c-amd756-s4882: "
+		       "Physical bus restoration failed\n");
 }
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");


-- 
Jean Delvare
