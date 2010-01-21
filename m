Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171Ab0AUC6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0AUC6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 21:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735Ab0AUC6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 21:58:44 -0500
Received: from mga10.intel.com ([192.55.52.92]:27399 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754075Ab0AUC6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 21:58:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,314,1262592000"; 
   d="scan'208";a="533109248"
Message-ID: <4B57C2DD.3050402@linux.intel.com>
Date: Thu, 21 Jan 2010 10:58:37 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: set hotpluggable nodes in nodes_possible_map
References: <4B501C4D.4080907@linux.intel.com> <alpine.DEB.2.00.1001171338170.16238@chino.kir.corp.google.com> <86802c441001172230y137b4916h7d744a96ab75873d@mail.gmail.com> <alpine.DEB.2.00.1001180231430.20677@chino.kir.corp.google.com> <4B5592B1.9030800@linux.intel.com> <alpine.DEB.2.00.1001191513010.24223@chino.kir.corp.google.com> <4B5731E2.4040207@linux.intel.com> <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001201152040.30528@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Thu, 21 Jan 2010, Haicheng Li wrote:
> 
>> let's add more changes to fix naming issue as well since it's too confusing
>> for people to understand
>> the code logic. how about below patch?
> 
> That should be a seperate change; there's a bugfix here (my patch) and 
> then a cleanup patch that you could make incrementally on mine.  I don't 
> personally like the name "rest_nodes_parsed" since it's poor English, I 
> suggest renaming nodes_parsed to mem_nodes_parsed as I originally asked 
> and then cpu_nodes_parsed to acpi_nodes_parsed or something similiar.

IMHO, name acpi_nodes_parsed is not appropriate for this intention as nodes_parsed comes from acpi too.

Think about it again, it's better _NOT_ to mix up cpu_nodes_parsed and hotplugpable_nodes together.
We cannot assume cpu_nodes_parsed has no other use in future, like possibly cpu hotplug emulation. I 
think that a clean and straightforward way is to keep nodes with hotpluggable range in a separated 
nodemask, like "hp_nodes_parsed", which could also be used for future mem hotplug emulation. Then 
node data corresponding to nodes_parsed is kept in nodes[], node data for hp_nodes_parsed is kept in 
nodes_add[].

> Ingo, the following is my bugfix patch that addresses the issue at 
> http://patchwork.kernel.org/patch/69499.  

Personally I don't like such patch with confusable info.
I think following patch would be more straightfoward and clean:

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a271241..c5552ae 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -27,8 +27,18 @@ int acpi_numa __initdata;

  static struct acpi_table_slit *acpi_slit;

+/* nodes_parsed:
+ *  - nodes with memory on
+ * cpu_nodes_parsed:
+ *  - nodes with cpu on
+ * hp_nodes_parsed:
+ *  - nodes with hotpluggable memory region
+ *
+ * We union these tree nodemasks to get node_possible_map.
+ */
  static nodemask_t nodes_parsed __initdata;
  static nodemask_t cpu_nodes_parsed __initdata;
+static nodemask_t hp_nodes_parsed __initdata;
  static struct bootnode nodes[MAX_NUMNODES] __initdata;
  static struct bootnode nodes_add[MAX_NUMNODES];

@@ -229,9 +239,11 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
  			printk(KERN_ERR "SRAT: Hotplug zone not continuous. Partly ignored\n");
  	}

-	if (changed)
+	if (changed) {
+		node_set(node, hp_nodes_parsed);
  		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
  				 nd->start, nd->end);
+	}
  }

  /* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
@@ -380,8 +392,10 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
  		return -1;
  	}

-	/* Account for nodes with cpus and no memory */
+	/* Account for nodes with memory and cpus */
  	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
+	/* Account for nodes with hotpluggable memory regions */
+	nodes_or(node_possible_map, node_possible_map, hp_nodes_parsed);

  	/* Finally register nodes */
  	for_each_node_mask(i, node_possible_map)

