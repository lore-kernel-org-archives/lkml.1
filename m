Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXGTPHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXGTPHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764523AbXGTPHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:07:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36020 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764294AbXGTPHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:07:42 -0400
Date: Fri, 20 Jul 2007 16:07:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: shemminger@linux-foundation.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sky2 breakage
Message-ID: <20070720150733.GG21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Doing |= 1 << 19 to 16bit unsigned is not particulary useful;
that register is 32bit, unlike the ones dealt with in the rest of
function, so we need u32 variable here.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index a2f3215..13f08a3 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -692,6 +692,7 @@ static void sky2_mac_init(struct sky2_hw *hw, unsigned port)
 {
 	struct sky2_port *sky2 = netdev_priv(hw->dev[port]);
 	u16 reg;
+	u32 rx_reg;
 	int i;
 	const u8 *addr = hw->dev[port]->dev_addr;
 
@@ -768,11 +769,11 @@ static void sky2_mac_init(struct sky2_hw *hw, unsigned port)
 
 	/* Configure Rx MAC FIFO */
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_CLR);
-	reg = GMF_OPER_ON | GMF_RX_F_FL_ON;
+	rx_reg = GMF_OPER_ON | GMF_RX_F_FL_ON;
 	if (hw->chip_id == CHIP_ID_YUKON_EX)
-		reg |= GMF_RX_OVER_ON;
+		rx_reg |= GMF_RX_OVER_ON;
 
-	sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T), reg);
+	sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T), rx_reg);
 
 	/* Flush Rx MAC FIFO on any flow control or error */
 	sky2_write16(hw, SK_REG(port, RX_GMF_FL_MSK), GMR_FS_ANY_ERR);
