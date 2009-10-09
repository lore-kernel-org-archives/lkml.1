Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbZJIVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbZJIVMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934271AbZJIVMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:12:19 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:38487 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934264AbZJIVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rS9XRZDfEVAQBxhdEaLCGX0IhNkQqhf29cFJhgUVOmuDHpt6J/4UWPV68v8+S9rIuz
         flIHSFTImI2OY3926LpxS2ILrEZYC7gGAjx2Elpb8cvvcdC+3Ju01Xh+fl/ljhVP6RJx
         GeZChmi2BZUuPBzDxIUGh8p4DSvWR5vyXbfRg=
From: Bruce Beare <bbeare1@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Bruce Beare <bbeare1@gmail.com>
Subject: [PATCH] Cleanups for: line length, printk KERN_ argument, stack frame size > 2048 (added a kmalloc/kfree), style/formatting errors, incorrect include files
Date: Fri,  9 Oct 2009 14:11:38 -0700
Message-Id: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/comedi/drivers/serial2002.c |  342 +++++++++++---------------
 1 files changed, 145 insertions(+), 197 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index a219679..0232186 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -36,10 +36,10 @@ Status: in development
 #include <linux/delay.h>
 #include <linux/ioport.h>
 
-#include <asm/termios.h>
-#include <asm/ioctls.h>
+#include <linux/termios.h>
 #include <linux/serial.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 
 /*
  * Board descriptions for two imaginary boards.  Describing the
@@ -125,13 +125,11 @@ struct serial_data {
 static long tty_ioctl(struct file *f, unsigned op, unsigned long param)
 {
 #ifdef HAVE_UNLOCKED_IOCTL
-	if (f->f_op->unlocked_ioctl) {
+	if (f->f_op->unlocked_ioctl)
 		return f->f_op->unlocked_ioctl(f, op, param);
-	}
 #endif
-	if (f->f_op->ioctl) {
+	if (f->f_op->ioctl)
 		return f->f_op->ioctl(f->f_dentry->d_inode, f, op, param);
-	}
 	return -ENOSYS;
 }
 
@@ -195,9 +193,8 @@ static int tty_read(struct file *f, int timeout)
 				elapsed =
 				    (1000000 * (now.tv_sec - start.tv_sec) +
 				     now.tv_usec - start.tv_usec);
-				if (elapsed > timeout) {
+				if (elapsed > timeout)
 					break;
-				}
 				set_current_state(TASK_INTERRUPTIBLE);
 				schedule_timeout(((timeout -
 						   elapsed) * HZ) / 10000);
@@ -207,9 +204,8 @@ static int tty_read(struct file *f, int timeout)
 				unsigned char ch;
 
 				f->f_pos = 0;
-				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1) {
+				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1)
 					result = ch;
-				}
 			}
 		} else {
 			/* Device does not support poll, busy wait */
@@ -218,9 +214,8 @@ static int tty_read(struct file *f, int timeout)
 				unsigned char ch;
 
 				retries++;
