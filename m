Return-Path: <linux-kernel-owner+w=401wt.eu-S934654AbYAaShk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbYAaShk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761433AbYAaShc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:37:32 -0500
Received: from mail.hpce.nec.com ([193.141.139.212]:45370 "EHLO
	mail.hpce.nec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYAaSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:37:30 -0500
X-Greylist: delayed 1691 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 13:37:30 EST
From: Erich Focht <efocht@hpce.nec.com>
Reply-To: efocht@hpce.nec.com
To: dm-devel@redhat.com
Subject: [PATCH] remove device mapper max_sectors restriction
Date: Thu, 31 Jan 2008 19:09:10 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311909.11752.efocht@hpce.nec.com>
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.0-19; AVE: 7.6.0.61; VDF: 7.0.2.78; host: av.hpce.nec.com)
X-GData-Scanner: Clean, Agent: GData SMTP PROXY 1.6.1 on
 av.hpce.nec.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The maximum size of a bio is restricted by DM to BLK_DEF_MAX_SECTORS
although the I/O size can be increased for each member device above this
value by using the /sys/block/queue/max_sectors interface.

IMHO the limitation when loading the dm table is unnecessary, the values
for sub-devices are checked while set through the sysfs interface and
the restrictions of the sub-devices are combined, the minimal values are
used for the DM queue. Chopping this additionally to BLK_DEF_MAX_SECTORS
makes it impossible to use IOs bigger than 512KB on big RAIDs accessed
through multipath, even if the devices may support them. The trivial patch
removes this limitation. Sub-devices' max_sectors need to be set before
creating the DM device.

Patch is against 2.6.24. For older kernels max_hw_sectors needs to be set
additionally.



Signed-off-by: Erich Focht <efocht@hpce.nec.com>
---
 dm-table.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24/drivers/md/dm-table.c.orig	2008-01-31 17:06:30.000000000 +0100
+++ linux-2.6.24/drivers/md/dm-table.c	2008-01-31 17:34:03.000000000 +0100
@@ -901,10 +901,10 @@
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
-	 * Make sure we obey the optimistic sub devices
+	 * Make sure we obey the minimum of the sub devices
 	 * restrictions.
 	 */
-	blk_queue_max_sectors(q, t->limits.max_sectors);
+	q->max_sectors = t->limits.max_sectors;
 	q->max_phys_segments = t->limits.max_phys_segments;
 	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;

