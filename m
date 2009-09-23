Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbZIWMZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbZIWMZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZIWMZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZIWMZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:25:27 -0400
Subject: [RFC] VFS: Export dquot_send_warning
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 23 Sep 2009 13:25:20 +0100
Message-Id: <1253708720.6052.289.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It would be useful to have a generic method of sending quota messages
to userspace. The dquot code has such a method, but it can only currently
be used by that code, so I'm wondering whether there would be any objections
to exporting it so that other (non-dquot) filesystems could use it?

My proposed (first draft) patch is below,

Steve.

------------------------------------------------------------------------
>From 77e4ac5ef6311073e59e6abb34e0ff53df684bd2 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Wed, 16 Sep 2009 18:16:11 +0100
Subject: VFS: Export dquot_send_warning

Sending a message to userspace in a generic format to warn
of events (e.g. quota exceeded) in the quota subsystem is
a generically useful feature. This patch makes some minor
changes to the send_message function in dquot.c renaming
it dquot_send_message and exporting it for use by filesystems
which do not use the dquot quota code.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/quota/dquot.c      |   45 ++++++++++++++++++++++++++++++---------------
 include/linux/quota.h |   11 +++++++++++
 2 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 38f7bd5..4ced204 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1082,8 +1082,21 @@ static struct genl_family quota_genl_family = {
 	.maxattr = QUOTA_NL_A_MAX,
 };
 
-/* Send warning to userspace about user which exceeded quota */
-static void send_warning(const struct dquot *dquot, const char warntype)
+/**
+ * dquot_send_warning - Send warning to userspace about exceeded quota
+ * @type: The quota type: USRQQUOTA, GRPQUOTA,...
+ * @id: The user or group id of the quota that was exceeded
+ * @dev: The device on which the fs is mounted (sb->s_dev)
+ * @warntype: The type of the warning: QUOTA_NL_...
+ *
+ * This can be used by filesystems (including those which don't use
+ * other parts of dquot) to send a message to userspace relating to
+ * quota limits.
+ *
+ */
+
+void dquot_send_warning(short type, unsigned int id, dev_t dev,
+			const char warntype)
 {
 	static atomic_t seq;
 	struct sk_buff *skb;
@@ -1108,21 +1121,19 @@ static void send_warning(const struct dquot *dquot, const char warntype)
 		  "VFS: Cannot store netlink header in quota warning.\n");
 		goto err_out;
 	}
-	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, dquot->dq_type);
+	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, type);
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, dquot->dq_id);
+	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, id);
 	if (ret)
 		goto attr_err_out;
 	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR,
-		MAJOR(dquot->dq_sb->s_dev));
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR, MAJOR(dev));
 	if (ret)
 		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR,
-		MINOR(dquot->dq_sb->s_dev));
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR, MINOR(dev));
 	if (ret)
 		goto attr_err_out;
 	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
@@ -1137,6 +1148,8 @@ attr_err_out:
 err_out:
 	kfree_skb(skb);
 }
+EXPORT_SYMBOL(dquot_send_warning);
+
 #endif
 /*
  * Write warnings to the console and send warning messages over netlink.
@@ -1145,18 +1158,20 @@ err_out:
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
+			dquot_send_warning(dq->dq_type, dq->dq_id,
+					   dq->dq_sb->s_dev, warntype[i]);
 		}
+	}
 }
 
 static int ignore_hardlimit(struct dquot *dquot)
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 78c4889..c2a13dc 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -376,6 +376,17 @@ static inline unsigned int dquot_generic_flag(unsigned int flags, int type)
 	return flags >> _DQUOT_STATE_FLAGS;
 }
 
+#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
+extern void dquot_send_warning(short type, unsigned int id, dev_t dev,
+			       const char warntype);
+#else
+static inline void dquot_send_warning(short type, unsigned int id, dev_t dev,
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



