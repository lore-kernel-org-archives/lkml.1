Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYBKHRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYBKHRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYBKHRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:17:44 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58801 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYBKHRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:17:42 -0500
Date: Sun, 10 Feb 2008 23:25:25 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [SCSI] ses: fix memory leaks
In-reply-to: <1202704118.3136.79.camel@localhost.localdomain>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com
Message-id: <200802102325.26538.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802091515.48076.yinghai.lu@sun.com>
 <1202704118.3136.79.camel@localhost.localdomain>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check it...

---

From: Yinghai Lu <yinghai.lu@sun.com>

[SCSI] ses: fix memory leaks

fix leaking with scomp leaking when failing. Also free page10 on
driver removal  and remove one extra space.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---

 drivers/scsi/ses.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/scsi/ses.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ses.c
+++ linux-2.6/drivers/scsi/ses.c
@@ -416,11 +416,11 @@ static int ses_intf_add(struct class_dev
 	int i, j, types, len, components = 0;
 	int err = -ENOMEM;
 	struct enclosure_device *edev;
-	struct ses_component *scomp;
+	struct ses_component *scomp = NULL;
 
 	if (!scsi_device_enclosure(sdev)) {
 		/* not an enclosure, but might be in one */
-		edev = 	enclosure_find(&sdev->host->shost_gendev);
+		edev = enclosure_find(&sdev->host->shost_gendev);
 		if (edev) {
 			ses_match_to_enclosure(edev, sdev);
 			class_device_put(&edev->cdev);
@@ -456,9 +456,6 @@ static int ses_intf_add(struct class_dev
 	if (!buf)
 		goto err_free;
 
-	ses_dev->page1 = buf;
-	ses_dev->page1_len = len;
-
 	result = ses_recv_diag(sdev, 1, buf, len);
 	if (result)
 		goto recv_failed;
@@ -473,6 +470,9 @@ static int ses_intf_add(struct class_dev
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];
 	}
+	ses_dev->page1 = buf;
+	ses_dev->page1_len = len;
+	buf = NULL;
 
 	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
@@ -489,6 +489,7 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 	ses_dev->page2 = buf;
 	ses_dev->page2_len = len;
+	buf = NULL;
 
 	/* The additional information page --- allows us
 	 * to match up the devices */
@@ -506,11 +507,12 @@ static int ses_intf_add(struct class_dev
 		goto recv_failed;
 	ses_dev->page10 = buf;
 	ses_dev->page10_len = len;
+	buf = NULL;
 
  no_page10:
-	scomp = kmalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
+	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
-		goto  err_free;
+		goto err_free;
 
 	edev = enclosure_register(cdev->dev, sdev->sdev_gendev.bus_id,
 				  components, &ses_enclosure_callbacks);
@@ -521,10 +523,9 @@ static int ses_intf_add(struct class_dev
 
 	edev->scratch = ses_dev;
 	for (i = 0; i < components; i++)
-		edev->component[i].scratch = scomp++;
+		edev->component[i].scratch = scomp + i;
 
 	/* Page 7 for the descriptors is optional */
-	buf = NULL;
 	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
 		goto simple_populate;
@@ -532,6 +533,8 @@ static int ses_intf_add(struct class_dev
 	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	/* add 1 for trailing '\0' we'll use */
 	buf = kzalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		goto simple_polulate;
 	result = ses_recv_diag(sdev, 7, buf, len);
 	if (result) {
  simple_populate:
@@ -598,6 +601,7 @@ static int ses_intf_add(struct class_dev
 	err = -ENODEV;
  err_free:
 	kfree(buf);
+	kfree(scomp);
 	kfree(ses_dev->page10);
 	kfree(ses_dev->page2);
 	kfree(ses_dev->page1);
@@ -630,6 +634,7 @@ static void ses_intf_remove(struct class
 	ses_dev = edev->scratch;
 	edev->scratch = NULL;
 
+	kfree(ses_dev->page10);
 	kfree(ses_dev->page1);
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
