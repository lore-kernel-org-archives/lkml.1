Return-Path: <linux-kernel-owner+w=401wt.eu-S1765026AbYBZUnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765026AbYBZUnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762283AbYBZUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:43:09 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59155 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbYBZUnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:43:07 -0500
Date: Tue, 26 Feb 2008 21:43:03 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/9] drivers/char/isicom.c: Correct use of ! and &
Message-ID: <Pine.LNX.4.64.0802262142390.18200@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In commit e6bafba5b4765a5a252f1b8d31cbf6d2459da337, a bug was fixed that
involved converting !x & y to !(x & y).  The code below shows the same
pattern, and thus should perhaps be fixed in the same way.

This is not tested and clearly changes the semantics, so it is only
something to consider.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ expression E1,E2; @@
(
  !E1 & !E2
|
- !E1 & E2
+ !(E1 & E2)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/char/isicom.c b/drivers/char/isicom.c
--- a/drivers/char/isicom.c 2007-10-22 11:25:05.000000000 +0200
+++ b/drivers/char/isicom.c 2008-02-26 08:01:56.000000000 +0100
@@ -1527,7 +1527,7 @@ static int __devinit reset_card(struct p
 	msleep(10);
 
 	portcount = inw(base + 0x2);
-	if (!inw(base + 0xe) & 0x1 || (portcount != 0 && portcount != 4 &&
+	if (!(inw(base + 0xe) & 0x1) || (portcount != 0 && portcount != 4 &&
 				portcount != 8 && portcount != 16)) {
 		dev_err(&pdev->dev, "ISILoad:PCI Card%d reset failure.\n",
 			card + 1);
