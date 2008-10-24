Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYJXOv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYJXOv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYJXOvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:51:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60699 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYJXOvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:51:17 -0400
Date: Fri, 24 Oct 2008 16:51:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI pull request #2 for 2.6.28
Message-ID: <20081024145109.GA30103@elte.hu>
References: <200810221714.18723.jbarnes@virtuousgeek.org> <alpine.LFD.2.00.0810231043560.3287@nehalem.linux-foundation.org> <200810231052.47621.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810231052.47621.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thursday, October 23, 2008 10:46 am Linus Torvalds wrote:
> > On Wed, 22 Oct 2008, Jesse Barnes wrote:
> > > A few more bits for 2.6.28, mainly hotplug related stuff so the risk
> > > should be pretty low.  There are a few good fixes in here though too: a
> > > build fix for some architectures due to the new ioremap_nocache usage in
> > > pci.h and a fix for a refcounting bug.
> >
> > Pulled.
> >
> > Ingo tells me that the ARI code is broken on his Nehalem, and that 
> > there's already a confirmed fix for it by Yu Zhao ("[PATCH] pci: fix 
> > ARI") but it's not in this series.
> >
> > Hmm? Status?
> 
> Yeah came in after I set up my pull request; I'll queue it up today.

it's also rather lowprio fix IMO as ARI is a rare new feature. The 
commit below did the trick here and i havent had problems with the 
Nehalem testbox since then.

	Ingo

------------->
>From 8113587c2d14d3be2414190845b2e2617c0aa33b Mon Sep 17 00:00:00 2001
From: Zhao, Yu <yu.zhao@intel.com>
Date: Thu, 23 Oct 2008 13:15:39 +0800
Subject: [PATCH] PCI: fix ARI code to be compatible with mixed ARI/non-ARI systems

The original ARI support code has a compatibility problem with non-ARI
devices.  If a device doesn't support ARI, turning on ARI forwarding on
its upper level bridge will cause undefined behavior.

This fix turns on ARI forwarding only when the subordinate devices
support it.

Tested-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/pci.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 533aeb5..21f2ac6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1309,27 +1309,32 @@ void pci_enable_ari(struct pci_dev *dev)
 	int pos;
 	u32 cap;
 	u16 ctrl;
+	struct pci_dev *bridge;
 
-	if (!dev->is_pcie)
+	if (!dev->is_pcie || dev->devfn)
 		return;
 
-	if (dev->pcie_type != PCI_EXP_TYPE_ROOT_PORT &&
-	    dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)
+	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
+	if (!pos)
 		return;
 
-	pos = pci_find_capability(dev, PCI_CAP_ID_EXP);
+	bridge = dev->bus->self;
+	if (!bridge || !bridge->is_pcie)
+		return;
+
+	pos = pci_find_capability(bridge, PCI_CAP_ID_EXP);
 	if (!pos)
 		return;
 
-	pci_read_config_dword(dev, pos + PCI_EXP_DEVCAP2, &cap);
+	pci_read_config_dword(bridge, pos + PCI_EXP_DEVCAP2, &cap);
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
 
-	pci_read_config_word(dev, pos + PCI_EXP_DEVCTL2, &ctrl);
+	pci_read_config_word(bridge, pos + PCI_EXP_DEVCTL2, &ctrl);
 	ctrl |= PCI_EXP_DEVCTL2_ARI;
-	pci_write_config_word(dev, pos + PCI_EXP_DEVCTL2, ctrl);
+	pci_write_config_word(bridge, pos + PCI_EXP_DEVCTL2, ctrl);
 
-	dev->ari_enabled = 1;
+	bridge->ari_enabled = 1;
 }
 
 int
