Return-Path: <linux-kernel-owner+w=401wt.eu-S932448AbZJ0VoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbZJ0VoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 17:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZJ0VoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 17:44:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZJ0VoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 17:44:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=rsWFoalGcbnY3r5W/KScIK039p0Uq6LRYKTlPa58TEKFpulENLt3FfFkoIX0naoBw
	Ja+8u4qjKVAB81gaojbFA==
Date: Tue, 27 Oct 2009 14:44:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [patch -mm] acpi: remove NID_INVAL
In-Reply-To: <alpine.DEB.1.00.0910081325200.6998@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0910271442250.30270@chino.kir.corp.google.com>
References: <20091008162454.23192.91832.sendpatchset@localhost.localdomain> <20091008162533.23192.71981.sendpatchset@localhost.localdomain> <alpine.DEB.1.10.0910081616040.8030@gentwo.org> <alpine.DEB.1.00.0910081325200.6998@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA_NO_NODE has been exported globally and thus it can replace NID_INVAL
in the acpi code.

Also removes the unused acpi_unmap_pxm_to_node() function.

Cc: Len Brown <lenb@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Depends on Lee Schermerhorn's hugetlb patchset in mmotm-10132113.

 drivers/acpi/numa.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -28,6 +28,7 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/acpi.h>
+#include <linux/numa.h>
 #include <acpi/acpi_bus.h>
 
 #define PREFIX "ACPI: "
@@ -39,15 +40,15 @@ ACPI_MODULE_NAME("numa");
 static nodemask_t nodes_found_map = NODE_MASK_NONE;
 
 /* maps to convert between proximity domain and logical node ID */
-static int pxm_to_node_map[MAX_PXM_DOMAINS]
-				= { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
+static int pxm_to_node_map[MAX_PXM_DOMAINS]				
+			= { [0 ... MAX_PXM_DOMAINS - 1] = NUMA_NO_NODE };
 static int node_to_pxm_map[MAX_NUMNODES]
-				= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
+			= { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
 
 int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
-		return NID_INVAL;
+		return NUMA_NO_NODE;
 	return pxm_to_node_map[pxm];
 }
 
@@ -68,9 +69,9 @@ int acpi_map_pxm_to_node(int pxm)
 {
 	int node = pxm_to_node_map[pxm];
 
-	if (node < 0){
+	if (node < 0) {
 		if (nodes_weight(nodes_found_map) >= MAX_NUMNODES)
-			return NID_INVAL;
+			return NUMA_NO_NODE;
 		node = first_unset_node(nodes_found_map);
 		__acpi_map_pxm_to_node(pxm, node);
 		node_set(node, nodes_found_map);
@@ -79,16 +80,6 @@ int acpi_map_pxm_to_node(int pxm)
 	return node;
 }
 
-#if 0
-void __cpuinit acpi_unmap_pxm_to_node(int node)
-{
-	int pxm = node_to_pxm_map[node];
-	pxm_to_node_map[pxm] = NID_INVAL;
-	node_to_pxm_map[node] = PXM_INVAL;
-	node_clear(node, nodes_found_map);
-}
-#endif  /*  0  */
-
 static void __init
 acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 {