-				if (retries >= timeout) {
+				if (retries >= timeout)
 					break;
-				}
 
 				f->f_pos = 0;
 				if (f->f_op->read(f, &ch, 1, &f->f_pos) == 1) {
@@ -332,7 +327,7 @@ static struct serial_data serial_read(struct file *f, int timeout)
 
 		length++;
 		if (data < 0) {
-			printk("serial2002 error\n");
+			printk(KERN_ERR "serial2002 error\n");
 			break;
 		} else if (data & 0x80) {
 			result.value = (result.value << 7) | (data & 0x7f);
@@ -403,7 +398,7 @@ static void serial_2002_open(struct comedi_device *dev)
 	sprintf(port, "/dev/ttyS%d", devpriv->port);
 	devpriv->tty = filp_open(port, 0, O_RDWR);
 	if (IS_ERR(devpriv->tty)) {
-		printk("serial_2002: file open error = %ld\n",
+		printk(KERN_ERR "serial_2002: file open error = %ld\n",
 		       PTR_ERR(devpriv->tty));
 	} else {
 		struct config_t {
@@ -413,34 +408,37 @@ static void serial_2002_open(struct comedi_device *dev)
 			int min;
 			int max;
 		};
+		struct config_data_t {
+			struct config_t dig_in_config[32];
+			struct config_t dig_out_config[32];
+			struct config_t chan_in_config[32];
+			struct config_t chan_out_config[32];
+		} *config_data = NULL;
 
-		struct config_t dig_in_config[32];
-		struct config_t dig_out_config[32];
-		struct config_t chan_in_config[32];
-		struct config_t chan_out_config[32];
 		int i;
+		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
 
 		for (i = 0; i < 32; i++) {
-			dig_in_config[i].kind = 0;
-			dig_in_config[i].bits = 0;
-			dig_in_config[i].min = 0;
-			dig_in_config[i].max = 0;
-			dig_out_config[i].kind = 0;
-			dig_out_config[i].bits = 0;
-			dig_out_config[i].min = 0;
-			dig_out_config[i].max = 0;
-			chan_in_config[i].kind = 0;
-			chan_in_config[i].bits = 0;
-			chan_in_config[i].min = 0;
-			chan_in_config[i].max = 0;
-			chan_out_config[i].kind = 0;
-			chan_out_config[i].bits = 0;
-			chan_out_config[i].min = 0;
-			chan_out_config[i].max = 0;
+			config_data->dig_in_config[i].kind = 0;
+			config_data->dig_in_config[i].bits = 0;
+			config_data->dig_in_config[i].min = 0;
+			config_data->dig_in_config[i].max = 0;
+			config_data->dig_out_config[i].kind = 0;
+			config_data->dig_out_config[i].bits = 0;
+			config_data->dig_out_config[i].min = 0;
+			config_data->dig_out_config[i].max = 0;
+			config_data->chan_in_config[i].kind = 0;
+			config_data->chan_in_config[i].bits = 0;
+			config_data->chan_in_config[i].min = 0;
+			config_data->chan_in_config[i].max = 0;
+			config_data->chan_out_config[i].kind = 0;
+			config_data->chan_out_config[i].bits = 0;
+			config_data->chan_out_config[i].min = 0;
+			config_data->chan_out_config[i].max = 0;
 		}
 
 		tty_setspeed(devpriv->tty, devpriv->speed);
-		poll_channel(devpriv->tty, 31);	/*  Start reading configuration */
+		poll_channel(devpriv->tty, 31);	/* Start reading configuration*/
 		while (1) {
 			struct serial_data data;
 
@@ -456,118 +454,91 @@ static void serial_2002_open(struct comedi_device *dev)
 				kind = (data.value >> 5) & 0x7;
 				command = (data.value >> 8) & 0x3;
 				switch (kind) {
-				case 1:{
-						cur_config = dig_in_config;
-					}
+				case 1:
+					cur_config =
+					    config_data->dig_in_config;
 					break;
-				case 2:{
-						cur_config = dig_out_config;
-					}
+				case 2:
+					cur_config =
+					    config_data->dig_out_config;
 					break;
-				case 3:{
-						cur_config = chan_in_config;
-					}
+				case 3:
+					cur_config =
+					    config_data->chan_in_config;
 					break;
-				case 4:{
-						cur_config = chan_out_config;
-					}
+				case 4:
+					cur_config =
+					    config_data->chan_out_config;
 					break;
-				case 5:{
-						cur_config = chan_in_config;
-					}
+				case 5:
+					cur_config =
+					    config_data->chan_in_config;
 					break;
 				}
 
 				if (cur_config) {
 					cur_config[channel].kind = kind;
 					switch (command) {
-					case 0:{
-							cur_config[channel].bits
-							    =
-							    (data.value >> 10) &
-							    0x3f;
-						}
+					case 0:
+						cur_config[channel].bits =
+						    (data.value >> 10) & 0x3f;
 						break;
 					case 1:{
-							int unit, sign, min;
-							unit =
-							    (data.value >> 10) &
-							    0x7;
-							sign =
-							    (data.value >> 13) &
-							    0x1;
-							min =
-							    (data.value >> 14) &
-							    0xfffff;
-
-							switch (unit) {
-							case 0:{
-									min =
-									    min
-									    *
-									    1000000;
-								}
-								break;
-							case 1:{
-									min =
-									    min
-									    *
-									    1000;
-								}
-								break;
-							case 2:{
-									min =
-									    min
-									    * 1;
-								}
-								break;
-							}
-							if (sign) {
-								min = -min;
-							}
-							cur_config[channel].min
-							    = min;
+						int unit, sign, min;
+						unit =
+						    (data.value >> 10) &
+						    0x7;
+						sign =
+						    (data.value >> 13) &
+						    0x1;
+						min =
+						    (data.value >> 14) &
+						    0xfffff;
+
+						switch (unit) {
+						case 0:
+							min = min * 1000000;
+							break;
+						case 1:
+							min = min * 1000;
+							break;
+						case 2:
+							min = min * 1;
+							break;
+						}
+						if (sign)
+							min = -min;
+						cur_config[channel].min
+						    = min;
 						}
 						break;
 					case 2:{
-							int unit, sign, max;
-							unit =
-							    (data.value >> 10) &
-							    0x7;
-							sign =
-							    (data.value >> 13) &
-							    0x1;
-							max =
-							    (data.value >> 14) &
-							    0xfffff;
-
-							switch (unit) {
-							case 0:{
-									max =
-									    max
-									    *
-									    1000000;
-								}
-								break;
-							case 1:{
-									max =
-									    max
-									    *
-									    1000;
-								}
-								break;
-							case 2:{
-									max =
-									    max
-									    * 1;
-								}
-								break;
-							}
-							if (sign) {
-								max = -max;
-							}
-							cur_config[channel].max
-							    = max;
+						int unit, sign, max;
+						unit =
+						    (data.value >> 10) &
+						    0x7;
+						sign =
+						    (data.value >> 13) &
+						    0x1;
+						max =
+						    (data.value >> 14) &
+						    0xfffff;
+
+						switch (unit) {
+						case 0:
+							max = max * 1000000;
+							break;
+						case 1:
+							max = max * 1000;
+							break;
+						case 2:
+							max = max * 1;
+							break;
+						}
+						if (sign)
+							max = -max;
+						cur_config[channel].max
+						    = max;
 						}
 						break;
 					}
@@ -582,42 +553,36 @@ static void serial_2002_open(struct comedi_device *dev)
 			int kind = 0;
 
 			switch (i) {
-			case 0:{
-					c = dig_in_config;
-					mapping = devpriv->digital_in_mapping;
-					kind = 1;
-				}
+			case 0:
+				c = config_data->dig_in_config;
+				mapping = devpriv->digital_in_mapping;
+				kind = 1;
 				break;
-			case 1:{
-					c = dig_out_config;
-					mapping = devpriv->digital_out_mapping;
-					kind = 2;
-				}
+			case 1:
+				c = config_data->dig_out_config;
+				mapping = devpriv->digital_out_mapping;
+				kind = 2;
 				break;
-			case 2:{
-					c = chan_in_config;
-					mapping = devpriv->analog_in_mapping;
-					range = devpriv->in_range;
-					kind = 3;
-				}
+			case 2:
+				c = config_data->chan_in_config;
+				mapping = devpriv->analog_in_mapping;
+				range = devpriv->in_range;
+				kind = 3;
 				break;
-			case 3:{
-					c = chan_out_config;
-					mapping = devpriv->analog_out_mapping;
-					range = devpriv->out_range;
-					kind = 4;
-				}
+			case 3:
+				c = config_data->chan_out_config;
+				mapping = devpriv->analog_out_mapping;
+				range = devpriv->out_range;
+				kind = 4;
 				break;
-			case 4:{
-					c = chan_in_config;
-					mapping = devpriv->encoder_in_mapping;
-					range = devpriv->in_range;
-					kind = 5;
-				}
+			case 4:
+				c = config_data->chan_in_config;
+				mapping = devpriv->encoder_in_mapping;
+				range = devpriv->in_range;
+				kind = 5;
 				break;
-			default:{
-					c = 0;
-				}
+			default:
+				c = 0;
 				break;
 			}
 			if (c) {
@@ -628,22 +593,17 @@ static void serial_2002_open(struct comedi_device *dev)
 				int j, chan;
 
 				for (chan = 0, j = 0; j < 32; j++) {
-					if (c[j].kind == kind) {
+					if (c[j].kind == kind)
 						chan++;
-					}
 				}
 				s = &dev->subdevices[i];
 				s->n_chan = chan;
 				s->maxdata = 0;
-				if (s->maxdata_list) {
-					kfree(s->maxdata_list);
-				}
+				kfree(s->maxdata_list);
 				s->maxdata_list = maxdata_list =
 				    kmalloc(sizeof(unsigned int) * s->n_chan,
 					    GFP_KERNEL);
-				if (s->range_table_list) {
-					kfree(s->range_table_list);
-				}
+				kfree(s->range_table_list);
 				if (range) {
 					s->range_table = 0;
 					s->range_table_list = range_table_list =
@@ -654,9 +614,8 @@ static void serial_2002_open(struct comedi_device *dev)
 				}
 				for (chan = 0, j = 0; j < 32; j++) {
 					if (c[j].kind == kind) {
-						if (mapping) {
+						if (mapping)
 							mapping[chan] = j;
-						}
 						if (range) {
 							range[j].length = 1;
 							range[j].range.min =
@@ -664,9 +623,7 @@ static void serial_2002_open(struct comedi_device *dev)
 							range[j].range.max =
 							    c[j].max;
 							range_table_list[chan] =
-							    (const struct
-							     comedi_lrange *)
-							    &range[j];
+							    (const struct comedi_lrange *) &range[j];
 						}
 						maxdata_list[chan] =
 						    ((long long)1 << c[j].bits)
@@ -676,14 +633,14 @@ static void serial_2002_open(struct comedi_device *dev)
 				}
 			}
 		}
+		kfree(config_data);
 	}
 }
 
 static void serial_2002_close(struct comedi_device *dev)
 {
-	if (!IS_ERR(devpriv->tty) && (devpriv->tty != 0)) {
+	if (!IS_ERR(devpriv->tty) && (devpriv->tty != 0))
 		filp_close(devpriv->tty, 0);
-	}
 }
 
 static int serial2002_di_rinsn(struct comedi_device *dev,
@@ -700,9 +657,8 @@ static int serial2002_di_rinsn(struct comedi_device *dev,
 		poll_digital(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_digital || read.index == chan) {
+			if (read.kind != is_digital || read.index == chan)
 				break;
-			}
 		}
 		data[n] = read.value;
 	}
@@ -742,9 +698,8 @@ static int serial2002_ai_rinsn(struct comedi_device *dev,
 		poll_channel(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_channel || read.index == chan) {
+			if (read.kind != is_channel || read.index == chan)
 				break;
-			}
 		}
 		data[n] = read.value;
 	}
@@ -778,9 +733,8 @@ static int serial2002_ao_rinsn(struct comedi_device *dev,
 	int n;
 	int chan = CR_CHAN(insn->chanspec);
 
-	for (n = 0; n < insn->n; n++) {
+	for (n = 0; n < insn->n; n++)
 		data[n] = devpriv->ao_readback[chan];
-	}
 
 	return n;
 }
@@ -799,9 +753,8 @@ static int serial2002_ei_rinsn(struct comedi_device *dev,
 		poll_channel(devpriv->tty, chan);
 		while (1) {
 			read = serial_read(devpriv->tty, 1000);
-			if (read.kind != is_channel || read.index == chan) {
+			if (read.kind != is_channel || read.index == chan)
 				break;
-			}
 		}
 		data[n] = read.value;
 	}
@@ -813,16 +766,15 @@ static int serial2002_attach(struct comedi_device *dev,
 {
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: serial2002: ", dev->minor);
 	dev->board_name = thisboard->name;
-	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0) {
+	if (alloc_private(dev, sizeof(struct serial2002_private)) < 0)
 		return -ENOMEM;
-	}
 	dev->open = serial_2002_open;
 	dev->close = serial_2002_close;
 	devpriv->port = it->options[0];
 	devpriv->speed = it->options[1];
-	printk("/dev/ttyS%d @ %d\n", devpriv->port, devpriv->speed);
+	printk(KERN_NOTICE "comedi%d: serial2002: /dev/ttyS%d @ %d\n",
+		dev->minor, devpriv->port, devpriv->speed);
 
 	if (alloc_subdevices(dev, 5) < 0)
 		return -ENOMEM;
@@ -881,15 +833,11 @@ static int serial2002_detach(struct comedi_device *dev)
 	struct comedi_subdevice *s;
 	int i;
 
-	printk("comedi%d: serial2002: remove\n", dev->minor);
+	printk(KERN_NOTICE "comedi%d: serial2002: remove\n", dev->minor);
 	for (i = 0; i < 4; i++) {
 		s = &dev->subdevices[i];
-		if (s->maxdata_list) {
-			kfree(s->maxdata_list);
-		}
-		if (s->range_table_list) {
-			kfree(s->range_table_list);
-		}
+		kfree(s->maxdata_list);
+		kfree(s->range_table_list);
 	}
 	return 0;
 }
-- 
1.6.2.5

