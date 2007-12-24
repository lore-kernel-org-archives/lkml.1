Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbXLXOXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbXLXOXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXLXOXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:23:36 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58631 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbXLXOXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:23:35 -0500
Date: Mon, 24 Dec 2007 15:23:19 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: andi@firstfloor.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/38] arch/x86/ia32: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241522410.23999@ask.diku.dk>
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

diff -r -u -p a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
--- a/arch/x86/ia32/ia32_aout.c	2007-10-22 11:25:00.000000000 +0200
+++ b/arch/x86/ia32/ia32_aout.c	2007-12-23 20:31:29.000000000 +0100
@@ -25,6 +25,7 @@
 #include <linux/binfmts.h>
 #include <linux/personality.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -344,14 +345,15 @@ static int load_aout_binary(struct linux
 #ifdef WARN_OLD
 		static unsigned long error_time, error_time2;
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
-		    (N_MAGIC(ex) != NMAGIC) && (jiffies-error_time2) > 5*HZ)
+		    (N_MAGIC(ex) != NMAGIC) &&
+		    time_after(jiffies, error_time2 + 5*HZ))
 		{
 			printk(KERN_NOTICE "executable not page aligned\n");
 			error_time2 = jiffies;
 		}
 
 		if ((fd_offset & ~PAGE_MASK) != 0 &&
-		    (jiffies-error_time) > 5*HZ)
+		    time_after(jiffies, error_time + 5*HZ))
 		{
 			printk(KERN_WARNING 
 			       "fd_offset is not page aligned. Please convert program: %s\n",
@@ -467,7 +469,7 @@ static int load_aout_library(struct file
 
 #ifdef WARN_OLD
 		static unsigned long error_time;
-		if ((jiffies-error_time) > 5*HZ)
+		if (time_after(jiffies, error_time + 5*HZ))
 		{
 			printk(KERN_WARNING 
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
