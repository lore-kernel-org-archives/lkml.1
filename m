Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbZADIXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbZADIXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbZADIWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:22:42 -0500
Received: from jaguar.mkp.net ([192.139.46.146]:52467 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZADIWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:41 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 3] block: Allow empty integrity profile
X-Mercurial-Node: 70852918f333e9dfbfcae4a5041d654e14c42551
Message-Id: <70852918f333e9dfbfca.1231055020@sermon.lab.mkp.net>
In-Reply-To: <patchbomb.1231055017@sermon.lab.mkp.net>
Date: Sun, 04 Jan 2009 02:43:40 -0500
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a block device to allocate and register an integrity profile
without providing a template.  This allows DM to preallocate a profile
to avoid deadlocks during table reconfiguration.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 14 insertions(+), 11 deletions(-)
block/blk-integrity.c |   25 ++++++++++++++-----------



diff --git a/block/blk-integrity.c b/block/blk-integrity.c
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -309,24 +309,24 @@ static struct kobj_type integrity_ktype 
 /**
  * blk_integrity_register - Register a gendisk as being integrity-capable
  * @disk:	struct gendisk pointer to make integrity-aware
- * @template:	integrity profile
+ * @template:	optional integrity profile to register
  *
  * Description: When a device needs to advertise itself as being able
  * to send/receive integrity metadata it must use this function to
  * register the capability with the block layer.  The template is a
  * blk_integrity struct with values appropriate for the underlying
- * hardware.  See Documentation/block/data-integrity.txt.
+ * hardware.  If template is NULL the new profile is allocated but
+ * not filled out. See Documentation/block/data-integrity.txt.
  */
 int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 {
 	struct blk_integrity *bi;
 
 	BUG_ON(disk == NULL);
-	BUG_ON(template == NULL);
 
 	if (disk->integrity == NULL) {
 		bi = kmem_cache_alloc(integrity_cachep,
-						GFP_KERNEL | __GFP_ZERO);
+				      GFP_KERNEL | __GFP_ZERO);
 		if (!bi)
 			return -1;
 
@@ -346,13 +346,16 @@ int blk_integrity_register(struct gendis
 		bi = disk->integrity;
 
 	/* Use the provided profile as template */
-	bi->name = template->name;
-	bi->generate_fn = template->generate_fn;
-	bi->verify_fn = template->verify_fn;
-	bi->tuple_size = template->tuple_size;
-	bi->set_tag_fn = template->set_tag_fn;
-	bi->get_tag_fn = template->get_tag_fn;
-	bi->tag_size = template->tag_size;
+	if (template != NULL) {
+		bi->name = template->name;
+		bi->generate_fn = template->generate_fn;
+		bi->verify_fn = template->verify_fn;
+		bi->tuple_size = template->tuple_size;
+		bi->set_tag_fn = template->set_tag_fn;
+		bi->get_tag_fn = template->get_tag_fn;
+		bi->tag_size = template->tag_size;
+	} else
+		bi->name = "unsupported";
 
 	return 0;
 }


