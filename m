Return-Path: <linux-kernel-owner+w=401wt.eu-S1762849AbXIXQn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762849AbXIXQn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761024AbXIXQ2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:55 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58173 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281AbXIXQ2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:54 -0400
Date: Mon, 24 Sep 2007 09:22:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [49/50] Fix sparc64 v100 platform booting.
Message-ID: <20070924162252.GX13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline; filename="fix-sparc64-v100-platform-booting.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>

commit 2cc7345ff71b27b5ac99e49ad7de39360042f601 in mainline

Subject: [49/50] [PATCH] [SPARC64]: Fix booting on V100 systems.

On the root PCI bus, the OBP device tree lists device 3 twice.
Once as 'pm' and once as 'lomp'.

Everything goes downhill from there.

Ignore the second instance to workaround this.

Thanks to Kövedi_Krisztián for the bug report and
testing the fix.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/pci.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -751,7 +751,7 @@ static void __devinit pci_of_scan_bus(st
 {
 	struct device_node *child;
 	const u32 *reg;
-	int reglen, devfn;
+	int reglen, devfn, prev_devfn;
 	struct pci_dev *dev;
 
 	if (ofpci_verbose)
@@ -759,14 +759,25 @@ static void __devinit pci_of_scan_bus(st
 		       node->full_name, bus->number);
 
 	child = NULL;
+	prev_devfn = -1;
 	while ((child = of_get_next_child(node, child)) != NULL) {
 		if (ofpci_verbose)
 			printk("  * %s\n", child->full_name);
 		reg = of_get_property(child, "reg", &reglen);
 		if (reg == NULL || reglen < 20)
 			continue;
+
 		devfn = (reg[0] >> 8) & 0xff;
 
+		/* This is a workaround for some device trees
+		 * which list PCI devices twice.  On the V100
+		 * for example, device number 3 is listed twice.
+		 * Once as "pm" and once again as "lomp".
+		 */
+		if (devfn == prev_devfn)
+			continue;
+		prev_devfn = devfn;
+
 		/* create a new pci_dev for this device */
 		dev = of_create_pci_dev(pbm, child, bus, devfn, 0);
 		if (!dev)

-- 
