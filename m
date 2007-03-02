Return-Path: <linux-kernel-owner+w=401wt.eu-S965566AbXCBUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566AbXCBUPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 15:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXCBUPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 15:15:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965556AbXCBUPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 15:15:45 -0500
Subject: [PATCH] xfrm audit hook misplaced in pfkey_delete and xfrm_del_sa
From: Eric Paris <eparis@parisplace.org>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, jmorris@namei.org, vyekkirala@trustedcs.com,
       cxzhang@watson.ibm.com, sds@tycho.nsa.gov
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:15:36 -0500
Message-Id: <1172866536.31047.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Inside pfkey_delete and xfrm_del_sa the audit hooks were not called if
there was any permission/security failures in attempting to do the del
operation (such as permission denied from security_xfrm_state_delete).
This patch moves the audit hook to the exit path such that all failures
(and successes) will actually get audited.

Signed-off-by: Eric Paris <eparis@redhat.com>

 net/key/af_key.c     |    5 ++---
 net/xfrm/xfrm_user.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 1c58204..d8fc88c 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1467,9 +1467,6 @@ static int pfkey_delete(struct sock *sk, struct sk_buff *skb, struct sadb_msg *h
 
 	err = xfrm_state_delete(x);
 
-	xfrm_audit_log(audit_get_loginuid(current->audit_context), 0,
-		       AUDIT_MAC_IPSEC_DELSA, err ? 0 : 1, NULL, x);
-
 	if (err < 0)
 		goto out;
 
@@ -1478,6 +1475,8 @@ static int pfkey_delete(struct sock *sk, struct sk_buff *skb, struct sadb_msg *h
 	c.event = XFRM_MSG_DELSA;
 	km_state_notify(x, &c);
 out:
+	xfrm_audit_log(audit_get_loginuid(current->audit_context), 0,
+		       AUDIT_MAC_IPSEC_DELSA, err ? 0 : 1, NULL, x);
 	xfrm_state_put(x);
 
 	return err;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 956cfe0..4264473 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -530,9 +530,6 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	err = xfrm_state_delete(x);
 
-	xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
-		       AUDIT_MAC_IPSEC_DELSA, err ? 0 : 1, NULL, x);
-
 	if (err < 0)
 		goto out;
 
@@ -542,6 +539,8 @@ static int xfrm_del_sa(struct sk_buff *skb, struct nlmsghdr *nlh,
 	km_state_notify(x, &c);
 
 out:
+	xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
+		       AUDIT_MAC_IPSEC_DELSA, err ? 0 : 1, NULL, x);
 	xfrm_state_put(x);
 	return err;
 }


