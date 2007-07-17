Return-Path: <linux-kernel-owner+w=401wt.eu-S937269AbXGQXtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937269AbXGQXtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbXGQXtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:49:04 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:50324 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbXGQXtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:49:01 -0400
Date: Tue, 17 Jul 2007 19:48:58 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com
Subject: [PATCH 1/2] SELinux: enable dynamic activation/deactivation of
 NetLabel/SELinux enforcement
In-Reply-To: <Line.LNX.4.64.0707171945430.10858@d.namei>
Message-ID: <Line.LNX.4.64.0707171948170.10858@d.namei>
References: <Line.LNX.4.64.0707171945430.10858@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>

Create a new NetLabel KAPI interface, netlbl_enabled(), which reports on 
the current runtime status of NetLabel based on the existing 
configuration.  LSMs that make use of NetLabel, i.e. SELinux, can use this 
new function to determine if they should perform NetLabel access checks.  
This patch changes the NetLabel/SELinux glue code such that SELinux only 
enforces NetLabel related access checks when netlbl_enabled() returns 
true.

At present NetLabel is considered to be enabled when there is at least one 
labeled protocol configuration present.  The result is that by default 
NetLabel is considered to be disabled, however, as soon as an 
administrator configured a CIPSO DOI definition NetLabel is enabled and 
SELinux starts enforcing NetLabel related access controls - including 
unlabeled packet controls.

This patch should resolve the issue reported by Michal Piotrowski here:

 * http://lkml.org/lkml/2007/7/12/362

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 include/net/netlabel.h           |    6 +++
 net/netlabel/netlabel_cipso_v4.c |    5 +++
 net/netlabel/netlabel_kapi.c     |   21 ++++++++++++
 net/netlabel/netlabel_mgmt.c     |   65 ++++++++++++++++++++++++++++++++++++++
 net/netlabel/netlabel_mgmt.h     |    5 +++
 security/selinux/netlabel.c      |    8 +++++
 6 files changed, 110 insertions(+), 0 deletions(-)

diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 9b7d6f2..5d2bcad 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -332,6 +332,7 @@ static inline int netlbl_secattr_catmap_setrng(
  */
 
 #ifdef CONFIG_NETLABEL
+int netlbl_enabled(void);
 int netlbl_sock_setattr(struct sock *sk,
 			const struct netlbl_lsm_secattr *secattr);
 int netlbl_sock_getattr(struct sock *sk,
@@ -340,6 +341,11 @@ int netlbl_skbuff_getattr(const struct sk_buff *skb,
 			  struct netlbl_lsm_secattr *secattr);
 void netlbl_skbuff_err(struct sk_buff *skb, int error);
 #else
+int netlbl_enabled(void)
+{
+	return 0;
+}
+
 static inline int netlbl_sock_setattr(struct sock *sk,
 				     const struct netlbl_lsm_secattr *secattr)
 {
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index 24b660f..c060e3f 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -41,6 +41,7 @@
 
 #include "netlabel_user.h"
 #include "netlabel_cipso_v4.h"
+#include "netlabel_mgmt.h"
 
 /* Argument struct for cipso_v4_doi_walk() */
 struct netlbl_cipsov4_doiwalk_arg {
@@ -419,6 +420,8 @@ static int netlbl_cipsov4_add(struct sk_buff *skb, struct genl_info *info)
 		ret_val = netlbl_cipsov4_add_pass(info);
 		break;
 	}
+	if (ret_val == 0)
+		netlbl_mgmt_protocount_inc();
 
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_CIPSOV4_ADD,
 					      &audit_info);
@@ -694,6 +697,8 @@ static int netlbl_cipsov4_remove(struct sk_buff *skb, struct genl_info *info)
 	ret_val = cipso_v4_doi_remove(doi,
 				      &audit_info,
 				      netlbl_cipsov4_doi_free);
+	if (ret_val == 0)
+		netlbl_mgmt_protocount_dec();
 
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_CIPSOV4_DEL,
 					      &audit_info);
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index b165712..50195e2 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -38,6 +38,7 @@
 #include "netlabel_domainhash.h"
 #include "netlabel_unlabeled.h"
 #include "netlabel_user.h"
+#include "netlabel_mgmt.h"
 
 /*
  * Security Attribute Functions
@@ -245,6 +246,26 @@ int netlbl_secattr_catmap_setrng(struct netlbl_lsm_secattr_catmap *catmap,
  */
 
 /**
+ * netlbl_enabled - Determine if the NetLabel subsystem is enabled
+ *
+ * Description:
+ * The LSM can use this function to determine if it should use NetLabel
+ * security attributes in it's enforcement mechanism.  Currently, NetLabel is
+ * considered to be enabled when it's configuration contains a valid setup for
+ * at least one labeled protocol (i.e. NetLabel can understand incoming
+ * labeled packets of at least one type); otherwise NetLabel is considered to
+ * be disabled.
+ *
+ */
+int netlbl_enabled(void)
+{
+	/* At some point we probably want to expose this mechanism to the
+	 * user as well so that admins can toggle NetLabel regardless of
+	 * the configuration */
+	return (netlbl_mgmt_protocount_value() > 0 ? 1 : 0);
+}
+
+/**
  * netlbl_socket_setattr - Label a socket using the correct protocol
  * @sk: the socket to label
  * @secattr: the security attributes
diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
index e00fc21..5315dac 100644
--- a/net/netlabel/netlabel_mgmt.c
+++ b/net/netlabel/netlabel_mgmt.c
@@ -42,6 +42,10 @@
 #include "netlabel_user.h"
 #include "netlabel_mgmt.h"
 
+/* NetLabel configured protocol count */
+static DEFINE_SPINLOCK(netlabel_mgmt_protocount_lock);
+static u32 netlabel_mgmt_protocount = 0;
+
 /* Argument struct for netlbl_domhsh_walk() */
 struct netlbl_domhsh_walk_arg {
 	struct netlink_callback *nl_cb;
@@ -67,6 +71,67 @@ static const struct nla_policy netlbl_mgmt_genl_policy[NLBL_MGMT_A_MAX + 1] = {
 };
 
 /*
+ * NetLabel Misc Managment Functions
+ */
+
+/**
+ * netlbl_mgmt_protocount_inc - Increment the configured labeled protocol count
+ *
+ * Description:
+ * Increment the number of labeled protocol configurations in the current
+ * NetLabel configuration.  Keep track of this for use in determining if
+ * NetLabel label enforcement should be active/enabled or not in the LSM.
+ *
+ */
+void netlbl_mgmt_protocount_inc(void)
+{
+	rcu_read_lock();
+	spin_lock(&netlabel_mgmt_protocount_lock);
+	netlabel_mgmt_protocount++;
+	spin_unlock(&netlabel_mgmt_protocount_lock);
+	rcu_read_unlock();
+}
+
+/**
+ * netlbl_mgmt_protocount_dec - Decrement the configured labeled protocol count
+ *
+ * Description:
+ * Decrement the number of labeled protocol configurations in the current
+ * NetLabel configuration.  Keep track of this for use in determining if
+ * NetLabel label enforcement should be active/enabled or not in the LSM.
+ *
+ */
+void netlbl_mgmt_protocount_dec(void)
+{
+	rcu_read_lock();
+	spin_lock(&netlabel_mgmt_protocount_lock);
+	if (netlabel_mgmt_protocount > 0)
+		netlabel_mgmt_protocount--;
+	spin_unlock(&netlabel_mgmt_protocount_lock);
+	rcu_read_unlock();
+}
+
+/**
+ * netlbl_mgmt_protocount_value - Return the number of configured protocols
+ *
+ * Description:
+ * Return the number of labeled protocols in the current NetLabel
+ * configuration.  This value is useful in  determining if NetLabel label
+ * enforcement should be active/enabled or not in the LSM.
+ *
+ */
+u32 netlbl_mgmt_protocount_value(void)
+{
+	u32 val;
+
+	rcu_read_lock();
+	val = netlabel_mgmt_protocount;
+	rcu_read_unlock();
+
+	return val;
+}
+
+/*
  * NetLabel Command Handlers
  */
 
diff --git a/net/netlabel/netlabel_mgmt.h b/net/netlabel/netlabel_mgmt.h
index 3642d3b..ccb2b39 100644
--- a/net/netlabel/netlabel_mgmt.h
+++ b/net/netlabel/netlabel_mgmt.h
@@ -168,4 +168,9 @@ enum {
 /* NetLabel protocol functions */
 int netlbl_mgmt_genl_init(void);
 
+/* NetLabel misc management functions */
+void netlbl_mgmt_protocount_inc(void);
+void netlbl_mgmt_protocount_dec(void);
+u32 netlbl_mgmt_protocount_value(void);
+
 #endif
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index e64eca2..ed9155b 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -155,6 +155,11 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb, u32 base_sid, u32 *sid)
 	int rc;
 	struct netlbl_lsm_secattr secattr;
 
+	if (!netlbl_enabled()) {
+		*sid = SECSID_NULL;
+		return 0;
+	}
+
 	netlbl_secattr_init(&secattr);
 	rc = netlbl_skbuff_getattr(skb, &secattr);
 	if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
@@ -298,6 +303,9 @@ int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
 	u32 netlbl_sid;
 	u32 recv_perm;
 
+	if (!netlbl_enabled())
+		return 0;
+
 	rc = selinux_netlbl_skbuff_getsid(skb,
 					  SECINITSID_UNLABELED,
 					  &netlbl_sid);
-- 
1.5.0.6

