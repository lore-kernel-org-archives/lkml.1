Return-Path: <linux-kernel-owner+w=401wt.eu-S1422903AbXCGRfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422903AbXCGRfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422883AbXCGRfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:35:01 -0500
Received: from mx1.suse.de ([195.135.220.2]:44094 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422854AbXCGRQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:36 -0500
Message-Id: <20070307171458.916902349@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:40 -0800
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
Subject: [patch 065/101] Fix xfrm_add_sa_expire() return value
Content-Disposition: inline; filename=fix-xfrm_add_sa_expire-return-value.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

[XFRM] xfrm_user: Fix return values of xfrm_add_sa_expire.

As noted by Kent Yoder, this function will always return an
error.  Make sure it returns zero on success.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.20.1.orig/net/xfrm/xfrm_user.c
+++ linux-2.6.20.1/net/xfrm/xfrm_user.c
@@ -1557,14 +1557,13 @@ static int xfrm_add_sa_expire(struct sk_
 	struct xfrm_usersa_info *p = &ue->state;
 
 	x = xfrm_state_lookup(&p->id.daddr, p->id.spi, p->id.proto, p->family);
-		err = -ENOENT;
 
+	err = -ENOENT;
 	if (x == NULL)
 		return err;
 
-	err = -EINVAL;
-
 	spin_lock_bh(&x->lock);
+	err = -EINVAL;
 	if (x->km.state != XFRM_STATE_VALID)
 		goto out;
 	km_state_expired(x, ue->hard, current->pid);
@@ -1574,6 +1573,7 @@ static int xfrm_add_sa_expire(struct sk_
 		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
 			       AUDIT_MAC_IPSEC_DELSA, 1, NULL, x);
 	}
+	err = 0;
 out:
 	spin_unlock_bh(&x->lock);
 	xfrm_state_put(x);

--
