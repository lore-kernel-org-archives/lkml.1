Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZG0Hxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZG0Hxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZG0Hxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:53:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48772 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZG0Hxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:53:32 -0400
Date: Mon, 27 Jul 2009 17:53:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Karsten Keil <keil@b1-systems.de>
Subject: linux-next:  tree build failure
Message-Id: <20090727175328.fe3197a5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/isdn/hisax/built-in.o: In function `setup_w6692':
(.opd+0x4a28): multiple definition of `setup_w6692'
drivers/isdn/hardware/built-in.o:(.opd+0x4e90): first defined here
drivers/isdn/hisax/built-in.o: In function `.setup_w6692':
(.devinit.text+0x5b14): multiple definition of `.setup_w6692'
drivers/isdn/hardware/built-in.o:(.text+0x8b75c): first defined here

Caused by commit 707b2ce6c1f4f1261788f2ff09ad82c35e0e6240
("mISDN: Add driver for Winbond cards").

setup_w6692 appears in drivers/isdn/hardware/mISDN/w6692.c and
drivers/isdn/hisax/w6692.c.  I applied the patch below for today (this
may not be correct).

[I also get these warnings:
drivers/isdn/hardware/mISDN/w6692.c:533: warning: 'setvolume' defined but not used
drivers/isdn/hardware/mISDN/w6692.c:560: warning: 'enable_pots' defined but not used
]
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Jul 2009 17:45:36 +1000
Subject: [PATCH] net: fix multiple definitions of setup_w6692

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/isdn/hardware/mISDN/w6692.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
index 1b9008f..d3f1077 100644
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -1234,7 +1234,7 @@ w6692_dctrl(struct mISDNchannel *ch, u32 cmd, void *arg)
 	return err;
 }
 
-int
+static int
 setup_w6692(struct w6692_hw *card)
 {
 	u32	val;
-- 
1.6.3.3

