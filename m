Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbZABSvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbZABSvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZABSvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:51:44 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:47238 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbZABSvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:51:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lvfCZZsnp2Vfxm5T/hk5IGyKrWlnenQPWhnQ4EdLZe+v8sm2yVXb/6zATWA9FkjrIr
         QDS8yXxqp+mp5E3fmBOgnbaiyFNeNMBkmYjvCtLBYTBKnJOtvzruXTaiMX8juRhUtjwM
         Zr3YzQ9hu6Co3/td0HIVMYp4pOxcJqzarMjRg=
Date: Fri, 2 Jan 2009 21:51:32 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86 - setup_per_cpu_areas cleanup
Message-ID: <20090102185132.GG5372@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

__alloc_bootmem and __alloc_bootmem_node do panic
for us in case of fail so no need for additional
checks here.

Also lets use pr_ macros for printing.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Please review

 arch/x86/kernel/setup_percpu.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.git/arch/x86/kernel/setup_percpu.c
@@ -153,12 +153,10 @@ void __init setup_per_cpu_areas(void)
 	align = max_t(unsigned long, PAGE_SIZE, align);
 	size = roundup(old_size, align);
 
-	printk(KERN_INFO
-		"NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
+	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
 
-	printk(KERN_INFO "PERCPU: Allocating %zd bytes of per cpu data\n",
-			  size);
+	pr_info("PERCPU: Allocating %zd bytes of per cpu data\n", size);
 
 	for_each_possible_cpu(cpu) {
 #ifndef CONFIG_NEED_MULTIPLE_NODES
@@ -169,22 +167,15 @@ void __init setup_per_cpu_areas(void)
 		if (!node_online(node) || !NODE_DATA(node)) {
 			ptr = __alloc_bootmem(size, align,
 					 __pa(MAX_DMA_ADDRESS));
-			printk(KERN_INFO
-			       "cpu %d has no node %d or node-local memory\n",
+			pr_info("cpu %d has no node %d or node-local memory\n",
 				cpu, node);
-			if (ptr)
-				printk(KERN_DEBUG
-					"per cpu data for cpu%d at %016lx\n",
-					 cpu, __pa(ptr));
-		}
-		else {
+			pr_debug("per cpu data for cpu%d at %016lx\n",
+				 cpu, __pa(ptr));
+		} else {
 			ptr = __alloc_bootmem_node(NODE_DATA(node), size, align,
 							__pa(MAX_DMA_ADDRESS));
-			if (ptr)
-				printk(KERN_DEBUG
-					"per cpu data for cpu%d on node%d "
-					"at %016lx\n",
-					cpu, node, __pa(ptr));
+			pr_debug("per cpu data for cpu%d on node%d at %016lx\n",
+				cpu, node, __pa(ptr));
 		}
 #endif
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
