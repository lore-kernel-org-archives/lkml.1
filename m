Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbZKFWWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbZKFWWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbZKFWWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:20 -0500
Received: from kroah.org ([198.145.64.141]:56619 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921AbZKFWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:19 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:39 2009
Message-Id: <20091106221539.132843823@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [03/99] libata: fix internal command failure handling
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=libata-fix-internal-command-failure-handling.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit f4b31db92d163df8a639f5a8c8633bdeb6e8432d upstream.

When an internal command fails, it should be failed directly without
invoking EH.  In the original implemetation, this was accomplished by
letting internal command bypass failure handling in ata_qc_complete().
However, later changes added post-successful-completion handling to
that code path and the success path is no longer adequate as internal
command failure path.  One of the visible problems is that internal
command failure due to timeout or other freeze conditions would
spuriously trigger WARN_ON_ONCE() in the success path.

This patch updates failure path such that internal command failure
handling is contained there.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5008,12 +5008,14 @@ void ata_qc_complete(struct ata_queued_c
 			qc->flags |= ATA_QCFLAG_FAILED;
 
 		if (unlikely(qc->flags & ATA_QCFLAG_FAILED)) {
-			if (!ata_tag_internal(qc->tag)) {
-				/* always fill result TF for failed qc */
-				fill_result_tf(qc);
+			/* always fill result TF for failed qc */
+			fill_result_tf(qc);
+
+			if (!ata_tag_internal(qc->tag))
 				ata_qc_schedule_eh(qc);
-				return;
-			}
+			else
+				__ata_qc_complete(qc);
+			return;
 		}
 
 		/* read result TF if requested */


