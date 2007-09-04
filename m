Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbXIDQlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbXIDQlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 12:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXIDQl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 12:41:28 -0400
Received: from norden.math.tntech.edu ([149.149.136.15]:40534 "EHLO
	norden.math.tntech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbXIDQl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 12:41:27 -0400
X-Greylist: delayed 2033 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Sep 2007 12:41:27 EDT
Date: Tue, 4 Sep 2007 11:07:20 -0500
Message-Id: <200709041607.l84G7KsT032647@norden.math.tntech.edu>
From: Jeff Norden <jeff@math.tntech.edu>
To: alan@redhat.com
Subject: [PATCH 1/1] pata_it821x: fix lost interrupt with atapi devices
CC: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 From: Jeff Norden <jnorden@math.tntech.edu>

Fix "lost" interrupt problem when using dma with CD/DVD drives in some
configurations.  This problem can make installing linux from media
impossible for distro's that have switched to libata-only configurations.

The simple fix is to eliminate the use of dma for reading drive status, etc,
by checking the number of bytes to transferred.

This change will only affect the behavior of atapi devices, not disks.
There is more info at http://bugzilla.redhat.com/show_bug.cgi?id=242229
This patch is for 2.6.22.1

Signed-off-by: Jeff Norden <jnorden@math.tntech.edu>

---

--- pata_it821x.c.orig	2007-08-16 14:20:49.000000000 -0500
+++ pata_it821x.c	2007-08-31 16:09:22.000000000 -0500
@@ -533,6 +533,10 @@ static int it821x_check_atapi_dma(struct
 	struct ata_port *ap = qc->ap;
 	struct it821x_dev *itdev = ap->private_data;
 
+	/* Only use dma for transfers to/from the media. */
+	if (qc->nbytes < 2048)
+		return -EOPNOTSUPP;
+
 	/* No ATAPI DMA in smart mode */
 	if (itdev->smart)
 		return -EOPNOTSUPP;

