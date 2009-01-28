Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZA1Us1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZA1Us1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbZA1UcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:10 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47771 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbZA1UcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:09 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:01 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 01/12] OMAP2/3 clock: don't use a barrier after clk_disable()
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:01 -0700
Message-ID: <20090128193456.2396.29131.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_disable() previously used an ARM barrier, wmb(), to try to ensure
that the hardware write completed before continuing.  There are some
problems with this approach.

The first problem is that wmb() only ensures that the write leaves the
ARM -- not that it actually reaches the endpoint device.  In this
case, the endpoint device - either the PRM, CM, or SCM - is three
interconnects away from the ARM, and the final interconnect is
low-speed.  And the OCP interconnects will post the write, who knows
how long that will take to complete.  So the wmb() is not really what
we want.

Worse, the wmb() is indiscriminate; it will cause the ARM to flush any
other unrelated buffered writes and wait for the local interconnect to
acknowledge them - potentially very expensive.

This first problem could be fixed by doing a readback of the same PRM/CM/SCM
register.  Since these devices use a single OCP thread, this will cause the
MPU to wait for the write to complete.

But the primary problem is a conceptual one: clk_disable() should not
need any kind of barrier.  clk_enable() needs one since device driver
code must not access a device until its clocks are known to be
enabled.  But clk_disable() has no such restriction.

Since blocking the MPU on a PRM/CM/SCM write can be a very
high-latency operation - several hundred MPU cycles - it's worth
avoiding this barrier if possible.

linux-omap source commit is f4aacad2c0ed1055622d5c1e910befece24ef0e2.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 07b6232..a1ccdcb 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -448,7 +448,7 @@ static void _omap2_clk_disable(struct clk *clk)
 	else
 		v &= ~(1 << clk->enable_bit);
 	_omap2_clk_write_reg(v, clk->enable_reg, clk);
-	wmb();
+	/* No OCP barrier needed here since it is a disable operation */
 }
 
 void omap2_clk_disable(struct clk *clk)


