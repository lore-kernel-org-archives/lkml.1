Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab0BDRhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:37:54 -0500
Received: from kroah.org ([198.145.64.141]:34591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0BDRVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:31 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:50 2010
Message-Id: <20100204171450.450060042@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Rientjes <rientjes@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [07/74] x86: Set hotpluggable nodes in nodes_possible_map
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Rientjes <rientjes@google.com>

commit 3a5fc0e40cb467e692737bc798bc99773c81e1e2 upstream.

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
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/srat_64.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -229,9 +229,11 @@ update_nodes_add(int node, unsigned long
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


