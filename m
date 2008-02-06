Return-Path: <linux-kernel-owner+w=401wt.eu-S1764450AbYBFX5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764450AbYBFX5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764061AbYBFXyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:17 -0500
Received: from ns2.suse.de ([195.135.220.15]:59860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763675AbYBFXyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:15 -0500
Date: Wed, 6 Feb 2008 15:51:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stable.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/73] SPARC64: Fix memory controller register access when
	non-SMP.
Message-ID: <20080206235107.GH13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-memory-controller-register-access-when-non-smp.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: David Miller <davem@davemloft.net>

[SPARC64]: Fix memory controller register access when non-SMP.

[ Upstream commit: b332b8bc9c67165eabdfc7d10b4a2e4cc9f937d0 ]

get_cpu() always returns zero on non-SMP builds, but we
really want the physical cpu number in this code in order
to do the right thing.

Based upon a non-SMP kernel boot failure report from Bernd Zeimetz.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/chmc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/sparc64/kernel/chmc.c
+++ b/arch/sparc64/kernel/chmc.c
@@ -1,7 +1,6 @@
-/* $Id: chmc.c,v 1.4 2002/01/08 16:00:14 davem Exp $
- * memctrlr.c: Driver for UltraSPARC-III memory controller.
+/* memctrlr.c: Driver for UltraSPARC-III memory controller.
  *
- * Copyright (C) 2001 David S. Miller (davem@redhat.com)
+ * Copyright (C) 2001, 2007 David S. Miller (davem@davemloft.net)
  */
 
 #include <linux/module.h>
@@ -16,6 +15,7 @@
 #include <linux/init.h>
 #include <asm/spitfire.h>
 #include <asm/chmctrl.h>
+#include <asm/cpudata.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
 #include <asm/io.h>
@@ -242,8 +242,11 @@ int chmc_getunumber(int syndrome_code,
  */
 static u64 read_mcreg(struct mctrl_info *mp, unsigned long offset)
 {
-	unsigned long ret;
-	int this_cpu = get_cpu();
+	unsigned long ret, this_cpu;
+
+	preempt_disable();
+
+	this_cpu = real_hard_smp_processor_id();
 
 	if (mp->portid == this_cpu) {
 		__asm__ __volatile__("ldxa	[%1] %2, %0"
@@ -255,7 +258,8 @@ static u64 read_mcreg(struct mctrl_info 
 				     : "r" (mp->regs + offset),
 				       "i" (ASI_PHYS_BYPASS_EC_E));
 	}
-	put_cpu();
+
+	preempt_enable();
 
 	return ret;
 }

-- 
