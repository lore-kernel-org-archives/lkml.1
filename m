Return-Path: <linux-kernel-owner+w=401wt.eu-S1764027AbZGAAvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764027AbZGAAvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbZGAAe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:26 -0400
Received: from kroah.org ([198.145.64.141]:60144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761336AbZGAAeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:18 2009
Message-Id: <20090701002418.219188826@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 018/108] ipv4: fix NULL pointer + success return in route lookup path
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ipv4-fix-null-pointer-success-return-in-route-lookup-path.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 73e42897e8e5619eacb787d2ce69be12f47cfc21 ]

Don't drop route if we're not caching

	I recently got a report of an oops on a route lookup.  Maxime was
testing what would happen if route caching was turned off (doing so by setting
making rt_caching always return 0), and found that it triggered an oops.  I
looked at it and found that the problem stemmed from the fact that the route
lookup routines were returning success from their lookup paths (which is good),
but never set the **rp pointer to anything (which is bad).  This happens because
in rt_intern_hash, if rt_caching returns false, we call rt_drop and return 0.
This almost emulates slient success.  What we should be doing is assigning *rp =
rt and _not_ dropping the route.  This way, during slow path lookups, when we
create a new route cache entry, we don't immediately discard it, rather we just
don't add it into the cache hash table, but we let this one lookup use it for
the purpose of this route request.  Maxime has tested and reports it prevents
the oops.  There is still a subsequent routing issue that I'm looking into
further, but I'm confident that, even if its related to this same path, this
patch makes sense to take.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/route.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1081,8 +1081,16 @@ restart:
 	now = jiffies;
 
 	if (!rt_caching(dev_net(rt->u.dst.dev))) {
-		rt_drop(rt);
-		return 0;
+		/*
+		 * If we're not caching, just tell the caller we
+		 * were successful and don't touch the route.  The
+		 * caller hold the sole reference to the cache entry, and
+		 * it will be released when the caller is done with it.
+		 * If we drop it here, the callers have no way to resolve routes
+		 * when we're not caching.  Instead, just point *rp at rt, so
+		 * the caller gets a single use out of the route
+		 */
+		goto report_and_exit;
 	}
 
 	rthp = &rt_hash_table[hash].chain;
@@ -1210,6 +1218,8 @@ restart:
 	rcu_assign_pointer(rt_hash_table[hash].chain, rt);
 
 	spin_unlock_bh(rt_hash_lock_addr(hash));
+
+report_and_exit:
 	*rp = rt;
 	return 0;
 }


