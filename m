Return-Path: <linux-kernel-owner+w=401wt.eu-S1750741AbXCHKX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750741AbXCHKX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 05:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXCHKX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 05:23:27 -0500
Received: from p02c11o142.mxlogic.net ([208.65.145.65]:39868 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXCHKX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 05:23:26 -0500
Date: Thu, 8 Mar 2007 12:23:54 +0200
From: "Michael S. Tsirkin" <mst@mellanox.co.il>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
Message-ID: <20070308102354.GC5149@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@mellanox.co.il>
References: <20070227103021.GA2250@kernel.dk> <m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wt1s6x2p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 08 Mar 2007 10:26:02.0573 (UTC) FILETIME=[2BFD47D0:01C7616C]
X-TM-AS-Product-Ver: SMEX-7.0.0.1526-3.6.1039-15040.003
X-TM-AS-Result: No--6.278500-4.000000-31
X-Spam: [F=0.4633058877; S=0.463(2007030701)]
X-MAIL-FROM: <mst@mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The only case I can see which might trigger this is if we saved
> pci-X state and then didn't restore it because we could not find
> the capability on restore.

Hmm. pci_save_pcix_state/pci_restore_pcix_state seem to only handle
regular devices and seem to ignore the fact that for bridge PCI-X
capability has a different structure.

Is this intentional? If not, here's a patch to fix this.
Warning: completely untested.


PCI: restore bridge PCI-X capability registers after PM event

Restore PCI-X bridge up/downstream capability registers
after PM event.  This includes maxumum split transaction
commitment limit which might be vital for PCI X.

Signed-off-by: Michael S. Tsirkin <mst@mellanox.co.il>

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index df49530..4b788ef 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -597,14 +597,19 @@ static int pci_save_pcix_state(struct pci_dev *dev)
 	if (pos <= 0)
 		return 0;
 
-	save_state = kzalloc(sizeof(*save_state) + sizeof(u16), GFP_KERNEL);
+	save_state = kzalloc(sizeof(*save_state) + sizeof(u16) * 2, GFP_KERNEL);
 	if (!save_state) {
-		dev_err(&dev->dev, "Out of memory in pci_save_pcie_state\n");
+		dev_err(&dev->dev, "Out of memory in pci_save_pcix_state\n");
 		return -ENOMEM;
 	}
 	cap = (u16 *)&save_state->data[0];
 
-	pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
+	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
+		pci_read_config_word(dev, pos + PCI_X_BRIDGE_UP_SPL_CTL, &cap[i++]);
+		pci_read_config_word(dev, pos + PCI_X_BRIDGE_DN_SPL_CTL, &cap[i++]);
+	} else
+		pci_read_config_word(dev, pos + PCI_X_CMD, &cap[i++]);
+
 	pci_add_saved_cap(dev, save_state);
 	return 0;
 }
@@ -621,7 +626,11 @@ static void pci_restore_pcix_state(struct pci_dev *dev)
 		return;
 	cap = (u16 *)&save_state->data[0];
 
-	pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
+	if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE) {
+		pci_write_config_word(dev, pos + PCI_X_BRIDGE_UP_SPL_CTL, cap[i++]);
+		pci_write_config_word(dev, pos + PCI_X_BRIDGE_DN_SPL_CTL, cap[i++]);
+	} else
+		pci_write_config_word(dev, pos + PCI_X_CMD, cap[i++]);
 	pci_remove_saved_cap(save_state);
 	kfree(save_state);
 }
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index f09cce2..fb7eefd 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -332,6 +332,8 @@
 #define  PCI_X_STATUS_SPL_ERR	0x20000000	/* Rcvd Split Completion Error Msg */
 #define  PCI_X_STATUS_266MHZ	0x40000000	/* 266 MHz capable */
 #define  PCI_X_STATUS_533MHZ	0x80000000	/* 533 MHz capable */
+#define PCI_X_BRIDGE_UP_SPL_CTL 10	/* PCI-X upstream split transaction limit */
+#define PCI_X_BRIDGE_DN_SPL_CTL 14	/* PCI-X downstream split transaction limit */
 
 /* PCI Express capability registers */
 


-- 
MST
