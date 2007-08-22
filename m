Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbXHVIwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbXHVIwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXHVIwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:25 -0400
Received: from 1wt.eu ([62.212.114.60]:1866 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbXHVIwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:24 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083938.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:45 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 01/58] Fix IPCOMP crashes.
Content-Disposition: inline; filename=0001-Fix-IPCOMP-crashes.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[XFRM]: Fix crash introduced by struct dst_entry reordering

XFRM expects xfrm_dst->u.next to be same pointer as dst->next, which
was broken by the dst_entry reordering in commit 1e19e02c~, causing
an oops in xfrm_bundle_ok when walking the bundle upwards.

Kill xfrm_dst->u.next and change the only user to use dst->next instead.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/net/xfrm.h     |    1 -
 net/xfrm/xfrm_policy.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e476541..4fc943b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -561,7 +561,6 @@ static inline int xfrm_sec_ctx_match(struct xfrm_sec_ctx *s1, struct xfrm_sec_ct
 struct xfrm_dst
 {
 	union {
-		struct xfrm_dst		*next;
 		struct dst_entry	dst;
 		struct rtable		rt;
 		struct rt6_info		rt6;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 9704e05..c208a8a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1971,7 +1971,7 @@ int xfrm_bundle_ok(struct xfrm_policy *pol, struct xfrm_dst *first,
 		if (last == first)
 			break;
 
-		last = last->u.next;
+		last = (struct xfrm_dst *)last->u.dst.next;
 		last->child_mtu_cached = mtu;
 	}
 
-- 
1.5.2.5

-- 
