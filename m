Return-Path: <linux-kernel-owner+w=401wt.eu-S934901AbXGRQoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934901AbXGRQoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762080AbXGRQoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:44:16 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:44698 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759125AbXGRQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:44:14 -0400
From: "Paul Moore" <paul.moore@hp.com>
Message-Id: <20070718163456.263156642@hp.com>
References: <20070718162844.912864704@hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 18 Jul 2007 12:28:45 -0400
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, torvalds@linux-foundation.org,
       michal.k.k.piotrowski@gmail.com, Paul Moore <paul.moore@hp.com>
Subject: [PATCH v3 1/2] NetLabel: enable dynamic activation/deactivation of NetLabel/SELinux enforcement
Content-Disposition: inline; filename=netlabel-runtime_enable
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new NetLabel KAPI interface, netlbl_enabled(), which reports on the
current runtime status of NetLabel based on the existing configuration.  LSMs
that make use of NetLabel, i.e. SELinux, can use this new function to determine
if they should perform NetLabel access checks.  This patch changes the
NetLabel/SELinux glue code such that SELinux only enforces NetLabel related
access checks when netlbl_enabled() returns true.

At present NetLabel is considered to be enabled when there is at least one
labeled protocol configuration present.  The result is that by default NetLabel
is considered to be disabled, however, as soon as an administrator configured
a CIPSO DOI definition NetLabel is enabled and SELinux starts enforcing
NetLabel related access controls - including unlabeled packet controls.

This patch also tries to consolidate the multiple "#ifdef CONFIG_NETLABEL"
blocks into a single block to ease future review as recommended by Linus.

Signed-off-by: Paul Moore <paul.moore@hp.com>
---
 include/net/netlabel.h           |   62 ++++++++++++++++---------------------
 net/netlabel/netlabel_cipso_v4.c |    5 +++
 net/netlabel/netlabel_kapi.c     |   21 ++++++++++++
 net/netlabel/netlabel_mgmt.c     |   65 +++++++++++++++++++++++++++++++++++++++
 net/netlabel/netlabel_mgmt.h     |    5 +++
 security/selinux/netlabel.c      |    8 ++++
 6 files changed, 131 insertions(+), 35 deletions(-)

Index: linux-2.6_netmsg_3/include/net/netlabel.h
===================================================================
--- linux-2.6_netmsg_3.orig/include/net/netlabel.h
+++ linux-2.6_netmsg_3/include/net/netlabel.h
@@ -144,10 +144,9 @@ struct netlbl_lsm_secattr {
 };
 
 /*
- * LSM security attribute operations
+ * LSM security attribute operations (inline)
  */
 
