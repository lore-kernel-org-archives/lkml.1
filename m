Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYBKE25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYBKE25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 23:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYBKE2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 23:28:47 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43018 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbYBKE2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 23:28:44 -0500
Subject: Re: [PATCH] scsi: ses fix mem leaking when fail to add intf
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com
In-Reply-To: <200802091515.48076.yinghai.lu@sun.com>
References: <200802090413.53275.yinghai.lu@sun.com>
	 <1202569242.4254.9.camel@localhost.localdomain>
	 <200802091515.48076.yinghai.lu@sun.com>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 22:28:38 -0600
Message-Id: <1202704118.3136.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-09 at 15:15 -0800, Yinghai Lu wrote:
> [PATCH] scsi: ses fix mem leaking when fail to add intf
> 
> fix leaking with scomp leaking when failing.
> also remove one extra space.

There are still a few extraneous code moves in this one.  This is about
the correct minimal set, isn't it?

James

---

From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date: Sat, 9 Feb 2008 15:15:47 -0800
Subject: [SCSI] ses: fix memory leaks

fix leaking with scomp leaking when failing. Also free page10 on
driver removal  and remove one extra space.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/ses.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 2a6e4f4..8abc4a9 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -416,11 +416,11 @@ static int ses_intf_add(struct class_device *cdev,
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
@@ -456,9 +456,6 @@ static int ses_intf_add(struct class_device *cdev,
 	if (!buf)
 		goto err_free;
 
-	ses_dev->page1 = buf;
-	ses_dev->page1_len = len;
-
 	result = ses_recv_diag(sdev, 1, buf, len);
 	if (result)
 		goto recv_failed;
@@ -473,6 +470,9 @@ static int ses_intf_add(struct class_device *cdev,
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];
 	}
+	ses_dev->page1 = buf;
+	ses_dev->page1_len = len;
+	buf = NULL;
 
 	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
@@ -489,6 +489,7 @@ static int ses_intf_add(struct class_device *cdev,
 		goto recv_failed;
 	ses_dev->page2 = buf;
 	ses_dev->page2_len = len;
+	buf = NULL;
 
 	/* The additional information page --- allows us
 	 * to match up the devices */
@@ -506,11 +507,12 @@ static int ses_intf_add(struct class_device *cdev,
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
@@ -521,7 +523,7 @@ static int ses_intf_add(struct class_device *cdev,
 
 	edev->scratch = ses_dev;
 	for (i = 0; i < components; i++)
-		edev->component[i].scratch = scomp++;
+		edev->component[i].scratch = scomp + i;
 
 	/* Page 7 for the descriptors is optional */
 	buf = NULL;
@@ -598,6 +600,7 @@ static int ses_intf_add(struct class_device *cdev,
 	err = -ENODEV;
  err_free:
 	kfree(buf);
+	kfree(scomp);
 	kfree(ses_dev->page10);
 	kfree(ses_dev->page2);
 	kfree(ses_dev->page1);
@@ -630,6 +633,7 @@ static void ses_intf_remove(struct class_device *cdev,
 	ses_dev = edev->scratch;
 	edev->scratch = NULL;
 
+	kfree(ses_dev->page10);
 	kfree(ses_dev->page1);
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
-- 
1.5.3.8



