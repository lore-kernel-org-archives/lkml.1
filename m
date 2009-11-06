Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbZKFWFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbZKFWFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932191AbZKFWFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:49 -0500
Received: from kroah.org ([198.145.64.141]:39738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113AbZKFWFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:51 2009
Message-Id: <20091106215951.213173511@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [09/30] libata: fix internal command failure handling
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=libata-fix-internal-command-failure-handling.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

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
@@ -4747,12 +4747,14 @@ void ata_qc_complete(struct ata_queued_c
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


