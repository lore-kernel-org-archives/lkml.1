Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522Ab0BPWpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 17:45:52 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50923 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab0BPWpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 17:45:39 -0500
From: Serge Hallyn <serue@us.ibm.com>
To: serue@us.ibm.com
Cc: Greg KH <greg@kroah.com>, rsc@swtch.com,
       Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>
Subject: [PATCH 7/8] p9auth: add cap_node timeout
Date: Tue, 16 Feb 2010 16:45:00 -0600
Message-Id: <1266360301-30081-7-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Mark each caphash entry with the current time.  When a new caphash is
added, any entries which were added more than two minutes ago are
discarded.

We may want to make two minutes configurable, or may want to also
discard entries if more than N entries are on the list (to prevent
a forced OOM by a misbehaving privileged process).  The purpose
of this patch is only to prevent gradually consuming more and more
memory due to "legitimate" unused entries.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
cc: rsc@swtch.com
Cc: Ashwin Ganti <ashwin.ganti@gmail.com>
Cc: ericvh@gmail.com
Cc: devel@linuxdriverproject.org
Cc: linux-kernel@vger.kernel.org
Cc: Ron Minnich <rminnich@gmail.com>
---
 drivers/staging/p9auth/p9auth.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/p9auth/p9auth.c b/drivers/staging/p9auth/p9auth.c
index e94c4fe..6012bd9 100644
--- a/drivers/staging/p9auth/p9auth.c
+++ b/drivers/staging/p9auth/p9auth.c
@@ -40,6 +40,7 @@
 
 struct cap_node {
 	char data[CAP_NODE_SIZE];
+	unsigned long time_created;
 	struct list_head list;
 };
 
@@ -275,6 +276,23 @@ static int grant_id(struct id_set *set)
 	return ret;
 }
 
+/* Expose this through sysctl eventually?  2 min timeout for hashes */
+
+static int cap_timeout = 120;
+static void remove_old_entries(struct cap_dev *dev)
+{
+	struct cap_node *node, *tmp;
+
+	if (dev->head == NULL)
+		return;
+	list_for_each_entry_safe(node, tmp, &dev->head->list, list) {
+		if (node->time_created + HZ * cap_timeout < jiffies) {
+			list_del(&node->list);
+			kfree(node);
+		}
+	}
+}
+
 static int add_caphash_entry(struct cap_dev *dev, char *user_buf, size_t count)
 {
 	struct cap_node *node_ptr;
@@ -290,7 +308,9 @@ static int add_caphash_entry(struct cap_dev *dev, char *user_buf, size_t count)
 	printk(KERN_INFO "Capability being written to /dev/caphash : \n");
 	hexdump(user_buf, count);
 	memcpy(node_ptr->data, user_buf, count);
+	node_ptr->time_created = jiffies;
 	list_add(&(node_ptr->list), &(dev->head->list));
+	remove_old_entries(dev);
 
 	return 0;
 }
-- 
1.6.1

