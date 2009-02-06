Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZBFKVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZBFKVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 05:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753823AbZBFKVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 05:21:37 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:47863 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZBFKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 05:21:36 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82430004"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH] usb: musb: - kill the compile warning
Date: Fri,  6 Feb 2009 18:23:30 +0800
Message-Id: <1233915810-18616-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
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
 drivers/usb/musb/musb_regs.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index de3b2f1..c2f6a16 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -333,7 +333,7 @@ static inline u16 musb_read_hwvers(void __iomem *mbase)
 
 static inline void __iomem *musb_read_target_reg_base(u8 i, void __iomem *mbase)
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
