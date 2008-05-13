Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbYEMUK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbYEMUK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbYEMUKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:10:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:37647 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbYEMUKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:10:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=gYS9Mri2jtDwqNRTjqrcj1xsGnkkrOQhGvsuOK6cPK8zwQsFCBqdFuDn6ZlEpMm7mvXK+qOcfGfVfNmKatE5T3+opbM70A5MpRlCN9mp7sd1lFtW3xzlmTnxmSfFFLnPjAPLe3pRdOrIPj2ASPXeYywjY4g+rce6//KVnTEkGIQ=
Date: Wed, 14 May 2008 01:05:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: muli@il.ibm.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] OSS trident: switch from ->write_proc
Message-ID: <20080513210544.GB23977@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 sound/oss/trident.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -4028,10 +4028,10 @@ ali_free_other_states_resources(struct trident_state *state)
 
 static struct proc_dir_entry *res;
 
-static int
-ali_write_proc(struct file *file, const char __user *buffer, unsigned long count, void *data)
+static ssize_t
+ali_write_proc(struct file *file, const char __user *buffer, size_t count, loff_t *ppos)
 {
-	struct trident_card *card = (struct trident_card *) data;
+	struct trident_card *card = PDE(file->f_path.dentry->d_inode)->data;
 	unsigned long flags;
 	char c;
 
@@ -4068,6 +4068,11 @@ ali_write_proc(struct file *file, const char __user *buffer, unsigned long count
 	return count;
 }
 
+static const struct file_operations ali_proc_fops = {
+	.owner	= THIS_MODULE,
+	.write	= ali_write_proc,
+};
+
 /* OSS /dev/mixer file operation methods */
 static int
 trident_open_mixdev(struct inode *inode, struct file *file)
@@ -4441,11 +4446,8 @@ trident_probe(struct pci_dev *pci_dev, const struct pci_device_id *pci_id)
 		/* ALi SPDIF OUT function */
 		if (card->revision == ALI_5451_V02) {
 			ali_setup_spdif_out(card, ALI_PCM_TO_SPDIF_OUT);
-			res = create_proc_entry("ALi5451", 0, NULL);
-			if (res) {
-				res->write_proc = ali_write_proc;
-				res->data = card;
-			}
+			proc_create_data("ALi5451", 0, NULL,
+					 &ali_proc_fops, card);
 		}
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */

