Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbXKFT7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbXKFT7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbXKFTwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45424 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756224AbXKFTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:04 -0500
Message-Id: <20071106195203.138276895@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:08 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 24/28] cpu alloc: convert mib handling to cpu alloc
Content-Disposition: inline; filename=cpu_alloc_net_snmp
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the cpu alloc functions for the mib handling functions in the net
layer. The API for snmp_mib_free() is changed to add a size parameter
since cpu_fre requires that.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/net/ip.h    |    2 +-
 include/net/snmp.h  |   14 +++++++-------
 net/dccp/proto.c    |   12 +++++++-----
 net/ipv4/af_inet.c  |   32 ++++++++++++++++++--------------
 net/ipv6/addrconf.c |   10 +++++-----
 net/ipv6/af_inet6.c |   18 +++++++++---------
 net/sctp/proc.c     |    4 ++--
 net/sctp/protocol.c |   13 ++++++++-----
 8 files changed, 57 insertions(+), 48 deletions(-)

Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2007-11-04 20:19:49.000000000 -0800
+++ linux-2.6/include/net/snmp.h	2007-11-04 20:57:16.000000000 -0800
@@ -133,18 +133,18 @@ struct linux_mib {
 #define SNMP_STAT_USRPTR(name)	(name[1])
 
 #define SNMP_INC_STATS_BH(mib, field) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field]++)
+	(__THIS_CPU(mib[0])->mibs[field]++)
 #define SNMP_INC_STATS_OFFSET_BH(mib, field, offset)	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field + (offset)]++)
+	(__THIS_CPU(mib[0])->mibs[field + (offset)]++)
 #define SNMP_INC_STATS_USER(mib, field) \
-	(per_cpu_ptr(mib[1], raw_smp_processor_id())->mibs[field]++)
+	(__THIS_CPU(mib[1])->mibs[field]++)
 #define SNMP_INC_STATS(mib, field) 	\
-	(per_cpu_ptr(mib[!in_softirq()], raw_smp_processor_id())->mibs[field]++)
+	(__THIS_CPU(mib[!in_softirq()])->mibs[field]++)
 #define SNMP_DEC_STATS(mib, field) 	\
-	(per_cpu_ptr(mib[!in_softirq()], raw_smp_processor_id())->mibs[field]--)
+	(__THIS_CPU(mib[!in_softirq()])->mibs[field]--)
 #define SNMP_ADD_STATS_BH(mib, field, addend) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field] += addend)
+	(__THIS_CPU(mib[0])->mibs[field] += addend)
 #define SNMP_ADD_STATS_USER(mib, field, addend) 	\
-	(per_cpu_ptr(mib[1], raw_smp_processor_id())->mibs[field] += addend)
+	(__THIS_CPU(mib[1])->mibs[field] += addend)
 
 #endif
Index: linux-2.6/net/dccp/proto.c
===================================================================
--- linux-2.6.orig/net/dccp/proto.c	2007-11-04 20:19:49.000000000 -0800
+++ linux-2.6/net/dccp/proto.c	2007-11-04 20:57:16.000000000 -0800
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
 
Index: linux-2.6/net/sctp/protocol.c
===================================================================
--- linux-2.6.orig/net/sctp/protocol.c	2007-11-04 20:19:49.000000000 -0800
+++ linux-2.6/net/sctp/protocol.c	2007-11-04 21:11:37.000000000 -0800
@@ -61,6 +61,7 @@
 #include <net/addrconf.h>
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
+#include <linux/cpu_alloc.h>
 
 /* Global data structures. */
 struct sctp_globals sctp_globals __read_mostly;
@@ -970,12 +971,14 @@ int sctp_register_pf(struct sctp_pf *pf,
 
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
@@ -984,8 +987,8 @@ static int __init init_sctp_mibs(void)
 
 static void cleanup_sctp_mibs(void)
 {
-	free_percpu(sctp_statistics[0]);
-	free_percpu(sctp_statistics[1]);
+	CPU_FREE(sctp_statistics[0]);
+	CPU_FREE(sctp_statistics[1]);
 }
 
 /* Initialize the universe into something sensible.  */
Index: linux-2.6/net/ipv4/af_inet.c
===================================================================
--- linux-2.6.orig/net/ipv4/af_inet.c	2007-11-04 20:19:49.000000000 -0800
+++ linux-2.6/net/ipv4/af_inet.c	2007-11-04 21:01:34.000000000 -0800
@@ -88,6 +88,7 @@
 #include <linux/poll.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/random.h>
+#include <linux/cpu_alloc.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -1230,8 +1231,8 @@ unsigned long snmp_fold_field(void *mib[
 	int i;
 
 	for_each_possible_cpu(i) {
-		res += *(((unsigned long *) per_cpu_ptr(mib[0], i)) + offt);
-		res += *(((unsigned long *) per_cpu_ptr(mib[1], i)) + offt);
+		res += *(((unsigned long *) CPU_PTR(mib[0], i)) + offt);
+		res += *(((unsigned long *) CPU_PTR(mib[1], i)) + offt);
 	}
 	return res;
 }
@@ -1240,26 +1241,28 @@ EXPORT_SYMBOL_GPL(snmp_fold_field);
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
@@ -1324,17 +1327,18 @@ static int __init init_ipv4_mibs(void)
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
Index: linux-2.6/net/sctp/proc.c
===================================================================
--- linux-2.6.orig/net/sctp/proc.c	2007-11-04 20:19:49.000000000 -0800
+++ linux-2.6/net/sctp/proc.c	2007-11-04 20:57:16.000000000 -0800
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
Index: linux-2.6/include/net/ip.h
===================================================================
--- linux-2.6.orig/include/net/ip.h	2007-11-04 20:58:19.000000000 -0800
+++ linux-2.6/include/net/ip.h	2007-11-04 20:58:30.000000000 -0800
@@ -170,7 +170,7 @@ DECLARE_SNMP_STAT(struct linux_mib, net_
 
 extern unsigned long snmp_fold_field(void *mib[], int offt);
 extern int snmp_mib_init(void *ptr[2], size_t mibsize, size_t mibalign);
-extern void snmp_mib_free(void *ptr[2]);
+extern void snmp_mib_free(void *ptr[2], size_t mibsize);
 
 extern void inet_get_local_port_range(int *low, int *high);
 
Index: linux-2.6/net/ipv6/addrconf.c
===================================================================
--- linux-2.6.orig/net/ipv6/addrconf.c	2007-11-04 21:06:09.000000000 -0800
+++ linux-2.6/net/ipv6/addrconf.c	2007-11-04 21:07:56.000000000 -0800
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
--- linux-2.6.orig/net/ipv6/af_inet6.c	2007-11-04 21:02:39.000000000 -0800
+++ linux-2.6/net/ipv6/af_inet6.c	2007-11-04 21:05:36.000000000 -0800
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

-- 
