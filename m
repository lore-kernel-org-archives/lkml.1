Return-Path: <linux-kernel-owner+w=401wt.eu-S1761956AbYEMUU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761956AbYEMUU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbYEMUPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:15:30 -0400
Received: from mx1.suse.de ([195.135.220.2]:38227 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762294AbYEMUP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:15:26 -0400
Date: Tue, 13 May 2008 13:12:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 22/37] x86: sysfs cpu?/topology is empty in 2.6.25 (32-bit
	Intel system)
Message-ID: <20080513201222.GW31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-sysfs-cpu-topology-is-empty-in-2.6.25.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit 5c3a121d52b30a1e53cdaa802fa1965fcd243164 upstream

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

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86/topology.h |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
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

-- 
