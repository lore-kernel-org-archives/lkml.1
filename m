Return-Path: <linux-kernel-owner+w=401wt.eu-S1422950AbXCGRja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422950AbXCGRja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422785AbXCGRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:51 -0500
Received: from ns.suse.de ([195.135.220.2]:43864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817AbXCGRP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:26 -0500
Message-Id: <20070307171348.920686101@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Marcel Siegert <mws@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 046/101] dvbdev: fix illegal re-usage of fileoperations struct
Content-Disposition: inline; filename=dvbdev-fix-illegal-re-usage-of-fileoperations-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Siegert <mws@linuxtv.org>

Arjan van de Ven <arjan@infradead.org> reported an illegal re-usage of
the fileoperations struct if more than one dvb device (e.g. frontend) is
present.

This patch fixes this issue.

It allocates a new fileoperations struct each time a device is
registered and copies the default template fileops.

(backported from commit b61901024776b25ce7b8edc31bb1757c7382a88e)

Signed-off-by: Marcel Siegert <mws@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-core/dvbdev.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- linux-2.6.20.1.orig/drivers/media/dvb/dvb-core/dvbdev.c
+++ linux-2.6.20.1/drivers/media/dvb/dvb-core/dvbdev.c
@@ -200,6 +200,8 @@ int dvb_register_device(struct dvb_adapt
 			const struct dvb_device *template, void *priv, int type)
 {
 	struct dvb_device *dvbdev;
+	struct file_operations *dvbdevfops;
+
 	int id;
 
 	if (mutex_lock_interruptible(&dvbdev_register_lock))
@@ -219,12 +221,22 @@ int dvb_register_device(struct dvb_adapt
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
@@ -252,6 +264,7 @@ void dvb_unregister_device(struct dvb_de
 					dvbdev->type, dvbdev->id)));
 
 	list_del (&dvbdev->list_head);
+	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
 EXPORT_SYMBOL(dvb_unregister_device);

--
