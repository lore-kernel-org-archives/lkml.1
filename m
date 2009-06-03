Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZFCOaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZFCOaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZFCOaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:30:05 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:22070 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZFCOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:30:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(z34a4jzzz1202hzzz32i1a3h6bh17ch63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KKO2XO-02-TOC-01
Date: Wed, 3 Jun 2009 16:29:08 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH 1/5] topology: introduce cpu_node information for
	multi-node processors
Message-ID: <20090603142908.GJ5736@alberich.amd.com>
References: <20090603142727.GI5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090603142727.GI5736@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Jun 2009 14:29:54.0138 (UTC) FILETIME=[C2FC6BA0:01C9E457]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


New topology attributes are
- cpu_node_id (id of the internal node)
- cpu_node_siblings and cpu_node_siblings_list
  (siblings on the same internal node)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/base/topology.c  |   10 ++++++++++
 include/linux/topology.h |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index bf6b132..1e35a43 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -103,6 +103,9 @@ static ssize_t show_##name##_list(struct sys_device *dev,		\
 define_id_show_func(physical_package_id);
 define_one_ro(physical_package_id);
 
+define_id_show_func(cpu_node_id);
+define_one_ro(cpu_node_id);
+
 define_id_show_func(core_id);
 define_one_ro(core_id);
 
@@ -110,6 +113,10 @@ define_siblings_show_func(thread_cpumask);
 define_one_ro_named(thread_siblings, show_thread_cpumask);
 define_one_ro_named(thread_siblings_list, show_thread_cpumask_list);
 
+define_siblings_show_func(cpu_node_cpumask);
+define_one_ro_named(cpu_node_siblings, show_cpu_node_cpumask);
+define_one_ro_named(cpu_node_siblings_list, show_cpu_node_cpumask_list);
+
 define_siblings_show_func(core_cpumask);
 define_one_ro_named(core_siblings, show_core_cpumask);
 define_one_ro_named(core_siblings_list, show_core_cpumask_list);
@@ -119,6 +126,9 @@ static struct attribute *default_attrs[] = {
 	&attr_core_id.attr,
 	&attr_thread_siblings.attr,
 	&attr_thread_siblings_list.attr,
+	&attr_cpu_node_id.attr,
+	&attr_cpu_node_siblings.attr,
+	&attr_cpu_node_siblings_list.attr,
 	&attr_core_siblings.attr,
 	&attr_core_siblings_list.attr,
 	NULL
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7402c1a..976a130 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -180,6 +180,9 @@ int arch_update_cpu_topology(void);
 #ifndef topology_physical_package_id
 #define topology_physical_package_id(cpu)	((void)(cpu), -1)
 #endif
+#ifndef topology_cpu_node_id
+#define topology_cpu_node_id(cpu)		((void)(cpu), 0)
+#endif
 #ifndef topology_core_id
 #define topology_core_id(cpu)			((void)(cpu), 0)
 #endif
@@ -189,12 +192,18 @@ int arch_update_cpu_topology(void);
 #ifndef topology_core_siblings
 #define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
 #endif
+#ifndef topology_cpu_node_siblings
+#define topology_cpu_node_siblings(cpu)		topology_core_siblings(cpu)
+#endif
 #ifndef topology_thread_cpumask
 #define topology_thread_cpumask(cpu)		cpumask_of(cpu)
 #endif
 #ifndef topology_core_cpumask
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
+#ifndef topology_cpu_node_cpumask
+#define topology_cpu_node_cpumask(cpu)		topology_core_cpumask(cpu)
+#endif
 
 /* Returns the number of the current Node. */
 #ifndef numa_node_id
-- 
1.6.3.1



