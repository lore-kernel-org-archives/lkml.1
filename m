Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbYAPAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbYAPAso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYAPAsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:48:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:36233 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYAPAse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:48:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ViMeb6lOdT/lSWAT1NKSz2DJGUiqXX/ii853qnKA5CXoiVWJNEUFvsUxMeGaITqqoYce19XBA8m2YOqeU8ZUVDXDOz7m4phg8fYb0mQ7m8oaycpz6jc1Z3WwCeaN8FwybGAMKcIynGiT1d0wiCHflS9UMyk3h268csuyz3csRe0=
Date: Wed, 16 Jan 2008 08:51:45 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/7] scsi : use class iteration api
Message-ID: <20080116005145.GB2929@darkstar.te-china.tietoenator.com>
References: <20080112095517.GE2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112095517.GE2893@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update the patch with minor return path changes in match function:

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
