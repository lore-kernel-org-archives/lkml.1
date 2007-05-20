Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXETV0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXETV0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbXETV0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:26:34 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:43457 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757054AbXETV0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:26:34 -0400
Message-id: <212051818303603216@wsc.cz>
In-reply-to: <20461285551864014911@wsc.cz>
Subject: [PATCH 3/3] Char: isicom, proper variables types
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 20 May 2007 23:26:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

isicom, proper variables types

irq is int, base is unsigned long

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2c1fb6b2f7c17ab752e56220a0b7e84fbe6d3448
tree 1b4ceff6aacaae2ad1548c2efa202d7d0c3d92ba
parent 017f1314b3de8cf20bfff7df0d3d55e6498de104
author Jiri Slaby <jirislaby@gmail.com> Sun, 20 May 2007 23:20:41 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 20 May 2007 23:20:41 +0200

 drivers/char/isicom.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 2f8aaf8..77a7a4a 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -184,7 +184,7 @@ static signed char linuxb_to_isib[] = {
 
 struct	isi_board {
 	unsigned long		base;
-	unsigned char		irq;
+	int			irq;
 	unsigned char		port_count;
 	unsigned short		status;
 	unsigned short		port_status; /* each bit for each port */
@@ -224,7 +224,7 @@ static struct isi_port  isi_ports[PORT_COUNT];
  *	it wants to talk.
  */
 
-static inline int WaitTillCardIsFree(u16 base)
+static inline int WaitTillCardIsFree(unsigned long base)
 {
 	unsigned int count = 0;
 	unsigned int a = in_atomic(); /* do we run under spinlock? */
@@ -396,9 +396,9 @@ static inline int __isicom_paranoia_check(struct isi_port const *port,
 
 static void isicom_tx(unsigned long _data)
 {
-	unsigned long flags;
+	unsigned long flags, base;
 	unsigned int retries;
-	short count = (BOARD_COUNT-1), card, base;
+	short count = (BOARD_COUNT-1), card;
 	short txcount, wrd, residue, word_count, cnt;
 	struct isi_port *port;
 	struct tty_struct *tty;
@@ -1730,17 +1730,13 @@ static unsigned int card_count;
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	unsigned int ioaddr, signature, index;
+	unsigned int signature, index;
 	int retval = -EPERM;
-	u8 pciirq;
 	struct isi_board *board = NULL;
 
 	if (card_count >= BOARD_COUNT)
 		goto err;
 
-	ioaddr = pci_resource_start(pdev, 3);
-	/* i.e at offset 0x1c in the PCI configuration register space. */
-	pciirq = pdev->irq;
 	dev_info(&pdev->dev, "ISI PCI Card(Device ID 0x%x)\n", ent->device);
 
 	/* allot the first empty slot in the array */
@@ -1751,8 +1747,8 @@ static int __devinit isicom_probe(struct pci_dev *pdev,
 		}
 
 	board->index = index;
-	board->base = ioaddr;
-	board->irq = pciirq;
+	board->base = pci_resource_start(pdev, 3);
+	board->irq = pdev->irq;
 	card_count++;
 
 	pci_set_drvdata(pdev, board);
