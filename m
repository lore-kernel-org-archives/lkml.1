Return-Path: <linux-kernel-owner+w=401wt.eu-S1765780AbYCDQeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765780AbYCDQeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765404AbYCDQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:42 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48607 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765448AbYCDQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:38 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 09/11] memstick: fix parsing of "assembly_date" attribute field
Date: Wed,  5 Mar 2008 03:02:26 +1100
Message-Id: <1204646548-27466-10-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-9-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-5-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-6-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-7-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-8-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-9-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/memstick/core/mspro_block.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 2381c5d..62b913b 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -303,6 +303,20 @@ static ssize_t mspro_block_attr_show_sysinfo(struct device *dev,
 						     dev_attr);
 	struct mspro_sys_info *x_sys = x_attr->data;
 	ssize_t rc = 0;
+	int date_tz = 0, date_tz_f = 0;
+
+	if (x_sys->assembly_date[0] > 0x80U) {
+		date_tz = (~x_sys->assembly_date[0]) + 1;
+		date_tz_f = date_tz & 3;
+		date_tz >>= 2;
+		date_tz = -date_tz;
+		date_tz_f *= 15;
+	} else if (x_sys->assembly_date[0] < 0x80U) {
+		date_tz = x_sys->assembly_date[0];
+		date_tz_f = date_tz & 3;
+		date_tz >>= 2;
+		date_tz_f *= 15;
+	}
 
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "class: %x\n",
 			x_sys->class);
@@ -315,8 +329,8 @@ static ssize_t mspro_block_attr_show_sysinfo(struct device *dev,
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "page size: %x\n",
 			be16_to_cpu(x_sys->page_size));
 	rc += scnprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
-			"%d %04u-%02u-%02u %02u:%02u:%02u\n",
-			x_sys->assembly_date[0],
+			"GMT%+d:%d %04u-%02u-%02u %02u:%02u:%02u\n",
+			date_tz, date_tz_f,
 			be16_to_cpu(*(unsigned short *)
 				    &x_sys->assembly_date[1]),
 			x_sys->assembly_date[3], x_sys->assembly_date[4],
-- 
1.5.3.6

