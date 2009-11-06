Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbZKFWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbZKFWWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbZKFWWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:22 -0500
Received: from kroah.org ([198.145.64.141]:56628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760023AbZKFWWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:20 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:39 2009
Message-Id: <20091106221539.385182515@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [05/99] sata_nv: make sure link is brough up online when skipping hardreset
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=sata_nv-make-sure-link-is-brough-up-online-when-skipping-hardreset.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 6489e3262e6b188a1a009b65e8a94b7aa17645b7 upstream.

prereset doesn't bring link online if hardreset is about to happen and
nv_hardreset() may skip if conditions are not right so softreset may
be entered with non-working link status if the system firmware didn't
bring it up before entering OS code which can happen during resume.
This patch makes nv_hardreset() to bring up the link if it's skipping
reset.

This bug was reported by frodone@gmail.com in the following bug entry.

  http://bugzilla.kernel.org/show_bug.cgi?id=14329

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: frodone@gmail.com
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_nv.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1594,9 +1594,21 @@ static int nv_hardreset(struct ata_link 
 	    !ata_dev_enabled(link->device))
 		sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
 				    NULL, NULL);
-	else if (!(ehc->i.flags & ATA_EHI_QUIET))
-		ata_link_printk(link, KERN_INFO,
-				"nv: skipping hardreset on occupied port\n");
+	else {
+		const unsigned long *timing = sata_ehc_deb_timing(ehc);
+		int rc;
+
+		if (!(ehc->i.flags & ATA_EHI_QUIET))
+			ata_link_printk(link, KERN_INFO, "nv: skipping "
+					"hardreset on occupied port\n");
+
+		/* make sure the link is online */
+		rc = sata_link_resume(link, timing, deadline);
+		/* whine about phy resume failure but proceed */
+		if (rc && rc != -EOPNOTSUPP)
+			ata_link_printk(link, KERN_WARNING, "failed to resume "
+					"link (errno=%d)\n", rc);
+	}
 
 	/* device signature acquisition is unreliable */
 	return -EAGAIN;


