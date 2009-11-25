Return-Path: <linux-kernel-owner+w=401wt.eu-S964914AbZKYN2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964914AbZKYN2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964876AbZKYN2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964897AbZKYN2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:35 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/30] VFS: Export dquot_send_warning
Date: Wed, 25 Nov 2009 14:22:45 +0000
Message-Id: <1259158975-28499-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-11-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-12-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-13-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-14-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-15-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-16-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-17-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-18-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-19-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-20-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sending a message to userspace in a generic format to warn
of events (e.g. quota exceeded) in the quota subsystem is
a generically useful feature. This patch makes some minor
changes to the send_message function from dquot.c renaming
it quota_send_message, moving it to quota.c and exporting it
for use by filesystems which do not use the dquot code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/quota/Kconfig      |    2 +-
 fs/quota/dquot.c      |   93 +++++--------------------------------------------
 fs/quota/quota.c      |   93 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/quota.h |   11 ++++++
 4 files changed, 114 insertions(+), 85 deletions(-)

diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
index 8047e01..353e78a 100644
--- a/fs/quota/Kconfig
+++ b/fs/quota/Kconfig
@@ -17,7 +17,7 @@ config QUOTA
 
 config QUOTA_NETLINK_INTERFACE
 	bool "Report quota messages through netlink interface"
-	depends on QUOTA && NET
+	depends on QUOTACTL && NET
 	help
 	  If you say Y here, quota warnings (about exceeding softlimit, reaching
 	  hardlimit, etc.) will be reported through netlink interface. If unsure,
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 39b49c4..9b6ad90 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -77,10 +77,6 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/writeback.h> /* for inode_lock, oddly enough.. */
-#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
-#include <net/netlink.h>
-#include <net/genetlink.h>
-#endif
 
 #include <asm/uaccess.h>
 
@@ -1071,73 +1067,6 @@ static void print_warning(struct dquot *dquot, const int warntype)
 }
 #endif
 
-#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
-
-/* Netlink family structure for quota */
-static struct genl_family quota_genl_family = {
-	.id = GENL_ID_GENERATE,
-	.hdrsize = 0,
-	.name = "VFS_DQUOT",
-	.version = 1,
-	.maxattr = QUOTA_NL_A_MAX,
-};
-
-/* Send warning to userspace about user which exceeded quota */
-static void send_warning(const struct dquot *dquot, const char warntype)
-{
-	static atomic_t seq;
-	struct sk_buff *skb;
-	void *msg_head;
-	int ret;
-	int msg_size = 4 * nla_total_size(sizeof(u32)) +
-		       2 * nla_total_size(sizeof(u64));
-
-	/* We have to allocate using GFP_NOFS as we are called from a
-	 * filesystem performing write and thus further recursion into
-	 * the fs to free some data could cause deadlocks. */
-	skb = genlmsg_new(msg_size, GFP_NOFS);
-	if (!skb) {
-		printk(KERN_ERR
-		  "VFS: Not enough memory to send quota warning.\n");
-		return;
-	}
-	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
-			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
-	if (!msg_head) {
-		printk(KERN_ERR
-		  "VFS: Cannot store netlink header in quota warning.\n");
-		goto err_out;
-	}
-	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, dquot->dq_type);
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, dquot->dq_id);
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR,
-		MAJOR(dquot->dq_sb->s_dev));
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR,
-		MINOR(dquot->dq_sb->s_dev));
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
-	if (ret)
-		goto attr_err_out;
-	genlmsg_end(skb, msg_head);
-
-	genlmsg_multicast(skb, 0, quota_genl_family.id, GFP_NOFS);
-	return;
-attr_err_out:
-	printk(KERN_ERR "VFS: Not enough space to compose quota message!\n");
-err_out:
-	kfree_skb(skb);
-}
-#endif
 /*
  * Write warnings to the console and send warning messages over netlink.
  *
@@ -1145,18 +1074,20 @@ err_out:
  */
 static void flush_warnings(struct dquot *const *dquots, char *warntype)
 {
+	struct dquot *dq;
 	int i;
 
-	for (i = 0; i < MAXQUOTAS; i++)
-		if (dquots[i] && warntype[i] != QUOTA_NL_NOWARN &&
-		    !warning_issued(dquots[i], warntype[i])) {
+	for (i = 0; i < MAXQUOTAS; i++) {
+		dq = dquots[i];
+		if (dq && warntype[i] != QUOTA_NL_NOWARN &&
+		    !warning_issued(dq, warntype[i])) {
 #ifdef CONFIG_PRINT_QUOTA_WARNING
-			print_warning(dquots[i], warntype[i]);
-#endif
-#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
-			send_warning(dquots[i], warntype[i]);
+			print_warning(dq, warntype[i]);
 #endif
+			quota_send_warning(dq->dq_type, dq->dq_id,
+					   dq->dq_sb->s_dev, warntype[i]);
 		}
+	}
 }
 
 static int ignore_hardlimit(struct dquot *dquot)
@@ -2607,12 +2538,6 @@ static int __init dquot_init(void)
 
 	register_shrinker(&dqcache_shrinker);
 
-#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
-	if (genl_register_family(&quota_genl_family) != 0)
-		printk(KERN_ERR
-		       "VFS: Failed to create quota netlink interface.\n");
-#endif
-
 	return 0;
 }
 module_init(dquot_init);
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 95c5b42..ee91e27 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -18,6 +18,8 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/types.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
 
 /* Check validity of generic quotactl commands */
 static int generic_quotactl_valid(struct super_block *sb, int type, int cmd,
@@ -525,3 +527,94 @@ asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
 	return ret;
 }
 #endif
