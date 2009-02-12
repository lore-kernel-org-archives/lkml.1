Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZBLMad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZBLMad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbZBLMaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:30:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbZBLMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:30:22 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com
Subject: [PATCH v2] dmaengine: Fix oops on dmatest module unload.
Date: Thu, 12 Feb 2009 13:30:11 +0100
Message-Id: <1234441811-9628-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090212.204840.124087545.nemoto@toshiba-tops.co.jp>
References: <20090212.204840.124087545.nemoto@toshiba-tops.co.jp>
X-Provags-ID: V01U2FsdGVkX18BhF9NWNysszVa5Q3gCdxqXrhbve+b009jG37
 LxO8vJ9cwYP+Rh/S0GZyeaCODUQEVb73WWL5QVyUMOBUF59ka4
 1SMbNZVq1jfWgkg9MyZzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an oops that happens when the dmatest module is unloaded. The
dma_release_channel() function is called on channels that have already been
cleaned up (and therefore freed) with dmatest_cleanup_channel().

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

---
 drivers/dma/dmatest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 732fa1e..0fb053e 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -433,10 +433,10 @@ static void __exit dmatest_exit(void)
 
 	list_for_each_entry_safe(dtc, _dtc, &dmatest_channels, node) {
 		list_del(&dtc->node);
-		dmatest_cleanup_channel(dtc);
 		pr_debug("dmatest: dropped channel %s\n",
 			 dma_chan_name(dtc->chan));
 		dma_release_channel(dtc->chan);
+		dmatest_cleanup_channel(dtc);
 	}
 }
 module_exit(dmatest_exit);
-- 
tg: (8e49215..) adx/dma (depends on: adx/master)
