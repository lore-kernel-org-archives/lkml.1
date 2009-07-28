Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbZG1Xv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbZG1Xv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932089AbZG1XvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:51:17 -0400
Received: from kroah.org ([198.145.64.141]:35996 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbZG1Xuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:02 2009
Message-Id: <20090728234202.080936110@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 68/71] libata: fix follow-up SRST failure path
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=libata-fix-follow-up-srst-failure-path.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit fe2c4d018fc6127610fef677e020b3bb41cfaaaf upstream.

ata_eh_reset() was missing error return handling after follow-up SRST
allowing EH to continue the normal probing path after reset failure.
This was discovered while testing new WD 2TB drives which take longer
than 10 secs to spin up and cause the first follow-up SRST to time
out.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2517,6 +2517,10 @@ int ata_eh_reset(struct ata_link *link, 
 
 			ata_eh_about_to_do(link, NULL, ATA_EH_RESET);
 			rc = ata_do_reset(link, reset, classes, deadline, true);
+			if (rc) {
+				failed_link = link;
+				goto fail;
+			}
 		}
 	} else {
 		if (verbose)


