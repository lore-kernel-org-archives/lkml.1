Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0CBCOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 21:14:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57919
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771Ab0CBCN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 21:13:58 -0500
Date: Mon, 01 Mar 2010 18:14:15 -0800 (PST)
Message-Id: <20100301.181415.266447389.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: randy.dunlap@oracle.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for March 1 (bluetooth/hci_sysfs)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100302121526.36a1ea88.sfr@canb.auug.org.au>
References: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
	<4B8C2CC5.8000603@oracle.com>
	<20100302121526.36a1ea88.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 2 Mar 2010 12:15:26 +1100

> Hi Randy,
> 
> On Mon, 01 Mar 2010 13:08:21 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>> static ssize_t inquiry_cache_read(struct file *file, char __user *userbuf,
>> 						size_t count, loff_t *ppos)
>> {
>> 	struct hci_dev *hdev = file->private_data;
>> 	struct inquiry_cache *cache = &hdev->inq_cache;
>> 	struct inquiry_entry *e;
>> 	char buf[4096]; // <<<<<<<<<<<<<<<<<<<<<<<<<<< huh? don't do that on stack.
>> 	int n = 0;
> 
> Dave Miller is following up on that.

This looks like a job for.... SEQ FILE! :-)

I'm testing the following fix.

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 1a79a6c..f02c2ff 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -405,44 +406,85 @@ static struct device_type bt_host = {
 	.release = bt_host_release,
 };
 
-static int inquiry_cache_open(struct inode *inode, struct file *file)
+static int inquiry_cache_show(struct seq_file *m, void *v)
 {
-	file->private_data = inode->i_private;
+	struct inquiry_entry *e = v;
+	struct inquiry_data *data;
+	bdaddr_t bdaddr;
+
+	data = &e->data;
+	baswap(&bdaddr, &data->bdaddr);
+
+	seq_printf(m, "%s %d %d %d 0x%.2x%.2x%.2x 0x%.4x %d %d %u\n",
+		   batostr(&bdaddr),
+		   data->pscan_rep_mode, data->pscan_period_mode,
+		   data->pscan_mode, data->dev_class[2],
+		   data->dev_class[1], data->dev_class[0],
+		   __le16_to_cpu(data->clock_offset),
+		   data->rssi, data->ssp_mode, e->timestamp);
+
 	return 0;
 }
 
-static ssize_t inquiry_cache_read(struct file *file, char __user *userbuf,
-						size_t count, loff_t *ppos)
+static void *inquiry_cache_get_idx(struct hci_dev *hdev, loff_t pos)
 {
-	struct hci_dev *hdev = file->private_data;
 	struct inquiry_cache *cache = &hdev->inq_cache;
-	struct inquiry_entry *e;
-	char buf[4096];
-	int n = 0;
+	struct inquiry_entry *e = cache->list;
+
+	while (e && pos) {
+		e = e->next;
+		pos--;
+	}
+	return e;
+}
+
+static void *inquiry_cache_start(struct seq_file *m, loff_t *pos)
+{
+	struct hci_dev *hdev = m->private;
 
 	hci_dev_lock_bh(hdev);
 
-	for (e = cache->list; e; e = e->next) {
-		struct inquiry_data *data = &e->data;
-		bdaddr_t bdaddr;
-		baswap(&bdaddr, &data->bdaddr);
-		n += sprintf(buf + n, "%s %d %d %d 0x%.2x%.2x%.2x 0x%.4x %d %d %u\n",
-				batostr(&bdaddr),
-				data->pscan_rep_mode, data->pscan_period_mode,
-				data->pscan_mode, data->dev_class[2],
-				data->dev_class[1], data->dev_class[0],
-				__le16_to_cpu(data->clock_offset),
-				data->rssi, data->ssp_mode, e->timestamp);
-	}
+	return inquiry_cache_get_idx(hdev, *pos);
+}
+
+static void *inquiry_cache_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct inquiry_entry *e = v;
+
+	++*pos;
+	return e->next;
+}
+
+static void inquiry_cache_stop(struct seq_file *m, void *v)
+{
+	struct hci_dev *hdev = m->private;
 
 	hci_dev_unlock_bh(hdev);
+}
 
-	return simple_read_from_buffer(userbuf, count, ppos, buf, n);
+static const struct seq_operations inquiry_cache_ops = {
+	.start	= inquiry_cache_start,
+	.next	= inquiry_cache_next,
+	.stop	= inquiry_cache_stop,
+	.show	= inquiry_cache_show,
+};
+
+static int inquiry_cache_open(struct inode *inode, struct file *file)
+{
+	int rc = seq_open(file, &inquiry_cache_ops);
+
+	if (rc >= 0) {
+		struct seq_file *m = file->private_data;
+		m->private = inode->i_private;
+	}
+	return rc;
 }
 
 static const struct file_operations inquiry_cache_fops = {
-	.open = inquiry_cache_open,
-	.read = inquiry_cache_read,
+	.open		= inquiry_cache_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
 };
 
 int hci_register_sysfs(struct hci_dev *hdev)
