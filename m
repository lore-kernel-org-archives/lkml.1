Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYLUPjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYLUPjR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYLUPi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:38:58 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58955 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYLUPi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:38:56 -0500
Date: Sun, 21 Dec 2008 16:38:54 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davem@davemloft.net, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/13] drivers/net: Remove redundant test
Message-ID: <Pine.LNX.4.64.0812211637560.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, ap is checked not to be NULL a few lines before.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x@p1 == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
x@p2 == NULL
|
x@p2 != NULL
)

// another path to the test that is not through p1?
@s exists@
local idexpression r.x;
position r.p1,r.p2;
@@

... when != x@p1
(
x@p2 == NULL
|
x@p2 != NULL
)

@fix depends on !s@
position r.p1,r.p2;
expression x,E;
statement S1,S2;
@@

(
- if ((x@p2 != NULL) || ...)
  S1
|
- if ((x@p2 == NULL) && ...) S1
|
- BUG_ON(x@p2 == NULL);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/ppp_async.c   |    6 ------
 drivers/net/ppp_synctty.c |    6 ------
 2 files changed, 12 deletions(-)

diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index 451bdb5..6567fab 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -293,9 +293,6 @@ ppp_asynctty_ioctl(struct tty_struct *tty, struct file *file,
 	err = -EFAULT;
 	switch (cmd) {
 	case PPPIOCGCHAN:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_channel_index(&ap->chan), p))
 			break;
@@ -303,9 +300,6 @@ ppp_asynctty_ioctl(struct tty_struct *tty, struct file *file,
 		break;
 
 	case PPPIOCGUNIT:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_unit_number(&ap->chan), p))
 			break;
diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index 801d8f9..1e892b7 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -333,9 +333,6 @@ ppp_synctty_ioctl(struct tty_struct *tty, struct file *file,
 	err = -EFAULT;
 	switch (cmd) {
 	case PPPIOCGCHAN:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_channel_index(&ap->chan), p))
 			break;
@@ -343,9 +340,6 @@ ppp_synctty_ioctl(struct tty_struct *tty, struct file *file,
 		break;
 
 	case PPPIOCGUNIT:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_unit_number(&ap->chan), p))
 			break;
