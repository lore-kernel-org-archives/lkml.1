Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbXDZGFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbXDZGFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXDZGFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:05:22 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:35290 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbXDZGFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:05:18 -0400
Date: Thu, 26 Apr 2007 02:05:14 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 03/12] SELinux: extract the NetLabel SELinux support from
 the security server
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260204290.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>

Up until this patch the functions which have provided NetLabel support to
SELinux have been integrated into the SELinux security server, which for
various reasons is not really ideal.  This patch makes an effort to extract as
much of the NetLabel support from the security server as possibile and move it
into it's own file within the SELinux directory structure.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 net/netlabel/netlabel_kapi.c                |    3 -
 security/selinux/Makefile                   |    2 +
 security/selinux/include/security.h         |   24 ++
 security/selinux/include/selinux_netlabel.h |   71 +++---
 security/selinux/netlabel.c                 |  363 +++++++++++++++++++++++
 security/selinux/ss/services.c              |  423 ++++-----------------------
 6 files changed, 481 insertions(+), 405 deletions(-)
 create mode 100644 security/selinux/netlabel.c

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index e03a328..f2535e7 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -263,9 +263,6 @@ int netlbl_socket_setattr(const struct socket *sock,
 	int ret_val = -ENOENT;
 	struct netlbl_dom_map *dom_entry;
 
-	if ((secattr->flags & NETLBL_SECATTR_DOMAIN) == 0)
-		return -ENOENT;
-
 	rcu_read_lock();
 	dom_entry = netlbl_domhsh_getentry(secattr->domain);
 	if (dom_entry == NULL)
diff --git a/security/selinux/Makefile b/security/selinux/Makefile
index faf2e02..dc3502e 100644
--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -8,5 +8,7 @@ selinux-y := avc.o hooks.o selinuxfs.o netlink.o nlmsgtab.o netif.o exports.o
 
 selinux-$(CONFIG_SECURITY_NETWORK_XFRM) += xfrm.o
 
+selinux-$(CONFIG_NETLABEL) += netlabel.o
+
 EXTRA_CFLAGS += -Isecurity/selinux/include
 
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 210eec7..605b071 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -35,6 +35,7 @@
 #endif
 
 struct sk_buff;
+struct netlbl_lsm_secattr;
 
 extern int selinux_enabled;
 extern int selinux_mls_enabled;
@@ -102,5 +103,28 @@ int security_fs_use(const char *fstype, unsigned int *behavior,
 int security_genfs_sid(const char *fstype, char *name, u16 sclass,
 	u32 *sid);
 
+#ifdef CONFIG_NETLABEL
+int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
+				   u32 base_sid,
+				   u32 *sid);
+
+int security_netlbl_sid_to_secattr(u32 sid,
+				   struct netlbl_lsm_secattr *secattr);
+#else
+static inline int security_netlbl_secattr_to_sid(
+					    struct netlbl_lsm_secattr *secattr,
+					    u32 base_sid,
+					    u32 *sid)
+{
+	return -EIDRM;
+}
+
+static inline int security_netlbl_sid_to_secattr(u32 sid,
+					   struct netlbl_lsm_secattr *secattr)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_NETLABEL */
+
 #endif /* _SELINUX_SECURITY_H_ */
 
diff --git a/security/selinux/include/selinux_netlabel.h b/security/selinux/include/selinux_netlabel.h
index 2a732c9..218e3f7 100644
--- a/security/selinux/include/selinux_netlabel.h
+++ b/security/selinux/include/selinux_netlabel.h
@@ -38,19 +38,22 @@
 
 #ifdef CONFIG_NETLABEL
 void selinux_netlbl_cache_invalidate(void);
-int selinux_netlbl_skbuff_getsid(struct sk_buff *skb, u32 base_sid, u32 *sid);
-int selinux_netlbl_socket_post_create(struct socket *sock);
-void selinux_netlbl_sock_graft(struct sock *sk, struct socket *sock);
-int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
-				struct sk_buff *skb,
-				struct avc_audit_data *ad);
+
 void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec,
 				      int family);
 void selinux_netlbl_sk_security_init(struct sk_security_struct *ssec,
 				     int family);
 void selinux_netlbl_sk_security_clone(struct sk_security_struct *ssec,
 				      struct sk_security_struct *newssec);
+
+int selinux_netlbl_skbuff_getsid(struct sk_buff *skb, u32 base_sid, u32 *sid);
+
+void selinux_netlbl_sock_graft(struct sock *sk, struct socket *sock);
+int selinux_netlbl_socket_post_create(struct socket *sock);
 int selinux_netlbl_inode_permission(struct inode *inode, int mask);
+int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
+				struct sk_buff *skb,
+				struct avc_audit_data *ad);
 int selinux_netlbl_socket_setsockopt(struct socket *sock,
 				     int level,
 				     int optname);
