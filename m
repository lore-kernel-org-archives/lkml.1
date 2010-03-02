Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab0CBXvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:51:39 -0500
Received: from kroah.org ([198.145.64.141]:51579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab0CBXgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@novell.com>, Alan Cox <alan@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/36] serial: Char: cyclades, fix compiler warning
Date: Tue,  2 Mar 2010 15:36:17 -0800
Message-Id: <1267573003-782-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@novell.com>

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
Signed-off-by: Jiri Slaby <jslaby@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 4254457..274e965 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -598,12 +598,6 @@ static void cyy_chip_tx(struct cyclades_card *cinfo, unsigned int chip,
 	save_car = readb(base_addr + (CyCAR << index));
 	cy_writeb(base_addr + (CyCAR << index), save_xir);
 
-	/* validate the port# (as configured and open) */
-	if (channel + chip * 4 >= cinfo->nports) {
-		cy_writeb(base_addr + (CySRER << index),
-			  readb(base_addr + (CySRER << index)) & ~CyTxRdy);
-		goto end;
-	}
 	info = &cinfo->ports[channel + chip * 4];
 	tty = tty_port_tty_get(&info->port);
 	if (tty == NULL) {
-- 
1.7.0.1

