Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYCUXpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYCUXpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYCUXpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:30 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60158 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYCUXpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:22 -0400
Message-Id: <20080321224339.094954774@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/76] IPV4: Remove IP_TOS setting privilege checks.
Content-Disposition: inline; filename=ipv4-remove-ip_tos-setting-privilege-checks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: e4f8b5d4edc1edb0709531bd1a342655d5e8b98e

Various RFCs have all sorts of things to say about the CS field of the
DSCP value.  In particular they try to make the distinction between
values that should be used by "user applications" and things like
routing daemons.

This seems to have influenced the CAP_NET_ADMIN check which exists for
IP_TOS socket option settings, but in fact it has an off-by-one error
so it wasn't allowing CS5 which is meant for "user applications" as
well.

Further adding to the inconsistency and brokenness here, IPV6 does not
validate the DSCP values specified for the IPV6_TCLASS socket option.

The real actual uses of these TOS values are system specific in the
final analysis, and these RFC recommendations are just that, "a
recommendation".  In fact the standards very purposefully use
"SHOULD" and "SHOULD NOT" when describing how these values can be
used.

In the final analysis the only clean way to provide consistency here
is to remove the CAP_NET_ADMIN check.  The alternatives just don't
work out:

1) If we add the CAP_NET_ADMIN check to ipv6, this can break existing
   setups.

2) If we just fix the off-by-one error in the class comparison in
   IPV4, certain DSCP values can be used in IPV6 but not IPV4 by
   default.  So people will just ask for a sysctl asking to
   override that.

I checked several other freely available kernel trees and they
do not make any privilege checks in this area like we do.  For
the BSD stacks, this goes back all the way to Stevens Volume 2
and beyond.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv4/ip_sockglue.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -514,11 +514,6 @@ static int do_ip_setsockopt(struct sock 
 			val &= ~3;
 			val |= inet->tos & 3;
 		}
-		if (IPTOS_PREC(val) >= IPTOS_PREC_CRITIC_ECP &&
-		    !capable(CAP_NET_ADMIN)) {
-			err = -EPERM;
-			break;
-		}
 		if (inet->tos != val) {
 			inet->tos = val;
 			sk->sk_priority = rt_tos2priority(val);

-- 
