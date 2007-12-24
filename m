Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbXLXOps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbXLXOps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbXLXOph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:45:37 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51576 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230AbXLXOpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:45:36 -0500
Date: Mon, 24 Dec 2007 15:45:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: shemminger@linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 30/38] net/bridge: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241545090.23999@ask.diku.dk>
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

diff -r -u -p a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c	2007-11-15 15:09:37.000000000 +0100
+++ b/net/bridge/br_netfilter.c	2007-12-23 20:30:40.000000000 +0100
@@ -46,6 +46,7 @@
 #include "br_private.h"
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
+#include <linux/jiffies.h>
 #endif
 
 #define skb_origaddr(skb)	 (((struct bridge_skb_cb *) \
@@ -221,7 +222,7 @@ static void __br_dnat_complain(void)
 {
 	static unsigned long last_complaint;
 
-	if (jiffies - last_complaint >= 5 * HZ) {
+	if (time_before_eq(jiffies, last_complaint + 5 * HZ)) {
 		printk(KERN_WARNING "Performing cross-bridge DNAT requires IP "
 		       "forwarding to be enabled\n");
 		last_complaint = jiffies;
