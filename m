Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYADOms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYADOms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYADOmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:42:40 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:36736 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYADOmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:42:39 -0500
Date: Fri, 4 Jan 2008 15:42:26 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: airlied@linux.ie, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/char/agp: Add missing pci_dev_get
Message-ID: <Pine.LNX.4.58.0801041541380.1184@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

pci_get_slot does a pci_dev_get, so pci_dev_put needs to be called in an
error case

The problem was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@exists@
type T1,T2;
identifier E;
statement S,S1;
expression x1,x2,x3;
expression test;
int ret != 0;
@@

  struct pci_dev *E;
  ...
(
  E = \(pci_get_slot\|pci_get_device\|pci_get_bus_and_slot\)(...);
  if (E == NULL) S
|
  if ((E = \(pci_get_slot\|pci_get_device\|pci_get_bus_and_slot\)(...)) == NULL) S
)
  ... when != pci_dev_put(...,(T1)E,...)
      when != if (E != NULL) { ... pci_dev_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
(
  if (E == NULL) S1
|
  if (test)
+   {
(
+   pci_dev_put(E);
    return;
|
+   pci_dev_put(E);
    return ret;
)
+   }
|
  if (test) {
    ... when != pci_dev_put(...,(T2)E,...)
        when != if (E != NULL) { ... pci_dev_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
+   pci_dev_put(E);
    return;
|
+   pci_dev_put(E);
    return ret;
)
  }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
--- a/drivers/char/agp/amd64-agp.c 2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/char/agp/amd64-agp.c 2008-01-04 13:59:45.000000000 +0100
@@ -422,6 +422,7 @@ static int __devinit uli_agp_init(struct

 	if (i == ARRAY_SIZE(uli_sizes)) {
 		printk(KERN_INFO PFX "No ULi size found for %d\n", size);
+		pci_dev_put(dev1);
 		return -ENODEV;
 	}

@@ -429,8 +430,10 @@ static int __devinit uli_agp_init(struct
 	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &httfea);

 	/* if x86-64 aperture base is beyond 4G, exit here */
-	if ((httfea & 0x7fff) >> (32 - 25))
+	if ((httfea & 0x7fff) >> (32 - 25)) {
+		pci_dev_put(dev1);
 		return -ENODEV;
+	}

 	httfea = (httfea& 0x7fff) << 25;

@@ -482,6 +485,7 @@ static int nforce3_agp_init(struct pci_d

 	if (i == ARRAY_SIZE(nforce3_sizes)) {
 		printk(KERN_INFO PFX "No NForce3 size found for %d\n", size);
+		pci_dev_put(dev1);
 		return -ENODEV;
 	}

@@ -496,6 +500,7 @@ static int nforce3_agp_init(struct pci_d
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ( (apbase & 0x7fff) >> (32 - 25) ) {
 		printk(KERN_INFO PFX "aperture base > 4G\n");
+		pci_dev_put(dev1);
 		return -ENODEV;
 	}

