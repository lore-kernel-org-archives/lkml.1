Return-Path: <linux-kernel-owner+w=401wt.eu-S1761993AbYHESBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761993AbYHESBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbYHESBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:01:37 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47735 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbYHESBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:01:35 -0400
Date: Tue, 5 Aug 2008 21:00:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Douglas Landgraf <dougsland@gmail.com>, v4l-dvb-maintainer@linuxtv.org
Subject: [2.6 patch] remove the dead CONFIG_RADIO_MIROPCM20{,_RDS} code
Message-ID: <20080805180011.GG22895@cs181140183.pp.htv.fi>
References: <alpine.LFD.1.10.0807281607400.28285@localhost.localdomain> <20080728214841.GG7713@cs181140183.pp.htv.fi> <20080804102421.588e2e56@gaivota.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080804102421.588e2e56@gaivota.chehab.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 10:24:21AM -0300, Mauro Carvalho Chehab wrote:
> Hi Adrian,
> 
> On Tue, 29 Jul 2008 00:48:41 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Mon, Jul 28, 2008 at 04:09:28PM -0400, Robert P. J. Day wrote:
> > > 
> > >   a complete list of all references to non-existent CONFIG variables
> > > exclusively from Makefiles in the tree.  since the list is so short,
> > > i'm not bothering to break it up by subsystem or arch.  enjoy.
> > >...
> > > ===== RADIO_MIROPCM20 =====
> > > ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
> > > ===== RADIO_MIROPCM20_RDS =====
> > > ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) +=
> > > miropcm20-rds.o
> > >...
> > 
> > Mauro, 1.5 years ago you said you wanted this code to stay for having it 
> > perhaps ported to ALSA.
> > 
> > Do you still want it to stay or could it be removed now (if anyone 
> > suddenly feels the desire to work on it the code is still in older 
> > kernels)?
> > 
> 
> Douglas started working on this, but never finished a changeset. Since nobody
> ever complained about this during this 1.5 years period, IMO, we should just
> drop it.

Patch below.

> Cheers,
> Mauro

cu
Adrian


<--  snip  -->


The CONFIG_RADIO_MIROPCM20{,_RDS} code became dead code 1.5 years ago.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/radio/Makefile             |    4 
 drivers/media/radio/miropcm20-radio.c    |  266 -----------------------
 drivers/media/radio/miropcm20-rds-core.c |  211 ------------------
 drivers/media/radio/miropcm20-rds-core.h |   19 -
 drivers/media/radio/miropcm20-rds.c      |  136 -----------
 5 files changed, 636 deletions(-)

d9753b7ed4d193099bf15c8fcf1496b92682481d 
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index a30159f..7ca71ab 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -2,8 +2,6 @@
 # Makefile for the kernel character device drivers.
 #
 
-miropcm20-objs	:= miropcm20-rds-core.o miropcm20-radio.o
-
 obj-$(CONFIG_RADIO_AZTECH) += radio-aztech.o
 obj-$(CONFIG_RADIO_RTRACK2) += radio-rtrack2.o
 obj-$(CONFIG_RADIO_SF16FMI) += radio-sf16fmi.o
@@ -14,8 +12,6 @@ obj-$(CONFIG_RADIO_TERRATEC) += radio-terratec.o
 obj-$(CONFIG_RADIO_MAXIRADIO) += radio-maxiradio.o
 obj-$(CONFIG_RADIO_RTRACK) += radio-aimslab.o
 obj-$(CONFIG_RADIO_ZOLTRIX) += radio-zoltrix.o
-obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
-obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
 obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
 obj-$(CONFIG_RADIO_GEMTEK_PCI) += radio-gemtek-pci.o
 obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
