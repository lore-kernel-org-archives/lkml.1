Return-Path: <linux-kernel-owner+w=401wt.eu-S932307Ab0AFQyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0AFQyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 11:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932216Ab0AFQyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 11:54:20 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:48995 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab0AFQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 11:54:20 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
       Jie Yang <jie.yang@atheros.com>, atl1-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: [PATCH 1/1] NET: atlx, fix memory leak
Date: Wed,  6 Jan 2010 17:54:16 +0100
Message-Id: <1262796856-21919-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak in atl2_get_eeprom. eeprom_buff is not
freed/assigned on all paths. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Chris Snook <chris.snook@gmail.com>
Cc: Jie Yang <jie.yang@atheros.com>
Cc: atl1-devel@lists.sourceforge.net
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/atlx/atl2.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index c0451d7..ec52529 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -1959,12 +1959,15 @@ static int atl2_get_eeprom(struct net_device *netdev,
 		return -ENOMEM;
 
 	for (i = first_dword; i < last_dword; i++) {
-		if (!atl2_read_eeprom(hw, i*4, &(eeprom_buff[i-first_dword])))
-			return -EIO;
+		if (!atl2_read_eeprom(hw, i*4, &(eeprom_buff[i-first_dword]))) {
+			ret_val = -EIO;
+			goto free;
+		}
 	}
 
 	memcpy(bytes, (u8 *)eeprom_buff + (eeprom->offset & 3),
 		eeprom->len);
+free:
 	kfree(eeprom_buff);
 
 	return ret_val;
-- 
1.6.5.7

