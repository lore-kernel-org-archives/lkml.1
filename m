Return-Path: <linux-kernel-owner+w=401wt.eu-S933014AbZFQNna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbZFQNna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765432AbZFQNnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:43:12 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54478 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764899AbZFQNnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:43:11 -0400
Date: Wed, 17 Jun 2009 07:43:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
	resources trees
Message-ID: <20090617134311.GR19977@parisc-linux.org>
References: <20090616220419.14021.84524.stgit@bob.kio> <4A38B3B4.1020304@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A38B3B4.1020304@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 06:13:24PM +0900, Kenji Kaneshige wrote:
> I think the reason why it happen is ia64 (I believe you are using
> ia64 environment) uses pci_claim_resource(), which calls
> insert_resource(), to insert resources. In my understanding, if
> two resources having an identical address range are inserted using
> insert_resource(), the latter one  becomes parent of the first one.
> 
> I made a sample patch, though I don't know if it fixes the problem.
> I hope this would help you. But please note that it is NOT well
> tested.

This patch seems to be saying that it's ia64's fault for using
pci_claim_resource.  Surely pci_claim_resource() is buggy and is the
right place to fix the problem (other users include alpha, mn10300,
powerpc and parisc).

This all kind of begs the question why x86 isn't using
pci_claim_resource(); if it were, bugs like this would be found and
fixed earlier.

It further begs the question why architectures are doing this in the
first place.  All PCI device resources should be in /proc/iomem, no
matter what architecture.

Anyway, this should fix pci_claim_resource (untested):

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 3039fcb..1240351 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -99,11 +99,11 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
 	struct resource *res = &dev->resource[resource];
-	struct resource *root = NULL;
+	struct resource *root;
 	char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
 	int err;
 
-	root = pcibios_select_root(dev, res);
+	root = pci_find_parent_resource(dev, res);
 
 	err = -EINVAL;
 	if (root != NULL)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
