Return-Path: <linux-kernel-owner+w=401wt.eu-S1422888AbXCGRRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422888AbXCGRRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422877AbXCGRRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:43504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422874AbXCGRQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:53 -0500
Message-Id: <20070307171515.126721128@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de, Michal Wrobel <xmxwx@asn.pl>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 069/101] Dont add anycast reference to device multiple times
Content-Disposition: inline; filename=don-t-add-anycast-reference-to-device-multiple-times.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Wrobel <xmxwx@asn.pl>

[IPV6]: anycast refcnt fix

This patch fixes a bug in Linux IPv6 stack which caused anycast address
to be added to a device prior DAD has been completed. This led to
incorrect reference count which resulted in infinite wait for
unregister_netdevice completion on interface removal.

Signed-off-by: Michal Wrobel <xmxwx@asn.pl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/addrconf.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.20.1.orig/net/ipv6/addrconf.c
+++ linux-2.6.20.1/net/ipv6/addrconf.c
@@ -469,6 +469,8 @@ static void dev_forward_change(struct in
 			ipv6_dev_mc_dec(dev, &addr);
 	}
 	for (ifa=idev->addr_list; ifa; ifa=ifa->if_next) {
+		if (ifa->flags&IFA_F_TENTATIVE)
+			continue;
 		if (idev->cnf.forwarding)
 			addrconf_join_anycast(ifa);
 		else

--
