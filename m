Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXFZFuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXFZFuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXFZFty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:49:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271AbXFZFtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:49:53 -0400
Date: Mon, 25 Jun 2007 22:49:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 02/10] PCI generic helper function
Message-Id: <20070625224937.502d46a0.akpm@linux-foundation.org>
In-Reply-To: <20070619213808.504997000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070619213808.504997000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:37:03 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> +struct pci_dev *
> +pci_find_upstream_pcie_bridge(struct pci_dev *pdev)

You didn't need a newline there, but that's what the rest of that file
does.  Hu hum.

> +{
> +	struct pci_dev *tmp = NULL;
> +
> +	if (pdev->is_pcie)
> +		return NULL;
> +	while (1) {
> +		if (!pdev->bus->self)
> +			break;
> +		pdev = pdev->bus->self;
> +		/* a p2p bridge */
> +		if (!pdev->is_pcie) {
> +			tmp = pdev;
> +			continue;
> +		}
> +		/* PCI device should connect to a PCIE bridge */
> +		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);

I assume that if this bug triggers, we've found some broken hardware?

Going BUG seems like a pretty rude reaction to this, especially when it
would be so easy to drop a warning and then recover.


How's about this?

--- a/drivers/pci/search.c~intel-iommu-pci-generic-helper-function-fix
+++ a/drivers/pci/search.c
@@ -38,7 +38,11 @@ pci_find_upstream_pcie_bridge(struct pci
 			continue;
 		}
 		/* PCI device should connect to a PCIE bridge */
-		BUG_ON(pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE);
+		if (pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE) {
+			/* Busted hardware? */
+			WARN_ON_ONCE(1);
+			return NULL;
+		}
 		return pdev;
 	}
 

