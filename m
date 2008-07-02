Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYGBWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYGBWVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYGBWVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:21:10 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4060 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYGBWVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:21:08 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3EDU4-01-1X5-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/11] x86/pci: merge: Moving mp_bus_to_node.c to amd_bus.c
Date: Wed, 2 Jul 2008 22:50:26 +0200
Message-ID: <1215031829-29124-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 02 Jul 2008 21:17:56.0240 (UTC) FILETIME=[18A8B900:01C8DC89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile         |    3 +--
 arch/x86/pci/amd_bus.c        |   32 +++++++++++++++++++++++++++++---
 arch/x86/pci/mp_bus_to_node.c |   23 -----------------------
 3 files changed, 30 insertions(+), 28 deletions(-)
 delete mode 100644 arch/x86/pci/mp_bus_to_node.c

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 844906e..58a3749 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -14,12 +14,11 @@ pci-y				:= fixup.o
 # legacy/irq.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
-pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
 
 # Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
 # therefor correct. This needs a proper fix by distangling the code.
 pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
-pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o mp_bus_to_node.o
+pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
 
 obj-y				+= $(pci-y) common.o early.o
 obj-y				+= amd_bus.o
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index aa3a190..f2b81d6 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -1,13 +1,13 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/topology.h>
 #include "pci.h"
 
 #ifdef CONFIG_X86_64
-
 #include <asm/pci-direct.h>
 #include <asm/mpspec.h>
 #include <linux/cpumask.h>
-#include <linux/topology.h>
+#endif
 
 /*
  * This discovers the pcibus <-> node mapping on AMD K8.
@@ -18,6 +18,8 @@
 
 #define BUS_NR 256
 
+#ifdef CONFIG_X86_64
+
 static int mp_bus_to_node[BUS_NR];
 
 void set_mp_bus_to_node(int busnum, int node)
@@ -45,7 +47,31 @@ int get_mp_bus_to_node(int busnum)
 	return node;
 }
 
-#endif
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
+#endif /* CONFIG_NUMA */
+
+#ifdef CONFIG_X86_64
 
 /*
  * sub bus (transparent) will use entres from 3 to store extra from root,
diff --git a/arch/x86/pci/mp_bus_to_node.c b/arch/x86/pci/mp_bus_to_node.c
deleted file mode 100644
index 0229439..0000000
--- a/arch/x86/pci/mp_bus_to_node.c
+++ /dev/null
@@ -1,23 +0,0 @@
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/topology.h>
-
-#define BUS_NR 256
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
-- 
1.5.5.4


