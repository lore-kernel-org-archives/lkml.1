Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbZGJVHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbZGJVHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZGJVG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:06:59 -0400
Received: from outbound-mail-129.bluehost.com ([67.222.38.29]:44623 "HELO
	outbound-mail-129.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752302AbZGJVG6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:06:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Jxo3PrRl9Ly4z/I8IdQzyQ/1UMa6WbmoiGIK/wfz2Y4Pgycr1tc0dHeX7p07I7B+mWbDQoHZAZ6C55xPfYw7QOTOSrmwDxTniiMxDZAEfQaQxpRgjxJkabnz94f7QoA+;
Date: Fri, 10 Jul 2009 14:06:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: [PATCH] x86/PCI: initialize PCI bus node numbers early
Message-ID: <20090710140654.32132bcb@jbarnes-g45>
In-Reply-To: <20090710132249.1a032cfb@jbarnes-g45>
References: <20090710104419.0032be7b@jbarnes-g45>
	<4A57A1FE.30609@kernel.org>
	<20090710132249.1a032cfb@jbarnes-g45>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jul 2009 13:22:49 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Fri, 10 Jul 2009 13:18:06 -0700
> Yinghai Lu <yinghai@kernel.org> wrote:
> 
> > Jesse Barnes wrote:
> > > The current mp_bus_to_node array is initialized only by AMD
> > > specific code, since AMD platforms have registers that can be
> > > used for determining mode numbers.  On new Intel platforms it's
> > > necessary to initialize this array as well though, otherwise all
> > > PCI node numbers will be 0, when in fact they should be -1
> > > (indicating that I/O isn't tied to any particular node).
> > > 
> > > So move the mp_bus_to_node code into the common PCI code, and
> > > initialize it early with a default value of -1.  This may be
> > > overridden later by arch code (e.g. the AMD code).
> > > 
> > > With this change, PCI consistent memory and other node specific
> > > allocations (e.g. skbuff allocs) should occur on the "current"
> > > node. If, for performance reasons, applications want to be bound
> > > to specific nodes, they should open their devices only after being
> > > pinned to the CPU where they'll run, for maximum locality.
> > > 
> > > Any thoughts here Yinghai or Jesse?
> > > 
> > > 
> > >  include/asm/pci.h |    2 +
> > >  kernel/setup.c    |    2 +
> > >  pci/amd_bus.c     |   61
> > > +----------------------------------------- pci/common.c      |
> > > 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++ 4 files
> > > changed, 83 insertions(+), 59 deletions(-)
> > > 
> > > Thanks,
> > 
> > could use
> > 
> > static int mp_bus_to_node[BUS_NR] = {
> >         [0 ... BUS_NR - 1] = -1
> > };
> > 
> > so we avoid to add pci_bus_to_node_init()
> 
> Ah yeah that would clean things up a bit...  Thanks.
> 

So something like this...

--

>From 2b51fba93f7b2dabf453a74923a9a217611ebc1a Mon Sep 17 00:00:00 2001
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Fri, 10 Jul 2009 14:04:30 -0700
Subject: [PATCH] x86/PCI: initialize PCI bus node numbers early

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

Acked-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/amd_bus.c |   64 +-------------------------------------------
 arch/x86/pci/common.c  |   69 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 63 deletions(-)

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
index 2202b62..8ce1ce1 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -600,3 +600,72 @@ struct pci_bus * __devinit pci_scan_bus_with_sysdata(int busno)
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
+static int mp_bus_to_node[BUS_NR] = {
+	[0 ... BUS_NR - 1] = -1;
+};
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
+static unsigned char mp_bus_to_node[BUS_NR] = {
+	[0 ... BUS_NR - 1] = -1;
+};
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
+#endif /* CONFIG_NUMA */
-- 
1.6.0.4



-- 
Jesse Barnes, Intel Open Source Technology Center
