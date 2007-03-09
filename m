Return-Path: <linux-kernel-owner+w=401wt.eu-S2993036AbXCIHRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993036AbXCIHRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993037AbXCIHRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:17:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:6200 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993036AbXCIHRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:17:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=QneELFmxORXw+UXEyhuBmBmVGpck7Dbg9qz7V5NtCGXEZq5sD1eaeK/Ij+mHCy2ooQ4N/oSymEx6o3Q8suYIy09vSQaXycDcu4+3PlJEs6ti00nkiyUMcNelvG8WOq2JPDTpD9QoTLD2m7mThbKuBu/+4AGziBIQWbRH7mHI+vg=
Date: Thu, 8 Mar 2007 23:16:58 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: check kmalloc() return value.
Message-Id: <20070308231658.de80dad1.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function ch_readconfig(), in file drivers/scsi/ch.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index f6caa43..fcd635b 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -324,7 +324,7 @@ ch_readconfig(scsi_changer *ch)
 	if (!buffer)
 		return -ENOMEM;
 	memset(buffer,0,512);
-	
+
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = MODE_SENSE;
 	cmd[1] = ch->device->lun << 5;
@@ -367,7 +367,7 @@ ch_readconfig(scsi_changer *ch)
 	} else {
 		vprintk("reading element address assigment page failed!\n");
 	}
-	
+
 	/* vendor specific element types */
 	for (i = 0; i < 4; i++) {
 		if (0 == vendor_counts[i])
@@ -384,6 +384,10 @@ ch_readconfig(scsi_changer *ch)
 	/* look up the devices of the data transfer elements */
 	ch->dt = kmalloc(ch->counts[CHET_DT]*sizeof(struct scsi_device),
 			 GFP_KERNEL);
+	if (!ch->dt) {
+		kfree(buffer);
+		return -ENOMEM;
+	}
 	for (elem = 0; elem < ch->counts[CHET_DT]; elem++) {
 		id  = -1;
 		lun = 0;
