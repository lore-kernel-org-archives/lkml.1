Return-Path: <linux-kernel-owner+w=401wt.eu-S967676AbXFHHUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967676AbXFHHUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937873AbXFHHRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:16 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33160 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937851AbXFHHRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:14 -0400
Message-Id: <20070608071528.022470000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       yoshfuji@linux-ipv6.org, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 01/32] pv6: track device renames in snmp6
Content-Disposition: inline; filename=ipv6-track-device-renames-in-snmp6.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

When network device's are renamed, the IPV6 snmp6 code
gets confused. It doesn't track name changes so it will OOPS
when network device's are removed.

The fix is trivial, just unregister/re-register in notify handler.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/addrconf.c |    6 ++++--
 net/ipv6/proc.c     |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.20.13.orig/net/ipv6/addrconf.c
+++ linux-2.6.20.13/net/ipv6/addrconf.c
@@ -2338,8 +2338,9 @@ static int addrconf_notify(struct notifi
 		break;
 
 	case NETDEV_CHANGENAME:
-#ifdef CONFIG_SYSCTL
 		if (idev) {
+			snmp6_unregister_dev(idev);
+#ifdef CONFIG_SYSCTL
 			addrconf_sysctl_unregister(&idev->cnf);
 			neigh_sysctl_unregister(idev->nd_parms);
 			neigh_sysctl_register(dev, idev->nd_parms,
@@ -2347,8 +2348,9 @@ static int addrconf_notify(struct notifi
 					      &ndisc_ifinfo_sysctl_change,
 					      NULL);
 			addrconf_sysctl_register(idev, &idev->cnf);
-		}
 #endif
+			snmp6_register_dev(idev);
+		}
 		break;
 	};
 
--- linux-2.6.20.13.orig/net/ipv6/proc.c
+++ linux-2.6.20.13/net/ipv6/proc.c
@@ -237,6 +237,7 @@ int snmp6_unregister_dev(struct inet6_de
 		return -EINVAL;
 	remove_proc_entry(idev->stats.proc_dir_entry->name,
 			  proc_net_devsnmp6);
+	idev->stats.proc_dir_entry = NULL;
 	return 0;
 }
 

-- 
