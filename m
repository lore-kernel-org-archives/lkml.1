Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbXJYTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbXJYTgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbXJYTfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:35:52 -0400
Received: from ozlabs.org ([203.10.76.45]:51459 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbXJYTfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:35:51 -0400
Date: Thu, 25 Oct 2007 14:35:30 -0500
From: Anton Blanchard <anton@samba.org>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Initialise scatter/gather list in sg driver
Message-ID: <20071025193530.GB20459@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


After turning on DEBUG_SG I hit a fail:

kernel BUG at include/linux/scatterlist.h:50!

	sg_build_indirect
	sg_build_reserve
	sg_open
	chrdev_open
	__dentry_open
	do_filp_open
	do_sys_open

We should initialise the sg list when we allocate it in sg_build_sgat.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index b5fa4f0..f1871ea 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1652,6 +1652,7 @@ sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
 	schp->buffer = kzalloc(sg_bufflen, gfp_flags);
 	if (!schp->buffer)
 		return -ENOMEM;
+	sg_init_table(schp->buffer, tablesize);
 	schp->sglist_len = sg_bufflen;
 	return tablesize;	/* number of scat_gath elements allocated */
 }
