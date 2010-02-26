Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528Ab0BZRgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:36:07 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57386
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965460Ab0BZRgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:00 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7O-02-2LK-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/15] oprofile/x86: implement lsfr pseudo-random number generator for IBS
Date: Fri, 26 Feb 2010 18:29:58 +0100
Message-ID: <1267205407-6523-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0335 (UTC) FILETIME=[21843970:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

This patch implements a linear feedback shift register (LFSR) for
pseudo-random number generation for IBS.

For IBS measurements it would be good to minimize memory traffic in
the interrupt handler since every access pollutes the data
caches. Computing a maximal period LFSR just needs shifts and ORs.

The LFSR method is good enough to randomize the ops at low
overhead. 16 pseudo-random bits are enough for the implementation and
it doesn't matter that the pattern repeats with a fairly short
cycle. It only needs to break up (hard) periodic sampling behavior.

The logic was designed by Paul Drongowski.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 6557683..97c84eb 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -218,6 +218,29 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 }
 
+/*
+ * 16-bit Linear Feedback Shift Register (LFSR)
+ *
+ *                       16   14   13    11
+ * Feedback polynomial = X  + X  + X  +  X  + 1
+ */
+static unsigned int lfsr_random(void)
+{
+	static unsigned int lfsr_value = 0xF00D;
+	unsigned int bit;
+
+	/* Compute next bit to shift in */
+	bit = ((lfsr_value >> 0) ^
+	       (lfsr_value >> 2) ^
+	       (lfsr_value >> 3) ^
+	       (lfsr_value >> 5)) & 0x0001;
+
+	/* Advance to next register value */
+	lfsr_value = (lfsr_value >> 1) | (bit << 15);
+
+	return lfsr_value;
+}
+
 static inline void
 op_amd_handle_ibs(struct pt_regs * const regs,
 		  struct op_msrs const * const msrs)
-- 
1.6.6


