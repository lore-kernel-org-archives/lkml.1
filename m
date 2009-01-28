Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZA1Izu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZA1Izu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 03:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZA1Izm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 03:55:42 -0500
Received: from norkia.v3.sk ([92.240.234.41]:56863 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZA1Izl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 03:55:41 -0500
X-Greylist: delayed 1508 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2009 03:55:41 EST
Subject: [PATCH] Fix a panic with 1M of shared memory, no GTT entries
From: Lubomir Rintel <lkundrak@v3.sk>
To: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain
Date: Wed, 28 Jan 2009 09:30:43 +0100
Message-Id: <1233131443.5389.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When GTT size is equal to amount of video memory, the amount of GTT
entries is computed lower than zero, which is invalid and leads to
off-by-one error in intel_i915_configure()

Originally posted here:
http://bugzilla.kernel.org/show_bug.cgi?id=12539
http://bugzilla.redhat.com/show_bug.cgi?id=445592

Signed-Off-By: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/char/agp/intel-agp.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index c771418..4373adb 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -633,13 +633,15 @@ static void intel_i830_init_gtt_entries(void)
 			break;
 		}
 	}
-	if (gtt_entries > 0)
+	if (gtt_entries > 0) {
 		dev_info(&agp_bridge->dev->dev, "detected %dK %s memory\n",
 		       gtt_entries / KB(1), local ? "local" : "stolen");
-	else
+		gtt_entries /= KB(4);
+	} else {
 		dev_info(&agp_bridge->dev->dev,
 		       "no pre-allocated video memory detected\n");
-	gtt_entries /= KB(4);
+		gtt_entries = 0;
+	}
 
 	intel_private.gtt_entries = gtt_entries;
 }
-- 
1.5.5.6

