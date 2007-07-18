Return-Path: <linux-kernel-owner+w=401wt.eu-S935058AbXGRQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935058AbXGRQpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935035AbXGRQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:44:30 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:44852 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934958AbXGRQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:44:27 -0400
From: "Paul Moore" <paul.moore@hp.com>
Message-Id: <20070718163458.086699071@hp.com>
References: <20070718162844.912864704@hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 18 Jul 2007 12:28:46 -0400
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, torvalds@linux-foundation.org,
       michal.k.k.piotrowski@gmail.com, Paul Moore <paul.moore@hp.com>
Subject: [PATCH v3 2/2] SELinux: use SECINITSID_NETMSG instead of SECINITSID_UNLABELED for NetLabel
Content-Disposition: inline; filename=selinux-netlabel_netmsg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These changes will make NetLabel behave like labeled IPsec where there is an
access check for both labeled and unlabeled packets as well as providing the
ability to restrict domains to receiving only labeled packets when NetLabel is
in use.  The changes to the policy are straight forward with the following
necessary to receive labeled traffic (with SECINITSID_NETMSG defined as
"netlabel_peer_t"):

 allow mydom_t netlabel_peer_t:{ tcp_socket udp_socket rawip_socket } recvfrom;

The policy for unlabeled traffic would be:

 allow mydom_t unlabeled_t:{ tcp_socket udp_socket rawip_socket } recvfrom;

These policy changes, as well as more general NetLabel support, are included in
the latest SELinux Reference Policy release 20070629 or later.  Users who make
use of NetLabel are strongly encouraged to upgrade their policy to avoid
network problems.  Users who do not make use of NetLabel will not notice any
difference.

Signed-off-by: Paul Moore <paul.moore@hp.com>
---
 security/selinux/hooks.c    |   21 +++++++++++----------
 security/selinux/netlabel.c |   41 ++++++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 31 deletions(-)

Index: linux-2.6_netmsg_3/security/selinux/hooks.c
===================================================================
--- linux-2.6_netmsg_3.orig/security/selinux/hooks.c
+++ linux-2.6_netmsg_3/security/selinux/hooks.c
@@ -3129,17 +3129,19 @@ static int selinux_parse_skb(struct sk_b
 /**
  * selinux_skb_extlbl_sid - Determine the external label of a packet
  * @skb: the packet
- * @base_sid: the SELinux SID to use as a context for MLS only external labels
  * @sid: the packet's SID
  *
  * Description:
  * Check the various different forms of external packet labeling and determine
- * the external SID for the packet.
+ * the external SID for the packet.  If only one form of external labeling is
+ * present then it is used, if both labeled IPsec and NetLabel labels are
+ * present then the SELinux type information is taken from the labeled IPsec
+ * SA and the MLS sensitivity label information is taken from the NetLabel
+ * security attributes.  This bit of "magic" is done in the call to
+ * selinux_netlbl_skbuff_getsid().
  *
  */
-static void selinux_skb_extlbl_sid(struct sk_buff *skb,
-				   u32 base_sid,
-				   u32 *sid)
+static void selinux_skb_extlbl_sid(struct sk_buff *skb, u32 *sid)
 {
 	u32 xfrm_sid;
 	u32 nlbl_sid;
@@ -3147,10 +3149,9 @@ static void selinux_skb_extlbl_sid(struc
 	selinux_skb_xfrm_sid(skb, &xfrm_sid);
 	if (selinux_netlbl_skbuff_getsid(skb,
 					 (xfrm_sid == SECSID_NULL ?
-					  base_sid : xfrm_sid),
+					  SECINITSID_NETMSG : xfrm_sid),
 					 &nlbl_sid) != 0)
 		nlbl_sid = SECSID_NULL;
-
 	*sid = (nlbl_sid == SECSID_NULL ? xfrm_sid : nlbl_sid);
 }
 
@@ -3695,7 +3696,7 @@ static int selinux_socket_getpeersec_dgr
 	if (sock && sock->sk->sk_family == PF_UNIX)
 		selinux_get_inode_sid(SOCK_INODE(sock), &peer_secid);
 	else if (skb)
-		selinux_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &peer_secid);
+		selinux_skb_extlbl_sid(skb, &peer_secid);
 
 	if (peer_secid == SECSID_NULL)
 		err = -EINVAL;
