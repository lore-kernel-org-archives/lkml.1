Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbZIEAZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbZIEAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934628AbZIEAZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:25:09 -0400
Received: from kroah.org ([198.145.64.141]:42297 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934561AbZIEAVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:56 2009
Message-Id: <20090905001456.144717677@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 57/71] ipv6: Fix commit 63d9950b08184e6531adceb65f64b429909cc101 (ipv6: Make v4-mapped bindings consistent with IPv4)
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=ipv6-fix-commit-63d9950b08184e6531adceb65f64b429909cc101.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bruno Prémont <bonbons@linux-vserver.org>

commit ca6982b858e1d08010c1d29d8e8255b2ac2ad70a upstream.

Commit 63d9950b08184e6531adceb65f64b429909cc101
  (ipv6: Make v4-mapped bindings consistent with IPv4)
changes behavior of inet6_bind() for v4-mapped addresses so it should
behave the same way as inet_bind().

During this change setting of err to -EADDRNOTAVAIL got lost:

af_inet.c:469 inet_bind()
	err = -EADDRNOTAVAIL;
	if (!sysctl_ip_nonlocal_bind &&
	    !(inet->freebind || inet->transparent) &&
	    addr->sin_addr.s_addr != htonl(INADDR_ANY) &&
	    chk_addr_ret != RTN_LOCAL &&
	    chk_addr_ret != RTN_MULTICAST &&
	    chk_addr_ret != RTN_BROADCAST)
		goto out;


af_inet6.c:463 inet6_bind()
	if (addr_type == IPV6_ADDR_MAPPED) {
		int chk_addr_ret;

		/* Binding to v4-mapped address on a v6-only socket
		 * makes no sense
		 */
		if (np->ipv6only) {
			err = -EINVAL;
			goto out;
		}

		/* Reproduce AF_INET checks to make the bindings consitant */
		v4addr = addr->sin6_addr.s6_addr32[3];
		chk_addr_ret = inet_addr_type(net, v4addr);
		if (!sysctl_ip_nonlocal_bind &&
		    !(inet->freebind || inet->transparent) &&
		    v4addr != htonl(INADDR_ANY) &&
		    chk_addr_ret != RTN_LOCAL &&
		    chk_addr_ret != RTN_MULTICAST &&
		    chk_addr_ret != RTN_BROADCAST)
			goto out;
	} else {


Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/ipv6/af_inet6.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -294,8 +294,10 @@ int inet6_bind(struct socket *sock, stru
 		    v4addr != htonl(INADDR_ANY) &&
 		    chk_addr_ret != RTN_LOCAL &&
 		    chk_addr_ret != RTN_MULTICAST &&
-		    chk_addr_ret != RTN_BROADCAST)
+		    chk_addr_ret != RTN_BROADCAST) {
+			err = -EADDRNOTAVAIL;
 			goto out;
+		}
 	} else {
 		if (addr_type != IPV6_ADDR_ANY) {
 			struct net_device *dev = NULL;


