Return-Path: <linux-kernel-owner+w=401wt.eu-S935156AbXHGUqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156AbXHGUqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935145AbXHGUqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:46:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51262 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935119AbXHGUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:46:11 -0400
Date: Tue, 7 Aug 2007 13:42:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 04/84] Fix IPCOMP crashes.
Message-ID: <20070807204250.GE23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipcomp-crashes.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Patrick McHardy <kaber@trash.net>

[XFRM]: Fix crash introduced by struct dst_entry reordering

XFRM expects xfrm_dst->u.next to be same pointer as dst->next, which
was broken by the dst_entry reordering in commit 1e19e02c~, causing
an oops in xfrm_bundle_ok when walking the bundle upwards.

Kill xfrm_dst->u.next and change the only user to use dst->next instead.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/xfrm.h     |    1 -
 net/xfrm/xfrm_policy.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -577,7 +577,6 @@ static inline int xfrm_sec_ctx_match(str
 struct xfrm_dst
 {
 	union {
-		struct xfrm_dst		*next;
 		struct dst_entry	dst;
 		struct rtable		rt;
 		struct rt6_info		rt6;
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2141,7 +2141,7 @@ int xfrm_bundle_ok(struct xfrm_policy *p
 		if (last == first)
 			break;
 
-		last = last->u.next;
+		last = (struct xfrm_dst *)last->u.dst.next;
 		last->child_mtu_cached = mtu;
 	}
 

-- 
