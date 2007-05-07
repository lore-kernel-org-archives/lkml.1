Return-Path: <linux-kernel-owner+w=401wt.eu-S965965AbXEGQff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965AbXEGQff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbXEGQf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:35:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965964AbXEGQfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:35:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=kn4rd8Dzkxd+ghVbzttj/hO3gBkQlwdGu+0O6+tvpGMceiEgPP9qJzBEdIxWXSOTx
	C85GL09R3lnjJN/T9alLQ==
Date: Mon, 7 May 2007 09:34:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: [patch 1/4] x86_64 acpi: define and use LOCAL_DISTANCE and
 REMOTE_DISTANCE
Message-ID: <Pine.LNX.4.64.0705070028560.1899@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export {LOCAL,REMOTE}_DISTANCE to x86_64 ACPI code.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86_64/mm/srat.c    |    6 +++---
 include/linux/topology.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -106,9 +106,9 @@ static __init int slit_valid(struct acpi_table_slit *slit)
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
 			if (i == j) {
-				if (val != 10)
+				if (val != LOCAL_DISTANCE)
 					return 0;
-			} else if (val <= 10)
+			} else if (val <= LOCAL_DISTANCE)
 				return 0;
 		}
 	}
@@ -464,7 +464,7 @@ int __node_distance(int a, int b)
 	int index;
 
 	if (!acpi_slit)
-		return a == b ? 10 : 20;
+		return a == b ? LOCAL_DISTANCE : REMOTE_DISTANCE;
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
diff --git a/include/linux/topology.h b/include/linux/topology.h
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -50,10 +50,10 @@
 	for_each_online_node(node)						\
 		if (nr_cpus_node(node))
 
-#ifndef node_distance
 /* Conform to ACPI 2.0 SLIT distance definitions */
 #define LOCAL_DISTANCE		10
 #define REMOTE_DISTANCE		20
+#ifndef node_distance
 #define node_distance(from,to)	((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)
 #endif
 #ifndef RECLAIM_DISTANCE
