Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZHCFcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZHCFcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZHCFcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:32:18 -0400
Received: from mail.atheros.com ([12.36.123.2]:55107 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZHCFcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:32:17 -0400
From: <jie.yang@atheros.com>
To: <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: atl1c: Do not call cancel_work_sync from the work itself
Date: Mon, 3 Aug 2009 13:32:19 +0800
Message-ID: <12492775393830-git-send-email-jie.yang@atheros.com>
X-Mailer: git-send-email 1.5.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: jie yang <jie.yang>@atheros.com
---

diff --git a/drivers/net/atl1c/atl1c.h b/drivers/net/atl1c/atl1c.h
index 2a1120a..53242dc 100644
--- a/drivers/net/atl1c/atl1c.h
+++ b/drivers/net/atl1c/atl1c.h
@@ -427,6 +427,7 @@ struct atl1c_hw {
 #define ATL1C_ASPM_CTRL_MON        0x0200
 #define ATL1C_HIB_DISABLE      0x0400
 #define ATL1C_LINK_CAP_1000M       0x0800
+#define ATL1C_RESET_IN_WORK        0x1000
 #define ATL1C_FPGA_VERSION     0x8000
    u16 cmb_tpd;
    u16 cmb_rrd;
diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index 1d601ce..dec88fa 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -321,7 +321,10 @@ static void atl1c_del_timer(struct atl1c_adapter *adapter)
 
 static void atl1c_cancel_work(struct atl1c_adapter *adapter)
 {
-   cancel_work_sync(&adapter->reset_task);
+   if (adapter->hw.ctrl_flags & ATL1C_RESET_IN_WORK)
+       adapter->hw.ctrl_flags &= ~ATL1C_RESET_IN_WORK;/* clear the flag */
+   else
+       cancel_work_sync(&adapter->reset_task);
    cancel_work_sync(&adapter->link_chg_task);
 }
 
@@ -1544,6 +1547,7 @@ static irqreturn_t atl1c_intr(int irq, void *data)
            /* reset MAC */
            hw->intr_mask &= ~ISR_ERROR;
            AT_WRITE_REG(hw, REG_IMR, hw->intr_mask);
+           adapter->hw.ctrl_flags |= ATL1C_RESET_IN_WORK;
            schedule_work(&adapter->reset_task);
            break;
        }