@@ -60,59 +63,53 @@ static inline void selinux_netlbl_cache_invalidate(void)
 	return;
 }
 
-static inline int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
-					       u32 base_sid,
-					       u32 *sid)
+static inline void selinux_netlbl_sk_security_reset(
+	                                       struct sk_security_struct *ssec,
+					       int family)
 {
-	*sid = SECSID_NULL;
-	return 0;
+	return;
 }
-
-static inline int selinux_netlbl_socket_post_create(struct socket *sock)
+static inline void selinux_netlbl_sk_security_init(
+	                                       struct sk_security_struct *ssec,
+					       int family)
 {
-	return 0;
+	return;
 }
-
-static inline void selinux_netlbl_sock_graft(struct sock *sk,
-					     struct socket *sock)
+static inline void selinux_netlbl_sk_security_clone(
+	                                    struct sk_security_struct *ssec,
+					    struct sk_security_struct *newssec)
 {
 	return;
 }
 
-static inline int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
-					      struct sk_buff *skb,
-					      struct avc_audit_data *ad)
+static inline int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
+					       u32 base_sid,
+					       u32 *sid)
 {
+	*sid = SECSID_NULL;
 	return 0;
 }
 
-static inline void selinux_netlbl_sk_security_reset(
-					       struct sk_security_struct *ssec,
-					       int family)
-{
-	return;
-}
-
-static inline void selinux_netlbl_sk_security_init(
-	                                       struct sk_security_struct *ssec,
-					       int family)
+static inline void selinux_netlbl_sock_graft(struct sock *sk,
+					     struct socket *sock)
 {
 	return;
 }
-
-static inline void selinux_netlbl_sk_security_clone(
-	                                   struct sk_security_struct *ssec,
-					   struct sk_security_struct *newssec)
+static inline int selinux_netlbl_socket_post_create(struct socket *sock)
 {
-	return;
+	return 0;
 }
-
 static inline int selinux_netlbl_inode_permission(struct inode *inode,
 						  int mask)
 {
 	return 0;
 }
