Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbZJGEfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbZJGEfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbZJGEfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:35:32 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:55537 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752632AbZJGEfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:35:31 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091006233730.091617018@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
User-Agent: quilt/0.46-1
Date: Tue, 06 Oct 2009 19:36:57 -0400
From: cl@linux-foundation.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [this_cpu_xx V5 03/19] Use this_cpu operations for SNMP statistics
Content-Disposition: inline; filename=this_cpu_snmp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNMP statistic macros can be signficantly simplified.
This will also reduce code size if the arch supports these operations
in hardware.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/net/snmp.h |   50 ++++++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2009-09-30 11:37:26.000000000 -0500
+++ linux-2.6/include/net/snmp.h	2009-09-30 12:57:48.000000000 -0500
@@ -136,45 +136,31 @@ struct linux_xfrm_mib {
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
-#define SNMP_ADD_STATS(mib, field, addend) 	\
-	do { \
-		per_cpu_ptr(mib[!in_softirq()], get_cpu())->mibs[field] += addend; \
-		put_cpu(); \
-	} while (0)
-#define SNMP_ADD_STATS_BH(mib, field, addend) 	\
-	(per_cpu_ptr(mib[0], raw_smp_processor_id())->mibs[field] += addend)
-#define SNMP_ADD_STATS_USER(mib, field, addend) 	\
-	do { \
-		per_cpu_ptr(mib[1], get_cpu())->mibs[field] += addend; \
-		put_cpu(); \
-	} while (0)
+#define SNMP_INC_STATS_BH(mib, field)	\
+			__this_cpu_inc(mib[0]->mibs[field])
+#define SNMP_INC_STATS_USER(mib, field)	\
+			this_cpu_inc(mib[1]->mibs[field])
+#define SNMP_INC_STATS(mib, field)	\
+			this_cpu_inc(mib[!in_softirq()]->mibs[field])
+#define SNMP_DEC_STATS(mib, field)	\
+			this_cpu_dec(mib[!in_softirq()]->mibs[field])
+#define SNMP_ADD_STATS_BH(mib, field, addend)	\
+			__this_cpu_add(mib[0]->mibs[field], addend)
+#define SNMP_ADD_STATS_USER(mib, field, addend)	\
+			this_cpu_add(mib[1]->mibs[field], addend)
 #define SNMP_UPD_PO_STATS(mib, basefield, addend)	\
 	do { \
-		__typeof__(mib[0]) ptr = per_cpu_ptr(mib[!in_softirq()], get_cpu());\
+		__typeof__(mib[0]) ptr; \
+		preempt_disable(); \
+		ptr = this_cpu_ptr((mib)[!in_softirq()]); \
 		ptr->mibs[basefield##PKTS]++; \
 		ptr->mibs[basefield##OCTETS] += addend;\
-		put_cpu(); \
+		preempt_enable(); \
 	} while (0)
 #define SNMP_UPD_PO_STATS_BH(mib, basefield, addend)	\
 	do { \
-		__typeof__(mib[0]) ptr = per_cpu_ptr(mib[!in_softirq()], raw_smp_processor_id());\
+		__typeof__(mib[0]) ptr = \
+			__this_cpu_ptr((mib)[!in_softirq()]); \
 		ptr->mibs[basefield##PKTS]++; \
 		ptr->mibs[basefield##OCTETS] += addend;\
 	} while (0)

-- 
