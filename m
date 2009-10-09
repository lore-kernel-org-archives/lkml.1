Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbZJIKTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbZJIKTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbZJIKTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:19:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33906 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760542AbZJIKTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:19:38 -0400
Date: Fri, 9 Oct 2009 11:20:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, gregkh@suse.de
Subject: Re: [Regression, bisected] Transmit failure in et131x.
Message-ID: <20091009112016.4fb07eb7@lxorguk.ukuu.org.uk>
In-Reply-To: <20091008140805.GA21535@emergent.ellipticsemi.com>
References: <20091008140805.GA21535@emergent.ellipticsemi.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please test the following if you would.

If it doesn't work see if you can tell from the other end and tcpdump if the receiver or sender side dies, and let me know if you are using 10, 100 or Gbit and if you have the mtu set over 1500.


et131x: Correct WRAP bit handling

From: Alan Cox <alan@linux.intel.com>

add_10bit loses the existing wrap value

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/et131x/et1310_rx.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)


diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 5356d0f..4c4555d 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -1074,12 +1074,20 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 
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