-
+static inline int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
+					      struct sk_buff *skb,
+					      struct avc_audit_data *ad)
+{
+	return 0;
+}
 static inline int selinux_netlbl_socket_setsockopt(struct socket *sock,
 						   int level,
 						   int optname)
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
new file mode 100644
index 0000000..bf87507
--- /dev/null
+++ b/security/selinux/netlabel.c
@@ -0,0 +1,363 @@
+/*
+ * SELinux NetLabel Support
+ *
+ * This file provides the necessary glue to tie NetLabel into the SELinux
+ * subsystem.
+ *
+ * Author: Paul Moore <paul.moore@hp.com>
+ *
+ */
+
+/*
+ * (c) Copyright Hewlett-Packard Development Company, L.P., 2007
+ *
+ * This program is free software;  you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ * the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program;  if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/spinlock.h>
+#include <linux/rcupdate.h>
+#include <net/sock.h>
+#include <net/netlabel.h>
+
+#include "objsec.h"
+#include "security.h"
+
+/**
+ * selinux_netlbl_socket_setsid - Label a socket using the NetLabel mechanism
+ * @sock: the socket to label
+ * @sid: the SID to use
+ *
+ * Description:
+ * Attempt to label a socket using the NetLabel mechanism using the given
+ * SID.  Returns zero values on success, negative values on failure.  The
+ * caller is responsibile for calling rcu_read_lock() before calling this
+ * this function and rcu_read_unlock() after this function returns.
+ *
+ */
+static int selinux_netlbl_socket_setsid(struct socket *sock, u32 sid)
+{
+	int rc;
+	struct sk_security_struct *sksec = sock->sk->sk_security;
+	struct netlbl_lsm_secattr secattr;
+
+	rc = security_netlbl_sid_to_secattr(sid, &secattr);
+	if (rc != 0)
+		return rc;
+
+	rc = netlbl_socket_setattr(sock, &secattr);
+	if (rc == 0) {
+		spin_lock_bh(&sksec->nlbl_lock);
+		sksec->nlbl_state = NLBL_LABELED;
+		spin_unlock_bh(&sksec->nlbl_lock);
+	}
+
+	return rc;
+}
+
+/**
+ * selinux_netlbl_cache_invalidate - Invalidate the NetLabel cache
+ *
+ * Description:
+ * Invalidate the NetLabel security attribute mapping cache.
+ *
+ */
+void selinux_netlbl_cache_invalidate(void)
+{
+	netlbl_cache_invalidate();
+}
+
+/**
+ * selinux_netlbl_sk_security_reset - Reset the NetLabel fields
+ * @ssec: the sk_security_struct
+ * @family: the socket family
+ *
+ * Description:
+ * Called when the NetLabel state of a sk_security_struct needs to be reset.
+ * The caller is responsibile for all the NetLabel sk_security_struct locking.
+ *
+ */
+void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec,
+				      int family)
+{
+        if (family == PF_INET)
+		ssec->nlbl_state = NLBL_REQUIRE;
+	else
+		ssec->nlbl_state = NLBL_UNSET;
+}
+
+/**
+ * selinux_netlbl_sk_security_init - Setup the NetLabel fields
+ * @ssec: the sk_security_struct
+ * @family: the socket family
+ *
+ * Description:
+ * Called when a new sk_security_struct is allocated to initialize the NetLabel
+ * fields.
+ *
+ */
+void selinux_netlbl_sk_security_init(struct sk_security_struct *ssec,
+				     int family)
+{
+	/* No locking needed, we are the only one who has access to ssec */
+	selinux_netlbl_sk_security_reset(ssec, family);
+	spin_lock_init(&ssec->nlbl_lock);
+}
+
+/**
+ * selinux_netlbl_sk_security_clone - Copy the NetLabel fields
+ * @ssec: the original sk_security_struct
+ * @newssec: the cloned sk_security_struct
+ *
+ * Description:
+ * Clone the NetLabel specific sk_security_struct fields from @ssec to
+ * @newssec.
+ *
+ */
+void selinux_netlbl_sk_security_clone(struct sk_security_struct *ssec,
+				      struct sk_security_struct *newssec)
+{
+	/* We don't need to take newssec->nlbl_lock because we are the only
+	 * thread with access to newssec, but we do need to take the RCU read
+	 * lock as other threads could have access to ssec */
+	rcu_read_lock();
+	selinux_netlbl_sk_security_reset(newssec, ssec->sk->sk_family);
+	newssec->sclass = ssec->sclass;
+	rcu_read_unlock();
+}
+
+/**
+ * selinux_netlbl_skbuff_getsid - Get the sid of a packet using NetLabel
+ * @skb: the packet
+ * @base_sid: the SELinux SID to use as a context for MLS only attributes
+ * @sid: the SID
+ *
+ * Description:
+ * Call the NetLabel mechanism to get the security attributes of the given
+ * packet and use those attributes to determine the correct context/SID to
+ * assign to the packet.  Returns zero on success, negative values on failure.
+ *
+ */
+int selinux_netlbl_skbuff_getsid(struct sk_buff *skb, u32 base_sid, u32 *sid)
+{
+	int rc;
+	struct netlbl_lsm_secattr secattr;
+
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_skbuff_getattr(skb, &secattr);
+	if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
+		rc = security_netlbl_secattr_to_sid(&secattr,
+						    base_sid,
+						    sid);
+	else
+		*sid = SECSID_NULL;
+	netlbl_secattr_destroy(&secattr);
+
+	return rc;
+}
+
+/**
+ * selinux_netlbl_sock_graft - Netlabel the new socket
+ * @sk: the new connection
+ * @sock: the new socket
+ *
+ * Description:
+ * The connection represented by @sk is being grafted onto @sock so set the
+ * socket's NetLabel to match the SID of @sk.
+ *
+ */
+void selinux_netlbl_sock_graft(struct sock *sk, struct socket *sock)
+{
+	struct inode_security_struct *isec = SOCK_INODE(sock)->i_security;
+	struct sk_security_struct *sksec = sk->sk_security;
+	struct netlbl_lsm_secattr secattr;
+	u32 nlbl_peer_sid;
+
+	sksec->sclass = isec->sclass;
+
+	rcu_read_lock();
+
+	if (sksec->nlbl_state != NLBL_REQUIRE) {
+		rcu_read_unlock();
+		return;
+	}
+
+	netlbl_secattr_init(&secattr);
+	if (netlbl_sock_getattr(sk, &secattr) == 0 &&
+	    secattr.flags != NETLBL_SECATTR_NONE &&
+	    security_netlbl_secattr_to_sid(&secattr,
+					   SECINITSID_UNLABELED,
+					   &nlbl_peer_sid) == 0)
+		sksec->peer_sid = nlbl_peer_sid;
+	netlbl_secattr_destroy(&secattr);
+
+	/* Try to set the NetLabel on the socket to save time later, if we fail
+	 * here we will pick up the pieces in later calls to
+	 * selinux_netlbl_inode_permission(). */
+	selinux_netlbl_socket_setsid(sock, sksec->sid);
+
+	rcu_read_unlock();
+}
+
+/**
+ * selinux_netlbl_socket_post_create - Label a socket using NetLabel
+ * @sock: the socket to label
+ *
+ * Description:
+ * Attempt to label a socket using the NetLabel mechanism using the given
+ * SID.  Returns zero values on success, negative values on failure.
+ *
+ */
+int selinux_netlbl_socket_post_create(struct socket *sock)
+{
+	int rc = 0;
+	struct inode_security_struct *isec = SOCK_INODE(sock)->i_security;
+	struct sk_security_struct *sksec = sock->sk->sk_security;
+
+	sksec->sclass = isec->sclass;
+
+	rcu_read_lock();
+	if (sksec->nlbl_state == NLBL_REQUIRE)
+		rc = selinux_netlbl_socket_setsid(sock, sksec->sid);
+	rcu_read_unlock();
+
+	return rc;
+}
+
+/**
+ * selinux_netlbl_inode_permission - Verify the socket is NetLabel labeled
+ * @inode: the file descriptor's inode
+ * @mask: the permission mask
+ *
+ * Description:
+ * Looks at a file's inode and if it is marked as a socket protected by
+ * NetLabel then verify that the socket has been labeled, if not try to label
+ * the socket now with the inode's SID.  Returns zero on success, negative
+ * values on failure.
+ *
+ */
+int selinux_netlbl_inode_permission(struct inode *inode, int mask)
+{
+	int rc;
+	struct sk_security_struct *sksec;
+	struct socket *sock;
+
+	if (!S_ISSOCK(inode->i_mode) ||
+	    ((mask & (MAY_WRITE | MAY_APPEND)) == 0))
+		return 0;
+	sock = SOCKET_I(inode);
+	sksec = sock->sk->sk_security;
+
+	rcu_read_lock();
+	if (sksec->nlbl_state != NLBL_REQUIRE) {
+		rcu_read_unlock();
+		return 0;
+	}
+	local_bh_disable();
+	bh_lock_sock_nested(sock->sk);
+	rc = selinux_netlbl_socket_setsid(sock, sksec->sid);
+	bh_unlock_sock(sock->sk);
+	local_bh_enable();
+	rcu_read_unlock();
+
+	return rc;
+}
+
+/**
+ * selinux_netlbl_sock_rcv_skb - Do an inbound access check using NetLabel
+ * @sksec: the sock's sk_security_struct
+ * @skb: the packet
+ * @ad: the audit data
+ *
+ * Description:
+ * Fetch the NetLabel security attributes from @skb and perform an access check
+ * against the receiving socket.  Returns zero on success, negative values on
+ * error.
+ *
+ */
+int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
+				struct sk_buff *skb,
+				struct avc_audit_data *ad)
+{
+	int rc;
+	u32 netlbl_sid;
+	u32 recv_perm;
+
+	rc = selinux_netlbl_skbuff_getsid(skb,
+					  SECINITSID_UNLABELED,
+					  &netlbl_sid);
+	if (rc != 0)
+		return rc;
+
+	if (netlbl_sid == SECSID_NULL)
+		return 0;
+
+	switch (sksec->sclass) {
+	case SECCLASS_UDP_SOCKET:
+		recv_perm = UDP_SOCKET__RECVFROM;
+		break;
+	case SECCLASS_TCP_SOCKET:
+		recv_perm = TCP_SOCKET__RECVFROM;
+		break;
+	default:
+		recv_perm = RAWIP_SOCKET__RECVFROM;
+	}
+
+	rc = avc_has_perm(sksec->sid,
+			  netlbl_sid,
+			  sksec->sclass,
+			  recv_perm,
+			  ad);
+	if (rc == 0)
+		return 0;
+
+	netlbl_skbuff_err(skb, rc);
+	return rc;
+}
+
+/**
+ * selinux_netlbl_socket_setsockopt - Do not allow users to remove a NetLabel
+ * @sock: the socket
+ * @level: the socket level or protocol
+ * @optname: the socket option name
+ *
+ * Description:
+ * Check the setsockopt() call and if the user is trying to replace the IP
+ * options on a socket and a NetLabel is in place for the socket deny the
+ * access; otherwise allow the access.  Returns zero when the access is
+ * allowed, -EACCES when denied, and other negative values on error.
+ *
+ */
+int selinux_netlbl_socket_setsockopt(struct socket *sock,
+				     int level,
+				     int optname)
+{
+	int rc = 0;
+	struct sk_security_struct *sksec = sock->sk->sk_security;
+	struct netlbl_lsm_secattr secattr;
+
+	rcu_read_lock();
+	if (level == IPPROTO_IP && optname == IP_OPTIONS &&
+	    sksec->nlbl_state == NLBL_LABELED) {
+		netlbl_secattr_init(&secattr);
+		rc = netlbl_socket_getattr(sock, &secattr);
+		if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
+			rc = -EACCES;
+		netlbl_secattr_destroy(&secattr);
+	}
+	rcu_read_unlock();
+
+	return rc;
+}
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 1e52356..c8913c5 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2226,13 +2226,13 @@ void security_skb_extlbl_sid(struct sk_buff *skb, u32 base_sid, u32 *sid)
 
 #ifdef CONFIG_NETLABEL
 /*
- * This is the structure we store inside the NetLabel cache block.
+ * NetLabel cache structure
  */
