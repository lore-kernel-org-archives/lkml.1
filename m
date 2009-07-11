Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZGKHwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZGKHwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZGKHwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:52:15 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59339 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbZGKHwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:52:13 -0400
Date: Sat, 11 Jul 2009 09:50:49 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: maxk@qualcomm.com, vtun@office.satix.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/net: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0907110950300.29592@ask.diku.dk>
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
 drivers/net/tun.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -u -p a/drivers/net/tun.c b/drivers/net/tun.c
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -486,11 +486,12 @@ static unsigned int tun_chr_poll(struct 
 {
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = __tun_get(tfile);
-	struct sock *sk = tun->sk;
+	struct sock *sk;
 	unsigned int mask = 0;
 
 	if (!tun)
 		return POLLERR;
+	sk = tun->sk;
 
 	DBG(KERN_INFO "%s: tun_chr_poll\n", tun->dev->name);
 
