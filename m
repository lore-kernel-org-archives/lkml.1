Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbYFXI0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbYFXI0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbYFXI0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:26:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:44124 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759318AbYFXI0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:26:22 -0400
Date: Tue, 24 Jun 2008 10:26:20 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/14] kernel: Eliminate NULL test and memset after alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241025550.26777@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

 kernel/pid.c    |    2 --
 kernel/printk.c |    5 -----
 2 files changed, 7 deletions(-)

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/kernel/pid.c b/kernel/pid.c
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -517,8 +517,6 @@ void __init pidhash_init(void)
 		pidhash_size * sizeof(struct hlist_head));
 
 	pid_hash = alloc_bootmem(pidhash_size *	sizeof(*(pid_hash)));
-	if (!pid_hash)
-		panic("Could not alloc pidhash!\n");
 	for (i = 0; i < pidhash_size; i++)
 		INIT_HLIST_HEAD(&pid_hash[i]);
 }
diff -u -p a/kernel/printk.c b/kernel/printk.c
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -144,10 +144,6 @@ static int __init log_buf_len_setup(char
 		char *new_log_buf;
 
 		new_log_buf = alloc_bootmem(size);
-		if (!new_log_buf) {
-			printk(KERN_WARNING "log_buf_len: allocation failed\n");
-			goto out;
-		}
 
 		spin_lock_irqsave(&logbuf_lock, flags);
 		log_buf_len = size;
@@ -167,7 +163,6 @@ static int __init log_buf_len_setup(char
 
 		printk(KERN_NOTICE "log_buf_len: %d\n", log_buf_len);
 	}
-out:
 	return 1;
 }
 
