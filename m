Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbXLXOjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbXLXOjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXLXOji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:39:38 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:49890 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbXLXOjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:39:36 -0500
Date: Mon, 24 Dec 2007 15:39:33 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 19/38] drivers/net/appletalk: Use time_before, time_before_eq,
 etc.
Message-ID: <Pine.LNX.4.64.0712241539040.23999@ask.diku.dk>
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

diff -r -u -p a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
--- a/drivers/net/appletalk/cops.c	2007-10-22 11:25:13.000000000 +0200
+++ b/drivers/net/appletalk/cops.c	2007-12-23 20:30:39.000000000 +0100
@@ -69,6 +69,7 @@ static const char *version =
 #include <linux/atalk.h>
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
+#include <linux/jiffies.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -503,7 +504,7 @@ static void cops_reset(struct net_device
                         long snap=jiffies;
 
 			/* Let card finish initializing, about 1/3 second */
-	                while(jiffies-snap<HZ/3)
+			while (time_before(jiffies, snap + HZ/3))
                                 schedule();
                 }
                 else
