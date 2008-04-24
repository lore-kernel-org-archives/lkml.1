Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbYDXEdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbYDXEdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751520AbYDXEdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:33:25 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:45945 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYDXEdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:33:24 -0400
Date: Thu, 24 Apr 2008 14:33:23 +1000
To: David Miller <davem@davemloft.net>, linux-net@bakeyournoodle.com
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Silence 'may be used uninitialized' warning in net/key/af_key.c
Message-ID: <20080424043323.GR20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the kernel warns about:
net/key/af_key.c: In function 'pfkey_spddelete':
net/key/af_key.c:2359: warning: 'pol_ctx' may be used uninitialized in this function

Certainly in the case that CONFIG_SECURITY_NETWORK_XFRM is not set a bogus
value for pol_ctx will be passed arround.  Unconditonnaly initialise to NULL,
to avoid this problem.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 net/key/af_key.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 81a8e52..48923e0 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2385,6 +2385,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, struct sadb_msg
 	if (sel.dport)
 		sel.dport_mask = htons(0xffff);
 
+	pol_ctx = NULL;
 	sec_ctx = (struct sadb_x_sec_ctx *) ext_hdrs[SADB_X_EXT_SEC_CTX-1];
 	if (sec_ctx != NULL) {
 		struct xfrm_user_sec_ctx *uctx = pfkey_sadb2xfrm_user_sec_ctx(sec_ctx);
@@ -2396,8 +2397,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, struct sadb_msg
 		kfree(uctx);
 		if (err)
 			return err;
-	} else
-		pol_ctx = NULL;
+	}
 
 	xp = xfrm_policy_bysel_ctx(XFRM_POLICY_TYPE_MAIN,
 				   pol->sadb_x_policy_dir - 1, &sel, pol_ctx,
-- 
1.5.5.1


Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

