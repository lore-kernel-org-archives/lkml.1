Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYJTTBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYJTTBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYJTTBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:01:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46294 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215AbYJTTBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:01:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Don't store volatile bits in WM8350 register cache
Date: Mon, 20 Oct 2008 20:01:14 +0100
Message-Id: <1224529274-9571-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1224529274-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081020190022.GA9504@rakim.wolfsonmicro.main>
 <1224529274-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the contents of the cache clearer and fixes incorrect
initialisation of the cache for partially volatile registers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index fbe22fb..0d47fb9 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -183,6 +183,9 @@ static int wm8350_write(struct wm8350 *wm8350, u8 reg, int num_regs, u16 *src)
 			(wm8350->reg_cache[i] & ~wm8350_reg_io_map[i].writable)
 			| src[i - reg];
 
+		/* Don't store volatile bits */
+		wm8350->reg_cache[i] &= ~wm8350_reg_io_map[i].vol;
+
 		src[i - reg] = cpu_to_be16(src[i - reg]);
 	}
 
@@ -1120,6 +1123,7 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int mode)
 			}
 			value = be16_to_cpu(value);
 			value &= wm8350_reg_io_map[i].readable;
+			value &= ~wm8350_reg_io_map[i].vol;
 			wm8350->reg_cache[i] = value;
 		} else
 			wm8350->reg_cache[i] = reg_map[i];
-- 
1.5.6.5

