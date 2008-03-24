Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbYCXSXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbYCXSXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760833AbYCXSVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:21:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42453 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761649AbYCXSVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:21:21 -0400
Date: Mon, 24 Mar 2008 13:21:19 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC 7/8] x86_64: Define the macros and tables for blade functions
Message-ID: <20080324182119.GA28318@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add UV macros for converting between cpu numbers, blade numbers
and node numbers. Note that these are used ONLY within x86_64 UV
modules, and are not for general kernel use.

	Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 include/asm-x86/uv_hub.h |   74 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

Index: linux/include/asm-x86/uv_hub.h
===================================================================
--- linux.orig/include/asm-x86/uv_hub.h	2008-03-21 15:48:18.000000000 -0500
+++ linux/include/asm-x86/uv_hub.h	2008-03-21 15:49:26.000000000 -0500
@@ -213,5 +213,79 @@ static inline void uv_write_local_mmr(un
 	*uv_local_mmr_address(offset) = val;
 }
 
+/*
+ * Structures and definitions for converting between cpu, node, and blade
+ * numbers.
+ */
+struct uv_blade_info {
+	unsigned short	nr_posible_cpus;
+	unsigned short	nr_online_cpus;
+	unsigned short	nasid;
+};
+struct uv_blade_info *uv_blade_info;
+extern short *uv_node_to_blade;
+extern short *uv_cpu_to_blade;
+extern short uv_possible_blades;
+
+/* Blade-local cpu number of current cpu. Numbered 0 .. <# cpus on the blade> */
+static inline int uv_blade_processor_id(void)
+{
+	return uv_hub_info->blade_processor_id;
+}
+
+/* Blade number of current cpu. Numnbered 0 .. <#blades -1> */
+static inline int uv_numa_blade_id(void)
+{
+	return uv_hub_info->numa_blade_id;
+}
+
+/* Convert a cpu number to the the UV blade number */
+static inline int uv_cpu_to_blade_id(int cpu)
+{
+	return uv_cpu_to_blade[cpu];
+}
+
+/* Convert linux node number to the UV blade number */
+static inline int uv_node_to_blade_id(int nid)
+{
+	return uv_node_to_blade[nid];
+}
+
+/* Convert a blade id to the NASID of the blade */
+static inline int uv_blade_to_nasid(int bid)
+{
+	return uv_blade_info[bid].nasid;
+}
+
+/* Determine the number of possible cpus on a blade */
+static inline int uv_blade_nr_possible_cpus(int bid)
+{
+	return uv_blade_info[bid].nr_posible_cpus;
+}
+
+/* Determine the number of online cpus on a blade */
+static inline int uv_blade_nr_online_cpus(int bid)
+{
+	return uv_blade_info[bid].nr_online_cpus;
+}
+
+/* Convert a cpu id to the NASID of the blade containing the cpu */
+static inline int uv_cpu_to_nasid(int cpu)
+{
+	return uv_blade_info[uv_cpu_to_blade_id(cpu)].nasid;
+}
+
+/* Convert a node number to the NASID of the blade */
+static inline int uv_node_to_nasid(int nid)
+{
+	return uv_blade_info[uv_node_to_blade_id(nid)].nasid;
+}
+
+/* Maximum possible number of blades */
+static inline int uv_num_possible_blades(void)
+{
+	return uv_possible_blades;
+}
+
 #endif /* __ASM_X86_UV_HUB__ */
 
