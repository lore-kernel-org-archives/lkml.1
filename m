Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXCCOgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXCCOgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030291AbXCCOgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:36:53 -0500
Received: from thing.hostingexpert.com ([67.15.235.34]:47362 "EHLO
	thing.hostingexpert.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030284AbXCCOgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:36:52 -0500
Message-ID: <45E987C4.8040302@linuxtv.org>
Date: Sat, 03 Mar 2007 09:35:48 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: stable@kernel.org
CC: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2.6.20.y PATCH 1/7] dvbdev: fix illegal re-usage of fileoperations
 struct
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

From: Marcel Siegert <mws@linuxtv.org>
Date: Tue, 27 Feb 2007 13:09:49 -0500
Subject: [PATCH] dvbdev: fix illegal re-usage of fileoperations struct

Arjan van de Ven <arjan@infradead.org> reported an illegal re-usage of
the fileoperations struct if more than one dvb device (e.g. frontend) is
present.

This patch fixes this issue.

It allocates a new fileoperations struct each time a device is
registered and copies the default template fileops.

Signed-off-by: Marcel Siegert <mws@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
(backported from commit b61901024776b25ce7b8edc31bb1757c7382a88e)
---
 drivers/media/dvb/dvb-core/dvbdev.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 40774fe..af35f30 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -200,6 +200,8 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			const struct dvb_device *template, void *priv, int type)
 {
 	struct dvb_device *dvbdev;
+	struct file_operations *dvbdevfops;
+
 	int id;
 
 	if (mutex_lock_interruptible(&dvbdev_register_lock))
@@ -219,12 +221,22 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
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
@@ -252,6 +264,7 @@ void dvb_unregister_device(struct dvb_device *dvbdev)
 					dvbdev->type, dvbdev->id)));
 
 	list_del (&dvbdev->list_head);
+	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
 EXPORT_SYMBOL(dvb_unregister_device);
