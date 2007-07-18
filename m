Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbXGRJdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbXGRJdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbXGRJcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:32:46 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:38902 "EHLO
	outbound8-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753032AbXGRJco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:32:44 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "lkml List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] make node distance writeable
Date: Wed, 18 Jul 2007 11:31:27 +0200
User-Agent: KMail/1.9.7
cc: gregkh@suse.de, "Andreas Kleen" <ak@suse.de>, lenb@kernel.org,
       "Christoph Lameter" <clameter@sgi.com>
References: <200707181130.01861.joachim.deguara@amd.com>
In-Reply-To: <200707181130.01861.joachim.deguara@amd.com>
MIME-Version: 1.0
Message-ID: <200707181131.27718.joachim.deguara@amd.com>
X-OriginalArrivalTime: 18 Jul 2007 09:32:25.0328 (UTC)
 FILETIME=[8CE3A700:01C7C91E]
X-WSS-ID: 6A8301A50X81901213-12-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the ability to write the node distance for NUMA systems.  This is 
generally handled by the SLIT but unfortunately the large majority of systems 
do not have a SLIT as Windows does not use them. Until now if no SLIT was 
found all remote nodes had a distance of 20 which is ok for 2P systems but 
wrong for 4P and larger.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>


--
Index: kernel/drivers/base/node.c
===================================================================
--- kernel.orig/drivers/base/node.c
+++ kernel/drivers/base/node.c
@@ -129,7 +129,30 @@ static ssize_t node_read_distance(struct
 	len += sprintf(buf + len, "\n");
 	return len;
 }
-static SYSDEV_ATTR(distance, S_IRUGO, node_read_distance, NULL);
+
+//takes a space seperated string as the distances of online nodes
+static ssize_t node_write_distance(struct sys_device * dev, const char * buf,
+					size_t size){
+	int i, ret;
+	u8 dist;
+
+	for_each_online_node(i){
+		if (i){
+			buf = strchr(buf, ' ');
+			buf++;
+		}
+		ret = sscanf(buf, "%hu", &dist);
+		if (!ret)
+			return -EINVAL;
+		if (dist < 10)
+			dist = 10;
+		set_node_distance(dev->id, i, dist);
+	}
+	return size;
+}
+
+static SYSDEV_ATTR(distance, S_IRUGO | S_IWUSR, node_read_distance,
+		node_write_distance);
 
 
 /*
Index: kernel/arch/x86_64/mm/srat.c
===================================================================
--- kernel.orig/arch/x86_64/mm/srat.c
+++ kernel/arch/x86_64/mm/srat.c
@@ -471,6 +471,18 @@ int __node_distance(int a, int b)
 
 EXPORT_SYMBOL(__node_distance);
 
+void __set_node_distance(int a, int b, u8 dist)
+{
+	int index;
+
+	if (!acpi_slit)
+		return;
+	index = acpi_slit->locality_count * node_to_pxm(a);
+	acpi_slit->entry[index + node_to_pxm(b)] = dist;
+}
+
+EXPORT_SYMBOL(__set_node_distance);
+
 int memory_add_physaddr_to_nid(u64 start)
 {
 	int i, ret = 0;
Index: kernel/include/asm-x86_64/topology.h
===================================================================
--- kernel.orig/include/asm-x86_64/topology.h
+++ kernel/include/asm-x86_64/topology.h
@@ -14,7 +14,9 @@ extern cpumask_t     node_to_cpumask[];
 
 #ifdef CONFIG_ACPI_NUMA
 extern int __node_distance(int, int);
+extern void __set_node_distance(int, int, u8);
 #define node_distance(a,b) __node_distance(a,b)
+#define set_node_distance(a,b,dist) __set_node_distance(a,b,dist)
 /* #else fallback version */
 #endif
 


