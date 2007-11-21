Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbXKUUKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbXKUUKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXKUUKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:10:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:18867 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXKUUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=rsTAAaw1JVT+RZI+D+XZR9GX5JlrULP2xL5EzNcV2v2yD/lR4vO0L1hdUTkXa4Fw13H3YUzg5GO66AvP6tnxoh6mv7o9inFE48Ik759N0nmi/H7crtAWci3j22OS42ZxjriEA3chtM4CYIjoy7YTxPZdodBWfd3JovPiiIW7oGk=
Date: Wed, 21 Nov 2007 23:09:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: [RFC] PPC: convert for(...) cycles into for_each... form
Message-ID: <20071121200954.GB7273@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch does convert cyclic calls to of_find_compatible_node()
and of_find_node_by_type() into appropriate macroses. It does reduce
code a bit.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
WARNING: I've no PowerPC to test it - please reiew the patch
closely. Thanks.

 arch/powerpc/kernel/legacy_serial.c       |    8 ++++----
 arch/powerpc/platforms/82xx/pq2.c         |    4 ++--
 arch/powerpc/platforms/celleb/scc_sio.c   |    5 ++---
 arch/powerpc/platforms/powermac/low_i2c.c |    3 +--
 arch/powerpc/sysdev/mv64x60_pci.c         |    4 ++--
 arch/powerpc/sysdev/mv64x60_udbg.c        |    4 ++--
 arch/powerpc/sysdev/uic.c                 |   17 +++++------------
 7 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 4ed5887..b5dc646 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -307,7 +307,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with SOC ports */
