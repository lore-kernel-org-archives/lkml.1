Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbXF3OSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbXF3OSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbXF3OSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:18:33 -0400
Received: from mail.screens.ru ([213.234.233.54]:45811 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136AbXF3OSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:18:32 -0400
Date: Sat, 30 Jun 2007 18:19:28 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Sattler <tsattler@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Holger Waechtler <holger@qanu.de>
Subject: Re: 2.6.22-rc6 spurious hangs
Message-ID: <20070630141928.GA5182@tv-sign.ru>
References: <20070628150826.GA487@tv-sign.ru> <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de> <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de> <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu> <20070629135848.GA332@tv-sign.ru> <1183152090.7089.183.camel@gaivota> <d9def9db0706291434v2fe69578qf84488bfd6a965f3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0706291434v2fe69578qf84488bfd6a965f3@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Markus Rechberger wrote:
>
> On 6/29/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> >> Still we can't do this under cinergyt2->sem, because cinergyt2_query()
> >> takes it too. This all looks very wrong to me, I hope maintaners can
> >> explain.
> >
> >AFAIK, the driver authors are not working anymore with CinergyT2. The
> >last patch we have on development tree from Holger is dated as Dec, 3
> >2004. Since them, only internal kernel API changes and a few sparse
> >fixes from other contributors were applied.
> >
> >Also, none of the current DVB maintainers seem to have any hardware for
> >testing.
> >
> 
> I received a Mail a while ago that this driver is open to the
> community, it duplicates some code because the developers wanted to
> use this driver for testing another DVB API which never took off.
> Best would be to remove the duplicated code in that driver and make it
> look like all other DVB drivers.

OK.

Thomas, any chance you could try the patch below? It is very, very stupid,
it was done without any understanding of this code, and of course it is
completely untested. I doubt very much it is correct, and even if it is
correct it is definitely not good. It would be great if Dmitry can take a look.

This patch shifts cancel_rearming_delayed_work() out of ->sem. Another mutex,
->wq_sem, was added to protect against the concurrent open/resume.

Oleg.

--- t/drivers/media/dvb/cinergyT2/cinergyT2.c~cinergy	2007-06-19 17:09:15.000000000 +0400
+++ t/drivers/media/dvb/cinergyT2/cinergyT2.c	2007-06-30 18:01:43.000000000 +0400
@@ -118,6 +118,7 @@ struct cinergyt2 {
 	struct dvb_demux demux;
 	struct usb_device *udev;
 	struct mutex sem;
+	struct mutex wq_sem;
 	struct dvb_adapter adapter;
 	struct dvb_device *fedev;
 	struct dmxdev dmxdev;
@@ -482,14 +483,14 @@ static int cinergyt2_open (struct inode 
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 	int err = -ERESTARTSYS;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+		goto out;
 
-	if ((err = dvb_generic_open(inode, file))) {
-		mutex_unlock(&cinergyt2->sem);
-		return err;
-	}
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		goto out_unlock1;
 
+	if ((err = dvb_generic_open(inode, file)))
+		goto out_unlock2;
 
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
 		cinergyt2_sleep(cinergyt2, 0);
@@ -498,8 +499,12 @@ static int cinergyt2_open (struct inode 
 
 	atomic_inc(&cinergyt2->inuse);
 
+out_unlock2:
 	mutex_unlock(&cinergyt2->sem);
-	return 0;
+out_unlock1:
+	mutex_unlock(&cinergyt2->wq_sem);
+out:
+	return err;
 }
 
 static void cinergyt2_unregister(struct cinergyt2 *cinergyt2)
@@ -519,15 +524,17 @@ static int cinergyt2_release (struct ino
 	struct dvb_device *dvbdev = file->private_data;
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 
-	mutex_lock(&cinergyt2->sem);
+	mutex_lock(&cinergyt2->wq_sem);
 
 	if (!cinergyt2->disconnect_pending && (file->f_flags & O_ACCMODE) != O_RDONLY) {
-		cancel_delayed_work(&cinergyt2->query_work);
-		flush_scheduled_work();
+		cancel_rearming_delayed_work(&cinergyt2->query_work);
+
+		mutex_lock(&cinergyt2->sem);
 		cinergyt2_sleep(cinergyt2, 1);
+		mutex_unlock(&cinergyt2->sem);
 	}
 
-	mutex_unlock(&cinergyt2->sem);
+	mutex_unlock(&cinergyt2->wq_sem);
 
 	if (atomic_dec_and_test(&cinergyt2->inuse) && cinergyt2->disconnect_pending) {
 		warn("delayed unregister in release");
@@ -838,13 +845,13 @@ static int cinergyt2_register_rc(struct 
 
 static void cinergyt2_unregister_rc(struct cinergyt2 *cinergyt2)
 {
-	cancel_delayed_work(&cinergyt2->rc_query_work);
+	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
 	input_unregister_device(cinergyt2->rc_input_dev);
 }
 
 static inline void cinergyt2_suspend_rc(struct cinergyt2 *cinergyt2)
 {
-	cancel_delayed_work(&cinergyt2->rc_query_work);
+	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
 }
 
 static inline void cinergyt2_resume_rc(struct cinergyt2 *cinergyt2)
@@ -907,6 +914,7 @@ static int cinergyt2_probe (struct usb_i
 	usb_set_intfdata (intf, (void *) cinergyt2);
 
 	mutex_init(&cinergyt2->sem);
+	mutex_init(&cinergyt2->wq_sem);
 	init_waitqueue_head (&cinergyt2->poll_wq);
 	INIT_DELAYED_WORK(&cinergyt2->query_work, cinergyt2_query);
 
@@ -974,11 +982,8 @@ static void cinergyt2_disconnect (struct
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	flush_scheduled_work();
-
 	cinergyt2_unregister_rc(cinergyt2);
-
-	cancel_delayed_work(&cinergyt2->query_work);
+	cancel_rearming_delayed_work(&cinergyt2->query_work);
 	wake_up_interruptible(&cinergyt2->poll_wq);
 
 	cinergyt2->demux.dmx.close(&cinergyt2->demux.dmx);
@@ -992,21 +997,22 @@ static int cinergyt2_suspend (struct usb
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
 		return -ERESTARTSYS;
 
 	if (1) {
-		struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
 		cinergyt2_suspend_rc(cinergyt2);
-		cancel_delayed_work(&cinergyt2->query_work);
+		cancel_rearming_delayed_work(&cinergyt2->query_work);
+
+		mutex_lock(&cinergyt2->sem);
 		if (cinergyt2->streaming)
 			cinergyt2_stop_stream_xfer(cinergyt2);
-		flush_scheduled_work();
 		cinergyt2_sleep(cinergyt2, 1);
+		mutex_unlock(&cinergyt2->sem);
 	}
 
-	mutex_unlock(&cinergyt2->sem);
+	mutex_unlock(&cinergyt2->wq_sem);
 	return 0;
 }
 
@@ -1014,9 +1020,15 @@ static int cinergyt2_resume (struct usb_
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 	struct dvbt_set_parameters_msg *param = &cinergyt2->param;
+	int err = -ERESTARTSYS;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+		goto out;
+
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		goto out_unlock1;
+
+	err = 0;
 
 	if (!cinergyt2->sleeping) {
 		cinergyt2_sleep(cinergyt2, 0);
@@ -1029,7 +1041,10 @@ static int cinergyt2_resume (struct usb_
 	cinergyt2_resume_rc(cinergyt2);
 
 	mutex_unlock(&cinergyt2->sem);
-	return 0;
+out_unlock1:
+	mutex_unlock(&cinergyt2->wq_sem);
+out:
+	return err;
 }
 
 static const struct usb_device_id cinergyt2_table [] __devinitdata = {

