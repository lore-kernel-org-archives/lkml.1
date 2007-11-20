Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbXKTBWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbXKTBWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbXKTBOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:01 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36874 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755641AbXKTBNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:38 -0500
Message-Id: <20071120011338.111856563@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:59 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 27/45] cpu alloc: convert mib handling to cpu alloc
Content-Disposition: inline; filename=0035-cpu-alloc-convert-mib-handling-to-cpu-alloc.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the cpu alloc functions for the mib handling functions in the net
layer. The API for snmp_mib_free() is changed to add a size parameter
since cpu_fre requires that.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/net/ip.h    |    2 +-
 include/net/snmp.h  |   15 +++++++--------
 net/dccp/proto.c    |   12 +++++++-----
 net/ipv4/af_inet.c  |   31 +++++++++++++++++--------------
 net/ipv6/addrconf.c |   10 +++++-----
 net/ipv6/af_inet6.c |   18 +++++++++---------
 net/sctp/proc.c     |    4 ++--
 net/sctp/protocol.c |   12 +++++++-----
 8 files changed, 55 insertions(+), 49 deletions(-)

Index: linux-2.6/include/net/ip.h
===================================================================
--- linux-2.6.orig/include/net/ip.h	2007-11-18 14:38:23.385283253 -0800
+++ linux-2.6/include/net/ip.h	2007-11-18 21:55:27.684797168 -0800
@@ -170,7 +170,7 @@ DECLARE_SNMP_STAT(struct linux_mib, net_
 
 extern unsigned long snmp_fold_field(void *mib[], int offt);
 extern int snmp_mib_init(void *ptr[2], size_t mibsize, size_t mibalign);
-extern void snmp_mib_free(void *ptr[2]);
+extern void snmp_mib_free(void *ptr[2], size_t mibsize);
 
 extern void inet_get_local_port_range(int *low, int *high);
 
Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2007-11-18 14:38:23.393283116 -0800
+++ linux-2.6/include/net/snmp.h	2007-11-18 22:04:47.477773921 -0800
@@ -132,19 +132,18 @@ struct linux_mib {
 #define SNMP_STAT_BHPTR(name)	(name[0])
 #define SNMP_STAT_USRPTR(name)	(name[1])
 
-#define SNMP_INC_STATS_BH(mib, field) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field]++)
+#define SNMP_INC_STATS_BH(mib, field) __CPU_INC(mib[0]->mibs[field])
 #define SNMP_INC_STATS_OFFSET_BH(mib, field, offset)	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field + (offset)]++)
+	__CPU_INC(mib[0]->mibs[field + (offset)])
 #define SNMP_INC_STATS_USER(mib, field) \
-	(per_cpu_ptr(mib[1], raw_smp_processor_id())->mibs[field]++)
+	__CPU_INC(mib[1]->mibs[field])
 #define SNMP_INC_STATS(mib, field) 	\
-	(per_cpu_ptr(mib[!in_softirq()], raw_smp_processor_id())->mibs[field]++)
+	__CPU_INC(mib[!in_softirq()]->mibs[field])
 #define SNMP_DEC_STATS(mib, field) 	\
-	(per_cpu_ptr(mib[!in_softirq()], raw_smp_processor_id())->mibs[field]--)
+	__CPU_DEC(mib[!in_softirq()]->mibs[field])
 #define SNMP_ADD_STATS_BH(mib, field, addend) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field] += addend)
+	__CPU_ADD(mib[0]->mibs[field], addend)
 #define SNMP_ADD_STATS_USER(mib, field, addend) 	\
-	(per_cpu_ptr(mib[1], raw_smp_processor_id())->mibs[field] += addend)
+	__CPU_ADD(mib[1]->mibs[field], addend)
 
 #endif
Index: linux-2.6/net/dccp/proto.c
===================================================================
--- linux-2.6.orig/net/dccp/proto.c	2007-11-18 14:38:23.397283534 -0800
+++ linux-2.6/net/dccp/proto.c	2007-11-18 21:55:27.704797139 -0800
@@ -990,11 +990,13 @@ static int __init dccp_mib_init(void)
 {
 	int rc = -ENOMEM;
 
-	dccp_statistics[0] = alloc_percpu(struct dccp_mib);
+	dccp_statistics[0] = CPU_ALLOC(struct dccp_mib,
+					GFP_KERNEL | __GFP_ZERO);
 	if (dccp_statistics[0] == NULL)
 		goto out;
 
-	dccp_statistics[1] = alloc_percpu(struct dccp_mib);
+	dccp_statistics[1] = CPU_ALLOC(struct dccp_mib,
+					GFP_KERNEL | __GFP_ZERO);
 	if (dccp_statistics[1] == NULL)
 		goto out_free_one;
 
@@ -1002,7 +1004,7 @@ static int __init dccp_mib_init(void)
 out:
 	return rc;
 out_free_one:
-	free_percpu(dccp_statistics[0]);
+	CPU_FREE(dccp_statistics[0]);
 	dccp_statistics[0] = NULL;
 	goto out;
 
@@ -1010,8 +1012,8 @@ out_free_one:
 
 static void dccp_mib_exit(void)
 {
-	free_percpu(dccp_statistics[0]);
-	free_percpu(dccp_statistics[1]);
+	CPU_FREE(dccp_statistics[0]);
+	CPU_FREE(dccp_statistics[1]);
 	dccp_statistics[0] = dccp_statistics[1] = NULL;
 }
 
Index: linux-2.6/net/ipv4/af_inet.c
===================================================================
--- linux-2.6.orig/net/ipv4/af_inet.c	2007-11-18 14:38:23.405283096 -0800
+++ linux-2.6/net/ipv4/af_inet.c	2007-11-18 21:55:27.725047497 -0800
@@ -1230,8 +1230,8 @@ unsigned long snmp_fold_field(void *mib[
 	int i;
 
 	for_each_possible_cpu(i) {
-		res += *(((unsigned long *) per_cpu_ptr(mib[0], i)) + offt);
-		res += *(((unsigned long *) per_cpu_ptr(mib[1], i)) + offt);
+		res += *(((unsigned long *) CPU_PTR(mib[0], i)) + offt);
+		res += *(((unsigned long *) CPU_PTR(mib[1], i)) + offt);
 	}
 	return res;
 }
@@ -1240,26 +1240,28 @@ EXPORT_SYMBOL_GPL(snmp_fold_field);
 int snmp_mib_init(void *ptr[2], size_t mibsize, size_t mibalign)
 {
 	BUG_ON(ptr == NULL);
-	ptr[0] = __alloc_percpu(mibsize);
+	ptr[0] = cpu_alloc(mibsize, GFP_KERNEL | __GFP_ZERO,
+					mibalign);
 	if (!ptr[0])
 		goto err0;
-	ptr[1] = __alloc_percpu(mibsize);
+	ptr[1] = cpu_alloc(mibsize, GFP_KERNEL | __GFP_ZERO,
+					mibalign);
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
@@ -1324,17 +1326,18 @@ static int __init init_ipv4_mibs(void)
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
--- linux-2.6.orig/net/ipv6/addrconf.c	2007-11-18 14:38:23.413283686 -0800
+++ linux-2.6/net/ipv6/addrconf.c	2007-11-18 21:55:27.749296774 -0800
@@ -271,18 +271,18 @@ static int snmp6_alloc_dev(struct inet6_
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
+	snmp_mib_free((void **)idev->stats.icmpv6msg, sizeof(struct icmpv6_mib));
+	snmp_mib_free((void **)idev->stats.icmpv6, sizeof(struct icmpv6_mib));
+	snmp_mib_free((void **)idev->stats.ipv6, sizeof(struct ipstats_mib));
 }
 
 /* Nobody refers to this device, we may destroy it. */
Index: linux-2.6/net/ipv6/af_inet6.c
===================================================================
--- linux-2.6.orig/net/ipv6/af_inet6.c	2007-11-18 14:38:23.417283064 -0800
+++ linux-2.6/net/ipv6/af_inet6.c	2007-11-18 21:55:27.756797042 -0800
@@ -731,13 +731,13 @@ static int __init init_ipv6_mibs(void)
 	return 0;
 
 err_udplite_mib:
-	snmp_mib_free((void **)udp_stats_in6);
+	snmp_mib_free((void **)udp_stats_in6, sizeof(struct udp_mib));
 err_udp_mib:
-	snmp_mib_free((void **)icmpv6msg_statistics);
+	snmp_mib_free((void **)icmpv6msg_statistics, sizeof(struct icmpv6_mib));
 err_icmpmsg_mib:
-	snmp_mib_free((void **)icmpv6_statistics);
+	snmp_mib_free((void **)icmpv6_statistics, sizeof(struct icmpv6_mib));
 err_icmp_mib:
-	snmp_mib_free((void **)ipv6_statistics);
+	snmp_mib_free((void **)ipv6_statistics, sizeof(struct ipstats_mib));
 err_ip_mib:
 	return -ENOMEM;
 
@@ -745,11 +745,11 @@ err_ip_mib:
 
 static void cleanup_ipv6_mibs(void)
 {
-	snmp_mib_free((void **)ipv6_statistics);
-	snmp_mib_free((void **)icmpv6_statistics);
-	snmp_mib_free((void **)icmpv6msg_statistics);
-	snmp_mib_free((void **)udp_stats_in6);
-	snmp_mib_free((void **)udplite_stats_in6);
+	snmp_mib_free((void **)ipv6_statistics, sizeof(struct ipstats_mib));
+	snmp_mib_free((void **)icmpv6_statistics, sizeof(struct icmpv6_mib));
+	snmp_mib_free((void **)icmpv6msg_statistics, sizeof(struct icmpv6_mib));
+	snmp_mib_free((void **)udp_stats_in6, sizeof(struct udp_mib));
+	snmp_mib_free((void **)udplite_stats_in6, sizeof(struct udp_mib));
 }
 
 static int __init inet6_init(void)
Index: linux-2.6/net/sctp/proc.c
===================================================================
--- linux-2.6.orig/net/sctp/proc.c	2007-11-18 14:38:23.425283197 -0800
+++ linux-2.6/net/sctp/proc.c	2007-11-18 21:55:27.772797109 -0800
@@ -86,10 +86,10 @@ fold_field(void *mib[], int nr)
 
 	for_each_possible_cpu(i) {
 		res +=
-		    *((unsigned long *) (((void *) per_cpu_ptr(mib[0], i)) +
+		    *((unsigned long *) (((void *)CPU_PTR(mib[0], i)) +
 					 sizeof (unsigned long) * nr));
 		res +=
-		    *((unsigned long *) (((void *) per_cpu_ptr(mib[1], i)) +
+		    *((unsigned long *) (((void *)CPU_PTR(mib[1], i)) +
 					 sizeof (unsigned long) * nr));
 	}
 	return res;
Index: linux-2.6/net/sctp/protocol.c
===================================================================
--- linux-2.6.orig/net/sctp/protocol.c	2007-11-18 14:38:23.433283093 -0800
+++ linux-2.6/net/sctp/protocol.c	2007-11-18 21:55:27.784297095 -0800
@@ -970,12 +970,14 @@ int sctp_register_pf(struct sctp_pf *pf,
 
 static int __init init_sctp_mibs(void)
 {
-	sctp_statistics[0] = alloc_percpu(struct sctp_mib);
+	sctp_statistics[0] = CPU_ALLOC(struct sctp_mib,
+					GFP_KERNEL | __GFP_ZERO);
 	if (!sctp_statistics[0])
 		return -ENOMEM;
-	sctp_statistics[1] = alloc_percpu(struct sctp_mib);
+	sctp_statistics[1] = CPU_ALLOC(struct sctp_mib,
+					GFP_KERNEL | __GFP_ZERO);
 	if (!sctp_statistics[1]) {
-		free_percpu(sctp_statistics[0]);
+		CPU_FREE(sctp_statistics[0]);
 		return -ENOMEM;
 	}
 	return 0;
@@ -984,8 +986,8 @@ static int __init init_sctp_mibs(void)
 
 static void cleanup_sctp_mibs(void)
 {
-	free_percpu(sctp_statistics[0]);
-	free_percpu(sctp_statistics[1]);
+	CPU_FREE(sctp_statistics[0]);
+	CPU_FREE(sctp_statistics[1]);
 }
 
 /* Initialize the universe into something sensible.  */

-- 
