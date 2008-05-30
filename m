Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYE3EGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYE3EGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbYE3EAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56631 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752938AbYE3EAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:23 -0400
Message-Id: <20080530040019.799353964@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:46 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 26/41] cpu alloc: Convert mib handling to cpu alloc
Content-Disposition: inline; filename=cpu_alloc_mib_handling_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the cpu alloc functions for the mib handling functions in the net
layer. The API for snmp_mib_free() is changed to add a size parameter
since cpu_free() requires a size parameter.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/net/ip.h     |    2 +-
 include/net/snmp.h   |   32 ++++++++------------------------
 net/dccp/proto.c     |    2 +-
 net/ipv4/af_inet.c   |   31 +++++++++++++++++--------------
 net/ipv6/addrconf.c  |   11 ++++++-----
 net/ipv6/af_inet6.c  |   20 +++++++++++---------
 net/sctp/protocol.c  |    2 +-
 net/xfrm/xfrm_proc.c |    4 ++--
 8 files changed, 47 insertions(+), 57 deletions(-)

Index: linux-2.6/include/net/ip.h
===================================================================
--- linux-2.6.orig/include/net/ip.h	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/include/net/ip.h	2008-05-29 20:15:34.000000000 -0700
@@ -170,7 +170,7 @@ DECLARE_SNMP_STAT(struct linux_mib, net_
 
 extern unsigned long snmp_fold_field(void *mib[], int offt);
 extern int snmp_mib_init(void *ptr[2], size_t mibsize);
-extern void snmp_mib_free(void *ptr[2]);
+extern void snmp_mib_free(void *ptr[2], size_t mibsize);
 
 extern void inet_get_local_port_range(int *low, int *high);
 
Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/include/net/snmp.h	2008-05-29 20:15:34.000000000 -0700
@@ -138,29 +138,13 @@ struct linux_xfrm_mib {
 #define SNMP_STAT_BHPTR(name)	(name[0])
 #define SNMP_STAT_USRPTR(name)	(name[1])
 
-#define SNMP_INC_STATS_BH(mib, field) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field]++)
-#define SNMP_INC_STATS_USER(mib, field) \
-	do { \
-		per_cpu_ptr(mib[1], get_cpu())->mibs[field]++; \
-		put_cpu(); \
-	} while (0)
-#define SNMP_INC_STATS(mib, field) 	\
-	do { \
-		per_cpu_ptr(mib[!in_softirq()], get_cpu())->mibs[field]++; \
-		put_cpu(); \
-	} while (0)
-#define SNMP_DEC_STATS(mib, field) 	\
-	do { \
-		per_cpu_ptr(mib[!in_softirq()], get_cpu())->mibs[field]--; \
-		put_cpu(); \
-	} while (0)
-#define SNMP_ADD_STATS_BH(mib, field, addend) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field] += addend)
-#define SNMP_ADD_STATS_USER(mib, field, addend) 	\
-	do { \
-		per_cpu_ptr(mib[1], get_cpu())->mibs[field] += addend; \
-		put_cpu(); \
-	} while (0)
+#define SNMP_INC_STATS_BH(mib, field) __CPU_INC(mib[0]->mibs[field])
+#define SNMP_INC_STATS_USER(mib, field) _CPU_INC(mib[1]->mibs[field])
+#define SNMP_INC_STATS(mib, field) _CPU_INC(mib[!in_softirq()]->mibs[field])
+#define SNMP_DEC_STATS(mib, field) _CPU_DEC(mib[!in_softirq()]->mibs[field])
+#define SNMP_ADD_STATS_BH(mib, field, addend) \
+				__CPU_ADD(mib[0]->mibs[field], addend)
+#define SNMP_ADD_STATS_USER(mib, field, addend) \
+				_CPU_ADD(mib[1]->mibs[field], addend)
 
 #endif
Index: linux-2.6/net/ipv4/af_inet.c
===================================================================
--- linux-2.6.orig/net/ipv4/af_inet.c	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/net/ipv4/af_inet.c	2008-05-29 20:15:34.000000000 -0700
@@ -1279,8 +1279,8 @@ unsigned long snmp_fold_field(void *mib[
 	int i;
 
 	for_each_possible_cpu(i) {
-		res += *(((unsigned long *) per_cpu_ptr(mib[0], i)) + offt);
-		res += *(((unsigned long *) per_cpu_ptr(mib[1], i)) + offt);
+		res += *(((unsigned long *) CPU_PTR(mib[0], i)) + offt);
+		res += *(((unsigned long *) CPU_PTR(mib[1], i)) + offt);
 	}
 	return res;
 }
@@ -1289,26 +1289,28 @@ EXPORT_SYMBOL_GPL(snmp_fold_field);
 int snmp_mib_init(void *ptr[2], size_t mibsize)
 {
 	BUG_ON(ptr == NULL);
-	ptr[0] = __alloc_percpu(mibsize);
+	ptr[0] = cpu_alloc(mibsize, GFP_KERNEL | __GFP_ZERO,
+					L1_CACHE_BYTES);
 	if (!ptr[0])
 		goto err0;
-	ptr[1] = __alloc_percpu(mibsize);
+	ptr[1] = cpu_alloc(mibsize, GFP_KERNEL | __GFP_ZERO,
+					L1_CACHE_BYTES);
 	if (!ptr[1])
 		goto err1;
 	return 0;
 err1:
-	free_percpu(ptr[0]);
+	cpu_free(ptr[0], mibsize);
 	ptr[0] = NULL;
 err0:
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(snmp_mib_init);
 
-void snmp_mib_free(void *ptr[2])
+void snmp_mib_free(void *ptr[2], size_t mibsize)
 {
 	BUG_ON(ptr == NULL);
-	free_percpu(ptr[0]);
-	free_percpu(ptr[1]);
+	cpu_free(ptr[0], mibsize);
+	cpu_free(ptr[1], mibsize);
 	ptr[0] = ptr[1] = NULL;
 }
 EXPORT_SYMBOL_GPL(snmp_mib_free);
@@ -1370,17 +1372,18 @@ static int __init init_ipv4_mibs(void)
 	return 0;
 
 err_udplite_mib:
-	snmp_mib_free((void **)udp_statistics);
+	snmp_mib_free((void **)udp_statistics, sizeof(struct udp_mib));
 err_udp_mib:
-	snmp_mib_free((void **)tcp_statistics);
+	snmp_mib_free((void **)tcp_statistics, sizeof(struct tcp_mib));
 err_tcp_mib:
-	snmp_mib_free((void **)icmpmsg_statistics);
+	snmp_mib_free((void **)icmpmsg_statistics,
+					sizeof(struct icmpmsg_mib));
 err_icmpmsg_mib:
-	snmp_mib_free((void **)icmp_statistics);
+	snmp_mib_free((void **)icmp_statistics, sizeof(struct icmp_mib));
 err_icmp_mib:
-	snmp_mib_free((void **)ip_statistics);
+	snmp_mib_free((void **)ip_statistics, sizeof(struct ipstats_mib));
 err_ip_mib:
-	snmp_mib_free((void **)net_statistics);
+	snmp_mib_free((void **)net_statistics, sizeof(struct linux_mib));
 err_net_mib:
 	return -ENOMEM;
 }
Index: linux-2.6/net/ipv6/addrconf.c
===================================================================
--- linux-2.6.orig/net/ipv6/addrconf.c	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/net/ipv6/addrconf.c	2008-05-29 20:16:35.000000000 -0700
@@ -279,18 +279,19 @@ static int snmp6_alloc_dev(struct inet6_
 	return 0;
 
 err_icmpmsg:
-	snmp_mib_free((void **)idev->stats.icmpv6);
+	snmp_mib_free((void **)idev->stats.icmpv6, sizeof(struct icmpv6_mib));
 err_icmp:
-	snmp_mib_free((void **)idev->stats.ipv6);
+	snmp_mib_free((void **)idev->stats.ipv6, sizeof(struct ipstats_mib));
 err_ip:
 	return -ENOMEM;
 }
 
 static void snmp6_free_dev(struct inet6_dev *idev)
 {
-	snmp_mib_free((void **)idev->stats.icmpv6msg);
-	snmp_mib_free((void **)idev->stats.icmpv6);
-	snmp_mib_free((void **)idev->stats.ipv6);
+	snmp_mib_free((void **)idev->stats.icmpv6msg,
+						sizeof(struct icmpv6msg_mib));
+	snmp_mib_free((void **)idev->stats.icmpv6, sizeof(struct icmpv6_mib));
+	snmp_mib_free((void **)idev->stats.ipv6, sizeof(struct ipstats_mib));
 }
 
 /* Nobody refers to this device, we may destroy it. */
Index: linux-2.6/net/ipv6/af_inet6.c
===================================================================
--- linux-2.6.orig/net/ipv6/af_inet6.c	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/net/ipv6/af_inet6.c	2008-05-29 20:17:39.000000000 -0700
@@ -822,13 +822,14 @@ static int __init init_ipv6_mibs(void)
 	return 0;
 
 err_udplite_mib:
-	snmp_mib_free((void **)udp_stats_in6);
+	snmp_mib_free((void **)udp_stats_in6, sizeof(struct udp_mib));
 err_udp_mib:
-	snmp_mib_free((void **)icmpv6msg_statistics);
+	snmp_mib_free((void **)icmpv6msg_statistics,
+					sizeof(struct icmpv6msg_mib));
 err_icmpmsg_mib:
-	snmp_mib_free((void **)icmpv6_statistics);
+	snmp_mib_free((void **)icmpv6_statistics, sizeof(struct icmpv6_mib));
 err_icmp_mib:
-	snmp_mib_free((void **)ipv6_statistics);
+	snmp_mib_free((void **)ipv6_statistics, sizeof(struct ipstats_mib));
 err_ip_mib:
 	return -ENOMEM;
 
@@ -836,11 +837,12 @@ err_ip_mib:
 
 static void cleanup_ipv6_mibs(void)
 {
-	snmp_mib_free((void **)ipv6_statistics);
-	snmp_mib_free((void **)icmpv6_statistics);
-	snmp_mib_free((void **)icmpv6msg_statistics);
-	snmp_mib_free((void **)udp_stats_in6);
-	snmp_mib_free((void **)udplite_stats_in6);
+	snmp_mib_free((void **)ipv6_statistics, sizeof(struct ipstats_mib));
+	snmp_mib_free((void **)icmpv6_statistics, sizeof(struct icmpv6_mib));
+	snmp_mib_free((void **)icmpv6msg_statistics,
+						sizeof(struct icmpv6msg_mib));
+	snmp_mib_free((void **)udp_stats_in6, sizeof(struct udp_mib));
+	snmp_mib_free((void **)udplite_stats_in6, sizeof(struct udp_mib));
 }
 
 static int inet6_net_init(struct net *net)
Index: linux-2.6/net/dccp/proto.c
===================================================================
--- linux-2.6.orig/net/dccp/proto.c	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/net/dccp/proto.c	2008-05-29 20:18:05.000000000 -0700
@@ -1016,7 +1016,7 @@ static inline int dccp_mib_init(void)
 
 static inline void dccp_mib_exit(void)
 {
-	snmp_mib_free((void**)dccp_statistics);
+	snmp_mib_free((void **)dccp_statistics, sizeof(struct dccp_mib));
 }
 
 static int thash_entries;
Index: linux-2.6/net/sctp/protocol.c
===================================================================
--- linux-2.6.orig/net/sctp/protocol.c	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/net/sctp/protocol.c	2008-05-29 20:18:21.000000000 -0700
@@ -981,7 +981,7 @@ static inline int init_sctp_mibs(void)
 
 static inline void cleanup_sctp_mibs(void)
 {
-	snmp_mib_free((void**)sctp_statistics);
+	snmp_mib_free((void **)sctp_statistics, sizeof(struct sctp_mib));
 }
 
 static void sctp_v4_pf_init(void)
Index: linux-2.6/net/xfrm/xfrm_proc.c
===================================================================
--- linux-2.6.orig/net/xfrm/xfrm_proc.c	2008-05-29 19:41:20.000000000 -0700
+++ linux-2.6/net/xfrm/xfrm_proc.c	2008-05-29 20:19:10.000000000 -0700
@@ -51,8 +51,8 @@ fold_field(void *mib[], int offt)
         int i;
 
         for_each_possible_cpu(i) {
-                res += *(((unsigned long *)per_cpu_ptr(mib[0], i)) + offt);
-                res += *(((unsigned long *)per_cpu_ptr(mib[1], i)) + offt);
+		res += *(((unsigned long *)CPU_PTR(mib[0], i)) + offt);
+		res += *(((unsigned long *)CPU_PTR(mib[1], i)) + offt);
         }
         return res;
 }

-- 
