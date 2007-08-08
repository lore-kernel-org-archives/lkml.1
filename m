Return-Path: <linux-kernel-owner+w=401wt.eu-S936327AbXHHDg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936327AbXHHDg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 23:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935765AbXHHDgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 23:36:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:9797 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623AbXHHDfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 23:35:48 -0400
X-IronPort-AV: i="4.19,233,1183348800"; 
   d="scan'208"; a="47739376:sNHT22424514"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: dbrownell@users.sourceforge.net,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 08/12] Blackfin arch: add missing gpio error handling to make sure we roll back requests in case one fails
Date: Wed,  8 Aug 2007 11:35:33 +0800
Message-Id: <11865441404194-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11865441373719-git-send-email-bryan.wu@analog.com>
References: <11865441373719-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_gpio.c |   10 ++++++++--
 arch/blackfin/mach-bf548/gpio.c  |   11 +++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index 5d488ef..f712772 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -711,9 +711,15 @@ int peripheral_request_list(unsigned short per[], const char *label)
 	int ret;
 
 	for (cnt = 0; per[cnt] != 0; cnt++) {
+
 		ret = peripheral_request(per[cnt], label);
-		if (ret < 0)
-			return ret;
+
+		if (ret < 0) {
+			for ( ; cnt > 0; cnt--) {
+				peripheral_free(per[cnt - 1]);
+			}
+		return ret;
+		}
 	}
 
 	return 0;
diff --git a/arch/blackfin/mach-bf548/gpio.c b/arch/blackfin/mach-bf548/gpio.c
index c073ab3..f3b9dea 100644
--- a/arch/blackfin/mach-bf548/gpio.c
+++ b/arch/blackfin/mach-bf548/gpio.c
@@ -212,11 +212,18 @@ int peripheral_request_list(unsigned short per[], const char *label)
 	int ret;
 
 	for (cnt = 0; per[cnt] != 0; cnt++) {
+
 		ret = peripheral_request(per[cnt], label);
-		if (ret < 0)
-			return ret;
+
+		if (ret < 0) {
+			for ( ; cnt > 0; cnt--) {
+				peripheral_free(per[cnt - 1]);
+			}
+		return ret;
+		}
 	}
 
+
 	return 0;
 }
 EXPORT_SYMBOL(peripheral_request_list);
-- 
1.5.2