diff --git a/drivers/media/radio/miropcm20-radio.c b/drivers/media/radio/miropcm20-radio.c
deleted file mode 100644
index 7fd7ee2..0000000
--- a/drivers/media/radio/miropcm20-radio.c
+++ /dev/null
@@ -1,266 +0,0 @@
-/* Miro PCM20 radio driver for Linux radio support
- * (c) 1998 Ruurd Reitsma <R.A.Reitsma@wbmt.tudelft.nl>
- * Thanks to Norberto Pellici for the ACI device interface specification
- * The API part is based on the radiotrack driver by M. Kirkwood
- * This driver relies on the aci mixer (drivers/sound/aci.c)
- * Look there for further info...
- */
-
-/* Revision history:
- *
- *   1998        Ruurd Reitsma <R.A.Reitsma@wbmt.tudelft.nl>
- *   2000-09-05  Robert Siemer <Robert.Siemer@gmx.de>
- *        removed unfinished volume control (maybe adding it later again)
- *        use OSS-mixer; added stereo control
- */
-
-/* What ever you think about the ACI, version 0x07 is not very well!
- * I can't get frequency, 'tuner status', 'tuner flags' or mute/mono
- * conditions...                Robert
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/videodev.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
-#include "oss/aci.h"
-#include "miropcm20-rds-core.h"
-
-static int radio_nr = -1;
-module_param(radio_nr, int, 0);
-
-struct pcm20_device {
-	unsigned long freq;
-	int muted;
-	int stereo;
-};
-
-
-static int pcm20_mute(struct pcm20_device *dev, unsigned char mute)
-{
-	dev->muted = mute;
-	return aci_write_cmd(ACI_SET_TUNERMUTE, mute);
-}
-
-static int pcm20_stereo(struct pcm20_device *dev, unsigned char stereo)
-{
-	dev->stereo = stereo;
-	return aci_write_cmd(ACI_SET_TUNERMONO, !stereo);
-}
-
-static int pcm20_setfreq(struct pcm20_device *dev, unsigned long freq)
-{
-	unsigned char freql;
-	unsigned char freqh;
-
-	dev->freq=freq;
-
-	freq /= 160;
-	if (!(aci_version==0x07 || aci_version>=0xb0))
-		freq /= 10;  /* I don't know exactly which version
-			      * needs this hack */
-	freql = freq & 0xff;
-	freqh = freq >> 8;
-
-	aci_rds_cmd(RDS_RESET, NULL, 0);
-	pcm20_stereo(dev, 1);
-
-	return aci_rw_cmd(ACI_WRITE_TUNE, freql, freqh);
-}
-
-static int pcm20_getflags(struct pcm20_device *dev, __u32 *flags, __u16 *signal)
-{
-	/* okay, check for signal, stereo and rds here... */
-	int i;
-	unsigned char buf;
-
-	if ((i=aci_rw_cmd(ACI_READ_TUNERSTATION, -1, -1))<0)
-		return i;
-	pr_debug("check_sig: 0x%x\n", i);
-	if (i & 0x80) {
-		/* no signal from tuner */
-		*flags=0;
-		*signal=0;
-		return 0;
-	} else
-		*signal=0xffff;
-
-	if ((i=aci_rw_cmd(ACI_READ_TUNERSTEREO, -1, -1))<0)
-		return i;
-	if (i & 0x40) {
-		*flags=0;
-	} else {
-		/* stereo */
-		*flags=VIDEO_TUNER_STEREO_ON;
-		/* I can't see stereo, when forced to mono */
-		dev->stereo=1;
-	}
-
-	if ((i=aci_rds_cmd(RDS_STATUS, &buf, 1))<0)
-		return i;
-	if (buf & 1)
-		/* RDS available */
-		*flags|=VIDEO_TUNER_RDS_ON;
-	else
-		return 0;
-
-	if ((i=aci_rds_cmd(RDS_RXVALUE, &buf, 1))<0)
-		return i;
-	pr_debug("rds-signal: %d\n", buf);
-	if (buf > 15) {
-		printk("miropcm20-radio: RX strengths unexpected high...\n");
-		buf=15;
-	}
-	/* refine signal */
-	if ((*signal=SCALE(15, 0xffff, buf))==0)
-		*signal = 1;
-
-	return 0;
-}
-
-static int pcm20_do_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, void *arg)
-{
-	struct video_device *dev = video_devdata(file);
-	struct pcm20_device *pcm20 = dev->priv;
-	int i;
-
-	switch(cmd)
-	{
-		case VIDIOCGCAP:
-		{
-			struct video_capability *v = arg;
-			memset(v,0,sizeof(*v));
-			v->type=VID_TYPE_TUNER;
-			strcpy(v->name, "Miro PCM20");
-			v->channels=1;
-			v->audios=1;
-			return 0;
-		}
-		case VIDIOCGTUNER:
-		{
-			struct video_tuner *v = arg;
-			if(v->tuner)	/* Only 1 tuner */
-				return -EINVAL;
-			v->rangelow=87*16000;
-			v->rangehigh=108*16000;
-			pcm20_getflags(pcm20, &v->flags, &v->signal);
-			v->flags|=VIDEO_TUNER_LOW;
-			v->mode=VIDEO_MODE_AUTO;
-			strcpy(v->name, "FM");
-			return 0;
-		}
-		case VIDIOCSTUNER:
-		{
-			struct video_tuner *v = arg;
-			if(v->tuner!=0)
-				return -EINVAL;
-			/* Only 1 tuner so no setting needed ! */
-			return 0;
-		}
-		case VIDIOCGFREQ:
-		{
-			unsigned long *freq = arg;
-			*freq = pcm20->freq;
-			return 0;
-		}
-		case VIDIOCSFREQ:
-		{
-			unsigned long *freq = arg;
-			pcm20->freq = *freq;
-			i=pcm20_setfreq(pcm20, pcm20->freq);
-			pr_debug("First view (setfreq): 0x%x\n", i);
-			return i;
-		}
-		case VIDIOCGAUDIO:
-		{
-			struct video_audio *v = arg;
-			memset(v,0, sizeof(*v));
-			v->flags=VIDEO_AUDIO_MUTABLE;
-			if (pcm20->muted)
-				v->flags|=VIDEO_AUDIO_MUTE;
-			v->mode=VIDEO_SOUND_STEREO;
-			if (pcm20->stereo)
-				v->mode|=VIDEO_SOUND_MONO;
-			/* v->step=2048; */
-			strcpy(v->name, "Radio");
-			return 0;
-		}
-		case VIDIOCSAUDIO:
-		{
-			struct video_audio *v = arg;
-			if(v->audio)
-				return -EINVAL;
-
-			pcm20_mute(pcm20, !!(v->flags&VIDEO_AUDIO_MUTE));
-			if(v->flags&VIDEO_SOUND_MONO)
-				pcm20_stereo(pcm20, 0);
-			if(v->flags&VIDEO_SOUND_STEREO)
-				pcm20_stereo(pcm20, 1);
-
-			return 0;
-		}
-		default:
-			return -ENOIOCTLCMD;
-	}
-}
-
-static int pcm20_ioctl(struct inode *inode, struct file *file,
-		       unsigned int cmd, unsigned long arg)
-{
-	return video_usercopy(inode, file, cmd, arg, pcm20_do_ioctl);
-}
-
-static struct pcm20_device pcm20_unit = {
-	.freq   = 87*16000,
-	.muted  = 1,
-};
-
-static const struct file_operations pcm20_fops = {
-	.owner		= THIS_MODULE,
-	.open           = video_exclusive_open,
-	.release        = video_exclusive_release,
-	.ioctl		= pcm20_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= v4l_compat_ioctl32,
-#endif
-	.llseek         = no_llseek,
-};
-
-static struct video_device pcm20_radio = {
-	.name		= "Miro PCM 20 radio",
-	.fops           = &pcm20_fops,
-	.priv		= &pcm20_unit
-};
-
-static int __init pcm20_init(void)
-{
-	if(video_register_device(&pcm20_radio, VFL_TYPE_RADIO, radio_nr)==-1)
-		goto video_register_device;
-
-	if(attach_aci_rds()<0)
-		goto attach_aci_rds;
-
-	printk(KERN_INFO "Miro PCM20 radio card driver.\n");
-
-	return 0;
-
- attach_aci_rds:
-	video_unregister_device(&pcm20_radio);
- video_register_device:
-	return -EINVAL;
-}
-
-MODULE_AUTHOR("Ruurd Reitsma");
-MODULE_DESCRIPTION("A driver for the Miro PCM20 radio card.");
-MODULE_LICENSE("GPL");
-
-static void __exit pcm20_cleanup(void)
-{
-	unload_aci_rds();
-	video_unregister_device(&pcm20_radio);
-}
-
-module_init(pcm20_init);
-module_exit(pcm20_cleanup);
diff --git a/drivers/media/radio/miropcm20-rds-core.c b/drivers/media/radio/miropcm20-rds-core.c
deleted file mode 100644
index 9428d8b..0000000
--- a/drivers/media/radio/miropcm20-rds-core.c
+++ /dev/null
@@ -1,211 +0,0 @@
-/*
- *  Many thanks to Fred Seidel <seidel@metabox.de>, the
- *  designer of the RDS decoder hardware. With his help
- *  I was able to code this driver.
- *  Thanks also to Norberto Pellicci, Dominic Mounteney
- *  <DMounteney@pinnaclesys.com> and www.teleauskunft.de
- *  for good hints on finding Fred. It was somewhat hard
- *  to locate him here in Germany... [:
- *
- * Revision history:
- *
- *   2000-08-09  Robert Siemer <Robert.Siemer@gmx.de>
- *        RDS support for MiroSound PCM20 radio
- */
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/string.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/mutex.h>
-
-#include <asm/io.h>
-#include "oss/aci.h"
-#include "miropcm20-rds-core.h"
-
-#define DEBUG 0
-
-static struct mutex aci_rds_mutex;
-
-#define RDS_DATASHIFT          2   /* Bit 2 */
-#define RDS_DATAMASK        (1 << RDS_DATASHIFT)
-#define RDS_BUSYMASK        0x10   /* Bit 4 */
-#define RDS_CLOCKMASK       0x08   /* Bit 3 */
-
-#define RDS_DATA(x)         (((x) >> RDS_DATASHIFT) & 1)
-
-
-#if DEBUG
-static void print_matrix(char array[], unsigned int length)
-{
-	int i, j;
-
-	for (i=0; i<length; i++) {
-		printk(KERN_DEBUG "aci-rds: ");
-		for (j=7; j>=0; j--) {
-			printk("%d", (array[i] >> j) & 0x1);
-		}
-		if (i%8 == 0)
-			printk(" byte-border\n");
-		else
-			printk("\n");
-	}
-}
-#endif /* DEBUG */
-
-static int byte2trans(unsigned char byte, unsigned char sendbuffer[], int size)
-{
-	int i;
-
-	if (size != 8)
-		return -1;
-	for (i = 7; i >= 0; i--)
-		sendbuffer[7-i] = (byte & (1 << i)) ? RDS_DATAMASK : 0;
-	sendbuffer[0] |= RDS_CLOCKMASK;
-
-	return 0;
-}
-
-static int rds_waitread(void)
-{
-	unsigned char byte;
-	int i=2000;
-
-	do {
-		byte=inb(RDS_REGISTER);
-		i--;
-	}
-	while ((byte & RDS_BUSYMASK) && i);
-
-	if (i) {
-		#if DEBUG
-		printk(KERN_DEBUG "rds_waitread()");
-		print_matrix(&byte, 1);
-		#endif
-		return (byte);
-	} else {
-		printk(KERN_WARNING "aci-rds: rds_waitread() timeout...\n");
-		return -1;
-	}
-}
-
-/* don't use any ..._nowait() function if you are not sure what you do... */
-
-static inline void rds_rawwrite_nowait(unsigned char byte)
-{
-	#if DEBUG
-	printk(KERN_DEBUG "rds_rawwrite()");
-	print_matrix(&byte, 1);
-	#endif
-	outb(byte, RDS_REGISTER);
-}
-
-static int rds_rawwrite(unsigned char byte)
-{
-	if (rds_waitread() >= 0) {
-		rds_rawwrite_nowait(byte);
-		return 0;
-	} else
-		return -1;
-}
-
-static int rds_write(unsigned char cmd)
-{
-	unsigned char sendbuffer[8];
-	int i;
-
-	if (byte2trans(cmd, sendbuffer, 8) != 0){
-		return -1;
-	} else {
-		for (i=0; i<8; i++) {
-			rds_rawwrite(sendbuffer[i]);
-		}
-	}
-	return 0;
-}
-
-static int rds_readcycle_nowait(void)
-{
-	rds_rawwrite_nowait(0);
-	return rds_waitread();
-}
-
-static int rds_readcycle(void)
-{
-	if (rds_rawwrite(0) < 0)
-		return -1;
-	return rds_waitread();
-}
-
-static int rds_read(unsigned char databuffer[], int datasize)
-{
-	#define READSIZE (8*datasize)
-
-	int i,j;
-
-	if (datasize < 1)  /* nothing to read */
-		return 0;
-
-	/* to be able to use rds_readcycle_nowait()
-	   I have to waitread() here */
-	if (rds_waitread() < 0)
-		return -1;
-
-	memset(databuffer, 0, datasize);
-
-	for (i=0; i< READSIZE; i++)
-		if((j=rds_readcycle_nowait()) < 0) {
-			return -1;
-		} else {
-			databuffer[i/8]|=(RDS_DATA(j) << (7-(i%8)));
-		}
-
-	return 0;
-}
-
-static int rds_ack(void)
-{
-	int i=rds_readcycle();
-
-	if (i < 0)
-		return -1;
-	if (i & RDS_DATAMASK) {
-		return 0;  /* ACK  */
-	} else {
-		printk(KERN_DEBUG "aci-rds: NACK\n");
-		return 1;  /* NACK */
-	}
-}
-
-int aci_rds_cmd(unsigned char cmd, unsigned char databuffer[], int datasize)
-{
-	int ret;
-
-	if (mutex_lock_interruptible(&aci_rds_mutex))
-		return -EINTR;
-
-	rds_write(cmd);
-
-	/* RDS_RESET doesn't need further processing */
-	if (cmd!=RDS_RESET && (rds_ack() || rds_read(databuffer, datasize)))
-		ret = -1;
-	else
-		ret = 0;
-
-	mutex_unlock(&aci_rds_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(aci_rds_cmd);
-
-int __init attach_aci_rds(void)
-{
-	mutex_init(&aci_rds_mutex);
-	return 0;
-}
-
-void __exit unload_aci_rds(void)
-{
-}
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/radio/miropcm20-rds-core.h b/drivers/media/radio/miropcm20-rds-core.h
deleted file mode 100644
index aeb5761..0000000
--- a/drivers/media/radio/miropcm20-rds-core.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _MIROPCM20_RDS_CORE_H_
-#define _MIROPCM20_RDS_CORE_H_
-
-extern int aci_rds_cmd(unsigned char cmd, unsigned char databuffer[], int datasize);
-
-#define RDS_STATUS      0x01
-#define RDS_STATIONNAME 0x02
-#define RDS_TEXT        0x03
-#define RDS_ALTFREQ     0x04
-#define RDS_TIMEDATE    0x05
-#define RDS_PI_CODE     0x06
-#define RDS_PTYTATP     0x07
-#define RDS_RESET       0x08
-#define RDS_RXVALUE     0x09
-
-extern void __exit unload_aci_rds(void);
-extern int __init attach_aci_rds(void);
-
-#endif /* _MIROPCM20_RDS_CORE_H_ */
diff --git a/drivers/media/radio/miropcm20-rds.c b/drivers/media/radio/miropcm20-rds.c
deleted file mode 100644
index 3e840f7..0000000
--- a/drivers/media/radio/miropcm20-rds.c
+++ /dev/null
@@ -1,136 +0,0 @@
-/* MiroSOUND PCM20 radio rds interface driver
- * (c) 2001 Robert Siemer <Robert.Siemer@gmx.de>
- * Thanks to Fred Seidel. See miropcm20-rds-core.c for further information.
- */
-
-/* Revision history:
- *
- *   2001-04-18  Robert Siemer <Robert.Siemer@gmx.de>
- *        separate file for user interface driver
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/smp_lock.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
-#include <linux/delay.h>
-#include <asm/uaccess.h>
-#include "miropcm20-rds-core.h"
-
-static char * text_buffer;
-static int rds_users;
-
-
-static int rds_f_open(struct inode *in, struct file *fi)
-{
-	if (rds_users)
-		return -EBUSY;
-
-	lock_kernel();
-	rds_users++;
-	if ((text_buffer=kmalloc(66, GFP_KERNEL)) == 0) {
-		rds_users--;
-		printk(KERN_NOTICE "aci-rds: Out of memory by open()...\n");
-		unlock_kernel();
-		return -ENOMEM;
-	}
-
-	unlock_kernel();
-	return 0;
-}
-
-static int rds_f_release(struct inode *in, struct file *fi)
-{
-	kfree(text_buffer);
-
-	rds_users--;
-	return 0;
-}
-
-static void print_matrix(char *ch, char out[])
-{
-	int j;
-
-	for (j=7; j>=0; j--) {
-		 out[7-j] = ((*ch >> j) & 0x1) + '0';
-	}
-}
-
-static ssize_t rds_f_read(struct file *file, char __user *buffer, size_t length, loff_t *offset)
-{
-//	i = sprintf(text_buffer, "length: %d, offset: %d\n", length, *offset);
-
-	char c;
-	char bits[8];
-
-	msleep(2000);
-	aci_rds_cmd(RDS_STATUS, &c, 1);
-	print_matrix(&c, bits);
-	if (copy_to_user(buffer, bits, 8))
-		return -EFAULT;
-
-/*	if ((c >> 3) & 1) {
-		aci_rds_cmd(RDS_STATIONNAME, text_buffer+1, 8);
-		text_buffer[0]  = ' ' ;
-		text_buffer[9]  = '\n';
-		return copy_to_user(buffer+8, text_buffer, 10) ? -EFAULT: 18;
-	}
-*/
-/*	if ((c >> 6) & 1) {
-		aci_rds_cmd(RDS_PTYTATP, &c, 1);
-		if ( c & 1)
-			sprintf(text_buffer, " M");
-		else
-			sprintf(text_buffer, " S");
-		if ((c >> 1) & 1)
-			sprintf(text_buffer+2, " TA");
-		else
-			sprintf(text_buffer+2, " --");
-		if ((c >> 7) & 1)
-			sprintf(text_buffer+5, " TP");
-		else
-			sprintf(text_buffer+5, " --");
-		sprintf(text_buffer+8, " %2d\n", (c >> 2) & 0x1f);
-		return copy_to_user(buffer+8, text_buffer, 12) ? -EFAULT: 20;
-	}
-*/
-
-	if ((c >> 4) & 1) {
-		aci_rds_cmd(RDS_TEXT, text_buffer, 65);
-		text_buffer[0]  = ' ' ;
-		text_buffer[65] = '\n';
-		return copy_to_user(buffer+8, text_buffer,66) ? -EFAULT : 66+8;
-	} else {
-		put_user('\n', buffer+8);
-		return 9;
-	}
-}
-
-static const struct file_operations rds_fops = {
-	.owner		= THIS_MODULE,
-	.read		= rds_f_read,
-	.open		= rds_f_open,
-	.release	= rds_f_release
-};
-
-static struct miscdevice rds_miscdev = {
-	.minor		= MISC_DYNAMIC_MINOR,
-	.name		= "radiotext",
-	.fops		= &rds_fops,
-};
-
-static int __init miropcm20_rds_init(void)
-{
-	return misc_register(&rds_miscdev);
-}
-
-static void __exit miropcm20_rds_cleanup(void)
-{
-	misc_deregister(&rds_miscdev);
-}
-
-module_init(miropcm20_rds_init);
-module_exit(miropcm20_rds_cleanup);
-MODULE_LICENSE("GPL");

