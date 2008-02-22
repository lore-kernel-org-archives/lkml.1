Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbYBVRrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbYBVRrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 12:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763309AbYBVRqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 12:46:42 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:31424 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760064AbYBVRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 12:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=REM94t2PXRU0YaDGr6sSEEMHiNEOck0zRotQh0QwaivHhsszjfnksOd98ZIkci31VsM5l4wgDqiJUfoWV9WOfpm+xFYvt6dUCF/JXnaEZ41aBkC0Bzr3urheWHEbaJq/tH5HV7QTYvoU0bUWFBq2tFcCHYRJt3RMkAjroltP/fA=
Subject: [PATCH] char: fix sparse variable shadowing and int as NULL
	pointer in rocket.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 09:46:59 -0800
Message-Id: <1203702419.5962.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nested min() macros shadow _x, separate into two lines.
drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:451:7: originally declared here
drivers/char/rocket.c:451:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:451:7: originally declared here
drivers/char/rocket.c:451:7: warning: symbol '_y' shadows an earlier one
drivers/char/rocket.c:451:7: originally declared here
drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:1754:7: originally declared here
drivers/char/rocket.c:1754:7: warning: symbol '_x' shadows an earlier one
drivers/char/rocket.c:1754:7: originally declared here
drivers/char/rocket.c:1754:7: warning: symbol '_y' shadows an earlier one
drivers/char/rocket.c:1754:7: originally declared here
drivers/char/rocket.c:1751:20: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/rocket.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 72f2892..2778d64 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -448,7 +448,8 @@ static void rp_do_transmit(struct r_port *info)
 	while (1) {
 		if (tty->stopped || tty->hw_stopped)
 			break;
-		c = min(info->xmit_fifo_room, min(info->xmit_cnt, XMIT_BUF_SIZE - info->xmit_tail));
+		c = min(info->xmit_fifo_room, info->xmit_cnt);
+		c = min(c, XMIT_BUF_SIZE - info->xmit_tail);
 		if (c <= 0 || info->xmit_fifo_room <= 0)
 			break;
 		sOutStrW(sGetTxRxDataIO(cp), (unsigned short *) (info->xmit_buf + info->xmit_tail), c / 2);
@@ -1748,10 +1749,10 @@ static int rp_write(struct tty_struct *tty,
 
 	/*  Write remaining data into the port's xmit_buf */
 	while (1) {
-		if (info->tty == 0)	/*   Seemingly obligatory check... */
+		if (info->tty == NULL)	/*   Seemingly obligatory check... */
 			goto end;
-
-		c = min(count, min(XMIT_BUF_SIZE - info->xmit_cnt - 1, XMIT_BUF_SIZE - info->xmit_head));
+		c = min(count, XMIT_BUF_SIZE - info->xmit_cnt - 1);
+		c = min(c, XMIT_BUF_SIZE - info->xmit_head);
 		if (c <= 0)
 			break;
 
-- 
1.5.4.2.200.g99e75



