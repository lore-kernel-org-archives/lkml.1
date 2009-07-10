Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZGJSdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZGJSdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZGJSdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:33:42 -0400
Received: from outbound-mail-107.bluehost.com ([69.89.22.7]:47978 "HELO
	outbound-mail-107.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753805AbZGJSdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:33:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pqhvRLGmC9qQxMh64PJOT0CP3xThqytBTvuuDz7LJQhnRFEu2sVYJuqsT5ekloXyPzZq8tjgPGnhEpPfyDemwm8lu4groDMihHSZQ3zxxn2MdlEYX5kX2uUzTiD/I/sk;
Date: Fri, 10 Jul 2009 11:33:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/PCI: initialize PCI bus node numbers early
Message-ID: <20090710113338.6c97d7f8@jbarnes-g45>
In-Reply-To: <20090710104419.0032be7b@jbarnes-g45>
References: <20090710104419.0032be7b@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, here's one that actually builds & links.

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 927958d..d30bbfa 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -84,6 +84,12 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 static inline void early_quirks(void) { }
 #endif
 
+#if defined (CONFIG_PCI) && defined(CONFIG_NUMA)
+extern void pci_bus_to_node_init(void);
+#else
+static inline void pci_bus_to_node_init(void) { }
+#endif
+
 extern void pci_iommu_alloc(void);
 
 /* MSI arch hook */
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
index 3ffa10d..572ee97 100644
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
@@ -301,11 +244,6 @@ static int __init early_fill_mp_bus_info(void)
 	u64 val;
 	u32 address;
 
-#ifdef CONFIG_NUMA
-	for (i = 0; i < BUS_NR; i++)
-		mp_bus_to_node[i] = -1;
-#endif
-
 	if (!early_pci_allowed())
 		return -1;
 
@@ -346,7 +284,7 @@ static int __init early_fill_mp_bus_info(void)
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
