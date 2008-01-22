Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYAVGAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYAVGAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYAVGAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:00:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:53259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYAVGAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:00:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rbRk8lBTrEBSI4JkFMIs17GB9nuuWnz7AHI9gEKpyFjqwEVKVEqC51UCQWVco8z/yvuM/JLYenc6tWpn8364YJsDYZ1vp9xTNfJiYQA7K4i4NJwf1zqwX+QI4BPK1WoT3RW4ZnaE5B+JqMZ5Sds9TNGDtAd2YccmY8JVEw4pTQk=
Date: Tue, 22 Jan 2008 14:01:34 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 5/6] scsi : use class iteration api
Message-ID: <20080122060134.GF3066@darkstar.te-china.tietoenator.com>
References: <20080112095517.GE2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112095517.GE2893@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/scsi/hosts.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -upr linux/drivers/scsi/hosts.c linux.new/drivers/scsi/hosts.c
--- linux/drivers/scsi/hosts.c	2008-01-16 08:43:35.000000000 +0800
+++ linux.new/drivers/scsi/hosts.c	2008-01-16 08:43:35.000000000 +0800
@@ -429,6 +429,15 @@ void scsi_unregister(struct Scsi_Host *s
 }
 EXPORT_SYMBOL(scsi_unregister);
 
+static int __scsi_host_match(struct class_device *cdev, void *data)
+{
+	struct Scsi_Host *p;
+	unsigned short *hostnum = (unsigned short *)data;
+
+	p = class_to_shost(cdev);
+	return p->host_no == *hostnum;
+}
+
 /**
  * scsi_host_lookup - get a reference to a Scsi_Host by host no
  *
@@ -439,19 +448,12 @@ EXPORT_SYMBOL(scsi_unregister);
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
