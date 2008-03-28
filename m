Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbYC1TOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbYC1TOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbYC1TMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:12:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53326 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756217AbYC1TMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:12:16 -0400
Date: Fri, 28 Mar 2008 14:12:14 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] x86_64: Define the macros and tables for blade functions
Message-ID: <20080328191214.GA16450@sgi.com>
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

Based on:
        git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 include/asm-x86/uv/uv_hub.h |   74 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

Index: linux/include/asm-x86/uv/uv_hub.h
===================================================================
--- linux.orig/include/asm-x86/uv/uv_hub.h	2008-03-27 12:47:39.000000000 -0500
+++ linux/include/asm-x86/uv/uv_hub.h	2008-03-27 12:47:45.000000000 -0500
@@ -206,5 +206,79 @@ static inline void uv_write_local_mmr(un
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
 