-
 /**
  * netlbl_secattr_cache_alloc - Allocate and initialize a secattr cache
  * @flags: the memory allocation flags
@@ -283,6 +282,9 @@ static inline void netlbl_secattr_free(s
 }
 
 #ifdef CONFIG_NETLABEL
+/*
+ * LSM security attribute operations
+ */
 int netlbl_secattr_catmap_walk(struct netlbl_lsm_secattr_catmap *catmap,
 			       u32 offset);
 int netlbl_secattr_catmap_walk_rng(struct netlbl_lsm_secattr_catmap *catmap,
@@ -294,6 +296,25 @@ int netlbl_secattr_catmap_setrng(struct 
 				 u32 start,
 				 u32 end,
 				 gfp_t flags);
+
+/*
+ * LSM protocol operations
+ */
+int netlbl_enabled(void);
+int netlbl_sock_setattr(struct sock *sk,
+			const struct netlbl_lsm_secattr *secattr);
+int netlbl_sock_getattr(struct sock *sk,
+			struct netlbl_lsm_secattr *secattr);
+int netlbl_skbuff_getattr(const struct sk_buff *skb,
+			  struct netlbl_lsm_secattr *secattr);
+void netlbl_skbuff_err(struct sk_buff *skb, int error);
+
+/*
+ * LSM label mapping cache operations
+ */
+void netlbl_cache_invalidate(void);
+int netlbl_cache_add(const struct sk_buff *skb,
+		     const struct netlbl_lsm_secattr *secattr);
 #else
 static inline int netlbl_secattr_catmap_walk(
 	                              struct netlbl_lsm_secattr_catmap *catmap,
@@ -301,14 +322,12 @@ static inline int netlbl_secattr_catmap_
 {
 	return -ENOENT;
 }
-
 static inline int netlbl_secattr_catmap_walk_rng(
 				      struct netlbl_lsm_secattr_catmap *catmap,
 				      u32 offset)
 {
 	return -ENOENT;
 }
-
 static inline int netlbl_secattr_catmap_setbit(
 	                              struct netlbl_lsm_secattr_catmap *catmap,
 				      u32 bit,
@@ -316,7 +335,6 @@ static inline int netlbl_secattr_catmap_
 {
 	return 0;
 }
-
 static inline int netlbl_secattr_catmap_setrng(
 	                              struct netlbl_lsm_secattr_catmap *catmap,
 				      u32 start,
@@ -325,59 +343,33 @@ static inline int netlbl_secattr_catmap_
 {
 	return 0;
 }
-#endif
-
-/*
- * LSM protocol operations
- */
-
-#ifdef CONFIG_NETLABEL
-int netlbl_sock_setattr(struct sock *sk,
-			const struct netlbl_lsm_secattr *secattr);
-int netlbl_sock_getattr(struct sock *sk,
-			struct netlbl_lsm_secattr *secattr);
-int netlbl_skbuff_getattr(const struct sk_buff *skb,
-			  struct netlbl_lsm_secattr *secattr);
-void netlbl_skbuff_err(struct sk_buff *skb, int error);
-#else
+static inline int netlbl_enabled(void)
+{
+	return 0;
+}
 static inline int netlbl_sock_setattr(struct sock *sk,
 				     const struct netlbl_lsm_secattr *secattr)
 {
 	return -ENOSYS;
 }
-
 static inline int netlbl_sock_getattr(struct sock *sk,
 				      struct netlbl_lsm_secattr *secattr)
 {
 	return -ENOSYS;
 }
-
 static inline int netlbl_skbuff_getattr(const struct sk_buff *skb,
 					struct netlbl_lsm_secattr *secattr)
 {
 	return -ENOSYS;
 }
-
 static inline void netlbl_skbuff_err(struct sk_buff *skb, int error)
 {
 	return;
 }
-#endif /* CONFIG_NETLABEL */
-
-/*
- * LSM label mapping cache operations
- */
-
-#ifdef CONFIG_NETLABEL
-void netlbl_cache_invalidate(void);
-int netlbl_cache_add(const struct sk_buff *skb,
-		     const struct netlbl_lsm_secattr *secattr);
-#else
 static inline void netlbl_cache_invalidate(void)
 {
 	return;
 }
-
 static inline int netlbl_cache_add(const struct sk_buff *skb,
 				   const struct netlbl_lsm_secattr *secattr)
 {
Index: linux-2.6_netmsg_3/net/netlabel/netlabel_cipso_v4.c
===================================================================
--- linux-2.6_netmsg_3.orig/net/netlabel/netlabel_cipso_v4.c
+++ linux-2.6_netmsg_3/net/netlabel/netlabel_cipso_v4.c
@@ -41,6 +41,7 @@
 
 #include "netlabel_user.h"
 #include "netlabel_cipso_v4.h"
+#include "netlabel_mgmt.h"
 
 /* Argument struct for cipso_v4_doi_walk() */
 struct netlbl_cipsov4_doiwalk_arg {
@@ -419,6 +420,8 @@ static int netlbl_cipsov4_add(struct sk_
 		ret_val = netlbl_cipsov4_add_pass(info);
 		break;
 	}
+	if (ret_val == 0)
+		netlbl_mgmt_protocount_inc();
 
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_CIPSOV4_ADD,
 					      &audit_info);
@@ -694,6 +697,8 @@ static int netlbl_cipsov4_remove(struct 
 	ret_val = cipso_v4_doi_remove(doi,
 				      &audit_info,
 				      netlbl_cipsov4_doi_free);
+	if (ret_val == 0)
+		netlbl_mgmt_protocount_dec();
 
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_CIPSOV4_DEL,
 					      &audit_info);
Index: linux-2.6_netmsg_3/net/netlabel/netlabel_kapi.c
===================================================================
--- linux-2.6_netmsg_3.orig/net/netlabel/netlabel_kapi.c
+++ linux-2.6_netmsg_3/net/netlabel/netlabel_kapi.c
@@ -38,6 +38,7 @@
 #include "netlabel_domainhash.h"
 #include "netlabel_unlabeled.h"
 #include "netlabel_user.h"
+#include "netlabel_mgmt.h"
 
 /*
  * Security Attribute Functions
@@ -245,6 +246,26 @@ int netlbl_secattr_catmap_setrng(struct 
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
+	/* At some point we probably want to expose this mechanism to the user
+	 * as well so that admins can toggle NetLabel regardless of the
+	 * configuration */
+	return (netlbl_mgmt_protocount_value() > 0 ? 1 : 0);
+}
+
+/**
  * netlbl_socket_setattr - Label a socket using the correct protocol
  * @sk: the socket to label
  * @secattr: the security attributes
Index: linux-2.6_netmsg_3/net/netlabel/netlabel_mgmt.c
===================================================================
--- linux-2.6_netmsg_3.orig/net/netlabel/netlabel_mgmt.c
+++ linux-2.6_netmsg_3/net/netlabel/netlabel_mgmt.c
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
@@ -67,6 +71,67 @@ static const struct nla_policy netlbl_mg
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
 
Index: linux-2.6_netmsg_3/net/netlabel/netlabel_mgmt.h
===================================================================
--- linux-2.6_netmsg_3.orig/net/netlabel/netlabel_mgmt.h
+++ linux-2.6_netmsg_3/net/netlabel/netlabel_mgmt.h
@@ -168,4 +168,9 @@ enum {
 /* NetLabel protocol functions */
 int netlbl_mgmt_genl_init(void);
 
+/* NetLabel misc management functions */
+void netlbl_mgmt_protocount_inc(void);
+void netlbl_mgmt_protocount_dec(void);
+u32 netlbl_mgmt_protocount_value(void);
+
 #endif
Index: linux-2.6_netmsg_3/security/selinux/netlabel.c
===================================================================
--- linux-2.6_netmsg_3.orig/security/selinux/netlabel.c
+++ linux-2.6_netmsg_3/security/selinux/netlabel.c
@@ -155,6 +155,11 @@ int selinux_netlbl_skbuff_getsid(struct 
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
@@ -298,6 +303,9 @@ int selinux_netlbl_sock_rcv_skb(struct s
 	u32 netlbl_sid;
 	u32 recv_perm;
 
+	if (!netlbl_enabled())
+		return 0;
+
 	rc = selinux_netlbl_skbuff_getsid(skb,
 					  SECINITSID_UNLABELED,
 					  &netlbl_sid);

-- 
paul moore
linux security @ hp
