Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbZCATZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbZCATZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 14:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZCATZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 14:25:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:49118 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZCATZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 14:25:45 -0500
Message-ID: <49AAE132.8030403@suse.de>
Date: Sun, 01 Mar 2009 20:25:38 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>, Zhu Yi <yi.zhu@intel.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Frank Seidel <fseidel@suse.de>, Frank Seidel <frank@f-seidel.de>,
       kernalert.de@gmail.com, Mohamed Abbas <mohamed.abbas@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>,
       Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] iwlwifi: reduce stack size
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Reduce stack memory footprint of iwlwifi.
(From >1000 bytes for each *_table_read
on i386 down to 32)

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   11 +++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   23 +++++++++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -815,11 +815,16 @@ static ssize_t iwl3945_sta_dbgfs_stats_t
 						  char __user *user_buf,
 						  size_t count, loff_t *ppos)
 {
-	char buff[1024];
+	char *buff;
 	int desc = 0;
 	int j;
+	ssize_t ret;
 	struct iwl3945_rs_sta *lq_sta = file->private_data;
 
+	buff = kmalloc(1024, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
 	desc += sprintf(buff + desc, "tx packets=%d last rate index=%d\n"
 			"rate=0x%X flush time %d\n",
 			lq_sta->tx_packets,
@@ -832,7 +837,9 @@ static ssize_t iwl3945_sta_dbgfs_stats_t
 				lq_sta->win[j].success_counter,
 				lq_sta->win[j].success_ratio);
 	}
-	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	kfree(buff);
+	return ret;
 }
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2474,12 +2474,17 @@ static ssize_t rs_sta_dbgfs_scale_table_
 static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
 {
-	char buff[1024];
+	char *buff;
 	int desc = 0;
 	int i = 0;
+	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
 
+	buff = kmalloc(1024, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
 	desc += sprintf(buff+desc, "sta_id %d\n", lq_sta->lq.sta_id);
 	desc += sprintf(buff+desc, "failed=%d success=%d rate=0%X\n",
 			lq_sta->total_failed, lq_sta->total_success,
@@ -2511,7 +2516,9 @@ static ssize_t rs_sta_dbgfs_scale_table_
 		desc += sprintf(buff+desc, " rate[%d] 0x%X\n",
 			i, le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
 
-	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	kfree(buff);
+	return ret;
 }
 
 static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
@@ -2522,11 +2529,17 @@ static const struct file_operations rs_s
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
 {
-	char buff[1024];
+	char *buff;
 	int desc = 0;
 	int i, j;
+	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
+
+	buff = kmalloc(1024, GFP_KERNEL);
+	if (!buff)
+		return -ENOMEM;
+
 	for (i = 0; i < LQ_SIZE; i++) {
 		desc += sprintf(buff+desc, "%s type=%d SGI=%d FAT=%d DUP=%d\n"
 				"rate=0x%X\n",
@@ -2544,7 +2557,9 @@ static ssize_t rs_sta_dbgfs_stats_table_
 				lq_sta->lq_info[i].win[j].success_ratio);
 		}
 	}
-	return simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
+	kfree(buff);
+	return ret;
 }
 
 static const struct file_operations rs_sta_dbgfs_stats_table_ops = {


