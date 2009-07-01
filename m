Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbZGABF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbZGABF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761511AbZGAAfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:14 -0400
Received: from kroah.org ([198.145.64.141]:60506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759627AbZGAAfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:08 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:33 2009
Message-Id: <20090701002433.711620126@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 066/108] cfg80211: fix in nl80211_set_reg()
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=cfg80211-fix-in-nl80211_set_reg.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 61405e97788b1bc4e7c5be5b4ec04a73fc11bac2 upstream.

There is a race on access to last_request and its alpha2
through reg_is_valid_request() and us possibly processing
first another regulatory request on another CPU. We avoid
this improbably race by locking with the cfg80211_mutex as
we should have done in the first place. While at it add
the assert on locking on reg_is_valid_request().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |    5 ++++-
 net/wireless/reg.c     |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2388,6 +2388,8 @@ static int nl80211_set_reg(struct sk_buf
 			return -EINVAL;
 	}
 
+	mutex_lock(&cfg80211_mutex);
+
 	if (!reg_is_valid_request(alpha2)) {
 		r = -EINVAL;
 		goto bad_reg;
@@ -2425,13 +2427,14 @@ static int nl80211_set_reg(struct sk_buf
 
 	BUG_ON(rule_idx != num_rules);
 
-	mutex_lock(&cfg80211_mutex);
 	r = set_regdom(rd);
+
 	mutex_unlock(&cfg80211_mutex);
 
 	return r;
 
  bad_reg:
+	mutex_unlock(&cfg80211_mutex);
 	kfree(rd);
 	return r;
 }
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -389,6 +389,8 @@ static int call_crda(const char *alpha2)
 /* Used by nl80211 before kmalloc'ing our regulatory domain */
 bool reg_is_valid_request(const char *alpha2)
 {
+	assert_cfg80211_lock();
+
 	if (!last_request)
 		return false;
 


