Return-Path: <linux-kernel-owner+w=401wt.eu-S1763588AbXG2Or6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763588AbXG2Or6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 10:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762864AbXG2Ort
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:47:49 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:18874 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762815AbXG2Ors (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from:sender;
        b=I1Iv/1UZNuaVWJAqewr+nh+LeN+I+AowTDUskh1GLeyM/metLQKdG4sBsMySXl/AaTZRLkjqfLjbKqzMBE25GBOQglz0ihlPtfrM6A0p3duLrijYo88G14phNwPAHOamcMBQLZU7GtGCCld6gXUHwcueUlZO2ByTqmUHDUhae8A=
Date: Sun, 29 Jul 2007 22:47:36 +0800
To: linux-kernel@vger.kernel.org
Cc: marcel@holtmann.org
Subject: [PATCH] drivers/bluetooth/hci_ldisc.c: fix possible NULL
	dereferences
Message-ID: <20070729144736.GA13275@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 22ad42033b7d2b3d7928fba9f89d1c7f8a3c9581 did not completely fix all 
the possible NULL dereferences. Besides hci_uart_close(), we also need to 
make sure that hdev is valid before calling hci_{unregister,free}_dev().

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/bluetooth/hci_ldisc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 6055b9c..4813f7c 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -308,11 +308,10 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 	if (hu) {
 		struct hci_dev *hdev = hu->hdev;
 
-		if (hdev)
+		if (hdev) {
 			hci_uart_close(hdev);
-
-		if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
-			hu->proto->close(hu);
+			if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags))
+				hu->proto->close(hu);
 			hci_unregister_dev(hdev);
 			hci_free_dev(hdev);
 		}

