Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbZA1U4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbZA1U4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZA1UdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:33:24 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47914 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbZA1UdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:33:22 -0500
MBOX-Line: From nobody Wed Jan 28 12:08:46 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH C 13/13] OMAP3 clock: disable DPLL autoidle while waiting for
	DPLL to lock
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Peter de Schrijver <peter.de-schrijver@nokia.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:08:46 -0700
Message-ID: <20090128190844.12092.15000.stgit@localhost.localdomain>
In-Reply-To: <20090128190724.12092.22239.stgit@localhost.localdomain>
References: <20090128190724.12092.22239.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During _omap3_noncore_dpll_lock(), if a DPLL has no active downstream
clocks and DPLL autoidle is enabled, the DPLL may never lock, since it
will enter autoidle immediately.  To resolve this, disable DPLL
autoidle while locking the DPLL, and unconditionally wait for the DPLL
to lock.  This fixes some bugs where the kernel would hang when returning
from retention or return the wrong rate for the DPLL.

This patch is a collaboration with Peter de Schrijver
<peter.de-schrijver@nokia.com> and Kevin Hilman
<khilman@deeprootsystems.com>.

linux-omap source commit is 3b7de4be879f1f4f55ae59882a5cbd80f6dcf0f0.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Peter de Schrijver <peter.de-schrijver@nokia.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index c943043..33d5a51 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -162,19 +162,14 @@ static int _omap3_noncore_dpll_lock(struct clk *clk)
 
 	ai = omap3_dpll_autoidle_read(clk);
 
+	omap3_dpll_deny_idle(clk);
+
 	_omap3_dpll_write_clken(clk, DPLL_LOCKED);
 
-	if (ai) {
-		/*
-		 * If no downstream clocks are enabled, CM_IDLEST bit
-		 * may never become active, so don't wait for DPLL to lock.
-		 */
-		r = 0;
+	r = _omap3_wait_dpll_status(clk, 1);
+
+	if (ai)
 		omap3_dpll_allow_idle(clk);
-	} else {
-		r = _omap3_wait_dpll_status(clk, 1);
-		omap3_dpll_deny_idle(clk);
-	};
 
 	return r;
 }