@@ -3756,7 +3757,7 @@ static int selinux_inet_conn_request(str
 	u32 newsid;
 	u32 peersid;
 
-	selinux_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &peersid);
+	selinux_skb_extlbl_sid(skb, &peersid);
 	if (peersid == SECSID_NULL) {
 		req->secid = sksec->sid;
 		req->peer_secid = SECSID_NULL;
@@ -3794,7 +3795,7 @@ static void selinux_inet_conn_establishe
 {
 	struct sk_security_struct *sksec = sk->sk_security;
 
-	selinux_skb_extlbl_sid(skb, SECINITSID_UNLABELED, &sksec->peer_sid);
+	selinux_skb_extlbl_sid(skb, &sksec->peer_sid);
 }
 
 static void selinux_req_classify_flow(const struct request_sock *req,
Index: linux-2.6_netmsg_3/security/selinux/netlabel.c
===================================================================
--- linux-2.6_netmsg_3.orig/security/selinux/netlabel.c
+++ linux-2.6_netmsg_3/security/selinux/netlabel.c
@@ -163,9 +163,7 @@ int selinux_netlbl_skbuff_getsid(struct 
 	netlbl_secattr_init(&secattr);
 	rc = netlbl_skbuff_getattr(skb, &secattr);
 	if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
-		rc = security_netlbl_secattr_to_sid(&secattr,
-						    base_sid,
-						    sid);
+		rc = security_netlbl_secattr_to_sid(&secattr, base_sid, sid);
 	else
 		*sid = SECSID_NULL;
 	netlbl_secattr_destroy(&secattr);
@@ -203,7 +201,7 @@ void selinux_netlbl_sock_graft(struct so
 	if (netlbl_sock_getattr(sk, &secattr) == 0 &&
 	    secattr.flags != NETLBL_SECATTR_NONE &&
 	    security_netlbl_secattr_to_sid(&secattr,
-					   SECINITSID_UNLABELED,
+					   SECINITSID_NETMSG,
 					   &nlbl_peer_sid) == 0)
 		sksec->peer_sid = nlbl_peer_sid;
 	netlbl_secattr_destroy(&secattr);
@@ -300,41 +298,42 @@ int selinux_netlbl_sock_rcv_skb(struct s
 				struct avc_audit_data *ad)
 {
 	int rc;
-	u32 netlbl_sid;
-	u32 recv_perm;
+	u32 nlbl_sid;
+	u32 perm;
+	struct netlbl_lsm_secattr secattr;
 
 	if (!netlbl_enabled())
 		return 0;
 
-	rc = selinux_netlbl_skbuff_getsid(skb,
-					  SECINITSID_UNLABELED,
-					  &netlbl_sid);
+	netlbl_secattr_init(&secattr);
+	rc = netlbl_skbuff_getattr(skb, &secattr);
+	if (rc == 0 && secattr.flags != NETLBL_SECATTR_NONE)
+		rc = security_netlbl_secattr_to_sid(&secattr,
+						    SECINITSID_NETMSG,
+						    &nlbl_sid);
+	else
+		nlbl_sid = SECINITSID_UNLABELED;
+	netlbl_secattr_destroy(&secattr);
 	if (rc != 0)
 		return rc;
 
-	if (netlbl_sid == SECSID_NULL)
-		return 0;
-
 	switch (sksec->sclass) {
 	case SECCLASS_UDP_SOCKET:
-		recv_perm = UDP_SOCKET__RECVFROM;
+		perm = UDP_SOCKET__RECVFROM;
 		break;
 	case SECCLASS_TCP_SOCKET:
-		recv_perm = TCP_SOCKET__RECVFROM;
+		perm = TCP_SOCKET__RECVFROM;
 		break;
 	default:
-		recv_perm = RAWIP_SOCKET__RECVFROM;
+		perm = RAWIP_SOCKET__RECVFROM;
 	}
 
-	rc = avc_has_perm(sksec->sid,
-			  netlbl_sid,
-			  sksec->sclass,
-			  recv_perm,
-			  ad);
+	rc = avc_has_perm(sksec->sid, nlbl_sid, sksec->sclass, perm, ad);
 	if (rc == 0)
 		return 0;
 
-	netlbl_skbuff_err(skb, rc);
+	if (nlbl_sid != SECINITSID_UNLABELED)
+		netlbl_skbuff_err(skb, rc);
 	return rc;
 }
 

-- 
paul moore
linux security @ hp
