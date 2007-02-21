Return-Path: <linux-kernel-owner+w=401wt.eu-S964814AbXBUCar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbXBUCar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 21:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXBUCar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 21:30:47 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:49078 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964814AbXBUCaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 21:30:46 -0500
Message-ID: <45DBAE91.8040804@linuxtv.org>
Date: Tue, 20 Feb 2007 21:29:37 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       stable@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [patch 00/50] -stable review
References: <20070106022753.334962000@sous-sol.org> <45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com> <45C7ACAB.6060408@linuxtv.org> <20070205223304.GA19793@kroah.com> <45CA3FBD.70407@linuxtv.org> <45CCCE51.8090103@linuxtv.org> <20070209195156.GA27018@kroah.com> <20070220231223.GA22746@kroah.com>
In-Reply-To: <20070220231223.GA22746@kroah.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - thing.hostingexpert.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - linuxtv.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Ok, I've now gotten all of these for .19 and .18.
> 
> If I've missed anything, please let me know.
> 
> thanks for your patience.

Looks good... Thank you, Greg.

Greg KH wrote:
> This will probably be the last release of the 2.6.19-stable series, so
> if there are patches that you feel should be applied to that tree,
> please let me know.

Normally, I would wait for a patch to appear in Linus' tree before I send it to -stable,
however, this patch can not wait.  Since 2.6.18-stable and 2.6.19-stable have their last
releases pending review, it is imperative that this final patch be added to the queue, if
possible.

This patch was recently submitted, and fixes many horrible, previously unexplained bugs of the
past.

Please queue this for the final 2.6.18 and 2.6.19 -stable releases, as well as for 2.6.20.1

Thank you,

Michael Krufky

---

dvbdev: fix illegal re-usage of fileoperations struct

From: Marcel Siegert <mws@linuxtv.org>

 Arjan van de Ven <arjan@infradead.org> reported an illegal re-usage of the fileoperations struct
 if more than one dvb device(e.g. frontend) is present. this patch fixes this issue.
 it allocates a new fileoperations struct each time a device is registered and copies the default
 template fileops.

Signed-off-by: Marcel Siegert <mws@linuxtv.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>

---
 linux/drivers/media/dvb/dvb-core/dvbdev.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux/drivers/media/dvb/dvb-core/dvbdev.c.orig
+++ linux/drivers/media/dvb/dvb-core/dvbdev.c
@@ -211,6 +211,8 @@
 			const struct dvb_device *template, void *priv, int type)
 {
 	struct dvb_device *dvbdev;
+	struct file_operations *dvbdevfops;
+
 	int id;
 
 	if (mutex_lock_interruptible(&dvbdev_register_lock))
@@ -230,12 +232,22 @@
 		return -ENOMEM;
 	}
 
+	dvbdevfops = kzalloc(sizeof(struct file_operations), GFP_KERNEL);
+
+	if (!dvbdevfops) {
+		kfree (dvbdev);
+		mutex_unlock(&dvbdev_register_lock);
+		return -ENOMEM;
+	}
+
 	memcpy(dvbdev, template, sizeof(struct dvb_device));
 	dvbdev->type = type;
 	dvbdev->id = id;
 	dvbdev->adapter = adap;
 	dvbdev->priv = priv;
+	dvbdev->fops = dvbdevfops;
 
+	memcpy(dvbdev->fops, template->fops, sizeof(struct file_operations));
 	dvbdev->fops->owner = adap->module;
 
 	list_add_tail (&dvbdev->list_head, &adap->device_list);
@@ -263,6 +275,7 @@
 					dvbdev->type, dvbdev->id)));
 
 	list_del (&dvbdev->list_head);
+	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
 EXPORT_SYMBOL(dvb_unregister_device);
