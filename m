Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZGJRo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZGJRo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 13:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbZGJRoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 13:44:22 -0400
Received: from outbound-mail-153.bluehost.com ([67.222.39.33]:33164 "HELO
	outbound-mail-153.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751871AbZGJRoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 13:44:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lz/KlgBpMXg2gL15ko0NV8wUlEd1oVch4mPdbjKE9grSGRi0vjqljZs6+j+TdnKPz40WbUNFyxR+KuMSREUWIjmq0FPwta73xySO9o5KyOzFGdmYq4zqEo/+xbvGVdj1;
Date: Fri, 10 Jul 2009 10:44:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86/PCI: initialize PCI bus node numbers early
Message-ID: <20090710104419.0032be7b@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current mp_bus_to_node array is initialized only by AMD specific
code, since AMD platforms have registers that can be used for
determining mode numbers.  On new Intel platforms it's necessary to
initialize this array as well though, otherwise all PCI node numbers
will be 0, when in fact they should be -1 (indicating that I/O isn't
tied to any particular node).

So move the mp_bus_to_node code into the common PCI code, and
initialize it early with a default value of -1.  This may be overridden
later by arch code (e.g. the AMD code).

With this change, PCI consistent memory and other node specific
allocations (e.g. skbuff allocs) should occur on the "current" node.
If, for performance reasons, applications want to be bound to specific
nodes, they should open their devices only after being pinned to the
CPU where they'll run, for maximum locality.

Any thoughts here Yinghai or Jesse?


 include/asm/pci.h |    2 +
 kernel/setup.c    |    2 +
 pci/amd_bus.c     |   61 +-----------------------------------------
 pci/common.c      |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 59 deletions(-)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 927958d..c74bbd3 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -80,8 +80,10 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 	*strat = PCI_DMA_BURST_INFINITY;
 	*strategy_parameter = ~0UL;
 }
+extern void pci_bus_to_node_init(void);
 #else
 static inline void early_quirks(void) { }
+static inline void pci_bus_to_node_init(void) { }
 #endif
 
 extern void pci_iommu_alloc(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..3b788f4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -972,6 +972,8 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
+	pci_bus_to_node_init();
+
 	/*
 	 * Read APIC and some other early information from ACPI tables.
 	 */
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 3ffa10d..10fa176 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -15,63 +15,6 @@
  * also get peer root bus resource for io,mmio
  */
 
-#ifdef CONFIG_NUMA
-
-#define BUS_NR 256
-
-#ifdef CONFIG_X86_64
-
-static int mp_bus_to_node[BUS_NR];
-
-void set_mp_bus_to_node(int busnum, int node)
-{
-	if (busnum >= 0 &&  busnum < BUS_NR)
-		mp_bus_to_node[busnum] = node;
-}
-
-int get_mp_bus_to_node(int busnum)
-{
-	int node = -1;
-
-	if (busnum < 0 || busnum > (BUS_NR - 1))
-		return node;
-
-	node = mp_bus_to_node[busnum];
-
-	/*
-	 * let numa_node_id to decide it later in dma_alloc_pages
-	 * if there is no ram on that node
-	 */
-	if (node != -1 && !node_online(node))
-		node = -1;
-
-	return node;
-}
-
-#else /* CONFIG_X86_32 */
-
-static unsigned char mp_bus_to_node[BUS_NR];
-
-void set_mp_bus_to_node(int busnum, int node)
-{
-	if (busnum >= 0 &&  busnum < BUS_NR)
-	mp_bus_to_node[busnum] = (unsigned char) node;
-}
-
-int get_mp_bus_to_node(int busnum)
-{
-	int node;
-
-	if (busnum < 0 || busnum > (BUS_NR - 1))
-		return 0;
-	node = mp_bus_to_node[busnum];
-	return node;
-}
-
-#endif /* CONFIG_X86_32 */
-
-#endif /* CONFIG_NUMA */
-
 #ifdef CONFIG_X86_64
 
 /*
@@ -303,7 +246,7 @@ static int __init early_fill_mp_bus_info(void)
 
 #ifdef CONFIG_NUMA
 	for (i = 0; i < BUS_NR; i++)
-		mp_bus_to_node[i] = -1;
+		set_mp_bus_to_node(i, -1);
 #endif
 
 	if (!early_pci_allowed())
@@ -346,7 +289,7 @@ static int __init early_fill_mp_bus_info(void)
 		node = (reg >> 4) & 0x07;
 #ifdef CONFIG_NUMA
 		for (j = min_bus; j <= max_bus; j++)
-			mp_bus_to_node[j] = (unsigned char) node;
+			set_mp_bus_to_node(j, node);
 #endif
 		link = (reg >> 8) & 0x03;
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 2202b62..27a9dd6 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -600,3 +600,80 @@ struct pci_bus * __devinit pci_scan_bus_with_sysdata(int busno)
 {
 	return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
 }
+
+/*
+ * NUMA info for PCI busses
+ *
+ * Early arch code is responsible for filling in reasonable values here.
+ * A node id of "-1" means "use current node".  In other words, if a bus
+ * has a -1 node id, it's not tightly coupled to any particular chunk
+ * of memory (as is the case on some Nehalem systems).
+ */
+#ifdef CONFIG_NUMA
+
+#define BUS_NR 256
+
+#ifdef CONFIG_X86_64
+
+static int mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+		mp_bus_to_node[busnum] = node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node = -1;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1))
+		return node;
+
+	node = mp_bus_to_node[busnum];
+
+	/*
+	 * let numa_node_id to decide it later in dma_alloc_pages
+	 * if there is no ram on that node
+	 */
+	if (node != -1 && !node_online(node))
+		node = -1;
+
+	return node;
+}
+
+#else /* CONFIG_X86_32 */
+
+static unsigned char mp_bus_to_node[BUS_NR];
+
+void set_mp_bus_to_node(int busnum, int node)
+{
+	if (busnum >= 0 &&  busnum < BUS_NR)
+	mp_bus_to_node[busnum] = (unsigned char) node;
+}
+
+int get_mp_bus_to_node(int busnum)
+{
+	int node;
+
+	if (busnum < 0 || busnum > (BUS_NR - 1))
+		return 0;
+	node = mp_bus_to_node[busnum];
+	return node;
+}
+
+#endif /* CONFIG_X86_32 */
+
+void __init pci_bus_to_node_init(void)
+{
+	int i;
+
+	/*
+	 * Default to "no node" for each bus, and let later code update
+	 * it if need be (e.g. amd_postcore_init)
+	 */
+	for (i = 0; i < BUS_NR; i++)
+		set_mp_bus_to_node(i, -1);
+}
+
+#endif /* CONFIG_NUMA */
