Return-Path: <linux-kernel-owner+w=401wt.eu-S1762167AbXEPQKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762167AbXEPQKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbXEPQKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:10:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23336 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXEPQKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:10:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=afctwYAxmzabYHAy6fHU+GPUuI7/N5YR0XyU3sK7W8YiCeYz5WIVIk3v5sLCTY6Ww
	DOeiEIAgY0OkTuspDma7w==
Date: Wed, 16 May 2007 09:09:11 -0700
From: Aaron Durbin <adurbin@google.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, len.brown@intel.com
Subject: [PATCH] acpi: Fix potential call to a freed memory section.
Message-ID: <20070516160911.GA15066@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Strip __cpuinit[data] from Node <-> PXM routines and supporting data structures.
Also make pxm_to_node_map and node_to_pxm_map local to the numa acpi module.

This fixes a bug triggered by the following conditions:
- boot on a machine with a SLIT table defined
- kernel is configured w/ CONFIG_HOTPLUG_CPU=n
- cat /sys/devices/system/node/node*/distance
This will cause an oops by calling into a freed memory section.

In particular, on x86_64, __node_distance calls node_to_pxm().

Signed-off-by: Aaron Durbin <adurbin@google.com>
---

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index 8fcd6a1..a2efae8 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -40,19 +40,19 @@ #define PXM_INVAL	-1
 #define NID_INVAL	-1
 
 /* maps to convert between proximity domain and logical node ID */
-int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
+static int pxm_to_node_map[MAX_PXM_DOMAINS]
 				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
-int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
+static int node_to_pxm_map[MAX_NUMNODES]
 				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
-int __cpuinit pxm_to_node(int pxm)
+int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
 		return NID_INVAL;
 	return pxm_to_node_map[pxm];
 }
 
-int __cpuinit node_to_pxm(int node)
+int node_to_pxm(int node)
 {
 	if (node < 0)
 		return PXM_INVAL;
diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
index f9d2bde..b62cd36 100644
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -11,11 +11,8 @@ #else
 #define MAX_PXM_DOMAINS (256)	/* Old pxm spec is defined 8 bit */
 #endif
 
-extern int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS];
-extern int __cpuinitdata node_to_pxm_map[MAX_NUMNODES];
-
-extern int __cpuinit pxm_to_node(int);
-extern int __cpuinit node_to_pxm(int);
+extern int pxm_to_node(int);
+extern int node_to_pxm(int);
 extern int __cpuinit acpi_map_pxm_to_node(int);
 extern void __cpuinit acpi_unmap_pxm_to_node(int);
 
