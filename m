Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYJGA7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYJGA7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbYJGApl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:41 -0400
Received: from ns.suse.de ([195.135.220.2]:47099 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989AbYJGApj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:39 -0400
Date: Mon, 6 Oct 2008 17:39:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Horman <nhorman@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 53/71] ipv6: Fix OOPS in ip6_dst_lookup_tail().
Message-ID: <20081007003951.GB3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0003-ipv6-Fix-OOPS-in-ip6_dst_lookup_tail.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit e550dfb0c2c31b6363aa463a035fc9f8dcaa3c9b ]

This fixes kernel bugzilla 11469: "TUN with 1024 neighbours:
ip6_dst_lookup_tail NULL crash"

dst->neighbour is not necessarily hooked up at this point
in the processing path, so blindly dereferencing it is
the wrong thing to do.  This NULL check exists in other
similar paths and this case was just an oversight.

Also fix the completely wrong and confusing indentation
here while we're at it.

Based upon a patch by Evgeniy Polyakov.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_output.c |   64 +++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -934,39 +934,39 @@ static int ip6_dst_lookup_tail(struct so
 	}
 
 #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
-		/*
-		 * Here if the dst entry we've looked up
-		 * has a neighbour entry that is in the INCOMPLETE
-		 * state and the src address from the flow is
-		 * marked as OPTIMISTIC, we release the found
-		 * dst entry and replace it instead with the
-		 * dst entry of the nexthop router
-		 */
-		if (!((*dst)->neighbour->nud_state & NUD_VALID)) {
-			struct inet6_ifaddr *ifp;
-			struct flowi fl_gw;
-			int redirect;
-
-			ifp = ipv6_get_ifaddr(net, &fl->fl6_src,
-					      (*dst)->dev, 1);
-
-			redirect = (ifp && ifp->flags & IFA_F_OPTIMISTIC);
-			if (ifp)
-				in6_ifa_put(ifp);
-
-			if (redirect) {
-				/*
-				 * We need to get the dst entry for the
-				 * default router instead
-				 */
-				dst_release(*dst);
-				memcpy(&fl_gw, fl, sizeof(struct flowi));
-				memset(&fl_gw.fl6_dst, 0, sizeof(struct in6_addr));
-				*dst = ip6_route_output(net, sk, &fl_gw);
-				if ((err = (*dst)->error))
-					goto out_err_release;
-			}
+	/*
+	 * Here if the dst entry we've looked up
+	 * has a neighbour entry that is in the INCOMPLETE
+	 * state and the src address from the flow is
+	 * marked as OPTIMISTIC, we release the found
+	 * dst entry and replace it instead with the
+	 * dst entry of the nexthop router
+	 */
+	if ((*dst)->neighbour && !((*dst)->neighbour->nud_state & NUD_VALID)) {
+		struct inet6_ifaddr *ifp;
+		struct flowi fl_gw;
+		int redirect;
+
+		ifp = ipv6_get_ifaddr(net, &fl->fl6_src,
+				      (*dst)->dev, 1);
+
+		redirect = (ifp && ifp->flags & IFA_F_OPTIMISTIC);
+		if (ifp)
+			in6_ifa_put(ifp);
+
+		if (redirect) {
+			/*
+			 * We need to get the dst entry for the
+			 * default router instead
+			 */
+			dst_release(*dst);
+			memcpy(&fl_gw, fl, sizeof(struct flowi));
+			memset(&fl_gw.fl6_dst, 0, sizeof(struct in6_addr));
+			*dst = ip6_route_output(net, sk, &fl_gw);
+			if ((err = (*dst)->error))
+				goto out_err_release;
 		}
+	}
 #endif
 
 	return 0;

-- 
