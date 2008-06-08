Return-Path: <linux-kernel-owner+w=401wt.eu-S1765289AbYFHM5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765289AbYFHM5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 08:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761000AbYFHM5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 08:57:01 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54811 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377AbYFHM47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 08:56:59 -0400
Date: Sun, 8 Jun 2008 14:56:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] drivers/s390/char/tape_3590.c: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0806081456260.10294@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

@r exists@
expression E,E1;
statement S;
position p1,p2,p3;
@@

E =@p1 \(kmalloc\|kcalloc\|kzalloc\)(...)
... when != E = E1
if (E == NULL || ...) S
... when != E = E1
if@p2 (...) {
 ... when != kfree(E)
 }
... when != E = E1
kfree@p3(E);

@forall@
position r.p2;
expression r.E;
int E1 != 0;
@@

* if@p2 (...) {
 ... when != kfree(E)
     when strict
return E1; }


Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -1598,7 +1598,7 @@ tape_3590_setup_device(struct tape_devic
 	rc = tape_3590_read_dev_chars(device, rdc_data);
 	if (rc) {
 		DBF_LH(3, "Read device characteristics failed!\n");
-		goto fail_kmalloc;
+		goto fail_rdc_data;
 	}
 	rc = tape_std_assign(device);
 	if (rc)
