Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbYBASRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbYBASRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYBASQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:16:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754237AbYBASQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:16:11 -0500
Message-ID: <47A3617D.10006@redhat.com>
Date: Fri, 01 Feb 2008 19:14:21 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, "Ed L. Cashin" <ecashin@coraid.com>
Subject: [Patch 4/6] Enhanced partition statistics: sysfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reports enhanced partition statistics in sysfs.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 fs/partitions/check.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6.orig/fs/partitions/check.c linux-2.6/fs/partitions/check.c
--- linux-2.6.orig/fs/partitions/check.c	2008-01-31 17:38:43.000000000 +0100
+++ linux-2.6/fs/partitions/check.c	2008-01-31 17:55:42.000000000 +0100
@@ -216,9 +216,25 @@ static ssize_t part_stat_show(struct dev
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%8u %8llu %8u %8llu\n",
-		       p->ios[0], (unsigned long long)p->sectors[0],
-		       p->ios[1], (unsigned long long)p->sectors[1]);
+	preempt_disable();
+	part_round_stats(p);
+	preempt_enable();
+	return sprintf(buf,
+		"%8lu %8lu %8llu %8u "
+		"%8lu %8lu %8llu %8u "
+		"%8u %8u %8u"
+		"\n",
+		part_stat_read(p, ios[READ]),
+		part_stat_read(p, merges[READ]),
+		(unsigned long long)part_stat_read(p, sectors[READ]),
+		jiffies_to_msecs(part_stat_read(p, ticks[READ])),
+		part_stat_read(p, ios[WRITE]),
+		part_stat_read(p, merges[WRITE]),
+		(unsigned long long)part_stat_read(p, sectors[WRITE]),
+		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
+		p->in_flight,
+		jiffies_to_msecs(part_stat_read(p, io_ticks)),
+		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST

