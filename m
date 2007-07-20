Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXGTV0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXGTV0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759958AbXGTV0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:26:31 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47848 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbXGTV03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:26:29 -0400
Date: Fri, 20 Jul 2007 23:27:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/7] console: fix section mismatch warning in vgacon.c
Message-ID: <20070720212743.GB25064@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following section mismatch warning:
WARNING: vmlinux.o(.text+0x121e62): Section mismatch: reference to .init.text:__alloc_bootmem (between 'vgacon_startup' and 'vgacon_scrolldelta')

Browsing the code it seems that vgacon_scrollback_startup() is only
called during the init phase so the reference to the .init.text
section is OK.
Teach modpost not to warn using ___init_refok.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 drivers/video/console/vgacon.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index f46fe95..d18b73a 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -187,7 +187,11 @@ static void vgacon_scrollback_init(int pitch)
 	}
 }
 
-static void vgacon_scrollback_startup(void)
+/*
+ * Called only duing init so call of alloc_bootmen is ok.
+ * Marked __init_refok to silence modpost.
+ */
+static void __init_refok vgacon_scrollback_startup(void)
 {
 	vgacon_scrollback = alloc_bootmem(CONFIG_VGACON_SOFT_SCROLLBACK_SIZE
 					  * 1024);
-- 
1.5.1.rc3.g84b7-dirty

