Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZJVO0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZJVO0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZJVO0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:26:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbZJVOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:25:58 -0400
Date: Thu, 22 Oct 2009 16:26:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Krzysztof Piotr Oledzki <ole@ans.pl>, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] netfilter: remove CONFIG_NF_CT_ACCT
Message-ID: <alpine.LSU.2.00.0910221615360.8582@wotan.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can see several issues with CONFIG_NF_CT_ACCT and I think it should be 
removed for the following reasons:

1) the netlink seems broken for the (CONFIG_NF_CT_ACCT unset && 
   net.netfilter.nf_conntrack_acct set) scenario. In such case, 
   ctnetlink_nlmsg_size() seems to miscompute the size of the message, as 
   the CTA_COUNTERS_* are not counted in at all. Seems quite serious on a 
   first glance.
2) It has been marked as deprecated for quite some time, and was supposed 
   to be removed in 2.6.29, but is apparently still with us.
3) Spits confusing warnings into dmesg.

All this since commit 584015727a3b ("netfilter: accounting rework: 
ct_extend + 64bit counters (v4)").

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
--- 
 Documentation/feature-removal-schedule.txt |    9 ---------
 Documentation/kernel-parameters.txt        |    3 +--
 net/netfilter/Kconfig                      |   22 ----------------------
 net/netfilter/nf_conntrack_acct.c          |   10 ----------
 net/netfilter/nf_conntrack_netlink.c       |    2 --
 5 files changed, 1 insertions(+), 45 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bc693ff..a4a8bf8 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -345,15 +345,6 @@ Who:	Johannes Berg <johannes@sipsolutions.net>
 
 ---------------------------
 
-What: CONFIG_NF_CT_ACCT
-When: 2.6.29
-Why:  Accounting can now be enabled/disabled without kernel recompilation.
-      Currently used only to set a default value for a feature that is also
-      controlled by a kernel/module/sysfs/sysctl parameter.
-Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
-
----------------------------
-
 What:	sysfs ui for changing p4-clockmod parameters
 When:	September 2009
 Why:	See commits 129f8ae9b1b5be94517da76009ea956e89104ce8 and
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..f307b55 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1534,8 +1534,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			[NETFILTER] Enable connection tracking flow accounting
 			0 to disable accounting
 			1 to enable accounting
-			Default value depends on CONFIG_NF_CT_ACCT that is
-			going to be removed in 2.6.29.
+			Default value is 0.
 
 	nfsaddrs=	[NFS]
 			See Documentation/filesystems/nfsroot.txt.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 634d14a..5dfe7ec 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -40,27 +40,6 @@ config NF_CONNTRACK
 
 if NF_CONNTRACK
 
-config NF_CT_ACCT
-	bool "Connection tracking flow accounting"
-	depends on NETFILTER_ADVANCED
-	help
-	  If this option is enabled, the connection tracking code will
-	  keep per-flow packet and byte counters.
-
-	  Those counters can be used for flow-based accounting or the
-	  `connbytes' match.
-
-	  Please note that currently this option only sets a default state.
-	  You may change it at boot time with nf_conntrack.acct=0/1 kernel
-	  parameter or by loading the nf_conntrack module with acct=0/1.
-
-	  You may also disable/enable it on a running system with:
-	   sysctl net.netfilter.nf_conntrack_acct=0/1
-
-	  This option will be removed in 2.6.29.
-
-	  If unsure, say `N'.
-
 config NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on NETFILTER_ADVANCED
@@ -557,7 +536,6 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
-	select NF_CT_ACCT
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 4a1d94a..bc25451 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -16,11 +16,7 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 
-#ifdef CONFIG_NF_CT_ACCT
-#define NF_CT_ACCT_DEFAULT 1
-#else
 #define NF_CT_ACCT_DEFAULT 0
-#endif
 
 static int nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
 
@@ -114,12 +110,6 @@ int nf_conntrack_acct_init(struct net *net)
 	net->ct.sysctl_acct = nf_ct_acct;
 
 	if (net_eq(net, &init_net)) {
-#ifdef CONFIG_NF_CT_ACCT
-	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
-		printk(KERN_WARNING "nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or\n");
-		printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
-#endif
-
 		ret = nf_ct_extend_register(&acct_extend);
 		if (ret < 0) {
 			printk(KERN_ERR "nf_conntrack_acct: Unable to register extension\n");
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 59d8064..d679562 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -430,11 +430,9 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + 3 * nla_total_size(sizeof(u_int8_t)) /* CTA_PROTO_NUM */
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_ID */
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_STATUS */
-#ifdef CONFIG_NF_CT_ACCT
 	       + 2 * nla_total_size(0) /* CTA_COUNTERS_ORIG|REPL */
 	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_PACKETS */
 	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_BYTES */
-#endif
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_TIMEOUT */
 	       + nla_total_size(0) /* CTA_PROTOINFO */
 	       + nla_total_size(0) /* CTA_HELP */
