Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbZKFWsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbZKFWsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760040AbZKFWsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:48:19 -0500
Received: from kroah.org ([198.145.64.141]:56624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759970AbZKFWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:19 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:39 2009
Message-Id: <20091106221539.257589628@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [04/99] libata: fix PMP initialization
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=libata-fix-pmp-initialization.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 4f7c2874995ac48a4622755b8bd159eb2fb6d8f4 upstream.

Commit 842faa6c1a1d6faddf3377948e5cf214812c6c90 fixed error handling
during attach by not committing detected device class to dev->class
while attaching a new device.  However, this change missed the PMP
class check in the configuration loop causing a new PMP device to go
through ata_dev_configure() as if it were an ATA or ATAPI device.

As PMP device doesn't have a regular IDENTIFY data, this makes
ata_dev_configure() tries to configure a PMP device using an invalid
data.  For the most part, it wasn't too harmful and went unnoticed but
this ends up clearing dev->flags which may have ATA_DFLAG_AN set by
sata_pmp_attach().  This means that SATA_PMP_FEAT_NOTIFY ends up being
disabled on PMPs and on PMPs which honor the flag breaks hotplug
support.

This problem was discovered and reported by Ethan Hsiao.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ethan Hsiao <ethanhsiao@jmicron.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2849,12 +2849,14 @@ static int ata_eh_revalidate_and_attach(
 	 * device detection messages backwards.
 	 */
 	ata_for_each_dev(dev, link, ALL) {
-		if (!(new_mask & (1 << dev->devno)) ||
-		    dev->class == ATA_DEV_PMP)
+		if (!(new_mask & (1 << dev->devno)))
 			continue;
 
 		dev->class = ehc->classes[dev->devno];
 
+		if (dev->class == ATA_DEV_PMP)
+			continue;
+
 		ehc->i.flags |= ATA_EHI_PRINTINFO;
 		rc = ata_dev_configure(dev);
 		ehc->i.flags &= ~ATA_EHI_PRINTINFO;


