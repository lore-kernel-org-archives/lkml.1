Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbXLXOZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbXLXOZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXLXOZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:25:36 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:39058 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbXLXOZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:25:35 -0500
Date: Mon, 24 Dec 2007 15:25:15 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: chas@cmf.nrl.navy.mil, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 10/38] drivers/atm: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241524450.23999@ask.diku.dk>
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

diff -r -u -p a/drivers/atm/iphase.c b/drivers/atm/iphase.c
--- a/drivers/atm/iphase.c	2007-09-09 08:31:35.000000000 +0200
+++ b/drivers/atm/iphase.c	2007-12-23 20:34:34.000000000 +0100
@@ -60,7 +60,8 @@
 #include <asm/uaccess.h>  
 #include <asm/string.h>  
 #include <asm/byteorder.h>  
-#include <linux/vmalloc.h>  
+#include <linux/vmalloc.h>
+#include <linux/jiffies.h>
 #include "iphase.h"		  
 #include "suni.h"		  
 #define swap(x) (((x & 0xff) << 8) | ((x & 0xff00) >> 8))  
@@ -189,7 +190,7 @@ static u16 get_desc (IADEV *dev, struct 
   int ltimeout;
 
   ia_hack_tcq (dev);
-  if(((jiffies - timer)>50)||((dev->ffL.tcq_rd==dev->host_tcq_wr))){      
+  if((time_after(jiffies,timer+50)) || ((dev->ffL.tcq_rd==dev->host_tcq_wr))) {
      timer = jiffies; 
      i=0;
      while (i < dev->num_tx_desc) {
@@ -1223,7 +1224,7 @@ static void rx_intr(struct atm_dev *dev)
         iadev->rx_tmp_jif = jiffies; 
         iadev->rxing = 0;
      } 
-     else if (((jiffies - iadev->rx_tmp_jif) > 50) && 
+     else if ((time_after(jiffies, iadev->rx_tmp_jif + 50)) &&
                ((iadev->rx_pkt_cnt - iadev->rx_tmp_cnt) == 0)) {
         for (i = 1; i <= iadev->num_rx_desc; i++)
                free_desc(dev, i);
