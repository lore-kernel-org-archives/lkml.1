Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYEENvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYEENvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbYEENvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:51:16 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:53099 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbYEENvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:51:15 -0400
Date: Mon, 5 May 2008 19:22:15 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: [BUG] sysfs cpu?/topology is empty in 2.6.25 (32-bit Intel system)
Message-ID: <20080505135215.GD5420@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Linux Kernel <linux-kernel@vger.kernel.org>,
	tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
	Mike Travis <travis@sgi.com>,
	Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

System topology on intel based system needs to be exported 
for non-numa case as well.

All parts of asm-i386/topology.h has come under 
#ifdef CONFIG_NUMA after the merge to asm-x86/topology.h

/sys/devices/system/cpu/cpu?/topology/* is populated based on 
ENABLE_TOPO_DEFINES

The sysfs cpu topology is not being populated on my dual socket
dual core xeon 5160 processor based (x86 32 bit) system.

CONFIG_NUMA is not set in my case yet the topology is relevant
and useful.

irqbalance daemon application depends on topology to build the
cpus and package list and it fails on Fedora9 beta since the 
sysfs topology was not being populated in the 2.6.25 kernel.

I am not sure if it was intentional to not define ENABLE_TOPO_DEFINES
for non-numa systems.

This fix has been tested on the above mentioned dual core, dual socket
system.

Comments? Did I miss already posted fix?

--Vaidy

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

---
 include/asm-x86/topology.h |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- linux-2.6.25.1.orig/include/asm-x86/topology.h
+++ linux-2.6.25.1/include/asm-x86/topology.h
@@ -25,6 +25,16 @@
 #ifndef _ASM_X86_TOPOLOGY_H
 #define _ASM_X86_TOPOLOGY_H
 
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_HT
+#  define ENABLE_TOPO_DEFINES
+# endif
+#else
+# ifdef CONFIG_SMP
+#  define ENABLE_TOPO_DEFINES
+# endif
+#endif
+
 #ifdef CONFIG_NUMA
 #include <linux/cpumask.h>
 #include <asm/mpspec.h>
@@ -112,10 +122,6 @@ extern unsigned long node_end_pfn[];
 extern unsigned long node_remap_size[];
 #define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
 
-# ifdef CONFIG_X86_HT
-#  define ENABLE_TOPO_DEFINES
-# endif
-
 # define SD_CACHE_NICE_TRIES	1
 # define SD_IDLE_IDX		1
 # define SD_NEWIDLE_IDX		2
@@ -123,10 +129,6 @@ extern unsigned long node_remap_size[];
 
 #else
 
-# ifdef CONFIG_SMP
-#  define ENABLE_TOPO_DEFINES
-# endif
-
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
 # define SD_NEWIDLE_IDX		0
