Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540Ab0ABGQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab0ABGQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 01:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542Ab0ABGQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 01:16:48 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:49832 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab0ABGQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 01:16:47 -0500
From: David John <davidjon@xenontk.org>
To: jbarnes@virtuousgeek.org, rusty@rustcorp.com.au
Cc: andreas.herrmann3@amd.com, rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Check the node argument passed to cpumask_of_node
Date: Sat,  2 Jan 2010 11:45:47 +0530
Message-Id: <1262412947-3890-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: BlackWidow
In-Reply-To: <201001012255.28094.rjw@sisk.pl>
References: <201001012255.28094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e0cd516 "PCI: derive nearby CPUs from device's instead of bus' NUMA information"
causes an null pointer dereference when reading from the sysfs attributes local_cpu*
on Intel machines with no ACPI NUMA proximity info, since dev->numa_node gets set to -1
for all PCI devices, which then gets passed to cpumask_of_node.

Ensure that the node value is valid.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index c5087d7..1141a6e 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -99,7 +99,8 @@ extern const struct cpumask *cpumask_of_node(int node);
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
 static inline const struct cpumask *cpumask_of_node(int node)
 {
-	return node_to_cpumask_map[node];
+	return (node < 0 || node >= nr_node_ids) ? cpu_online_mask :
+						   node_to_cpumask_map[node];
 }
 #endif
 
