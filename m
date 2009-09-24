Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbZIXMd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbZIXMd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZIXMd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:33:57 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:48344
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752627AbZIXMdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:33:54 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,8,
X-WSS-ID: 0KQH6WB-04-3W6-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 09/10] amd64_edac: fix DRAM base and limit extraction
Date: Thu, 24 Sep 2009 14:32:47 +0200
Message-ID: <1253795568-9877-10-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:40.0334 (UTC) FILETIME=[3EF420E0:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fam10h and above, F1x[1, 0][7C:40] are DRAM Base/Limit registers
which specify the destination node of a DRAM address. Those address
boundaries are being extracted into ->dram_base[] and ->dram_limit[].
Correct the extraction masks to match the respective address bits.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c2c7def..08cb744 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1368,8 +1368,8 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 
 	pvt->dram_IntlvEn[dram] = (low_base >> 8) & 0x7;
 
-	pvt->dram_base[dram] = (((((u64) high_base & 0x000000FF) << 32) |
-				((u64) low_base & 0xFFFF0000))) << 8;
+	pvt->dram_base[dram] = (((u64)high_base & 0x000000FF) << 40) |
+			       (((u64)low_base  & 0xFFFF0000) << 24);
 
 	low_offset = K8_DRAM_LIMIT_LOW + (dram << 3);
 	high_offset = F10_DRAM_LIMIT_HIGH + (dram << 3);
@@ -1390,9 +1390,9 @@ static void f10_read_dram_base_limit(struct amd64_pvt *pvt, int dram)
 	 * Extract address values and form a LIMIT address. Limit is the HIGHEST
 	 * memory location of the region, so low 24 bits need to be all ones.
 	 */
-	low_limit |= 0x0000FFFF;
-	pvt->dram_limit[dram] =
-		((((u64) high_limit << 32) + (u64) low_limit) << 8) | (0xFF);
+	pvt->dram_limit[dram] = (((u64)high_limit & 0x000000FF) << 40) |
+				(((u64) low_limit & 0xFFFF0000) << 24) |
+				0x00FFFFFF;
 }
 
 static void f10_read_dram_ctl_register(struct amd64_pvt *pvt)
-- 
1.6.3.3