-	for (np = NULL; (np = of_find_compatible_node(np, "serial", "ns16550")) != NULL;) {
+	for_each_compatible_node(np, "serial", "ns16550") {
 		struct device_node *soc = of_get_parent(np);
 		if (soc && !strcmp(soc->type, "soc")) {
 			index = add_legacy_soc_port(np, np);
@@ -318,7 +318,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with ISA ports */
-	for (np = NULL; (np = of_find_node_by_type(np, "serial"));) {
+	for_each_node_by_type(np, "serial") {
 		struct device_node *isa = of_get_parent(np);
 		if (isa && !strcmp(isa->name, "isa")) {
 			index = add_legacy_isa_port(np, isa);
@@ -329,7 +329,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with tsi-bridge ports */
-	for (np = NULL; (np = of_find_compatible_node(np, "serial", "ns16550")) != NULL;) {
+	for_each_compatible_node(np, "serial", "ns16550") {
 		struct device_node *tsi = of_get_parent(np);
 		if (tsi && !strcmp(tsi->type, "tsi-bridge")) {
 			index = add_legacy_soc_port(np, np);
@@ -340,7 +340,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with opb bus ports */
-	for (np = NULL; (np = of_find_compatible_node(np, "serial", "ns16550")) != NULL;) {
+	for_each_compatible_node(np, "serial", "ns16550") {
 		struct device_node *opb = of_get_parent(np);
 		if (opb && (!strcmp(opb->type, "opb") ||
 			    of_device_is_compatible(opb, "ibm,opb"))) {
diff --git a/arch/powerpc/platforms/82xx/pq2.c b/arch/powerpc/platforms/82xx/pq2.c
index a497cba..9e74393 100644
--- a/arch/powerpc/platforms/82xx/pq2.c
+++ b/arch/powerpc/platforms/82xx/pq2.c
@@ -72,11 +72,11 @@ err:
 
 void __init pq2_init_pci(void)
 {
-	struct device_node *np = NULL;
+	struct device_node *np;
 
 	ppc_md.pci_exclude_device = pq2_pci_exclude_device;
 
-	while ((np = of_find_compatible_node(np, NULL, "fsl,pq2-pci")))
+	for_each_compatible_node(np, NULL, "fsl,pq2-pci")
 		pq2_pci_add_bridge(np);
 }
 #endif
diff --git a/arch/powerpc/platforms/celleb/scc_sio.c b/arch/powerpc/platforms/celleb/scc_sio.c
index 6100082..5e43bac 100644
--- a/arch/powerpc/platforms/celleb/scc_sio.c
+++ b/arch/powerpc/platforms/celleb/scc_sio.c
@@ -42,14 +42,13 @@ static struct {
 static int __init txx9_serial_init(void)
 {
 	extern int early_serial_txx9_setup(struct uart_port *port);
-	struct device_node *node = NULL;
+	struct device_node *node;
 	int i;
 	struct uart_port req;
 	struct of_irq irq;
 	struct resource res;
 
-	while ((node = of_find_compatible_node(node,
-				"serial", "toshiba,sio-scc")) != NULL) {
+	for_each_compatible_node(node, "serial", "toshiba,sio-scc") {
 		for (i = 0; i < ARRAY_SIZE(txx9_scc_tab); i++) {
 			if (!(txx9_serial_bitmap & (1<<i)))
 				continue;
diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
index da2007e..864fbf4 100644
--- a/arch/powerpc/platforms/powermac/low_i2c.c
+++ b/arch/powerpc/platforms/powermac/low_i2c.c
@@ -585,8 +585,7 @@ static void __init kw_i2c_probe(void)
 	struct device_node *np, *child, *parent;
 
 	/* Probe keywest-i2c busses */
-	for (np = NULL;
-	     (np = of_find_compatible_node(np, "i2c","keywest-i2c")) != NULL;){
+	for_each_compatible_node(np, "i2c","keywest-i2c") {
 		struct pmac_i2c_host_kw *host;
 		int multibus, chans, i;
 
diff --git a/arch/powerpc/sysdev/mv64x60_pci.c b/arch/powerpc/sysdev/mv64x60_pci.c
index 6933f9c..d21ab8f 100644
--- a/arch/powerpc/sysdev/mv64x60_pci.c
+++ b/arch/powerpc/sysdev/mv64x60_pci.c
@@ -164,8 +164,8 @@ static int __init mv64x60_add_bridge(struct device_node *dev)
 
 void __init mv64x60_pci_init(void)
 {
-	struct device_node *np = NULL;
+	struct device_node *np;
 
-	while ((np = of_find_compatible_node(np, "pci", "marvell,mv64x60-pci")))
+	for_each_compatible_node(np, "pci", "marvell,mv64x60-pci")
 		mv64x60_add_bridge(np);
 }
diff --git a/arch/powerpc/sysdev/mv64x60_udbg.c b/arch/powerpc/sysdev/mv64x60_udbg.c
index 367e7b1..35c77c7 100644
--- a/arch/powerpc/sysdev/mv64x60_udbg.c
+++ b/arch/powerpc/sysdev/mv64x60_udbg.c
@@ -85,10 +85,10 @@ static void mv64x60_udbg_init(void)
 	if (!stdout)
 		return;
 
-	for (np = NULL;
-	     (np = of_find_compatible_node(np, "serial", "marvell,mpsc")); )
+	for_each_compatible_node(np, "serial", "marvell,mpsc") {
 		if (np == stdout)
 			break;
+	}
 
 	of_node_put(stdout);
 	if (!np)
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 5149716..815d6db 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -326,28 +326,23 @@ void __init uic_init_tree(void)
 	const u32 *interrupts;
 
 	/* First locate and initialize the top-level UIC */
-
-	np = of_find_compatible_node(NULL, NULL, "ibm,uic");
-	while (np) {
+	for_each_compatible_node(np, NULL, "ibm,uic") {
 		interrupts = of_get_property(np, "interrupts", NULL);
-		if (! interrupts)
+		if (!interrupts)
 			break;
-
-		np = of_find_compatible_node(np, NULL, "ibm,uic");
 	}
 
 	BUG_ON(!np); /* uic_init_tree() assumes there's a UIC as the
 		      * top-level interrupt controller */
 	primary_uic = uic_init_one(np);
-	if (! primary_uic)
+	if (!primary_uic)
 		panic("Unable to initialize primary UIC %s\n", np->full_name);
 
 	irq_set_default_host(primary_uic->irqhost);
 	of_node_put(np);
 
 	/* The scan again for cascaded UICs */
-	np = of_find_compatible_node(NULL, NULL, "ibm,uic");
-	while (np) {
+	for_each_compatible_node(np, NULL, "ibm,uic") {
 		interrupts = of_get_property(np, "interrupts", NULL);
 		if (interrupts) {
 			/* Secondary UIC */
@@ -355,7 +350,7 @@ void __init uic_init_tree(void)
 			int ret;
 
 			uic = uic_init_one(np);
-			if (! uic)
+			if (!uic)
 				panic("Unable to initialize a secondary UIC %s\n",
 				      np->full_name);
 
@@ -373,8 +368,6 @@ void __init uic_init_tree(void)
 
 			/* FIXME: setup critical cascade?? */
 		}
-
-		np = of_find_compatible_node(np, NULL, "ibm,uic");
 	}
 }
 
