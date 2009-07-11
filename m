Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbZGKHwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbZGKHwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbZGKHwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:52:09 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39555 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467AbZGKHwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:52:07 -0400
Date: Sat, 11 Jul 2009 09:51:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/otus/wwrap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -u -p a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
--- a/drivers/staging/otus/wwrap.c
+++ b/drivers/staging/otus/wwrap.c
@@ -1016,12 +1016,13 @@ void kevent(struct work_struct *work)
 {
     struct usbdrv_private *macp =
                container_of(work, struct usbdrv_private, kevent);
-    zdev_t *dev = macp->device;
+    zdev_t *dev;
 
     if (macp == NULL)
     {
         return;
     }
+    dev = macp->device;
 
     if (test_and_set_bit(0, (void *)&smp_kevent_Lock))
     {
