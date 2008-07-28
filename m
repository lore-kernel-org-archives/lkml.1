Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYG1OK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYG1OK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbYG1OKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:10:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59593 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbYG1OKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:10:14 -0400
Date: Mon, 28 Jul 2008 16:10:09 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: kkeil@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/isdn/capi/kcapi.c: Adjust error handling code
 involving capi_ctr_put
Message-ID: <Pine.LNX.4.64.0807281609190.15369@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

After calling capi_ctr_get, error handling code should call
capi_ctr_put.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E;
statement S;
position p1,p2,p3;
@@

(
if ((x = capi_ctr_get@p1(...)) == NULL || ...) S
|
x = capi_ctr_get@p1(...)
... when != x
if (x == NULL || ...) S
)
<...
if@p3 (...) { ... when != capi_ctr_put(x)
                  when != if (x) { ... capi_ctr_put(x); ...}
    return@p2 ...;
}
...>
(
return x;
|
return 0;
|
x = E
|
E = x
|
capi_ctr_put(x)
)

@exists@
position r.p1,r.p2,r.p3;
expression x;
int ret != 0;
statement S;
@@

* x = capi_ctr_get@p1(...)
  <...
* if@p3 (...)
  S
  ...>
* return@p2 \(NULL\|ret\);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/isdn/capi/kcapi.c     |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 75726ea..5360c4f 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -828,15 +828,18 @@ static int old_capi_manufacturer(unsigned int cmd, void __user *data)
 			return -ESRCH;
 		if (card->load_firmware == NULL) {
 			printk(KERN_DEBUG "kcapi: load: no load function\n");
+			capi_ctr_put(card);
 			return -ESRCH;
 		}
 
 		if (ldef.t4file.len <= 0) {
 			printk(KERN_DEBUG "kcapi: load: invalid parameter: length of t4file is %d ?\n", ldef.t4file.len);
+			capi_ctr_put(card);
 			return -EINVAL;
 		}
 		if (ldef.t4file.data == NULL) {
 			printk(KERN_DEBUG "kcapi: load: invalid parameter: dataptr is 0\n");
+			capi_ctr_put(card);
 			return -EINVAL;
 		}
 
@@ -849,6 +852,7 @@ static int old_capi_manufacturer(unsigned int cmd, void __user *data)
 
 		if (card->cardstate != CARD_DETECTED) {
 			printk(KERN_INFO "kcapi: load: contr=%d not in detect state\n", ldef.contr);
+			capi_ctr_put(card);
 			return -EBUSY;
 		}
 		card->cardstate = CARD_LOADING;
