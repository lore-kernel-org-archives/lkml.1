Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676Ab0AVLQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0AVLQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601Ab0AVLQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:16:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:39826 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab0AVLQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:16:17 -0500
Date: Fri, 22 Jan 2010 11:15:54 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com, hpa@zytor.com,
       mingo@redhat.com, stable@kernel.org, tglx@linutronix.de,
       rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, haicheng.li@linux.intel.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
       rientjes@google.com
In-Reply-To: <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Set hotpluggable nodes in nodes_possible_map
Message-ID: <tip-fefe0d8e9f0b2d1855ab4902c10399432cfc2e16@git.kernel.org>
Git-Commit-ID: fefe0d8e9f0b2d1855ab4902c10399432cfc2e16
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Jan 2010 11:15:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fefe0d8e9f0b2d1855ab4902c10399432cfc2e16
Gitweb:     http://git.kernel.org/tip/fefe0d8e9f0b2d1855ab4902c10399432cfc2e16
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 20 Jan 2010 12:10:47 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 22 Jan 2010 02:44:43 -0800

x86: Set hotpluggable nodes in nodes_possible_map

nodes_possible_map does not currently include nodes that have SRAT
entries that are all ACPI_SRAT_MEM_HOT_PLUGGABLE since the bit is
cleared in nodes_parsed if it does not have an online address range.

Unequivocally setting the bit in nodes_parsed is insufficient since
existing code, such as acpi_get_nodes(), assumes all nodes in the map
have online address ranges.  In fact, all code using nodes_parsed
assumes such nodes represent an address range of online memory.

nodes_possible_map is created by unioning nodes_parsed and
cpu_nodes_parsed; the former represents nodes with online memory and
the latter represents memoryless nodes.  We now set the bit for
hotpluggable nodes in cpu_nodes_parsed so that it also gets set in
nodes_possible_map.

[ hpa: Haicheng Li points out that this makes the naming of the
  variable cpu_nodes_parsed somewhat counterintuitive.  However, leave
  it as is in the interest of keeping the pure bug fix patch small. ]

Signed-off-by: David Rientjes <rientjes@google.com>
Tested-by: Haicheng Li <haicheng.li@linux.intel.com>
LKML-Reference: <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
Cc: <stable@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/srat_64.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a271241..28c6876 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -229,9 +229,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
 	}
 
-	if (changed)
+	if (changed) {
+		node_set(node, cpu_nodes_parsed);
 		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
 				 nd->start, nd->end);
+	}
 }
 
 /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
