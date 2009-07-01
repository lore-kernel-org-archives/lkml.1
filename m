Return-Path: <linux-kernel-owner+w=401wt.eu-S1761087AbZGABEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087AbZGABEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761494AbZGAAfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:11 -0400
Received: from kroah.org ([198.145.64.141]:60490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbZGAAfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:33 2009
Message-Id: <20090701002432.844204006@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 064/108] cfg80211: cleanup return calls on nl80211_set_reg()
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=cfg80211-cleanup-return-calls-on-nl80211_set_reg.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit d0e18f833d23afefb6751a21d14a2cd71d2d4d66 upstream.

This has no functional change, but it will make the race
fix easier to spot in my next patch.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2388,15 +2388,19 @@ static int nl80211_set_reg(struct sk_buf
 			goto bad_reg;
 	}
 
-	if (!reg_is_valid_request(alpha2))
-		return -EINVAL;
+	if (!reg_is_valid_request(alpha2)) {
+		r = -EINVAL;
+		goto bad_reg;
+	}
 
 	size_of_regd = sizeof(struct ieee80211_regdomain) +
 		(num_rules * sizeof(struct ieee80211_reg_rule));
 
 	rd = kzalloc(size_of_regd, GFP_KERNEL);
-	if (!rd)
-		return -ENOMEM;
+	if (!rd) {
+		r = -ENOMEM;
+		goto bad_reg;
+	}
 
 	rd->n_reg_rules = num_rules;
 	rd->alpha2[0] = alpha2[0];
@@ -2413,8 +2417,10 @@ static int nl80211_set_reg(struct sk_buf
 
 		rule_idx++;
 
-		if (rule_idx > NL80211_MAX_SUPP_REG_RULES)
+		if (rule_idx > NL80211_MAX_SUPP_REG_RULES) {
+			r = -EINVAL;
 			goto bad_reg;
+		}
 	}
 
 	BUG_ON(rule_idx != num_rules);
@@ -2422,11 +2428,12 @@ static int nl80211_set_reg(struct sk_buf
 	mutex_lock(&cfg80211_mutex);
 	r = set_regdom(rd);
 	mutex_unlock(&cfg80211_mutex);
+
 	return r;
 
  bad_reg:
 	kfree(rd);
-	return -EINVAL;
+	return r;
 }
 
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)


