Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbYFDMRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbYFDMRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760290AbYFDMLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:11:19 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:64902 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760943AbYFDMLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=O0Rz8Orb0i8B8JKUjh9p5T+dydBioEW7nz58rRSiwSSqeQyAByxjJqT+vqX9sCoBjW
         Ibn8219Bk6K4Bl+ev2TCZTZZMTF5HYoANJqhaoc5t/kk2GBpUZTgvJdfA8z+je4k7Sly
         Vnfx3320WkrypCvhz0gSWNLyjAGK/90t5nZQY=
Message-Id: <20080604115854.158492587@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:54 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Brian King <brking@us.ibm.com>,
       "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org
Subject: [patch -v3 21/22] ipr: use memory_read_from_buffer
Content-Disposition: inline; filename=scsi-ipr-use-memory-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Brian King <brking@us.ibm.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ipr.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: 2.6-git/drivers/scsi/ipr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/ipr.c
+++ 2.6-git/drivers/scsi/ipr.c
@@ -2455,20 +2455,14 @@ static ssize_t ipr_read_trace(struct kob
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *)shost->hostdata;
 	unsigned long lock_flags = 0;
-	int size = IPR_TRACE_SIZE;
-	char *src = (char *)ioa_cfg->trace;
-
-	if (off > size)
-		return 0;
-	if (off + count > size) {
-		size -= off;
-		count = size;
-	}
+	ssize_t ret;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	memcpy(buf, &src[off], count);
+	ret = memory_read_from_buffer(buf, count, &off, ioa_cfg->trace,
+				IPR_TRACE_SIZE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-	return count;
+
+	return ret;
 }
 
 static struct bin_attribute ipr_trace_attr = {

-- 
