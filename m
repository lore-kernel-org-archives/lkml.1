Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444Ab0ATUK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0ATUK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396Ab0ATUK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:10:57 -0500
Received: from smtp-out.google.com ([216.239.33.17]:48788 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0ATUK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:10:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=P2QrdPiPSRnB9gjN/BMnYM10yR9q01NTjpiPiwYauf+rGanOl/gNj6lLPgf6FXp5w
	N92/7so1wEqtYqqYEf1rg==
Date: Wed, 20 Jan 2010 12:10:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Haicheng Li <haicheng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>
cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: [patch] x86: set hotpluggable nodes in nodes_possible_map
In-Reply-To: <4B5731E2.4040207@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com>
 <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Haicheng Li wrote:

> let's add more changes to fix naming issue as well since it's too confusing
> for people to understand
> the code logic. how about below patch?

That should be a seperate change; there's a bugfix here (my patch) and 
then a cleanup patch that you could make incrementally on mine.  I don't 
personally like the name "rest_nodes_parsed" since it's poor English, I 
suggest renaming nodes_parsed to mem_nodes_parsed as I originally asked 
and then cpu_nodes_parsed to acpi_nodes_parsed or something similiar.

Ingo, the following is my bugfix patch that addresses the issue at 
http://patchwork.kernel.org/patch/69499.  Haicheng, can we add your 
tested-by line?



x86: set hotpluggable nodes in nodes_possible_map

nodes_possible_map does not currently include nodes that have SRAT
entries that are all ACPI_SRAT_MEM_HOT_PLUGGABLE since the bit is cleared
in nodes_parsed if it does not have an online address range.

Unequivocally setting the bit in nodes_parsed is insufficient since
existing code, such as acpi_get_nodes(), assumes all nodes in the map
have online address ranges.  In fact, all code using nodes_parsed assumes
such nodes represent an address range of online memory.

nodes_possible_map is created by unioning nodes_parsed and
cpu_nodes_parsed; the former represents nodes with online memory and the
latter represents memoryless nodes.  We now set the bit for hotpluggable
nodes in cpu_nodes_parsed so that it also gets set in nodes_possible_map.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/srat_64.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
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
