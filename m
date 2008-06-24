Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbYFXIkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbYFXIkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYFXIjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:39:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57704 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYFXIjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:39:53 -0400
Message-ID: <4860B279.9070105@cn.fujitsu.com>
Date: Tue, 24 Jun 2008 16:38:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2] CONNECTOR: add a proc entry to list connectors
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a problem when I wanted to check if the kernel supports process
event connector, and It seems there's no way to do this check.

At best I can check if the kernel supports connector or not, by looking
into /proc/net/netlink, or maybe checking the return value of bind() to
see if it's ENOENT.

So it would be useful to add /proc/net/connector to list all supported
connectors:
 # cat /proc/net/connector
 Name            ID
 connector       4294967295:4294967295
 cn_proc         1:1
 w1              3:1

Changelog:
- fix memory leak: s/seq_release/single_release
- use spin_lock_bh instead of spin_lock_irqsave

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/connector/connector.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 85e2ba7..bf48300 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -27,6 +27,8 @@
 #include <linux/moduleparam.h>
 #include <linux/connector.h>
 #include <linux/mutex.h>
+#include <linux/proc_fs.h>
+#include <linux/spinlock.h>
 
 #include <net/sock.h>
 
@@ -403,6 +405,40 @@ static void cn_callback(void *data)
 	mutex_unlock(&notify_lock);
 }
 
+static int cn_proc_show(struct seq_file *m, void *v)
+{
+	struct cn_queue_dev *dev = cdev.cbdev;
+	struct cn_callback_entry *cbq;
+
+	seq_printf(m, "Name            ID\n");
+
+	spin_lock_bh(&dev->queue_lock);
+
+	list_for_each_entry(cbq, &dev->queue_list, callback_entry) {
+		seq_printf(m, "%-15s %u:%u\n",
+			   cbq->id.name,
+			   cbq->id.id.idx,
+			   cbq->id.id.val);
+	}
+
+	spin_unlock_bh(&dev->queue_lock);
+
+	return 0;
+}
+
+static int cn_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, cn_proc_show, NULL);
+}
+
+static const struct file_operations cn_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = cn_proc_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release
+};
+
 static int __devinit cn_init(void)
 {
 	struct cn_dev *dev = &cdev;
@@ -434,6 +470,8 @@ static int __devinit cn_init(void)
 		return -EINVAL;
 	}
 
+	proc_net_fops_create(&init_net, "connector", S_IRUGO, &cn_file_ops);
+
 	return 0;
 }
 
@@ -443,6 +481,8 @@ static void __devexit cn_fini(void)
 
 	cn_already_initialized = 0;
 
+	proc_net_remove(&init_net, "connector");
+
 	cn_del_callback(&dev->id);
 	cn_queue_free_dev(dev->cbdev);
 	netlink_kernel_release(dev->nls);
-- 
1.5.4.rc3
