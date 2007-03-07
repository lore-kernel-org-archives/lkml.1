Return-Path: <linux-kernel-owner+w=401wt.eu-S1422751AbXCGRja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422751AbXCGRja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422817AbXCGRPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:15:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:43137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422801AbXCGRPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:15:02 -0500
Message-Id: <20070307171322.788439455@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 038/101] Fix oops in xfrm_audit_log()
Content-Disposition: inline; filename=fix-oops-in-xfrm_audit_log.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

[XFRM]: Fix OOPSes in xfrm_audit_log().

Make sure that this function is called correctly, and
add BUG() checking to ensure the arguments are sane.

Based upon a patch by Joy Latten.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/key/af_key.c       |   11 ++++++-----
 net/xfrm/xfrm_policy.c |    7 ++++++-
 net/xfrm/xfrm_user.c   |   12 +++++++-----
 3 files changed, 19 insertions(+), 11 deletions(-)

--- linux-2.6.20.1.orig/net/key/af_key.c
+++ linux-2.6.20.1/net/key/af_key.c
@@ -2297,16 +2297,17 @@ static int pfkey_spddelete(struct sock *
 				   &sel, tmp.security, 1);
 	security_xfrm_policy_free(&tmp);
 
-	xfrm_audit_log(audit_get_loginuid(current->audit_context), 0,
-		       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, NULL);
-
 	if (xp == NULL)
 		return -ENOENT;
 
-	err = 0;
+	err = security_xfrm_policy_delete(xp);
 
-	if ((err = security_xfrm_policy_delete(xp)))
+	xfrm_audit_log(audit_get_loginuid(current->audit_context), 0,
+		       AUDIT_MAC_IPSEC_DELSPD, err ? 0 : 1, xp, NULL);
+
+	if (err)
 		goto out;
+
 	c.seq = hdr->sadb_msg_seq;
 	c.pid = hdr->sadb_msg_pid;
 	c.event = XFRM_MSG_DELPOLICY;
--- linux-2.6.20.1.orig/net/xfrm/xfrm_policy.c
+++ linux-2.6.20.1/net/xfrm/xfrm_policy.c
@@ -1997,9 +1997,14 @@ void xfrm_audit_log(uid_t auid, u32 sid,
 	if (audit_enabled == 0)
 		return;
 
+	BUG_ON((type == AUDIT_MAC_IPSEC_ADDSA ||
+		type == AUDIT_MAC_IPSEC_DELSA) && !x);
+	BUG_ON((type == AUDIT_MAC_IPSEC_ADDSPD ||
+		type == AUDIT_MAC_IPSEC_DELSPD) && !xp);
+
 	audit_buf = audit_log_start(current->audit_context, GFP_ATOMIC, type);
 	if (audit_buf == NULL)
-	return;
+		return;
 
 	switch(type) {
 	case AUDIT_MAC_IPSEC_ADDSA:
--- linux-2.6.20.1.orig/net/xfrm/xfrm_user.c
+++ linux-2.6.20.1/net/xfrm/xfrm_user.c
@@ -1273,10 +1273,6 @@ static int xfrm_get_policy(struct sk_buf
 		xp = xfrm_policy_bysel_ctx(type, p->dir, &p->sel, tmp.security, delete);
 		security_xfrm_policy_free(&tmp);
 	}
-	if (delete)
-		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
-			       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, NULL);
-
 	if (xp == NULL)
 		return -ENOENT;
 
@@ -1292,8 +1288,14 @@ static int xfrm_get_policy(struct sk_buf
 					      MSG_DONTWAIT);
 		}
 	} else {
-		if ((err = security_xfrm_policy_delete(xp)) != 0)
+		err = security_xfrm_policy_delete(xp);
+
+		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
+			       AUDIT_MAC_IPSEC_DELSPD, err ? 0 : 1, xp, NULL);
+
+		if (err != 0)
 			goto out;
+
 		c.data.byid = p->index;
 		c.event = nlh->nlmsg_type;
 		c.seq = nlh->nlmsg_seq;

--
