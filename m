Return-Path: <linux-kernel-owner+w=401wt.eu-S932735AbXJLRIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbXJLRIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761090AbXJLRHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:07:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbXJLRHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:07:41 -0400
Date: Fri, 12 Oct 2007 18:07:36 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>, Milan Broz <mbroz@redhat.com>
Subject: [2.6.24 PATCH 06/25] dm delay: fix ctr error paths
Message-ID: <20071012170736.GQ24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

Add missing 'dm_put_device' to dm-delay target constructor.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-delay.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

Index: linux-2.6.23/drivers/md/dm-delay.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-delay.c	2007-10-12 13:15:18.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-delay.c	2007-10-12 13:15:33.000000000 +0100
@@ -163,34 +163,32 @@ static int delay_ctr(struct dm_target *t
 		goto bad;
 	}
 
-	if (argc == 3) {
-		dc->dev_write = NULL;
+	dc->dev_write = NULL;
+	if (argc == 3)
 		goto out;
-	}
 
 	if (sscanf(argv[4], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid write device sector";
-		goto bad;
+		goto bad_dev_read;
 	}
 	dc->start_write = tmpll;
 
 	if (sscanf(argv[5], "%u", &dc->write_delay) != 1) {
 		ti->error = "Invalid write delay";
-		goto bad;
+		goto bad_dev_read;
 	}
 
 	if (dm_get_device(ti, argv[3], dc->start_write, ti->len,
 			  dm_table_get_mode(ti->table), &dc->dev_write)) {
 		ti->error = "Write device lookup failed";
-		dm_put_device(ti, dc->dev_read);
-		goto bad;
+		goto bad_dev_read;
 	}
 
 out:
 	dc->delayed_pool = mempool_create_slab_pool(128, delayed_cache);
 	if (!dc->delayed_pool) {
 		DMERR("Couldn't create delayed bio pool.");
-		goto bad;
+		goto bad_dev_write;
 	}
 
 	setup_timer(&dc->delay_timer, handle_delayed_timer, (unsigned long)dc);
@@ -203,6 +201,11 @@ out:
 	ti->private = dc;
 	return 0;
 
+bad_dev_write:
+	if (dc->dev_write)
+		dm_put_device(ti, dc->dev_write);
+bad_dev_read:
+	dm_put_device(ti, dc->dev_read);
 bad:
 	kfree(dc);
 	return -EINVAL;
