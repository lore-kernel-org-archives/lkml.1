Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbXEUKLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbXEUKLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761487AbXEUKJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:20 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:23653 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbXEUKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:12 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505444:sNHT21422009"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Aubrey Li <aubrey.li@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 20/32] Blackfin arch: dma_memcpy borken for > 64K
Date: Mon, 21 May 2007 18:09:28 +0800
Message-Id: <11797421863363-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aubrey Li <aubrey.li@analog.com>

Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 1c344ac..0ccb0dc 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -595,7 +595,7 @@ unsigned short get_dma_curr_ycount(unsigned int channel)
 }
 EXPORT_SYMBOL(get_dma_curr_ycount);
 
-void *dma_memcpy(void *dest, const void *src, size_t size)
+void *_dma_memcpy(void *dest, const void *src, size_t size)
 {
 	int direction;	/* 1 - address decrease, 0 - address increase */
 	int flag_align;	/* 1 - address aligned,  0 - address unaligned */
@@ -734,6 +734,21 @@ void *dma_memcpy(void *dest, const void *src, size_t size)
 
 	return dest;
 }
+
+void *dma_memcpy(void *dest, const void *src, size_t size)
+{
+	size_t bulk;
+	size_t rest;
+	void * addr;
+
+	bulk = (size >> 16) << 16;
+	rest = size - bulk;
+	if (bulk)
+		_dma_memcpy(dest, src, bulk);
+	addr = _dma_memcpy(dest+bulk, src+bulk, rest);
+	return addr;
+}
+
 EXPORT_SYMBOL(dma_memcpy);
 
 void *safe_dma_memcpy(void *dest, const void *src, size_t size)
-- 
1.5.1.2
