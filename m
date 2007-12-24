Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbXLXOaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbXLXOaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:30:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbXLXO3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:29:52 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:33712 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbXLXO3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:29:50 -0500
Date: Mon, 24 Dec 2007 15:29:38 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: hpa@zytor.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 16/38] drivers/md: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241528430.23999@ask.diku.dk>
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

diff -r -u -p a/drivers/md/raid6algos.c b/drivers/md/raid6algos.c
--- a/drivers/md/raid6algos.c	2007-11-01 10:30:39.000000000 +0100
+++ b/drivers/md/raid6algos.c	2007-12-23 20:36:20.000000000 +0100
@@ -121,7 +121,8 @@ int __init raid6_select_algo(void)
 			j0 = jiffies;
 			while ( (j1 = jiffies) == j0 )
 				cpu_relax();
-			while ( (jiffies-j1) < (1 << RAID6_TIME_JIFFIES_LG2) ) {
+			while ( time_before(jiffies,
+					    j1 + (1<<RAID6_TIME_JIFFIES_LG2)) ) {
 				(*algo)->gen_syndrome(disks, PAGE_SIZE, dptrs);
 				perf++;
 			}
