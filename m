Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZKPDIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZKPDIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 22:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZKPDIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 22:08:44 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:50516 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZKPDIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 22:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Oppbb1J729qjv5xYsDxnzBKLiZooUUW92264vvV5fhsS7xBcbNeXtApG9Bz1VXYCpD
         CYpe4eTxk82oEwn9EnslhRvaqwUbmMmewnaEdRP3wqQ/WRnxTNT/DTJsdVmTiWIV+Xhz
         F9GMzcCQ7WyeUPvaLboGnZy0Lzw2UTKOhMjXE=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Ralph Campbell <infinipath@qlogic.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH] ipath: Use bitmap_weight
Date: Mon, 16 Nov 2009 12:08:00 +0900
Message-Id: <1258340880-28269-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap_weight instead of finding all set bits in bitmap

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Ralph Campbell <infinipath@qlogic.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ipath/ipath_driver.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 013d138..d2787fe 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -39,6 +39,7 @@
 #include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/vmalloc.h>
+#include <linux/bitmap.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
@@ -1697,7 +1698,7 @@ void ipath_chg_pioavailkernel(struct ipath_devdata *dd, unsigned start,
 			      unsigned len, int avail)
 {
 	unsigned long flags;
-	unsigned end, cnt = 0, next;
+	unsigned end, cnt = 0;
 
 	/* There are two bits per send buffer (busy and generation) */
 	start *= 2;
@@ -1748,12 +1749,7 @@ void ipath_chg_pioavailkernel(struct ipath_devdata *dd, unsigned start,
 
 	if (dd->ipath_pioupd_thresh) {
 		end = 2 * (dd->ipath_piobcnt2k + dd->ipath_piobcnt4k);
-		next = find_first_bit(dd->ipath_pioavailkernel, end);
-		while (next < end) {
-			cnt++;
-			next = find_next_bit(dd->ipath_pioavailkernel, end,
-					next + 1);
-		}
+		cnt = bitmap_weight(dd->ipath_pioavailkernel, end);
 	}
 	spin_unlock_irqrestore(&ipath_pioavail_lock, flags);
 
-- 
1.6.5.1