-#define NETLBL_CACHE(x)           ((struct netlbl_cache *)(x))
+#define NETLBL_CACHE(x)           ((struct selinux_netlbl_cache *)(x))
 #define NETLBL_CACHE_T_NONE       0
 #define NETLBL_CACHE_T_SID        1
 #define NETLBL_CACHE_T_MLS        2
-struct netlbl_cache {
+struct selinux_netlbl_cache {
 	u32 type;
 	union {
 		u32 sid;
@@ -2241,7 +2241,7 @@ struct netlbl_cache {
 };
 
 /**
- * selinux_netlbl_cache_free - Free the NetLabel cached data
+ * security_netlbl_cache_free - Free the NetLabel cached data
  * @data: the data to free
  *
  * Description:
@@ -2249,9 +2249,9 @@ struct netlbl_cache {
  * netlbl_lsm_cache structure.
  *
  */
-static void selinux_netlbl_cache_free(const void *data)
+static void security_netlbl_cache_free(const void *data)
 {
-	struct netlbl_cache *cache;
+	struct selinux_netlbl_cache *cache;
 
 	if (data == NULL)
 		return;
@@ -2266,33 +2266,33 @@ static void selinux_netlbl_cache_free(const void *data)
 }
 
 /**
- * selinux_netlbl_cache_add - Add an entry to the NetLabel cache
- * @skb: the packet
+ * security_netlbl_cache_add - Add an entry to the NetLabel cache
+ * @secattr: the NetLabel packet security attributes
  * @ctx: the SELinux context
  *
  * Description:
  * Attempt to cache the context in @ctx, which was derived from the packet in
- * @skb, in the NetLabel subsystem cache.
+ * @skb, in the NetLabel subsystem cache.  This function assumes @secattr has
+ * already been initialized.
  *
  */
-static void selinux_netlbl_cache_add(struct sk_buff *skb, struct context *ctx)
+static void security_netlbl_cache_add(struct netlbl_lsm_secattr *secattr,
+				      struct context *ctx)
 {
-	struct netlbl_cache *cache = NULL;
-	struct netlbl_lsm_secattr secattr;
+	struct selinux_netlbl_cache *cache = NULL;
 
-	netlbl_secattr_init(&secattr);
-	secattr.cache = netlbl_secattr_cache_alloc(GFP_ATOMIC);
-	if (secattr.cache == NULL)
-		goto netlbl_cache_add_return;
+	secattr->cache = netlbl_secattr_cache_alloc(GFP_ATOMIC);
+	if (secattr->cache == NULL)
+		return;
 
 	cache = kzalloc(sizeof(*cache),	GFP_ATOMIC);
 	if (cache == NULL)
-		goto netlbl_cache_add_return;
+		return;
 
 	cache->type = NETLBL_CACHE_T_MLS;
 	if (ebitmap_cpy(&cache->data.mls_label.level[0].cat,
 			&ctx->range.level[0].cat) != 0)
-		goto netlbl_cache_add_return;
+		return;
 	cache->data.mls_label.level[1].cat.highbit =
 		cache->data.mls_label.level[0].cat.highbit;
 	cache->data.mls_label.level[1].cat.node =
@@ -2300,52 +2300,40 @@ static void selinux_netlbl_cache_add(struct sk_buff *skb, struct context *ctx)
 	cache->data.mls_label.level[0].sens = ctx->range.level[0].sens;
 	cache->data.mls_label.level[1].sens = ctx->range.level[0].sens;
 
-	secattr.cache->free = selinux_netlbl_cache_free;
-	secattr.cache->data = (void *)cache;
-	secattr.flags = NETLBL_SECATTR_CACHE;
-
-	netlbl_cache_add(skb, &secattr);
-
-netlbl_cache_add_return:
-	netlbl_secattr_destroy(&secattr);
+	secattr->cache->free = security_netlbl_cache_free;
+	secattr->cache->data = (void *)cache;
+	secattr->flags |= NETLBL_SECATTR_CACHE;
 }
 
 /**
- * selinux_netlbl_cache_invalidate - Invalidate the NetLabel cache
- *
- * Description:
- * Invalidate the NetLabel security attribute mapping cache.
- *
- */
-void selinux_netlbl_cache_invalidate(void)
-{
-	netlbl_cache_invalidate();
-}
-
-/**
- * selinux_netlbl_secattr_to_sid - Convert a NetLabel secattr to a SELinux SID
- * @skb: the network packet
+ * security_netlbl_secattr_to_sid - Convert a NetLabel secattr to a SELinux SID
  * @secattr: the NetLabel packet security attributes
  * @base_sid: the SELinux SID to use as a context for MLS only attributes
  * @sid: the SELinux SID
  *
  * Description:
- * Convert the given NetLabel packet security attributes in @secattr into a
+ * Convert the given NetLabel security attributes in @secattr into a
  * SELinux SID.  If the @secattr field does not contain a full SELinux
- * SID/context then use the context in @base_sid as the foundation.  If @skb
- * is not NULL attempt to cache as much data as possibile.  Returns zero on
- * success, negative values on failure.
+ * SID/context then use the context in @base_sid as the foundation.  If
+ * possibile the 'cache' field of @secattr is set and the CACHE flag is set;
+ * this is to allow the @secattr to be used by NetLabel to cache the secattr to
+ * SID conversion for future lookups.  Returns zero on success, negative
+ * values on failure.
  *
  */
-static int selinux_netlbl_secattr_to_sid(struct sk_buff *skb,
-					 struct netlbl_lsm_secattr *secattr,
-					 u32 base_sid,
-					 u32 *sid)
+int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
+				   u32 base_sid,
+				   u32 *sid)
 {
 	int rc = -EIDRM;
 	struct context *ctx;
 	struct context ctx_new;
-	struct netlbl_cache *cache;
+	struct selinux_netlbl_cache *cache;
+
+	if (!ss_initialized) {
+		*sid = SECSID_NULL;
+		return 0;
+	}
 
 	POLICY_RDLOCK;
 
@@ -2410,8 +2398,8 @@ static int selinux_netlbl_secattr_to_sid(struct sk_buff *skb,
 		if (rc != 0)
 			goto netlbl_secattr_to_sid_return_cleanup;
 
-		if (skb != NULL)
-			selinux_netlbl_cache_add(skb, &ctx_new);
+		security_netlbl_cache_add(secattr, &ctx_new);
+
 		ebitmap_destroy(&ctx_new.range.level[0].cat);
 	} else {
 		*sid = SECSID_NULL;
@@ -2427,338 +2415,43 @@ netlbl_secattr_to_sid_return_cleanup:
 }
 
 /**
- * selinux_netlbl_skbuff_getsid - Get the sid of a packet using NetLabel
- * @skb: the packet
- * @base_sid: the SELinux SID to use as a context for MLS only attributes
- * @sid: the SID
- *
- * Description:
- * Call the NetLabel mechanism to get the security attributes of the given
- * packet and use those attributes to determine the correct context/SID to
- * assign to the packet.  Returns zero on success, negative values on failure.
- *
- */
-int selinux_netlbl_skbuff_getsid(struct sk_buff *skb, u32 base_sid, u32 *sid)
-{
-	int rc;
-	struct netlbl_lsm_secattr secattr;
-
-	netlbl_secattr_init(&secattr);
-	rc = netlbl_skbuff_getattr(skb, &secattr);
-	if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
-		rc = selinux_netlbl_secattr_to_sid(skb,
-						   &secattr,
-						   base_sid,
-						   sid);
-	else
-		*sid = SECSID_NULL;
-	netlbl_secattr_destroy(&secattr);
-
-	return rc;
-}
-
-/**
- * selinux_netlbl_socket_setsid - Label a socket using the NetLabel mechanism
- * @sock: the socket to label
- * @sid: the SID to use
+ * security_netlbl_sid_to_secattr - Convert a SELinux SID to a NetLabel secattr
+ * @sid: the SELinux SID
+ * @secattr: the NetLabel packet security attributes
  *
  * Description:
- * Attempt to label a socket using the NetLabel mechanism using the given
- * SID.  Returns zero values on success, negative values on failure.  The
- * caller is responsibile for calling rcu_read_lock() before calling this
- * this function and rcu_read_unlock() after this function returns.
+ * Convert the given SELinux SID in @sid into a NetLabel security attribute.
+ * Returns zero on success, negative values on failure.
  *
  */
-static int selinux_netlbl_socket_setsid(struct socket *sock, u32 sid)
+int security_netlbl_sid_to_secattr(u32 sid, struct netlbl_lsm_secattr *secattr)
 {
 	int rc = -ENOENT;
-	struct sk_security_struct *sksec = sock->sk->sk_security;
-	struct netlbl_lsm_secattr secattr;
 	struct context *ctx;
 
+	netlbl_secattr_init(secattr);
+
 	if (!ss_initialized)
 		return 0;
 
-	netlbl_secattr_init(&secattr);
-
 	POLICY_RDLOCK;
-
 	ctx = sidtab_search(&sidtab, sid);
 	if (ctx == NULL)
-		goto netlbl_socket_setsid_return;
-
-	secattr.domain = kstrdup(policydb.p_type_val_to_name[ctx->type - 1],
-				 GFP_ATOMIC);
-	secattr.flags |= NETLBL_SECATTR_DOMAIN;
-	mls_export_netlbl_lvl(ctx, &secattr);
-	rc = mls_export_netlbl_cat(ctx, &secattr);
+		goto netlbl_sid_to_secattr_failure;
+	secattr->domain = kstrdup(policydb.p_type_val_to_name[ctx->type - 1],
+				  GFP_ATOMIC);
+	secattr->flags |= NETLBL_SECATTR_DOMAIN;
+	mls_export_netlbl_lvl(ctx, secattr);
+	rc = mls_export_netlbl_cat(ctx, secattr);
 	if (rc != 0)
-		goto netlbl_socket_setsid_return;
-
-	rc = netlbl_socket_setattr(sock, &secattr);
-	if (rc == 0) {
-		spin_lock_bh(&sksec->nlbl_lock);
-		sksec->nlbl_state = NLBL_LABELED;
-		spin_unlock_bh(&sksec->nlbl_lock);
-	}
-
-netlbl_socket_setsid_return:
+		goto netlbl_sid_to_secattr_failure;
 	POLICY_RDUNLOCK;
-	netlbl_secattr_destroy(&secattr);
-	return rc;
-}
-
-/**
- * selinux_netlbl_sk_security_reset - Reset the NetLabel fields
- * @ssec: the sk_security_struct
- * @family: the socket family
- *
- * Description:
- * Called when the NetLabel state of a sk_security_struct needs to be reset.
- * The caller is responsibile for all the NetLabel sk_security_struct locking.
- *
- */
-void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec,
-				      int family)
-{
-        if (family == PF_INET)
-		ssec->nlbl_state = NLBL_REQUIRE;
-	else
-		ssec->nlbl_state = NLBL_UNSET;
-}
-
-/**
- * selinux_netlbl_sk_security_init - Setup the NetLabel fields
- * @ssec: the sk_security_struct
- * @family: the socket family
- *
- * Description:
- * Called when a new sk_security_struct is allocated to initialize the NetLabel
- * fields.
- *
- */
-void selinux_netlbl_sk_security_init(struct sk_security_struct *ssec,
-				     int family)
-{
-	/* No locking needed, we are the only one who has access to ssec */
-	selinux_netlbl_sk_security_reset(ssec, family);
-	spin_lock_init(&ssec->nlbl_lock);
-}
 
-/**
- * selinux_netlbl_sk_security_clone - Copy the NetLabel fields
- * @ssec: the original sk_security_struct
- * @newssec: the cloned sk_security_struct
- *
- * Description:
- * Clone the NetLabel specific sk_security_struct fields from @ssec to
- * @newssec.
- *
- */
-void selinux_netlbl_sk_security_clone(struct sk_security_struct *ssec,
-				      struct sk_security_struct *newssec)
-{
-	/* We don't need to take newssec->nlbl_lock because we are the only
-	 * thread with access to newssec, but we do need to take the RCU read
-	 * lock as other threads could have access to ssec */
-	rcu_read_lock();
-	selinux_netlbl_sk_security_reset(newssec, ssec->sk->sk_family);
-	newssec->sclass = ssec->sclass;
-	rcu_read_unlock();
-}
-
-/**
- * selinux_netlbl_socket_post_create - Label a socket using NetLabel
- * @sock: the socket to label
- *
- * Description:
- * Attempt to label a socket using the NetLabel mechanism using the given
- * SID.  Returns zero values on success, negative values on failure.
- *
- */
-int selinux_netlbl_socket_post_create(struct socket *sock)
-{
-	int rc = 0;
-	struct inode_security_struct *isec = SOCK_INODE(sock)->i_security;
-	struct sk_security_struct *sksec = sock->sk->sk_security;
-
-	sksec->sclass = isec->sclass;
-
-	rcu_read_lock();
-	if (sksec->nlbl_state == NLBL_REQUIRE)
-		rc = selinux_netlbl_socket_setsid(sock, sksec->sid);
-	rcu_read_unlock();
-
-	return rc;
-}
-
-/**
- * selinux_netlbl_sock_graft - Netlabel the new socket
- * @sk: the new connection
- * @sock: the new socket
- *
- * Description:
- * The connection represented by @sk is being grafted onto @sock so set the
- * socket's NetLabel to match the SID of @sk.
- *
- */
-void selinux_netlbl_sock_graft(struct sock *sk, struct socket *sock)
-{
-	struct inode_security_struct *isec = SOCK_INODE(sock)->i_security;
-	struct sk_security_struct *sksec = sk->sk_security;
-	struct netlbl_lsm_secattr secattr;
-	u32 nlbl_peer_sid;
-
-	sksec->sclass = isec->sclass;
-
-	rcu_read_lock();
-
-	if (sksec->nlbl_state != NLBL_REQUIRE) {
-		rcu_read_unlock();
-		return;
-	}
-
-	netlbl_secattr_init(&secattr);
-	if (netlbl_sock_getattr(sk, &secattr) == 0 &&
-	    secattr.flags != NETLBL_SECATTR_NONE &&
-	    selinux_netlbl_secattr_to_sid(NULL,
-					  &secattr,
-					  SECINITSID_UNLABELED,
-					  &nlbl_peer_sid) == 0)
-		sksec->peer_sid = nlbl_peer_sid;
-	netlbl_secattr_destroy(&secattr);
-
-	/* Try to set the NetLabel on the socket to save time later, if we fail
-	 * here we will pick up the pieces in later calls to
-	 * selinux_netlbl_inode_permission(). */
-	selinux_netlbl_socket_setsid(sock, sksec->sid);
-
-	rcu_read_unlock();
-}
-
-/**
- * selinux_netlbl_inode_permission - Verify the socket is NetLabel labeled
- * @inode: the file descriptor's inode
- * @mask: the permission mask
- *
- * Description:
- * Looks at a file's inode and if it is marked as a socket protected by
- * NetLabel then verify that the socket has been labeled, if not try to label
- * the socket now with the inode's SID.  Returns zero on success, negative
- * values on failure.
- *
- */
-int selinux_netlbl_inode_permission(struct inode *inode, int mask)
-{
-	int rc;
-	struct sk_security_struct *sksec;
-	struct socket *sock;
-
-	if (!S_ISSOCK(inode->i_mode) ||
-	    ((mask & (MAY_WRITE | MAY_APPEND)) == 0))
-		return 0;
-	sock = SOCKET_I(inode);
-	sksec = sock->sk->sk_security;
-
-	rcu_read_lock();
-	if (sksec->nlbl_state != NLBL_REQUIRE) {
-		rcu_read_unlock();
-		return 0;
-	}
-	local_bh_disable();
-	bh_lock_sock_nested(sock->sk);
-	rc = selinux_netlbl_socket_setsid(sock, sksec->sid);
-	bh_unlock_sock(sock->sk);
-	local_bh_enable();
-	rcu_read_unlock();
-
-	return rc;
-}
-
-/**
- * selinux_netlbl_sock_rcv_skb - Do an inbound access check using NetLabel
- * @sksec: the sock's sk_security_struct
- * @skb: the packet
- * @ad: the audit data
- *
- * Description:
- * Fetch the NetLabel security attributes from @skb and perform an access check
- * against the receiving socket.  Returns zero on success, negative values on
- * error.
- *
- */
-int selinux_netlbl_sock_rcv_skb(struct sk_security_struct *sksec,
-				struct sk_buff *skb,
-				struct avc_audit_data *ad)
-{
-	int rc;
-	u32 netlbl_sid;
-	u32 recv_perm;
-
-	rc = selinux_netlbl_skbuff_getsid(skb,
-					  SECINITSID_UNLABELED,
-					  &netlbl_sid);
-	if (rc != 0)
-		return rc;
-
-	if (netlbl_sid == SECSID_NULL)
-		return 0;
-
-	switch (sksec->sclass) {
-	case SECCLASS_UDP_SOCKET:
-		recv_perm = UDP_SOCKET__RECVFROM;
-		break;
-	case SECCLASS_TCP_SOCKET:
-		recv_perm = TCP_SOCKET__RECVFROM;
-		break;
-	default:
-		recv_perm = RAWIP_SOCKET__RECVFROM;
-	}
-
-	rc = avc_has_perm(sksec->sid,
-			  netlbl_sid,
-			  sksec->sclass,
-			  recv_perm,
-			  ad);
-	if (rc == 0)
-		return 0;
-
-	netlbl_skbuff_err(skb, rc);
-	return rc;
-}
-
-/**
- * selinux_netlbl_socket_setsockopt - Do not allow users to remove a NetLabel
- * @sock: the socket
- * @level: the socket level or protocol
- * @optname: the socket option name
- *
- * Description:
- * Check the setsockopt() call and if the user is trying to replace the IP
- * options on a socket and a NetLabel is in place for the socket deny the
- * access; otherwise allow the access.  Returns zero when the access is
- * allowed, -EACCES when denied, and other negative values on error.
- *
- */
-int selinux_netlbl_socket_setsockopt(struct socket *sock,
-				     int level,
-				     int optname)
-{
-	int rc = 0;
-	struct sk_security_struct *sksec = sock->sk->sk_security;
-	struct netlbl_lsm_secattr secattr;
-
-	rcu_read_lock();
-	if (level == IPPROTO_IP && optname == IP_OPTIONS &&
-	    sksec->nlbl_state == NLBL_LABELED) {
-		netlbl_secattr_init(&secattr);
-		rc = netlbl_socket_getattr(sock, &secattr);
-		if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
-			rc = -EACCES;
-		netlbl_secattr_destroy(&secattr);
-	}
-	rcu_read_unlock();
+	return 0;
 
+netlbl_sid_to_secattr_failure:
+	POLICY_RDUNLOCK;
+	netlbl_secattr_destroy(secattr);
 	return rc;
 }
 #endif /* CONFIG_NETLABEL */
-- 
1.5.0.6

