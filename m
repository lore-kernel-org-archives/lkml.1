Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYBNPOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYBNPOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYBNPOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:14:43 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:57910 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353AbYBNPOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:14:42 -0500
Date: Thu, 14 Feb 2008 16:14:33 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/6] fs/direct-io.c: Use DIV_ROUND_UP
Message-ID: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
(d)) but is perhaps more readable.

An extract of the semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression n,d;
@@

(
- (n + d - 1) / d
+ DIV_ROUND_UP(n,d)
|
- (n + (d - 1)) / d
+ DIV_ROUND_UP(n,d)
)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP((n),d)
+ DIV_ROUND_UP(n,d)

@depends on haskernel@
expression n,d;
@@

- DIV_ROUND_UP(n,(d))
+ DIV_ROUND_UP(n,d)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/fs/direct-io.c b/fs/direct-io.c
--- a/fs/direct-io.c 2008-02-08 08:58:17.000000000 +0100
+++ b/fs/direct-io.c 2008-02-13 20:58:53.000000000 +0100
@@ -976,7 +976,7 @@ direct_io_worker(int rw, struct kiocb *i
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		dio->pages_in_io +=
-			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
+			(DIV_ROUND_UP(user_addr + iov[seg].iov_len, PAGE_SIZE)
 				- user_addr/PAGE_SIZE);
 	}

@@ -998,7 +998,7 @@ direct_io_worker(int rw, struct kiocb *i
 			dio->total_pages++;
 			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
 		}
-		dio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+		dio->total_pages += DIV_ROUND_UP(bytes, PAGE_SIZE);
 		dio->curr_user_address = user_addr;

 		ret = do_direct_IO(dio);
