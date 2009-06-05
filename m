Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbZFEW3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbZFEW3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZFEW2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:28:53 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:52272 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754753AbZFEW2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:28:52 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 4
	times
Message-Id: <20090605191850.633645745@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:21 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu
Cc: rusty@rustcorp.com.au
Cc: davem@davemloft.net
Subject: [this_cpu_xx 02/11] Use this_cpu operations for SNMP statistics
Content-Disposition: inline; filename=this_cpu_snmp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SNMP statistics macros can be signficantly simplified.
This will also reduce code size if the arch supports these operations
in harware.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/net/snmp.h |   37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

Index: linux-2.6/include/net/snmp.h
===================================================================
--- linux-2.6.orig/include/net/snmp.h	2009-06-03 13:48:02.000000000 -0500
+++ linux-2.6/include/net/snmp.h	2009-06-03 14:27:51.000000000 -0500
@@ -136,29 +136,16 @@ struct linux_xfrm_mib {
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
-
+#define SNMP_INC_STATS_BH(mib, field)	\
+			__this_cpu_inc(mib[0]->mibs[field])
+#define SNMP_INC_STATS_USER(mib, field)	\
+			this_cpu_inc(mib[1]->mibs[field])
+#define SNMP_INC_STATS(mib, field)	\
+			this_cpu_inc(mib[!in_softirq()]->mibs[field])
+#define SNMP_DEC_STATS(mib, field)	\
+		 	this_cpu_dec(mib[!in_softirq()]->mibs[field])
+#define SNMP_ADD_STATS_BH(mib, field, addend)	\
+			__this_cpu_add(mib[0]->mibs[field], addend)
+#define SNMP_ADD_STATS_USER(mib, field, addend)	\
+			this_cpu_add(mib[1]->mibs[field], addend)
 #endif

-- 
