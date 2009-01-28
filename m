Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbZA1UqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbZA1UqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbZA1UbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:31:25 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47757 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZA1UbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:31:23 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:31 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 08/10] OMAP: wait for pwrdm transition after clk_enable()
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Date: Tue, 27 Jan 2009 19:44:31 -0700
Message-ID: <20090128024428.27240.35785.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@nokia.com>

Enabling clock in a disabled power domain causes the power domain to be
turned on. However, the power transition is not always finished when
clk_enable() returns and this randomly crashes the kernel when an
interrupt happens right after the clk_enable, and the kernel tries to
read the irq status register for that domain.

Why the irq status register is inaccessible, I don't know. Also it
doesn't seem to be related to the module being not powered up, but to
the transition itself.

The same could perhaps happen after clk_disable also, but I have not
witnessed that.

The problem affects at least dss, cam and sgx clocks.

This change waits for the transition to be finished before returning
from omap2_clkdm_clk_enable().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clockdomain.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clockdomain.c b/arch/arm/mach-omap2/clockdomain.c
index 882809d..ad6dfe4 100644
--- a/arch/arm/mach-omap2/clockdomain.c
+++ b/arch/arm/mach-omap2/clockdomain.c
@@ -561,6 +561,8 @@ int omap2_clkdm_clk_enable(struct clockdomain *clkdm, struct clk *clk)
 	else
 		omap2_clkdm_wakeup(clkdm);
 
+	pwrdm_wait_transition(clkdm->pwrdm.ptr);
+
 	return 0;
 }
 


