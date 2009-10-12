Return-Path: <linux-kernel-owner+w=401wt.eu-S932436AbZJLOuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436AbZJLOuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932401AbZJLOuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:50:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59150 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932377AbZJLOuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:50:06 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] et131x: Correct WRAP bit handling
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2009 15:38:17 +0100
Message-ID: <20091012143813.20944.66683.stgit@localhost.localdomain>
In-Reply-To: <20091012142816.20944.92471.stgit@localhost.localdomain>
References: <20091012142816.20944.92471.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_10bit loses the existing wrap value

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/et131x/et1310_rx.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)


diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 8f2e91f..10e21db 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -1177,12 +1177,20 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 
 static inline u32 bump_fbr(u32 *fbr, u32 limit)
 {
-	u32 v = *fbr;
-	add_10bit(&v, 1);
-	if (v > limit)
-		v = (*fbr & ~ET_DMA10_MASK) ^ ET_DMA10_WRAP;
-	*fbr = v;
-	return v;
+        u32 v = *fbr;
+        v++;
+        /* This works for all cases where limit < 1024. The 1023 case
+           works because 1023++ is 1024 which means the if condition is not
+           taken but the carry of the bit into the wrap bit toggles the wrap
+           value correctly */
+        if ((v & ET_DMA10_MASK) > limit) {
+                v &= ~ET_DMA10_MASK;
+                v ^= ET_DMA10_WRAP;
+        }
+        /* For the 1023 case */
+        v &= (ET_DMA10_MASK|ET_DMA10_WRAP);
+        *fbr = v;
+        return v;
 }
 
 /**

