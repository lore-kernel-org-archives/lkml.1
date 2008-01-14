Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYANV17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYANV17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYANV1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:27:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37661 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYANV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=LuyAKMIMMQpWjx2ZOwB/DrBNqxf0b9Ea0Z2vD7U9mLxkhMaIb6mNpDi84fojbyHdBKZpd+vTwJOQHBqeSJnSJ/G1W/KnDxAqGvoMBgYe1E4qGEbic9BJNqY/I5TIlOtDXCxNKL2jU/FFiPIn83swLT371ya+xU7aCC9T+Id4w5w=
Message-ID: <478BD3D2.3060807@gmail.com>
Date: Tue, 15 Jan 2008 00:27:46 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][MIPS] Malta: Fix reading the PCI clock frequency on big-endian
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The JMPRS register on Malta boards keeps a 32-bit CPU-endian
value. The readw() function assumes that the value it reads is a
little-endian 16-bit number. Therefore, using readw() to obtain
the value of the JMPRS register is a mistake. This error leads
to incorrect reading of the PCI clock frequency on big-endian
during board start-up.

Change readw() to __raw_readl().

This was tested by injecting a call to printk() and verifying
that the value of the jmpr variable was consistent with current
setting of the JP4 "PCI CLK" jumper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 9a2636e..bc43a5c 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -149,7 +149,7 @@ void __init plat_mem_setup(void)
 	/* Check PCI clock */
 	{
 		unsigned int __iomem *jmpr_p = (unsigned int *) ioremap(MALTA_JMPRS_REG, sizeof(unsigned int));
-		int jmpr = (readw(jmpr_p) >> 2) & 0x07;
+		int jmpr = (__raw_readl(jmpr_p) >> 2) & 0x07;
 		static const int pciclocks[] __initdata = {
 			33, 20, 25, 30, 12, 16, 37, 10
 		};
-- 
1.5.3
