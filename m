Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbXDZGIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbXDZGIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXDZGIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:08:23 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:57396 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbXDZGIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:08:22 -0400
Date: Thu, 26 Apr 2007 02:08:20 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 06/12] SELinux: move security_skb_extlbl_sid() out of the
 security server
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260207420.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>

As suggested, move the security_skb_extlbl_sid() function out of the security
server and into the SELinux hooks file.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/hooks.c            |   36 ++++++++++++++++++++++++++++++----
 security/selinux/include/security.h |    3 --
 security/selinux/ss/services.c      |   27 --------------------------
 3 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7f8d0b1..68629aa 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3123,6 +3123,34 @@ static int selinux_parse_skb(struct sk_buff *skb, struct avc_audit_data *ad,
 	return ret;
 }
 
+/**
+ * selinux_skb_extlbl_sid - Determine the external label of a packet
+ * @skb: the packet
+ * @base_sid: the SELinux SID to use as a context for MLS only external labels
+ * @sid: the packet's SID
+ *
+ * Description:
+ * Check the various different forms of external packet labeling and determine
+ * the external SID for the packet.
+ *
+ */
+static void selinux_skb_extlbl_sid(struct sk_buff *skb,
+				   u32 base_sid,
+				   u32 *sid)
+{
+	u32 xfrm_sid;
+	u32 nlbl_sid;
+
+	selinux_skb_xfrm_sid(skb, &xfrm_sid);
+	if (selinux_netlbl_skbuff_getsid(skb,
+					 (xfrm_sid == SECSID_NULL ?
+					  base_sid : xfrm_sid),
+					 &nlbl_sid) != 0)
+		nlbl_sid = SECSID_NULL;
+
+	*sid = (nlbl_sid == SECSID_NULL ? xfrm_sid : nlbl_sid);
+}
+
 /* socket security operations */
 static int socket_has_perm(struct task_struct *task, struct socket *sock,
 			   u32 perms)
@@ -3664,9 +3692,7 @@ static int selinux_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *
 	if (sock && sock->sk->sk_family == PF_UNIX)
 		selinux_get_inode_sid(SOCK_INODE(sock), &peer_secid);
 	else if (skb)
-		security_skb_extlbl_sid(skb,
-					SECINITSID_UNLABELED,
-					&peer_secid);
+		selinux_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &peer_secid);
 
 	if (peer_secid == SECSID_NULL)
 		err = -EINVAL;
@@ -3727,7 +3753,7 @@ static int selinux_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	u32 newsid;
 	u32 peersid;
 
-	security_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &peersid);
+	selinux_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &peersid);
 	if (peersid == SECSID_NULL) {
 		req->secid = sksec->sid;
 		req->peer_secid = SECSID_NULL;
@@ -3765,7 +3791,7 @@ static void selinux_inet_conn_established(struct sock *sk,
 {
 	struct sk_security_struct *sksec = sk->sk_security;
 
-	security_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &sksec->peer_sid);
+	selinux_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &sksec->peer_sid);
 }
 
 static void selinux_req_classify_flow(const struct request_sock *req,
diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 605b071..bfe562c 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -34,7 +34,6 @@
 #define POLICYDB_VERSION_MAX	POLICYDB_VERSION_RANGETRANS
 #endif
 
-struct sk_buff;
 struct netlbl_lsm_secattr;
 
 extern int selinux_enabled;
@@ -83,8 +82,6 @@ int security_netif_sid(char *name, u32 *if_sid,
 int security_node_sid(u16 domain, void *addr, u32 addrlen,
 	u32 *out_sid);
 
-void security_skb_extlbl_sid(struct sk_buff *skb, u32 base_sid, u32 *sid);
-
 int security_validate_transition(u32 oldsid, u32 newsid, u32 tasksid,
                                  u16 tclass);
 
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index f4129f5..8ee4aae 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -39,7 +39,6 @@
 #include <linux/sched.h>
 #include <linux/audit.h>
 #include <linux/mutex.h>
-#include <net/sock.h>
 #include <net/netlabel.h>
 
 #include "flask.h"
@@ -2198,32 +2197,6 @@ void selinux_audit_set_callback(int (*callback)(void))
 	aurule_callback = callback;
 }
 
-/**
- * security_skb_extlbl_sid - Determine the external label of a packet
- * @skb: the packet
- * @base_sid: the SELinux SID to use as a context for MLS only external labels
- * @sid: the packet's SID
- *
- * Description:
- * Check the various different forms of external packet labeling and determine
- * the external SID for the packet.
- *
- */
-void security_skb_extlbl_sid(struct sk_buff *skb, u32 base_sid, u32 *sid)
-{
-	u32 xfrm_sid;
-	u32 nlbl_sid;
-
-	selinux_skb_xfrm_sid(skb, &xfrm_sid);
-	if (selinux_netlbl_skbuff_getsid(skb,
-					 (xfrm_sid == SECSID_NULL ?
-					  base_sid : xfrm_sid),
-					 &nlbl_sid) != 0)
-		nlbl_sid = SECSID_NULL;
-
-	*sid = (nlbl_sid == SECSID_NULL ? xfrm_sid : nlbl_sid);
-}
-
 #ifdef CONFIG_NETLABEL
 /*
  * NetLabel cache structure
-- 
1.5.0.6

