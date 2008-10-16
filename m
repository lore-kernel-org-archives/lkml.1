Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYJPNCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYJPNCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbYJPNCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:02:38 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:36540 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbYJPNCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:02:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANvY9kjCTsYx/2dsb2JhbACBcsFkg2w
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Check fops_get() return value
Date: Thu, 16 Oct 2008 15:02:40 +0200
User-Agent: KMail/1.9.9
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>Tnf
	SacR{(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
Cc: airlied@linux.ie, mchehab@infradead.org, perex@perex.cz, tiwai@suse.de,
       alan-jenkins@tuffmail.co.uk
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810161502.41159.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several subsystem open handlers dereference the fops_get() return value
without checking it for nullness. This opens a race condition between the
open handler and module unloading.

A module can be marked as being unloaded (MODULE_STATE_GOING) before its exit
function is called and gets the chance to unregister the driver. During that
window open handlers can still be called, and fops_get() will fail in
try_module_get() and return a NULL pointer.

This change checks the fops_get() return value and returns -ENODEV if NULL.

Reported-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>
---
 drivers/gpu/drm/drm_fops.c          |    4 ++++
 drivers/media/dvb/dvb-core/dvbdev.c |    5 +++++
 sound/core/sound.c                  |    4 ++++
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 851a53f..ef5c295 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -186,6 +186,10 @@ int drm_stub_open(struct inode *inode, struct file *filp)
 
 	old_fops = filp->f_op;
 	filp->f_op = fops_get(&dev->driver->fops);
+	if (filp->f_op == NULL) {
+		filp->f_op = old_fops;
+		goto out;
+	}
 	if (filp->f_op->open && (err = filp->f_op->open(inode, filp))) {
 		fops_put(filp->f_op);
 		filp->f_op = fops_get(old_fops);
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index e713277..fb4e241 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -85,6 +85,10 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 		file->private_data = dvbdev;
 		old_fops = file->f_op;
 		file->f_op = fops_get(dvbdev->fops);
+		if (file->f_op == NULL) {
+			file->f_op = old_fops;
+			goto fail;
+		}
 		if(file->f_op->open)
 			err = file->f_op->open(inode,file);
 		if (err) {
@@ -95,6 +99,7 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 		unlock_kernel();
 		return err;
 	}
+fail:
 	unlock_kernel();
 	return -ENODEV;
 }
diff --git a/sound/core/sound.c b/sound/core/sound.c
index c0685e2..8659b84 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -152,6 +152,10 @@ static int __snd_open(struct inode *inode, struct file *file)
 	}
 	old_fops = file->f_op;
 	file->f_op = fops_get(mptr->f_ops);
+	if (file->f_op == NULL) {
+		file->f_op = old_fops;
+		return -ENODEV;
+	}
 	if (file->f_op->open)
 		err = file->f_op->open(inode, file);
 	if (err) {
-- 
1.5.0

