Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbXLXOUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbXLXOUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXLXOUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:20:36 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58241 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbXLXOUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:20:33 -0500
Date: Mon, 24 Dec 2007 15:20:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: paulus@samba.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/38] arch/powerpc: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241519310.23999@ask.diku.dk>
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

diff -r -u -p a/arch/powerpc/platforms/iseries/pci.c b/arch/powerpc/platforms/iseries/pci.c
--- a/arch/powerpc/platforms/iseries/pci.c	2007-07-20 17:45:44.000000000 +0200
+++ b/arch/powerpc/platforms/iseries/pci.c	2007-12-23 20:30:39.000000000 +0100
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/jiffies.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -405,7 +406,7 @@ static u8 iSeries_Read_Byte(const volati
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
@@ -434,7 +435,7 @@ static u16 iSeries_Read_Word(const volat
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
@@ -464,7 +465,7 @@ static u32 iSeries_Read_Long(const volat
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
@@ -498,7 +499,7 @@ static void iSeries_Write_Byte(u8 data, 
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
@@ -524,7 +525,7 @@ static void iSeries_Write_Word(u16 data,
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
@@ -551,7 +552,7 @@ static void iSeries_Write_Long(u32 data,
 		static unsigned long last_jiffies;
 		static int num_printed;
 
-		if ((jiffies - last_jiffies) > 60 * HZ) {
+		if (time_after(jiffies, last_jiffies + 60 * HZ)) {
 			last_jiffies = jiffies;
 			num_printed = 0;
 		}
