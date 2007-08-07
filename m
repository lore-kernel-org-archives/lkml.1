Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbXHGUuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbXHGUuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935153AbXHGUrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:47:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51445 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935348AbXHGUrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:47:47 -0400
Date: Tue, 7 Aug 2007 13:43:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 13/84] Fix ipv6 link down handling.
Message-ID: <20070807204356.GN23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipv6-link-down-handling.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>

[IPV6]: Call inet6addr_chain notifiers on link down

Currently if the link is brought down via ip link or ifconfig down,
the inet6addr_chain notifiers are not called even though all
the addresses are removed from the interface.  This caused SCTP
to add duplicate addresses to it's list.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/addrconf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2472,6 +2472,7 @@ static int addrconf_ifdown(struct net_de
 		write_unlock_bh(&idev->lock);
 
 		__ipv6_ifa_notify(RTM_DELADDR, ifa);
+		atomic_notifier_call_chain(&inet6addr_chain, NETDEV_DOWN, ifa);
 		in6_ifa_put(ifa);
 
 		write_lock_bh(&idev->lock);

-- 
