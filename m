Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbZFDSN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbZFDSN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZFDSNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:13:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11354 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZFDSNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hwINbp55tCiDxj0Kq8y9ZLcGBR9Kn/evpfxW3YRoKTbqnrsSzX07fjB/ZPa76HF3Qa
         XSvNOkUBmeVYqCHvLrTG9xLcJWANy89E6ob1EN4u563OnubyO0qhij81/0MpIfwZeVrK
         CNAVpOft91u0/AfCVvcYwv2gVFHPr0zjfX+20=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Molton <ian@mnementh.co.uk>, Pierre Ossman <pierre@ossman.eu>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 6/7] mmc: tmio_mmc: fix SDCLK divider setting
Date: Thu,  4 Jun 2009 20:12:36 +0200
Message-Id: <1244139157-16404-7-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except for the SDCLK = HCLK (divider bypassed) case, the clock
setting resulted in double the requested frequency.
The smallest possible frequency (f_max/512) is configured with
a divider setting 0x80, not 0x40.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mmc/host/tmio_mmc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index fe6d2b6..9f6e180 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -44,10 +44,10 @@ static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 			clock <<= 1;
 			clk >>= 1;
 		}
-		if (clk & 0x1)
-			clk = 0x20000;
+		if (clk == 0)
+			clk = 0x8000 << 1;
 
-		clk >>= 2;
+		clk >>= 1;
 		sd_config_write8(host, CNF_SD_CLK_MODE, (clk & 0x8000) ? 0 : 1);
 		clk |= 0x100;
 	}
-- 
1.6.3.1

