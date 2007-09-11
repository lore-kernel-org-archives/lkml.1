Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbXIKPiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbXIKPiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXIKPiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:38:46 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:37739
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbXIKPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:38:45 -0400
Date: Tue, 11 Sep 2007 08:38:23 -0700 (PDT)
Message-Id: <20070911.083823.15264559.davem@davemloft.net>
To: kovedi@gmail.com
Cc: linux-kernel@vger.kernel.org, stable-bounces@kernel.org,
       davem@sunset.davemloft.net
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com>
References: <406fe6c90709100442j1ae0ef79v3188eb10b8be451b@mail.gmail.com>
	<20070910.053642.71114977.davem@davemloft.net>
	<406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I think this patch should fix the problem.

Please give it a try, thanks.

diff --git a/arch/sparc64/kernel/pci.c b/arch/sparc64/kernel/pci.c
index 139b4cf..e8dac81 100644
--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -744,7 +744,7 @@ static void __devinit pci_of_scan_bus(struct pci_pbm_info *pbm,
 {
 	struct device_node *child;
 	const u32 *reg;
-	int reglen, devfn;
+	int reglen, devfn, prev_devfn;
 	struct pci_dev *dev;
 
 	if (ofpci_verbose)
@@ -752,14 +752,25 @@ static void __devinit pci_of_scan_bus(struct pci_pbm_info *pbm,
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
