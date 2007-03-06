Return-Path: <linux-kernel-owner+w=401wt.eu-S1030309AbXCFSxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309AbXCFSxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030306AbXCFSxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:53:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030309AbXCFSxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:53:04 -0500
Date: Tue, 6 Mar 2007 10:51:32 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: jeremy@goop.org, ak@muc.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, ian.pratt@xensource.com,
       Christian.Limpach@cl.cam.ac.uk, netdev@vger.kernel.org, jeff@garzik.org
Subject: [RFC] ARP notify option
Message-ID: <20070306105132.52c77491@freekitty>
In-Reply-To: <20070305.203536.92584097.davem@davemloft.net>
References: <20070301164214.4a40bc59@freekitty>
	<45E7764A.7000100@goop.org>
	<20070301173030.754514ec@freekitty>
	<20070305.203536.92584097.davem@davemloft.net>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds another inet device option to enable gratuitous ARP
when device is brought up or address change. This is handy for
clusters or virtualization.

Tested on a normal device (not Xen).

Signed-off-by: Stephen Hemminger <shemminge@linux-foundation.org>

---
 Documentation/networking/ip-sysctl.txt |    6 ++++++
 include/linux/inetdevice.h             |    2 ++
 include/linux/sysctl.h                 |    1 +
 net/ipv4/devinet.c                     |   16 ++++++++++++++++
 4 files changed, 25 insertions(+)

--- net-2.6.22.orig/Documentation/networking/ip-sysctl.txt	2007-03-05 14:35:31.000000000 -0800
+++ net-2.6.22/Documentation/networking/ip-sysctl.txt	2007-03-05 16:46:47.000000000 -0800
@@ -732,6 +732,12 @@
 	The max value from conf/{all,interface}/arp_ignore is used
 	when ARP request is received on the {interface}
 
+arp_notify - BOOLEAN
+	Define mode for notification of address and device changes.
+	0 - (default): do nothing
+	1 - Generate gratuitous arp replies when device is brought up
+	    or hardware address changes.
+
 arp_accept - BOOLEAN
 	Define behavior when gratuitous arp replies are received:
 	0 - drop gratuitous arp frames
--- net-2.6.22.orig/include/linux/inetdevice.h	2007-03-05 14:35:34.000000000 -0800
+++ net-2.6.22/include/linux/inetdevice.h	2007-03-05 16:46:47.000000000 -0800
@@ -26,6 +26,7 @@
 	int	arp_announce;
 	int	arp_ignore;
 	int	arp_accept;
+	int	arp_notify;
 	int	medium_id;
 	int	no_xfrm;
 	int	no_policy;
@@ -84,6 +85,7 @@
 #define IN_DEV_ARPFILTER(in_dev)	(ipv4_devconf.arp_filter || (in_dev)->cnf.arp_filter)
 #define IN_DEV_ARP_ANNOUNCE(in_dev)	(max(ipv4_devconf.arp_announce, (in_dev)->cnf.arp_announce))
 #define IN_DEV_ARP_IGNORE(in_dev)	(max(ipv4_devconf.arp_ignore, (in_dev)->cnf.arp_ignore))
+#define IN_DEV_ARP_NOTIFY(in_dev)	(ipv4_devconf.arp_notify || (in_dev)->cnf.arp_notify)
 
 struct in_ifaddr
 {
--- net-2.6.22.orig/include/linux/sysctl.h	2007-03-05 14:35:34.000000000 -0800
+++ net-2.6.22/include/linux/sysctl.h	2007-03-05 16:46:47.000000000 -0800
@@ -495,6 +495,7 @@
 	NET_IPV4_CONF_ARP_IGNORE=19,
 	NET_IPV4_CONF_PROMOTE_SECONDARIES=20,
 	NET_IPV4_CONF_ARP_ACCEPT=21,
+	NET_IPV4_CONF_ARP_NOTIFY=22,
 	__NET_IPV4_CONF_MAX
 };
 
--- net-2.6.22.orig/net/ipv4/devinet.c	2007-03-05 14:35:34.000000000 -0800
+++ net-2.6.22/net/ipv4/devinet.c	2007-03-05 16:46:47.000000000 -0800
@@ -1089,6 +1089,14 @@
 			}
 		}
 		ip_mc_up(in_dev);
+		/* fall through */
+	case NETDEV_CHANGEADDR:
+		if (IN_DEV_ARP_NOTIFY(in_dev))
+			arp_send(ARPOP_REQUEST, ETH_P_ARP,
+				 in_dev->ifa_list->ifa_address,
+				 dev,
+				 in_dev->ifa_list->ifa_address,
+				 NULL, dev->dev_addr, NULL);
 		break;
 	case NETDEV_DOWN:
 		ip_mc_down(in_dev);
@@ -1495,6 +1503,14 @@
 			.proc_handler	= &proc_dointvec,
 		},
 		{
+			.ctl_name	= NET_IPV4_CONF_ARP_NOTIFY,
+			.procname	= "arp_notify",
+			.data		= &ipv4_devconf.arp_notify,
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &proc_dointvec,
+		},
+		{
 			.ctl_name	= NET_IPV4_CONF_NOXFRM,
 			.procname	= "disable_xfrm",
 			.data		= &ipv4_devconf.no_xfrm,
