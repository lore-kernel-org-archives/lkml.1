Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYCCKLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYCCKLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYCCKLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:11:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbYCCKLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:11:13 -0500
Date: Mon, 3 Mar 2008 11:10:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Zhao Yakui <yakui.zhao@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Unneccessary to scan the PCI bus already scanned.
Message-ID: <20080303101040.GG18281@elte.hu>
References: <1204525186.4080.11.camel@yakui_zhao.sh.intel.com> <20080303073214.GA5934@elte.hu> <86802c440803030006m1879838awc238f07bc98ed43e@mail.gmail.com> <86802c440803030030p4ff9cec5tdb25d1cdc131d377@mail.gmail.com> <86802c440803030201i684f31c1m97fb3f1f1927d4f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803030201i684f31c1m97fb3f1f1927d4f4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> also please use attached patch to replace the one patch in x86.git# 
> testing. old one can not be applied after Yakui's patch.

ok, thanks. Note, i still have the patch below filed up against it - is 
that still needed?

	Ingo

-------------->
Subject: x86: fix k8-bus_64.c build
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Feb 20 10:30:15 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/k8-bus_64.c   |    6 ++++++
 include/asm-x86/topology.h |    4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/pci/k8-bus_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/k8-bus_64.c
+++ linux-x86.q/arch/x86/pci/k8-bus_64.c
@@ -22,6 +22,8 @@
 #define SUBORDINATE_LDT_BUS_NUMBER(dword) ((dword >> 16) & 0xFF)
 #define PCI_DEVICE_ID_K8HTCONFIG 0x1100
 
+#ifdef CONFIG_NUMA
+
 #define BUS_NR 256
 
 static int mp_bus_to_node[BUS_NR];
@@ -51,6 +53,8 @@ int get_mp_bus_to_node(int busnum)
 	return node;
 }
 
+#endif
+
 /**
  * early_fill_mp_bus_to_node()
  * called before pcibios_scan_root and pci_scan_bus
@@ -60,6 +64,7 @@ int get_mp_bus_to_node(int busnum)
 __init static int
 early_fill_mp_bus_to_node(void)
 {
+#ifdef CONFIG_NUMA
 	int i, j;
 	unsigned slot;
 	u32 ldtbus, nid;
@@ -111,6 +116,7 @@ early_fill_mp_bus_to_node(void)
 		if (node >= 0)
 			printk(KERN_DEBUG "bus: %02x to node: %02x\n", i, node);
 	}
+#endif
 	return 0;
 }
 
Index: linux-x86.q/include/asm-x86/topology.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/topology.h
+++ linux-x86.q/include/asm-x86/topology.h
@@ -165,8 +165,8 @@ extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
 
-int get_mp_bus_to_node(int busnum);
-void set_mp_bus_to_node(int busnum, int node);
+extern int get_mp_bus_to_node(int busnum);
+extern void set_mp_bus_to_node(int busnum, int node);
 
 #else /* CONFIG_NUMA */
 
