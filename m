Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZGOGsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZGOGsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZGOGsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:48:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:50311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZGOGsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:48:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208,223";a="165136468"
From: "Tan, Wei Chong" <wei.chong.tan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 15 Jul 2009 14:47:18 +0800
Subject: Subject: [PATCH] SMI workaround for pit_expect_msb, 2.6.31-rc2
Thread-Topic: Subject: [PATCH] SMI workaround for pit_expect_msb, 2.6.31-rc2
Thread-Index: AcoFGBh0Z0KZbSWmQg2z8QUPqBQriw==
Message-ID: <B28277FD4E0F9247A3D55704C440A140D3278C16@pgsmsx504.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f5e38e1e73e8909afe1bd2c6bd43f5c43a1775f8 Mon Sep 17 00:00:00 2001
From: Wei Chong Tan <wei.chong.tan@intel.com>
Date: Wed, 15 Jul 2009 14:21:26 +0800
Subject: [PATCH] SMI workaround for pit_expect_msb, 2.6.31-rc2

pit_expect_msb() seems to be vulnerable to SMI disturbance corner case in some platforms which causes /proc/cpuinfo to show wrong CPU MHz value when quick_pit_calibrate() jump to success section.
This patch try to minimize such cases by rejecting them so that other calibration method is utilized.
Initial trial shows that out of 300 reboot cycles, 18 uses quick_pit_calibrate() successfully and /proc/cpuinfo shows reasonable CPU MHz.
Without the patch, 1 out of roughly 20 reboot cycles may show wrong MHz value.

Signed-off-by: Wei Chong Tan <wei.chong.tan@intel.com>
---
 arch/x86/kernel/tsc.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6e1a368..68e93c1 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -285,10 +285,29 @@ static inline int pit_expect_msb(unsigned char val, u64 *tscp, unsigned long *de
 		inb(0x42);
 		if (inb(0x42) != val)
 			break;
+		/* What if an SMI kicks in here when
+		 * count is just slightly over 5 and SMI run long enough
+		 * so that PIT MSB value is way bigger then val?
+		 * Then tscp will have an unreasonably large value,
+		 * since the code has no notion of
+		 * how much inb(0x42) MSB is bigger then val when it return from SMI.
+		 * In addition, since the 2 get_cycles() are near,
+		 * deltap may get a sane value.
+		 * If this happen on the final few readings
+		 * just before (d1+d2 < delta >> 11),
+		 * this may skew the average delta variable of quick_pit_calibrate().
+		 */
 		tsc = get_cycles();
 	}
 	*deltap = get_cycles() - tsc;
 	*tscp = tsc;
+	/* inb(0x42) will need to be separately repeated here as
+	 * the SMI may take so long that the old reading
+	 * is no longer reliable. inb(0x42) after all get_cycles is the safest.
+	 */
+	inb(0x42);
+	if (inb(0x42) < (val - 1))
+		return 0;
 
 	/*
 	 * We require _some_ success, but the quality control
-- 
1.6.1.3

