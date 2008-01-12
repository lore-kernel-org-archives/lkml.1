Return-Path: <linux-kernel-owner+w=401wt.eu-S1763398AbYALJwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763398AbYALJwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762563AbYALJv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:51:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:17687 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762486AbYALJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:51:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=UJuoxZCxHywbFSsJaSeg+7wAuivtNguEB5gjTo0YK3sCnvR0iCqMrvBW6SIgJQ5BWVJhYuWzAqGe3pVuDZY61NTPXbwBHsY8o9aLUl0omXja2yyLN2qRqndwhSACSHxWJYQV1XqEXR+Vxw6GFsVj2mraw+rNp3lVGRavkYWjUQw=
Date: Sat, 12 Jan 2008 17:55:17 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 5/7] scsi : use class iteration api
Message-ID: <20080112095517.GE2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/scsi/hosts.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff -upr linux/drivers/scsi/hosts.c linux.new/drivers/scsi/hosts.c
--- linux/drivers/scsi/hosts.c	2008-01-12 15:54:16.000000000 +0800
+++ linux.new/drivers/scsi/hosts.c	2008-01-12 15:54:16.000000000 +0800
@@ -429,6 +429,17 @@ void scsi_unregister(struct Scsi_Host *s
 }
 EXPORT_SYMBOL(scsi_unregister);
 
+static int __scsi_host_match(struct class_device *cdev, void *data)
+{
+	struct Scsi_Host *p;
+	unsigned short *hostnum = (unsigned short *)data;
+
+	p = class_to_shost(cdev);
+	if (p->host_no == *hostnum)
+		return 1;
+	return 0;
+}
+
 /**
  * scsi_host_lookup - get a reference to a Scsi_Host by host no
  *
@@ -439,19 +450,12 @@ EXPORT_SYMBOL(scsi_unregister);
  **/
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
-	struct class *class = &shost_class;
 	struct class_device *cdev;
-	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
+	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
 
-	down(&class->sem);
-	list_for_each_entry(cdev, &class->children, node) {
-		p = class_to_shost(cdev);
-		if (p->host_no == hostnum) {
-			shost = scsi_host_get(p);
-			break;
-		}
-	}
-	up(&class->sem);
+	cdev = class_find_child(&shost_class, &hostnum, __scsi_host_match);
+	if (cdev)
+		shost = scsi_host_get(class_to_shost(cdev));
 
 	return shost;
 }
