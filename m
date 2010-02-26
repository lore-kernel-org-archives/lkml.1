Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965525Ab0BZRgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:36:23 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:13092
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965498Ab0BZRgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:14 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7V-02-2M0-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>, stable@kernel.org
Subject: [PATCH 12/15] oprofile/x86: fix msr access to reserved counters
Date: Fri, 26 Feb 2010 18:30:04 +0100
Message-ID: <1267205407-6523-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0507 (UTC) FILETIME=[219E7830:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During switching virtual counters there is access to perfctr msrs. If
the counter is not available this fails due to an invalid
address. This patch fixes this.

Cc: stable@kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index f4ebc45..6a58256 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -127,7 +127,7 @@ static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (!counter_config[virt].enabled)
+		if (!reset_value[virt])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= model->reserved;
@@ -163,7 +163,8 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* setup reset_value */
 	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
-		if (counter_config[i].enabled)
+		if (counter_config[i].enabled
+		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
 			reset_value[i] = counter_config[i].count;
 		else
 			reset_value[i] = 0;
@@ -197,9 +198,7 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (!counter_config[virt].enabled)
-			continue;
-		if (!msrs->counters[i].addr)
+		if (!reset_value[virt])
 			continue;
 
 		/* setup counter registers */
-- 
1.6.6


