Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZJ0PYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZJ0PYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZJ0PYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:24:38 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59898 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754078AbZJ0PYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:24:37 -0400
Message-ID: <4AE710C9.2070307@sgi.com>
Date: Tue, 27 Oct 2009 08:24:57 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, David Rientjes <rientjes@google.com>,
       Yinghai Lu <yinghai@kernel.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] SGI x86_64 UV: Limit the number of number of SRAT
 messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	<20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org>
In-Reply-To: <87pr8ay6tc.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andi Kleen wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> Limit number of SRAT messages of the form:
>> [    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0
> 
> While I generally agree on the concept of limiting per CPU information
> (see other mail) I don't think removing this message by default 
> is a good idea. I regularly needed it for debugging some NUMA related
> problems and they still happen moderately often even today.
> 
> I think the right approach here, to limit output, would be to figure out
> a more compact output format, perhaps using a matrix in a table
> or simply printing multiple pair per line.
> 
> -Andi
> 

In this approach, I only print the first SRAT of each node...  Is
this closer to what you're looking for?

Thanks,
Mike

SGI x86_64 UV: Limit the number of number of SRAT messages

Limit number of SRAT messages of the form:

[    0.000000] SRAT: PXM 0 -> APIC 0 -> Node 0

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/mm/srat_64.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- linux.orig/arch/x86/mm/srat_64.c
+++ linux/arch/x86/mm/srat_64.c
@@ -115,6 +115,7 @@
 {
 	int pxm, node;
 	int apic_id;
+	static int last_node = -1;
 
 	if (srat_disabled())
 		return;
@@ -136,8 +137,11 @@
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
+	if (node > last_node) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+		       pxm, apic_id, node);
+		last_node = node;
+	}
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
@@ -146,6 +150,7 @@
 {
 	int pxm, node;
 	int apic_id;
+	static int last_node = -1;
 
 	if (srat_disabled())
 		return;
@@ -170,8 +175,11 @@
 	apicid_to_node[apic_id] = node;
 	node_set(node, cpu_nodes_parsed);
 	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
-	       pxm, apic_id, node);
+	if (node > last_node) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC %u -> Node %u\n",
+		       pxm, apic_id, node);
+		last_node = node;
+	}
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
