Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYG0H7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYG0H7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 03:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbYG0H7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 03:59:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53764 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYG0H7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 03:59:36 -0400
Date: Sun, 27 Jul 2008 08:59:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] missing bits of net-namespace / sysctl
Message-ID: <20080727075933.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Piss-poor sysctl registration API strikes again, film at 11...
What we really need is _pathname_ required to be present in
already registered table, so that kernel could warn about bad
order.  That's the next target for sysctl stuff (and generally
saner and more explicit order of initialization of ipv[46]
internals wouldn't hurt either).

For the time being, here are full fixups required by ..._rotable()
stuff; we make per-net sysctl sets descendents of "ro" one and
make sure that sufficient skeleton is there before we start registering
per-net sysctls.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/ipv6.h         |    2 ++
 include/net/route.h        |    2 --
 net/ipv4/route.c           |   11 ++++++++++-
 net/ipv4/sysctl_net_ipv4.c |   14 --------------
 net/ipv6/af_inet6.c        |   12 ++++++++++++
 net/ipv6/sysctl_net_ipv6.c |   16 ++++++++++++++++
 net/sysctl_net.c           |    4 +++-
 7 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 2d5c185..113028f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -608,6 +608,8 @@ extern struct ctl_table *ipv6_icmp_sysctl_init(struct net *net);
 extern struct ctl_table *ipv6_route_sysctl_init(struct net *net);
 extern int ipv6_sysctl_register(void);
 extern void ipv6_sysctl_unregister(void);
+extern int ipv6_static_sysctl_register(void);
+extern void ipv6_static_sysctl_unregister(void);
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/include/net/route.h b/include/net/route.h
index 3140cc5..4f0d8c1 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -204,6 +204,4 @@ static inline struct inet_peer *rt_get_peer(struct rtable *rt)
 	return rt->peer;
 }
 
-extern ctl_table ipv4_route_table[];
-
 #endif	/* _ROUTE_H */
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index a507c5e..380d647 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2914,7 +2914,7 @@ static int ipv4_sysctl_rtcache_flush_strategy(ctl_table *table,
 	return 0;
 }
 
-ctl_table ipv4_route_table[] = {
+static ctl_table ipv4_route_table[] = {
 	{
 		.ctl_name	= NET_IPV4_ROUTE_GC_THRESH,
 		.procname	= "gc_thresh",
@@ -3216,6 +3216,15 @@ int __init ip_rt_init(void)
 	return rc;
 }
 
+/*
+ * We really need to sanitize the damn ipv4 init order, then all
+ * this nonsense will go away.
+ */
+void __init ip_static_sysctl_init(void)
+{
+	register_sysctl_paths(ipv4_route_path, ipv4_route_table);
+}
+
 EXPORT_SYMBOL(__ip_select_ident);
 EXPORT_SYMBOL(ip_route_input);
 EXPORT_SYMBOL(ip_route_output_key);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index d63e938..770d827 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -401,13 +401,6 @@ static struct ctl_table ipv4_table[] = {
 		.proc_handler	= &ipv4_local_port_range,
 		.strategy	= &ipv4_sysctl_local_port_range,
 	},
-	{
-		.ctl_name	= NET_IPV4_ROUTE,
-		.procname	= "route",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= ipv4_route_table
-	},
 #ifdef CONFIG_IP_MULTICAST
 	{
 		.ctl_name	= NET_IPV4_IGMP_MAX_MEMBERSHIPS,
@@ -882,11 +875,4 @@ static __init int sysctl_ipv4_init(void)
 	return 0;
 }
 
-/* set enough of tree skeleton to get rid of ordering problems */
-void __init ip_static_sysctl_init(void)
-{
-	static ctl_table table[1];
-	register_sysctl_paths(net_ipv4_ctl_path, table);
-}
-
 __initcall(sysctl_ipv4_init);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index c708ca8..95055f8 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -934,6 +934,11 @@ static int __init inet6_init(void)
 	if (err)
 		goto out_unregister_sock;
 
+#ifdef CONFIG_SYSCTL
+	err = ipv6_static_sysctl_register();
+	if (err)
+		goto static_sysctl_fail;
+#endif
 	/*
 	 *	ipngwg API draft makes clear that the correct semantics
 	 *	for TCP and UDP is to consider one TCP and UDP instance
@@ -1058,6 +1063,10 @@ ipmr_fail:
 icmp_fail:
 	unregister_pernet_subsys(&inet6_net_ops);
 register_pernet_fail:
+#ifdef CONFIG_SYSCTL
+	ipv6_static_sysctl_unregister();
+static_sysctl_fail:
+#endif
 	cleanup_ipv6_mibs();
 out_unregister_sock:
 	sock_unregister(PF_INET6);
@@ -1113,6 +1122,9 @@ static void __exit inet6_exit(void)
 	rawv6_exit();
 
 	unregister_pernet_subsys(&inet6_net_ops);
+#ifdef CONFIG_SYSCTL
+	ipv6_static_sysctl_unregister();
+#endif
 	cleanup_ipv6_mibs();
 	proto_unregister(&rawv6_prot);
 	proto_unregister(&udplitev6_prot);
diff --git a/net/ipv6/sysctl_net_ipv6.c b/net/ipv6/sysctl_net_ipv6.c
index 5c99274..e6dfaea 100644
--- a/net/ipv6/sysctl_net_ipv6.c
+++ b/net/ipv6/sysctl_net_ipv6.c
@@ -150,3 +150,19 @@ void ipv6_sysctl_unregister(void)
 	unregister_net_sysctl_table(ip6_header);
 	unregister_pernet_subsys(&ipv6_sysctl_net_ops);
 }
+
+static struct ctl_table_header *ip6_base;
+
+int ipv6_static_sysctl_register(void)
+{
+	static struct ctl_table empty[1];
+	ip6_base = register_net_sysctl_rotable(net_ipv6_ctl_path, empty);
+	if (ip6_base == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+void ipv6_static_sysctl_unregister(void)
+{
+	unregister_net_sysctl_table(ip6_base);
+}
diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index cefbc36..972201c 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -73,7 +73,9 @@ static struct ctl_table_root net_sysctl_ro_root = {
 
 static int sysctl_net_init(struct net *net)
 {
-	setup_sysctl_set(&net->sysctls, NULL, is_seen);
+	setup_sysctl_set(&net->sysctls,
+			 &net_sysctl_ro_root.default_set,
+			 is_seen);
 	return 0;
 }
 
-- 
1.5.6.2

