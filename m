Return-Path: <linux-kernel-owner+w=401wt.eu-S1755719AbXLXOsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbXLXOsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXLXOsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:48:32 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:37386 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbXLXOsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:48:31 -0500
Date: Mon, 24 Dec 2007 15:48:00 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: philb@gnu.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 32/38] net/econet: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241547330.23999@ask.diku.dk>
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

diff -r -u -p a/net/econet/af_econet.c b/net/econet/af_econet.c
--- a/net/econet/af_econet.c	2007-11-08 08:00:53.000000000 +0100
+++ b/net/econet/af_econet.c	2007-12-23 20:30:40.000000000 +0100
@@ -41,6 +41,7 @@
 #include <linux/rcupdate.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -993,7 +994,7 @@ static void ab_cleanup(unsigned long h)
 	{
 		struct sk_buff *newskb = skb->next;
 		struct ec_cb *eb = (struct ec_cb *)&skb->cb;
-		if ((jiffies - eb->start) > eb->timeout)
+		if (time_after(jiffies, eb->start + eb->timeout))
 		{
 			tx_result(skb->sk, eb->cookie,
 				  ECTYPE_TRANSMIT_NOT_PRESENT);
