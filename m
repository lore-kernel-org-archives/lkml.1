Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab0BDR3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:29:35 -0500
Received: from kroah.org ([198.145.64.141]:34831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300Ab0BDRWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:09 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:14 2010
Message-Id: <20100204171514.263483751@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [46/74] net: restore ip source validation
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jamal Hadi Salim <hadi@cyberus.ca>

[ Upstream commit 28f6aeea3f12d37bd258b2c0d5ba891bff4ec479 ]

when using policy routing and the skb mark:
there are cases where a back path validation requires us
to use a different routing table for src ip validation than
the one used for mapping ingress dst ip.
One such a case is transparent proxying where we pretend to be
the destination system and therefore the local table
is used for incoming packets but possibly a main table would
be used on outbound.
Make the default behavior to allow the above and if users
need to turn on the symmetry via sysctl src_valid_mark

Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/inetdevice.h |    1 +
 include/linux/sysctl.h     |    1 +
 net/ipv4/devinet.c         |    1 +
 net/ipv4/fib_frontend.c    |    2 ++
 4 files changed, 5 insertions(+)

--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -83,6 +83,7 @@ static inline void ipv4_devconf_setall(s
 #define IN_DEV_FORWARD(in_dev)		IN_DEV_CONF_GET((in_dev), FORWARDING)
 #define IN_DEV_MFORWARD(in_dev)		IN_DEV_ANDCONF((in_dev), MC_FORWARDING)
 #define IN_DEV_RPFILTER(in_dev)		IN_DEV_MAXCONF((in_dev), RP_FILTER)
+#define IN_DEV_SRC_VMARK(in_dev)    	IN_DEV_ORCONF((in_dev), SRC_VMARK)
 #define IN_DEV_SOURCE_ROUTE(in_dev)	IN_DEV_ANDCONF((in_dev), \
 						       ACCEPT_SOURCE_ROUTE)
 #define IN_DEV_BOOTP_RELAY(in_dev)	IN_DEV_ANDCONF((in_dev), BOOTP_RELAY)
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -490,6 +490,7 @@ enum
 	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
 	NET_IPV4_CONF_ARP_ACCEPT=21,
 	NET_IPV4_CONF_ARP_NOTIFY=22,
+	NET_IPV4_CONF_SRC_VMARK=24,
 	__NET_IPV4_CONF_MAX
 };
 
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1450,6 +1450,7 @@ static struct devinet_sysctl_table {
 		DEVINET_SYSCTL_RW_ENTRY(SEND_REDIRECTS, "send_redirects"),
 		DEVINET_SYSCTL_RW_ENTRY(ACCEPT_SOURCE_ROUTE,
 					"accept_source_route"),
+		DEVINET_SYSCTL_RW_ENTRY(SRC_VMARK, "src_valid_mark"),
 		DEVINET_SYSCTL_RW_ENTRY(PROXY_ARP, "proxy_arp"),
 		DEVINET_SYSCTL_RW_ENTRY(MEDIUM_ID, "medium_id"),
 		DEVINET_SYSCTL_RW_ENTRY(BOOTP_RELAY, "bootp_relay"),
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -251,6 +251,8 @@ int fib_validate_source(__be32 src, __be
 	if (in_dev) {
 		no_addr = in_dev->ifa_list == NULL;
 		rpf = IN_DEV_RPFILTER(in_dev);
+		if (mark && !IN_DEV_SRC_VMARK(in_dev))
+			fl.mark = 0;
 	}
 	rcu_read_unlock();
 


