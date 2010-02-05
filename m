Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0BEUvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:51:07 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36811 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755802Ab0BEUup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:50:45 -0500
Date: Fri, 5 Feb 2010 23:50:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, Michal Simek <monstr@monstr.eu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       devicetree-discuss@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 2/3] of: Introduce safe accessors for node->data
Message-ID: <20100205205043.GB4178@oksana.dev.rtsoft.ru>
References: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100205204949.GA2575@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform code use node->data to store some private information
associated with a node.

Previously there was no need for any locks and accessors since we were
initializing the data mostly at boot time and never modified it later.

Though, nowadays OF GPIO infrastructure supports GPIO chips detaching,
so to handle this correctly we have to introduce locking for the
node->data field.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/of/base.c  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h |    5 +++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 716d439..41ed6ba 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -36,8 +36,53 @@ void of_node_init(struct device_node *np)
 {
 	memset(np, 0, sizeof(*np));
 	kref_init(&np->kref);
+	spin_lock_init(&np->data_lock);
 }
 
+/**
+ *	of_node_set_data - Try to set node->data
+ *	@node:	Node
+ *	@data:	Data
+ *
+ *	This function tries to safely set node->data. Returns 0 on success,
+ *	-EBUSY if node->data was already set.
+ */
+int of_node_set_data(struct device_node *np, void *data)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&np->data_lock, flags);
+	if (np->data)
+		ret = -EBUSY;
+	else
+		np->data = data;
+	spin_unlock_irqrestore(&np->data_lock, flags);
+
+	if (!ret)
+		of_node_get(np);
+
+	return ret;
+}
+EXPORT_SYMBOL(of_node_set_data);
+
+/**
+ *	of_node_release_data_unlocked - Release node->data
+ *	@node:	Node
+ *
+ *	This function releases node->data, so that others could set it.
+ *
+ *	This function doesn't grab any locks, so that a caller can grab the
+ *	lock itself, atomically read the data and decide if it wants to
+ *	release it.
+ */
+void of_node_release_data_unlocked(struct device_node *np)
+{
+	np->data = NULL;
+	of_node_put(np);
+}
+EXPORT_SYMBOL(of_node_release_data_unlocked);
+
 int of_n_addr_cells(struct device_node *np)
 {
 	const int *ip;
diff --git a/include/linux/of.h b/include/linux/of.h
index 717d690..c573ee2 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/kref.h>
+#include <linux/spinlock.h>
 #include <linux/mod_devicetable.h>
 
 typedef u32 phandle;
@@ -56,6 +57,7 @@ struct device_node {
 	struct	kref kref;
 	unsigned long _flags;
 	void	*data;
+	spinlock_t data_lock;
 #if defined(CONFIG_SPARC)
 	char	*path_component_name;
 	unsigned int unique_id;
@@ -65,6 +67,9 @@ struct device_node {
 
 extern void of_node_init(struct device_node *np);
 
+extern int of_node_set_data(struct device_node *np, void *data);
+extern void of_node_release_data_unlocked(struct device_node *np);
+
 static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
 {
 	return test_bit(flag, &n->_flags);
-- 
1.6.5.7

