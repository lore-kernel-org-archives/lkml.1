Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXA1Tqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXA1Tqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 14:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932786AbXA1Tql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 14:46:41 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50814 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbXA1Tqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 14:46:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>,
       Kyle McMartin <kyle@parisc-linux.org>, <linuxppc-dev@ozlabs.org>,
       Brice Goglin <brice@myri.com>, <shaohua.li@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/6] msi: Fix msi_remove_pci_irq_vectors.
References: <1169714047.65693.647693675533.qpush@cradle>
	<m1hcubq6re.fsf@ebiederm.dsl.xmission.com>
	<m1d54zq6o3.fsf_-_@ebiederm.dsl.xmission.com>
	<m18xfnq6lm.fsf_-_@ebiederm.dsl.xmission.com>
Date: Sun, 28 Jan 2007 12:45:54 -0700
In-Reply-To: <m18xfnq6lm.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Sun, 28 Jan 2007 12:44:21 -0700")
Message-ID: <m14pqbq6j1.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since msi_remove_pci_irq_vectors is designed to be called during
hotplug remove it is actively wrong to query the hardware and expect
meaningful results back. 

To that end remove the pci_find_capability calls.  Testing
dev->msi_enabled and dev->msix_enabled gives us all of the information
we need.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pci/msi.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5e7a187..db9c1d7 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -865,13 +865,10 @@ void pci_disable_msix(struct pci_dev* dev)
  **/
 void msi_remove_pci_irq_vectors(struct pci_dev* dev)
 {
-	int pos;
-
 	if (!pci_msi_enable || !dev)
  		return;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSI);
-	if (pos > 0 && dev->msi_enabled) {
+	if (dev->msi_enabled) {
 		if (irq_has_action(dev->first_msi_irq)) {
 			printk(KERN_WARNING "PCI: %s: msi_remove_pci_irq_vectors() "
 			       "called without free_irq() on MSI irq %d\n",
@@ -880,8 +877,7 @@ void msi_remove_pci_irq_vectors(struct pci_dev* dev)
 		} else /* Release MSI irq assigned to this device */
 			msi_free_irq(dev, dev->first_msi_irq);
 	}
-	pos = pci_find_capability(dev, PCI_CAP_ID_MSIX);
-	if (pos > 0 && dev->msix_enabled) {
+	if (dev->msix_enabled) {
 		int irq, head, tail = 0, warning = 0;
 		void __iomem *base = NULL;
 
-- 
1.4.4.1.g278f

