Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbXLXOTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbXLXOTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXLXOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:19:35 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58152 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXLXOTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:19:34 -0500
Date: Mon, 24 Dec 2007 15:19:29 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: matthew@wil.cx, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/38] arch/parisc: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241518580.23999@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -r -u -p a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
--- a/arch/parisc/kernel/unaligned.c	2007-10-22 11:24:58.000000000 +0200
+++ b/arch/parisc/kernel/unaligned.c	2007-12-23 20:33:36.000000000 +0100
@@ -460,7 +460,8 @@ void handle_unaligned(struct pt_regs *re
 			goto force_sigbus;
 		}
 
-		if (unaligned_count > 5 && jiffies - last_time > 5*HZ) {
+		if (unaligned_count > 5 &&
+		    time_after(jiffies, last_time + 5*HZ)) {
 			unaligned_count = 0;
 			last_time = jiffies;
 		}
