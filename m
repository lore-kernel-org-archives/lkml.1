Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbZINUI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbZINUI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757092AbZINUI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:08:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54009 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054AbZINUIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:22 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Philippe Gerum <rpm@xenomai.org>
Subject: [PATCH 10/72] Blackfin: reuse evt_evt14 handler to perform irqtail epilogue
Date: Mon, 14 Sep 2009 16:07:14 -0400
Message-Id: <1252958896-25150-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Gerum <rpm@xenomai.org>

Signed-off-by: Philippe Gerum <rpm@xenomai.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/interrupt.S |   24 +-----------------------
 1 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index 9c46680..ae7fc88 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -276,33 +276,11 @@ ENTRY(___ipipe_call_irqtail)
 	( r7:4, p5:3 ) = [sp++];
 	rets = [sp++];
 
-	[--sp] = reti;
-	reti = [sp++];          /* IRQs are off. */
-	r0.h = 3f;
-	r0.l = 3f;
-	p0.l = lo(EVT14);
-	p0.h = hi(EVT14);
-	[p0] = r0;
-	csync;
 	r0 = 0x401f (z);
 	sti r0;
-	raise 14;
-	[--sp] = reti;          /* IRQs on. */
+	raise 14;		/* Branches to _evt_evt14 */
 2:
 	jump 2b;                /* Likely paranoid. */
-3:
-	sp += 4;                /* Discard saved RETI */
-	r0.h = _evt14_softirq;
-	r0.l = _evt14_softirq;
-	p0.l = lo(EVT14);
-	p0.h = hi(EVT14);
-	[p0] = r0;
-	csync;
-	p0.l = _bfin_irq_flags;
-	p0.h = _bfin_irq_flags;
-	r0 = [p0];
-	sti r0;
-	rts;
 ENDPROC(___ipipe_call_irqtail)
 
 #endif /* CONFIG_IPIPE */
-- 
1.6.4.2

