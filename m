Return-Path: <linux-kernel-owner+w=401wt.eu-S939313AbXFHHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939313AbXFHHsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938396AbXFHHYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:54 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55298 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938389AbXFHHYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:51 -0400
Message-Id: <20070608072221.248220000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Aaron Durbin <adurbin@google.com>,
       lenb@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 36/54] acpi: fix potential call to a freed memory section.
Content-Disposition: inline; filename=acpi-fix-potential-call-to-a-freed-memory-section.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Aaron Durbin <adurbin@google.com>

Strip __cpuinit[data] from Node <-> PXM routines and supporting data
structures.  Also make pxm_to_node_map and node_to_pxm_map local to the
numa acpi module.

This fixes a bug triggered by the following conditions:
- boot on a machine with a SLIT table defined
- kernel is configured w/ CONFIG_HOTPLUG_CPU=n
- cat /sys/devices/system/node/node*/distance
This will cause an oops by calling into a freed memory section.

In particular, on x86_64, __node_distance calls node_to_pxm().

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/acpi/numa.c      |    8 ++++----
 include/acpi/acpi_numa.h |    7 ++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

--- linux-2.6.21.4.orig/drivers/acpi/numa.c
+++ linux-2.6.21.4/drivers/acpi/numa.c
@@ -40,19 +40,19 @@ static nodemask_t nodes_found_map = NODE
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
--- linux-2.6.21.4.orig/include/acpi/acpi_numa.h
+++ linux-2.6.21.4/include/acpi/acpi_numa.h
@@ -11,11 +11,8 @@
 #define MAX_PXM_DOMAINS (256) /* Old pxm spec is defined 8 bit */
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
 

-- 
