Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYEOUZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYEOUZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYEOUZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:25:06 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:2797 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYEOUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:25:04 -0400
Date: Thu, 15 May 2008 19:48:05 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OSS trident: switch from ->write_proc
Message-ID: <20080515164805.GA7162@il.ibm.com>
References: <20080513210544.GB23977@martell.zuzino.mipt.ru> <20080514054707.GB6682@il.ibm.com> <20080514204930.GA10513@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514204930.GA10513@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:49:30AM +0400, Alexey Dobriyan wrote:

> Sorry, I just want to remove ->write_proc totally and auditing proc
> users are for later.

Ok, here's an updated patch to not leak the proc entry. Fix is
trivial, so I took the liberty of keeping your 'From' and
'Signed-off-by' lines. Andrew, please push to Linus.

Subject: [PATCH] OSS trident: switch from ->write_proc
From: Alexey Dobriyan <adobriyan@gmail.com>

[muli: don't leak the proc entry]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 sound/oss/trident.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index f43f91e..ff70a81 100644
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
+			res = proc_create_data("ALi5451", 0, NULL,
+					       &ali_proc_fops, card);
 		}
 
 		/* Add H/W Volume Control By Matt Wu Jul. 06, 2001 */
-- 
1.5.2.5


