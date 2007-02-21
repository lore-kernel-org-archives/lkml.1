Return-Path: <linux-kernel-owner+w=401wt.eu-S1423120AbXBUVFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423120AbXBUVFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423122AbXBUVFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:05:54 -0500
Received: from kirby.webscope.com ([204.141.84.54]:50142 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423120AbXBUVFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:05:53 -0500
Message-ID: <45DCB30F.2090001@linuxtv.org>
Date: Wed, 21 Feb 2007 16:01:03 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Wright <chrisw@sous-sol.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       stable@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Siegert <mws@linuxtv.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [v4l-dvb-maintainer] Re: [stable] [patch 00/50] -stable review
References: <20070106022753.334962000@sous-sol.org>	<45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com>	<45C7ACAB.6060408@linuxtv.org>	<20070205223304.GA19793@kroah.com> <45CA3FBD.70407@linuxtv.org>	<45CCCE51.8090103@linuxtv.org> <20070209195156.GA27018@kroah.com>	<20070220231223.GA22746@kroah.com> <45DBAE91.8040804@linuxtv.org>
In-Reply-To: <45DBAE91.8040804@linuxtv.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> Greg KH wrote:
>> Ok, I've now gotten all of these for .19 and .18.
>>
>> If I've missed anything, please let me know.
>>
>> thanks for your patience.
> 
> Looks good... Thank you, Greg.
> 
> Greg KH wrote:
>> This will probably be the last release of the 2.6.19-stable series, so
>> if there are patches that you feel should be applied to that tree,
>> please let me know.
> 
> Normally, I would wait for a patch to appear in Linus' tree before I send it to -stable,
> however, this patch can not wait.  Since 2.6.18-stable and 2.6.19-stable have their last
> releases pending review, it is imperative that this final patch be added to the queue, if
> possible.

It is merged into Linus' tree now:

http://www2.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b61901024776b25ce7b8edc31bb1757c7382a88e

... The only difference is that the changeset in Linus' tree also changes some
whitespace.

Please merge this into 2.6.18.y, 2.6.19.y and 2.6.20.y

Adrian, this should also apply against 2.6.16.y

Thank you,

Michael Krufky

---

dvbdev: fix illegal re-usage of fileoperations struct

From: Marcel Siegert <mws@linuxtv.org>

 Arjan van de Ven <arjan@infradead.org> reported an illegal re-usage of the
fileoperations struct
 if more than one dvb device(e.g. frontend) is present. this patch fixes this issue.
 it allocates a new fileoperations struct each time a device is registered and
copies the default
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



-- 
Michael Krufky

