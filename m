Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbXJaPYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbXJaPYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbXJaPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:24:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33417 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759718AbXJaPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:24:14 -0400
Date: Wed, 31 Oct 2007 08:11:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Mitsuru Chinen <mitch@linux.vnet.ibm.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/26] Fix some cases of missed IPV6 DAD
Message-ID: <20071031151114.GF2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-some-cases-of-missed-ipv6-dad.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mitsuru Chinen <mitch@linux.vnet.ibm.com>

changeset 0fcace22d38ce9216f5ba52f929a99d284aa7e49 from mainline

To judge the timing for DAD, netif_carrier_ok() is used. However,
there is a possibility that dev->qdisc stays noop_qdisc even if
netif_carrier_ok() returns true. In that case, DAD NS is not sent out.
We need to defer the IPv6 device initialization until a valid qdisc
is specified.

Signed-off-by: Mitsuru Chinen <mitch@linux.vnet.ibm.com>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/addrconf.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -73,6 +73,7 @@
 #include <net/tcp.h>
 #include <net/ip.h>
 #include <net/netlink.h>
+#include <net/pkt_sched.h>
 #include <linux/if_tunnel.h>
 #include <linux/rtnetlink.h>
 
@@ -212,6 +213,12 @@ static struct ipv6_devconf ipv6_devconf_
 const struct in6_addr in6addr_any = IN6ADDR_ANY_INIT;
 const struct in6_addr in6addr_loopback = IN6ADDR_LOOPBACK_INIT;
 
+/* Check if a valid qdisc is available */
+static inline int addrconf_qdisc_ok(struct net_device *dev)
+{
+	return (dev->qdisc != &noop_qdisc);
+}
+
 static void addrconf_del_timer(struct inet6_ifaddr *ifp)
 {
 	if (del_timer(&ifp->timer))
@@ -376,7 +383,7 @@ static struct inet6_dev * ipv6_add_dev(s
 	}
 #endif
 
-	if (netif_running(dev) && netif_carrier_ok(dev))
+	if (netif_running(dev) && addrconf_qdisc_ok(dev))
 		ndev->if_flags |= IF_READY;
 
 	ipv6_mc_init_dev(ndev);
@@ -2269,7 +2276,7 @@ static int addrconf_notify(struct notifi
 	case NETDEV_UP:
 	case NETDEV_CHANGE:
 		if (event == NETDEV_UP) {
-			if (!netif_carrier_ok(dev)) {
+			if (!addrconf_qdisc_ok(dev)) {
 				/* device is not ready yet. */
 				printk(KERN_INFO
 					"ADDRCONF(NETDEV_UP): %s: "
@@ -2281,7 +2288,7 @@ static int addrconf_notify(struct notifi
 			if (idev)
 				idev->if_flags |= IF_READY;
 		} else {
-			if (!netif_carrier_ok(dev)) {
+			if (!addrconf_qdisc_ok(dev)) {
 				/* device is still not ready. */
 				break;
 			}

-- 
