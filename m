Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYLFStW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYLFStW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 13:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYLFStN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 13:49:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:33096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYLFStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 13:49:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VROzFxzZTgsFfwHd4UN9OAPA3A+wf0aEBRoaNfRp0Ctz6ApMvEqRS7D4J/XxV0bqB9
         f0AVCfGOyov4W4SPrvcyvDRBvaBEfBBatGQQoeX5YjQAgbGaiHs41nCax1/rqJA2I0e5
         4ibpNMwCupGDwLGeLhgW9SQw/0pfIWq8LPvao=
Date: Sat, 6 Dec 2008 21:49:05 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: convert to list_for_each()
Message-ID: <20081206184905.GA19589@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/me4000/me4000.c |   42 ++++++++++++++++++--------------------
 drivers/staging/usbip/stub_rx.c |    3 +-
 2 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/me4000/me4000.c b/drivers/staging/me4000/me4000.c
index 0ac04b7..4feb615 100644
--- a/drivers/staging/me4000/me4000.c
+++ b/drivers/staging/me4000/me4000.c
@@ -542,8 +542,7 @@ static void clear_board_info_list(void)
 	struct me4000_ao_context *ao_context;
 
 	/* Clear context lists */
-	for (board_p = me4000_board_info_list.next;
-	     board_p != &me4000_board_info_list; board_p = board_p->next) {
+	list_for_each(board_p, &me4000_board_info_list) {
 		board_info = list_entry(board_p, struct me4000_info, list);
 		/* Clear analog output context list */
 		while (!list_empty(&board_info->ao_context_list)) {
@@ -663,12 +662,13 @@ static int init_board_info(struct pci_dev *pci_dev_p,
 	}
 
 	/* Get the index of the board in the global list */
-	for (board_p = me4000_board_info_list.next, i = 0;
-	     board_p != &me4000_board_info_list; board_p = board_p->next, i++) {
+	i = 0;
+	list_for_each(board_p, &me4000_board_info_list) {
 		if (board_p == &board_info->list) {
 			board_info->board_count = i;
 			break;
 		}
+		i++;
 	}
 	if (board_p == &me4000_board_info_list) {
 		printk(KERN_ERR
@@ -1303,11 +1303,12 @@ static int me4000_open(struct inode *inode_p, struct file *file_p)
 		       dev, mode);
 
 		/* Search for the board context */
-		for (ptr = me4000_board_info_list.next, i = 0;
-		     ptr != &me4000_board_info_list; ptr = ptr->next, i++) {
+		i = 0;
+		list_for_each(ptr, &me4000_board_info_list) {
 			board_info = list_entry(ptr, struct me4000_info, list);
 			if (i == board)
 				break;
+			i++;
 		}
 
 		if (ptr == &me4000_board_info_list) {
@@ -1318,13 +1319,13 @@ static int me4000_open(struct inode *inode_p, struct file *file_p)
 		}
 
 		/* Search for the dac context */
-		for (ptr = board_info->ao_context_list.next, i = 0;
-		     ptr != &board_info->ao_context_list;
-		     ptr = ptr->next, i++) {
+		i = 0;
+		list_for_each(ptr, &board_info->ao_context_list) {
 			ao_context = list_entry(ptr, struct me4000_ao_context,
 									list);
 			if (i == dev)
 				break;
+			i++;
 		}
 
 		if (ptr == &board_info->ao_context_list) {
@@ -1384,11 +1385,12 @@ static int me4000_open(struct inode *inode_p, struct file *file_p)
 		PDEBUG("me4000_open():ai board = %d mode = %d\n", board, mode);
 
 		/* Search for the board context */
-		for (ptr = me4000_board_info_list.next, i = 0;
-		     ptr != &me4000_board_info_list; ptr = ptr->next, i++) {
+		i = 0;
+		list_for_each(ptr, &me4000_board_info_list) {
 			board_info = list_entry(ptr, struct me4000_info, list);
 			if (i == board)
 				break;
+			i++;
 		}
 
 		if (ptr == &me4000_board_info_list) {
@@ -1438,8 +1440,7 @@ static int me4000_open(struct inode *inode_p, struct file *file_p)
 		PDEBUG("me4000_open():board = %d\n", board);
 
 		/* Search for the board context */
-		for (ptr = me4000_board_info_list.next;
-		     ptr != &me4000_board_info_list; ptr = ptr->next) {
+		list_for_each(ptr, &me4000_board_info_list) {
 			board_info = list_entry(ptr, struct me4000_info, list);
 			if (board_info->board_count == board)
 				break;
@@ -1483,8 +1484,7 @@ static int me4000_open(struct inode *inode_p, struct file *file_p)
 		PDEBUG("me4000_open():board = %d\n", board);
 
 		/* Search for the board context */
-		for (ptr = me4000_board_info_list.next;
-		     ptr != &me4000_board_info_list; ptr = ptr->next) {
+		list_for_each(ptr, &me4000_board_info_list) {
 			board_info = list_entry(ptr, struct me4000_info, list);
 			if (board_info->board_count == board)
 				break;
@@ -1526,8 +1526,7 @@ static int me4000_open(struct inode *inode_p, struct file *file_p)
 		PDEBUG("me4000_open():board = %d\n", board);
 
 		/* Search for the board context */
-		for (ptr = me4000_board_info_list.next;
-		     ptr != &me4000_board_info_list; ptr = ptr->next) {
+		list_for_each(ptr, &me4000_board_info_list) {
 			board_info = list_entry(ptr, struct me4000_info, list);
 			if (board_info->board_count == board)
 				break;
@@ -5975,8 +5974,7 @@ static void __exit me4000_module_exit(void)
 	pci_unregister_driver(&me4000_driver);
 
 	/* Reset the boards */
-	for (board_p = me4000_board_info_list.next;
-	     board_p != &me4000_board_info_list; board_p = board_p->next) {
+	list_for_each(board_p, &me4000_board_info_list) {
 		board_info = list_entry(board_p, struct me4000_info, list);
 		me4000_reset_board(board_info);
 	}
@@ -6000,9 +5998,7 @@ static int me4000_read_procmem(char *buf, char **start, off_t offset, int count,
 		       (ME4000_DRIVER_VERSION & 0xFF));
 
 	/* Search for the board context */
-	for (ptr = me4000_board_info_list.next;
-	     (ptr != &me4000_board_info_list) && (len < limit);
-	     ptr = ptr->next) {
+	list_for_each(ptr, &me4000_board_info_list) {
 		board_info = list_entry(ptr, struct me4000_info, list);
 
 		len +=
@@ -6110,6 +6106,8 @@ static int me4000_read_procmem(char *buf, char **start, off_t offset, int count,
 		    sprintf(buf + len, "AO 3 status register = 0x%08X\n",
 			    inl(board_info->me4000_regbase +
 				ME4000_AO_03_STATUS_REG));
+		if (len >= limit)
+			break;
 	}
 
 	*eof = 1;
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 2a2cc0f..524de53 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -234,7 +234,6 @@ static void tweak_special_requests(struct urb *urb)
 static int stub_recv_cmd_unlink(struct stub_device *sdev,
 						struct usbip_header *pdu)
 {
-	struct list_head *listhead = &sdev->priv_init;
 	struct list_head *ptr;
 	unsigned long flags;
 
@@ -243,7 +242,7 @@ static int stub_recv_cmd_unlink(struct stub_device *sdev,
 
 	spin_lock_irqsave(&sdev->priv_lock, flags);
 
-	for (ptr = listhead->next; ptr != listhead; ptr = ptr->next) {
+	list_for_each(ptr, &sdev->priv_init) {
 		priv = list_entry(ptr, struct stub_priv, list);
 		if (priv->seqnum == pdu->u.cmd_unlink.seqnum) {
 			int ret;