+
+
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+
+/* Netlink family structure for quota */
+static struct genl_family quota_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "VFS_DQUOT",
+	.version = 1,
+	.maxattr = QUOTA_NL_A_MAX,
+};
+
+/**
+ * quota_send_warning - Send warning to userspace about exceeded quota
+ * @type: The quota type: USRQQUOTA, GRPQUOTA,...
+ * @id: The user or group id of the quota that was exceeded
+ * @dev: The device on which the fs is mounted (sb->s_dev)
+ * @warntype: The type of the warning: QUOTA_NL_...
+ *
+ * This can be used by filesystems (including those which don't use
+ * dquot) to send a message to userspace relating to quota limits.
+ *
+ */
+
+void quota_send_warning(short type, unsigned int id, dev_t dev,
+			const char warntype)
+{
+	static atomic_t seq;
+	struct sk_buff *skb;
+	void *msg_head;
+	int ret;
+	int msg_size = 4 * nla_total_size(sizeof(u32)) +
+		       2 * nla_total_size(sizeof(u64));
+
+	/* We have to allocate using GFP_NOFS as we are called from a
+	 * filesystem performing write and thus further recursion into
+	 * the fs to free some data could cause deadlocks. */
+	skb = genlmsg_new(msg_size, GFP_NOFS);
+	if (!skb) {
+		printk(KERN_ERR
+		  "VFS: Not enough memory to send quota warning.\n");
+		return;
+	}
+	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
+	if (!msg_head) {
+		printk(KERN_ERR
+		  "VFS: Cannot store netlink header in quota warning.\n");
+		goto err_out;
+	}
+	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, type);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, id);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR, MAJOR(dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR, MINOR(dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
+	if (ret)
+		goto attr_err_out;
+	genlmsg_end(skb, msg_head);
+
+	genlmsg_multicast(skb, 0, quota_genl_family.id, GFP_NOFS);
+	return;
+attr_err_out:
+	printk(KERN_ERR "VFS: Not enough space to compose quota message!\n");
+err_out:
+	kfree_skb(skb);
+}
+EXPORT_SYMBOL(quota_send_warning);
+
+static int __init quota_init(void)
+{
+	if (genl_register_family(&quota_genl_family) != 0)
+		printk(KERN_ERR
+		       "VFS: Failed to create quota netlink interface.\n");
+	return 0;
+};
+
+module_init(quota_init);
+#endif
+
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 78c4889..ce9a9b2 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -376,6 +376,17 @@ static inline unsigned int dquot_generic_flag(unsigned int flags, int type)
 	return flags >> _DQUOT_STATE_FLAGS;
 }
 
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+extern void quota_send_warning(short type, unsigned int id, dev_t dev,
+			       const char warntype);
+#else
+static inline void quota_send_warning(short type, unsigned int id, dev_t dev,
+				      const char warntype)
+{
+	return;
+}
+#endif /* CONFIG_QUOTA_NETLINK_INTERFACE */
+
 struct quota_info {
 	unsigned int flags;			/* Flags for diskquotas on this device */
 	struct mutex dqio_mutex;		/* lock device while I/O in progress */
-- 
1.6.2.5

