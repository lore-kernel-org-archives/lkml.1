Return-Path: <linux-kernel-owner+w=401wt.eu-S1764063AbXHKTGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764063AbXHKTGE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760611AbXHKS6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:39 -0400
Received: from 1wt.eu ([62.212.114.60]:1583 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762683AbXHKS6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:32 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184853.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:17 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jay Lubomirski <jaylubo@motorola.com>, "Mark A. Greer" <mgreer@mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 25/28] serial: clear proper MPSC interrupt cause bits
Content-Disposition: inline; filename=0025-serial-clear-proper-MPSC-interrupt-cause-bits.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The interrupt clearing code in mpsc_sdma_intr_ack() mistakenly clears the
interrupt for both controllers instead of just the one its supposed to.
This can result in the other controller appearing to hang because its
interrupt was effectively lost.

So, don't clear the interrupt cause bits for both MPSC controllers when
clearing the interrupt for one of them.  Just clear the one that is
supposed to be cleared.

Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mpsc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 3d2fcc5..64ed5ef 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -502,7 +502,8 @@ mpsc_sdma_intr_ack(struct mpsc_port_info *pi)
 
 	if (pi->mirror_regs)
 		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
-	writel(0, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE);
+	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
+	       pi->port.line);
 	return;
 }
 
-- 
1.5.2.4

-- 
