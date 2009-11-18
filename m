Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZKRMST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZKRMST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 07:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZKRMSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 07:18:18 -0500
Received: from server1.wserver.cz ([82.113.45.157]:42592 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZKRMSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 07:18:18 -0500
From: Jiri Slaby <jslaby@novell.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/1] Char: cyclades, fix compiler warning
Date: Wed, 18 Nov 2009 13:18:22 +0100
Message-Id: <1258546702-29591-1-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20091114080505.7715b022.akpm@linux-foundation.org>
References: <20091114080505.7715b022.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc 4.0.2:
drivers/char/cyclades.c: In function 'cyy_interrupt':
drivers/char/cyclades.c:581: warning: 'info' may be used uninitialized in this function

introduced by

: commit 3aeea5b92210083c7cffd4f08a0bb141d3f2d574
: Author:     Jiri Slaby <jirislaby@gmail.com>
: AuthorDate: Sat Sep 19 13:13:16 2009 -0700
: Commit:     Live-CD User <linux@linux.site>
: CommitDate: Sat Sep 19 13:13:16 2009 -0700
:
:    cyclades: introduce cyy_readb/writeb

In fact the true branch which uses uninitialized 'info' can never
happen because chip is always less than ->nchips and channel is
always less than 4 which we alloc.

So behave similar to rx handling and remove the test completely.

I wonder why gcc 4.4.1 doesn't spit a word.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Jiri Slaby <jslaby@novell.com>
---
 drivers/char/cyclades.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index a188c05..e026f24 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -595,14 +595,8 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 	channel = save_xir & CyIRChannel;
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
-	info = &cinfo->ports[channel + chip * 4];
 
-	/* validate the port# (as configured and open) */
-	if (channel + chip * 4 >= cinfo->nports) {
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
-		goto end;
-	}
+	info = &cinfo->ports[channel + chip * 4];
 	tty = tty_port_tty_get(&info->port);
 	if (tty == NULL) {
 		cyy_writeb(info, CySRER, cyy_readb(info, CySRER) & ~CyTxRdy);
-- 
1.6.4.2

