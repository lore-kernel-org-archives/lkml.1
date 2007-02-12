Return-Path: <linux-kernel-owner+w=401wt.eu-S1030193AbXBLVqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193AbXBLVqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030192AbXBLVqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:46:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56698
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1030193AbXBLVqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:46:30 -0500
Date: Mon, 12 Feb 2007 13:46:28 -0800 (PST)
Message-Id: <20070212.134628.98748410.davem@davemloft.net>
To: latten@austin.ibm.com
Cc: ce@ruault.com, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-net@vger.kernel.org
Subject: Re: [BUG] 2.6.20 Oopses in xfrm_audit_log
From: David Miller <davem@davemloft.net>
In-Reply-To: <200702121744.l1CHiUD2026684@faith.austin.ibm.com>
References: <200702121744.l1CHiUD2026684@faith.austin.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joy Latten <latten@austin.ibm.com>
Date: Mon, 12 Feb 2007 11:44:30 -0600

> This is similar to another bug reported last month.
> Here is the patch I sent out then. Please let me know
> how it goes.
> 
> Signed-off-by: Joy Latten <latten@austin.ibm.com>

This whole interface is a complete mess.

Calling xfrm_audit_log() without the proper object being non-NULL
should be a bug.  And that's exactly what you fixed in the xfrm_user
case, so there is zero reason to silently allow this condition, we
should just BUG() on it.

But the logging function has this "result" thing, that in some cases
is set to 1 if "xp" or "x" is not-NULL by the callers, this is just
silly.

You can't log the event if the proper object is NULL, so the "result"
parameter and log information is useless in those cases.

Also, you missed the same exact identical bug in the AF_KEY code.

Thus, below is the patch I will use to fix this bug:

1) Calling xfrm_audit_log() with a NULL object is a BUG()
2) Setting "result" based upon NULL'ness of the object makes no
   sense, either set it to "1" in these cases or use an appropriate
   error check.

How does this look to others?

diff --git a/net/key/af_key.c b/net/key/af_key.c
index f3a026f..1c58204 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2297,16 +2297,17 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, struct sadb_msg
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
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index a24f385..c394b41 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1997,9 +1997,14 @@ void xfrm_audit_log(uid_t auid, u32 sid, int type, int result,
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
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d55436d..2567453 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1273,10 +1273,6 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		xp = xfrm_policy_bysel_ctx(type, p->dir, &p->sel, tmp.security, delete);
 		security_xfrm_policy_free(&tmp);
 	}
-	if (delete)
-		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
-			       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, NULL);
-
 	if (xp == NULL)
 		return -ENOENT;
 
@@ -1292,8 +1288,14 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
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
