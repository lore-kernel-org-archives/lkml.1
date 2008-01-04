Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYADOp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYADOp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 09:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYADOpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 09:45:17 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59261 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYADOpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:45:15 -0500
Date: Fri, 4 Jan 2008 15:45:01 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/pcmcia: Add missing pci_dev_get
Message-ID: <Pine.LNX.4.58.0801041542280.1184@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

pci_get_slot does a pci_dev_get, so pci_dev_put needs to be called in an
error case.


An extract of the semantic match used to find the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type find1.T,T1,T2;
identifier find1.E;
statement find1.S;
expression x1,x2,x3;
expression find1.test;
int ret != 0;
@@

  T E;
  ...
(
* E = pci_get_slot(...);
  if (E == NULL) S
|
* if ((E = pci_get_slot(...)) == NULL)
  S
)
  ... when != pci_dev_put(...,(T1)E,...)
      when != if (E != NULL) { ... pci_dev_put(...,(T1)E,...); ...}
      when != x1 = (T1)E
      when != E = x3;
      when any
  if (test) {
    ... when != pci_dev_put(...,(T2)E,...)
        when != if (E != NULL) { ... pci_dev_put(...,(T2)E,...); ...}
        when != x2 = (T2)E
(
*   return;
|
*   return ret;
)
  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
--- a/drivers/pcmcia/cardbus.c	2007-06-02 22:32:26.000000000 +0200
+++ b/drivers/pcmcia/cardbus.c	2008-01-04 14:17:42.000000000 +0100
@@ -143,7 +143,7 @@ int read_cb_mem(struct pcmcia_socket * s
 	/* Config space? */
 	if (space == 0) {
 		if (addr + len > 0x100)
-			goto fail;
+			goto failput;
 		for (; len; addr++, ptr++, len--)
 			pci_read_config_byte(dev, addr, ptr);
 		return 0;
@@ -171,6 +171,8 @@ int read_cb_mem(struct pcmcia_socket * s
 	memcpy_fromio(ptr, s->cb_cis_virt + addr, len);
 	return 0;

+failput:
+	pci_dev_put(dev);
 fail:
 	memset(ptr, 0xff, len);
 	return -1;
