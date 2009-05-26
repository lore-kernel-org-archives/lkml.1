Return-Path: <linux-kernel-owner+w=401wt.eu-S1759162AbZEZXd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162AbZEZXd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbZEZXdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:33:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57292 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZEZXdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:33:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Paul Mundt <lethal@linux-sh.org>,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH 1/3] mtd/maps: uclinux: allow systems to override map addr/size
Date: Tue, 26 May 2009 19:33:16 -0400
Message-Id: <1243380798-10089-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090526231902.GA6295@linux-sh.org>
References: <20090526231902.GA6295@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a processor anomaly (05000263 to be exact), most Blackfin parts
cannot keep the embedded filesystem image directly after the kernel in
RAM.  Instead, the filesystem needs to be relocated to the end of memory.
As such, we need to tweak the map addr/size during boot for Blackfin
systems.  This can be done in any early arch/board init code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Paul Mundt <lethal@linux-sh.org>
CC: Greg Ungerer <gerg@uclinux.org>
CC: uclinux-dev@uclinux.org
CC: linux-mtd@lists.infradead.org
---
 drivers/mtd/maps/uclinux.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
index 81756e3..61d4087 100644
--- a/drivers/mtd/maps/uclinux.c
+++ b/drivers/mtd/maps/uclinux.c
@@ -22,8 +22,12 @@
 
 /****************************************************************************/
 
+extern char _ebss;
+
 struct map_info uclinux_ram_map = {
 	.name = "RAM",
+	.phys = (unsigned long)&_ebss,
+	.size = 0,
 };
 
 struct mtd_info *uclinux_ram_mtdinfo;
@@ -55,12 +59,10 @@ static int __init uclinux_mtd_init(void)
 {
 	struct mtd_info *mtd;
 	struct map_info *mapp;
-	extern char _ebss;
-	unsigned long addr = (unsigned long) &_ebss;
 
 	mapp = &uclinux_ram_map;
-	mapp->phys = addr;
-	mapp->size = PAGE_ALIGN(ntohl(*((unsigned long *)(addr + 8))));
+	if (!mapp->size)
+		mapp->size = PAGE_ALIGN(ntohl(*((unsigned long *)(mapp->phys + 8))));
 	mapp->bankwidth = 4;
 
 	printk("uclinux[mtd]: RAM probe address=0x%x size=0x%x\n",
-- 
1.6.3.1

