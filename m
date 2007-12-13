Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXLMQUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXLMQUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762798AbXLMQTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:19:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762786AbXLMQTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:19:01 -0500
Message-ID: <47615B38.3060702@redhat.com>
Date: Thu, 13 Dec 2007 17:18:00 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [Patch 6/8] Enhanced partition statistics: sysfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reports enhanced partition statistics in sysfs.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 check.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/fs/partitions/check.c linux-2.6/fs/partitions/check.c
--- linux-2.6.orig/fs/partitions/check.c	2007-12-05 13:43:49.000000000 +0100
+++ linux-2.6/fs/partitions/check.c	2007-12-05 13:51:03.000000000 +0100
@@ -254,11 +254,27 @@ static ssize_t part_size_read(struct hd_
 {
 	return sprintf(page, "%llu\n",(unsigned long long)p->nr_sects);
 }
-static ssize_t part_stat_read(struct hd_struct * p, char *page)
+static ssize_t part_stats_read(struct hd_struct * p, char *page)
 {
-	return sprintf(page, "%8u %8llu %8u %8llu\n",
-		       p->ios[0], (unsigned long long)p->sectors[0],
-		       p->ios[1], (unsigned long long)p->sectors[1]);
+	preempt_disable();
+	part_round_stats(p);
+	preempt_enable();
+	return sprintf(page,
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
 static struct part_attribute part_attr_uevent = {
 	.attr = {.name = "uevent", .mode = S_IWUSR },
@@ -278,7 +294,7 @@ static struct part_attribute part_attr_s
 };
 static struct part_attribute part_attr_stat = {
 	.attr = {.name = "stat", .mode = S_IRUGO },
-	.show	= part_stat_read
+	.show	= part_stats_read
 };
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST

