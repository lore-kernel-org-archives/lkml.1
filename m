Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbZG0QQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbZG0QQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZG0QQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:16:08 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40661 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZG0QQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:16:06 -0400
Date: Mon, 27 Jul 2009 18:12:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/12] drivers/char: Correct redundant test
Message-ID: <Pine.LNX.4.64.0907271812340.2682@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dc was tested for NULL at the beginning of the function, in which case the
function returns.  dc does not seem to be updated in the meantime, so the
second test is unnecessary.  I have assumed that the comment, "notify
card" goes with the code below it.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
@@

if (x@ == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/nozomi.c               |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index ec58d8c..9322fec 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1675,11 +1675,6 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	rval = __kfifo_put(port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
-	if (unlikely(dc == NULL)) {
-		DBG1("No device context?");
-		goto exit;
-	}
-
 	spin_lock_irqsave(&dc->spin_mutex, flags);
 	/* CTS is only valid on the modem channel */
 	if (port == &(dc->port[PORT_MDM])) {
