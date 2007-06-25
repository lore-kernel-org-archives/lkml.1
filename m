Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXFYVEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXFYVEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXFYVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:03:58 -0400
Received: from fw1-az.mvista.com ([65.200.49.156]:4619 "EHLO
	zipcode.az.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752230AbXFYVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:03:57 -0400
Date: Mon, 25 Jun 2007 14:01:49 -0700
From: "Mark A. Greer" <mgreer@mvista.com>
To: "Mark A. Greer" <mgreer@mvista.com>
Cc: lkml <linux-kernel@vger.kernel.org>, jaylubo@motorola.com
Subject: [PATCH] serial: Clear proper MPSC interrupt cause bits
Message-ID: <20070625210149.GB11031@mag.az.mvista.com>
References: <20070622023208.GA20651@mag.az.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622023208.GA20651@mag.az.mvista.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Lubomirski <jaylubo@motorola.com>

The interrupt clearing code in mpsc_sdma_intr_ack() mistakenly clears the
interrupt for both controllers instead of just the one its supposed to.
This can result in the other controller appearing to hang because its
interrupt was effectively lost.

So, don't clear the interrupt cause bits for both MPSC controllers when
clearing the interrupt for one of them.  Just clear the one that is
supposed to be cleared.

Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
Acked-by: Mark A. Greer <mgreer@mvista.com>
---
Please add this to 2.6.21.x and 2.6.22-rc6, if its not too late.

 drivers/serial/mpsc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index d09f209..00924fe 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -503,7 +503,8 @@ mpsc_sdma_intr_ack(struct mpsc_port_info *pi)
 
 	if (pi->mirror_regs)
 		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
-	writel(0, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE);
+	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
+	       pi->port.line);
 	return;
 }
