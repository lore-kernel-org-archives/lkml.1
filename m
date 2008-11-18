Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYKRIXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYKRIXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbYKRIWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:22:22 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:51424 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYKRIWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:22:16 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691808"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH 6/6] usb: musb: - kill the compile warning
Date: Tue, 18 Nov 2008 16:23:40 +0800
Message-Id: <1226996620-11388-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
References: <1226996620-11388-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/musb/musb_core.c:1433: warning: assignment makes pointer
from integer without a cast
	hw_ep->target_regs = musb_read_target_reg_base(i, mbase);

static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase);

this is a common bug, but a bug still ?  mbase is a 32/64 bit pointer,
but we return a u16 to assign to a pointer ?  seems odd :)

So return right pointer in the stub.

Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/usb/musb/musb_regs.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index 37f90f0..6f6b1f9 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -331,9 +331,9 @@ static inline u16 musb_read_hwvers(void __iomem *mbase)
 	return musb_readw(mbase, MUSB_HWVERS);
 }
 
-static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase)
+static inline void __iomem *musb_read_target_reg_base(u8 i, void __iomem *mbase)
 {
-	return (MUSB_BUSCTL_OFFSET(i, 0) + mbase);
+	return (void __iomem *)(MUSB_BUSCTL_OFFSET(i, 0) + mbase);
 }
 
 static inline void musb_write_rxfunaddr(void __iomem *ep_target_regs,
@@ -473,9 +473,9 @@ static inline u16 musb_read_hwvers(void __iomem *mbase)
 	return 0;
 }
 
-static inline u16 musb_read_target_reg_base(u8 i, void __iomem *mbase)
+static inline void __iomem *musb_read_target_reg_base(u8 i, void __iomem *mbase)
 {
-	return 0;
+	return NULL;
 }
 
 static inline void musb_write_rxfunaddr(void __iomem *ep_target_regs,
-- 
1.5.6.3
