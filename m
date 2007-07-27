Return-Path: <linux-kernel-owner+w=401wt.eu-S937305AbXG0PPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937305AbXG0PPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761909AbXG0PPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:15:21 -0400
Received: from mail.tnp-online.de ([212.80.247.147]:36603 "EHLO
	relay1.gigamail.to" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761524AbXG0PPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:15:19 -0400
X-Greylist: delayed 1438 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jul 2007 11:15:18 EDT
Subject: [PATCH] md: handle writes to broken raid10 arrays gracefully
From: Arne Redlich <agr@powerkom-dd.de>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 16:44:35 +0200
Message-Id: <1185547475.25852.5.camel@confield.dd.xiranet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
X-xiranet-MailScanner-OpenProtect-Information: Please contact the ISP for more information
X-xiranet-MailScanner-OpenProtect: Found to be clean
X-xiranet-MailScanner-OpenProtect-MCPCheck: 
X-xiranet-MailScanner-OpenProtect-From: agr@powerkom-dd.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When writing to a broken array, raid10 currently happily emits empty bio
lists. IOW, the master bio will never be completed, sending writers to
UNINTERRUPTIBLE_SLEEP forever.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ea1b3e3..957932e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -917,6 +917,13 @@ static int make_request(struct request_queue *q, struct bio * bio)
 		bio_list_add(&bl, mbio);
 	}
 
+	if (unlikely(!atomic_read(&r10_bio->remaining))) {
+		/* the array is dead */
+		md_write_end(mddev);
+		raid_end_bio_io(r10_bio);
+		return 0;
+	}
+
 	bitmap_startwrite(mddev->bitmap, bio->bi_sector, r10_bio->sectors, 0);
 	spin_lock_irqsave(&conf->device_lock, flags);
 	bio_list_merge(&conf->pending_bio_list, &bl);


