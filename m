Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZFJDeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZFJDeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZFJDdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:33:17 -0400
Received: from kroah.org ([198.145.64.141]:56566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZFJDdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:33:15 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:41 2009
Message-Id: <20090610002340.795051025@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 05/60] sparc: Fix bus type probing for ESP and LE devices.
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=sparc-fix-bus-type-probing-for-esp-and-le-devices.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

If there is a dummy "espdma" or "ledma" parent device above ESP scsi
or LE ethernet device nodes, we have to match the bus as SBUS.

Otherwise the address and size cell counts are wrong and we don't
calculate the final physical device resource values correctly at all.

Commit 5280267c1dddb8d413595b87dc406624bb497946 ("sparc: Fix handling
of LANCE and ESP parent nodes in of_device.c") was meant to fix this
problem, but that only influences the inner loop of
build_device_resources().  We need this logic to also kick in at the
beginning of build_device_resources() as well, when we make the first
attempt to determine the device's immediate parent bus type for 'reg'
property element extraction.

Based almost entirely upon a patch by Friedrich Oslage.

Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/of_device.c   |   21 +++++++++++++++++++--
 arch/sparc64/kernel/of_device.c |   21 +++++++++++++++++++--
 2 files changed, 38 insertions(+), 4 deletions(-)

--- a/arch/sparc64/kernel/of_device.c
+++ b/arch/sparc64/kernel/of_device.c
@@ -278,8 +278,25 @@ static unsigned long of_bus_pci_get_flag
 
 static int of_bus_sbus_match(struct device_node *np)
 {
-	return !strcmp(np->name, "sbus") ||
-		!strcmp(np->name, "sbi");
+	struct device_node *dp = np;
+
+	while (dp) {
+		if (!strcmp(dp->name, "sbus") ||
+		    !strcmp(dp->name, "sbi"))
+			return 1;
+
+		/* Have a look at use_1to1_mapping().  We're trying
+		 * to match SBUS if that's the top-level bus and we
+		 * don't have some intervening real bus that provides
+		 * ranges based translations.
+		 */
+		if (of_find_property(dp, "ranges", NULL) != NULL)
+			break;
+
+		dp = dp->parent;
+	}
+
+	return 0;
 }
 
 static void of_bus_sbus_count_cells(struct device_node *child,
--- a/arch/sparc/kernel/of_device.c
+++ b/arch/sparc/kernel/of_device.c
@@ -223,8 +223,25 @@ static unsigned long of_bus_pci_get_flag
 
 static int of_bus_sbus_match(struct device_node *np)
 {
-	return !strcmp(np->name, "sbus") ||
-		!strcmp(np->name, "sbi");
+	struct device_node *dp = np;
+
+	while (dp) {
+		if (!strcmp(dp->name, "sbus") ||
+		    !strcmp(dp->name, "sbi"))
+			return 1;
+
+		/* Have a look at use_1to1_mapping().  We're trying
+		 * to match SBUS if that's the top-level bus and we
+		 * don't have some intervening real bus that provides
+		 * ranges based translations.
+		 */
+		if (of_find_property(dp, "ranges", NULL) != NULL)
+			break;
+
+		dp = dp->parent;
+	}
+
+	return 0;
 }
 
 static void of_bus_sbus_count_cells(struct device_node *child,


