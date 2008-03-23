Return-Path: <linux-kernel-owner+w=401wt.eu-S1765994AbYCWJLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765994AbYCWJLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbYCWIRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:17:22 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:37581 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575AbYCWIRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:17:19 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH]skge napi->poll() locking bug
Date: Sun, 23 Mar 2008 10:20:09 +0200
User-Agent: KMail/1.9.7
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803231020.10030.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

According to: Documentation/networking/netdevices.txt:

<cite>
napi->poll:
..........
	Context: softirq
	         will be called with interrupts disabled by netconsole.
</cite>

napi->poll() could be called either with interrupts enabled 
(in softirq context) or disabled (by netconsole), so the irq flag
should be preserved.

Inspired by Ingo's resent forcedeth patch :-)

Regards

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>
===============================
--- a/drivers/net/skge.c	2008-03-23 09:06:13.000000000 +0200
+++ b/drivers/net/skge.c	2008-03-23 09:24:47.000000000 +0200
@@ -3199,12 +3199,14 @@ static int skge_poll(struct napi_struct 
 	skge_write8(hw, Q_ADDR(rxqaddr[skge->port], Q_CSR), CSR_START);
 
 	if (work_done < to_do) {
-		spin_lock_irq(&hw->hw_lock);
+		unsigned long flags;
+		
+		spin_lock_irqsave(&hw->hw_lock, flags);
 		__netif_rx_complete(dev, napi);
 		hw->intr_mask |= napimask[skge->port];
 		skge_write32(hw, B0_IMSK, hw->intr_mask);
 		skge_read32(hw, B0_IMSK);
-		spin_unlock_irq(&hw->hw_lock);
+		spin_unlock_irqrestore(&hw->hw_lock, flags);
 	}
 
 	return work_done;


