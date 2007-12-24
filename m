Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbXLXOnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbXLXOnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbXLXOnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:43:15 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:58909 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbXLXOnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:43:13 -0500
Date: Mon, 24 Dec 2007 15:42:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 25/38] fs: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.64.0712241542250.23999@ask.diku.dk>
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

diff -r -u -p a/fs/binfmt_aout.c b/fs/binfmt_aout.c
--- a/fs/binfmt_aout.c	2007-12-21 06:57:19.000000000 +0100
+++ b/fs/binfmt_aout.c	2007-12-23 20:42:57.000000000 +0100
@@ -24,6 +24,7 @@
 #include <linux/binfmts.h>
 #include <linux/personality.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -373,14 +374,15 @@ static int load_aout_binary(struct linux
 	} else {
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
@@ -497,7 +499,7 @@ static int load_aout_library(struct file
 		static unsigned long error_time;
 		loff_t pos = N_TXTOFF(ex);
 
-		if ((jiffies-error_time) > 5*HZ)
+		if (time_after(jiffies, error_time + 5*HZ))
 		{
 			printk(KERN_WARNING 
 			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
diff -r -u -p a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
--- a/fs/ncpfs/dir.c	2007-06-02 22:32:35.000000000 +0200
+++ b/fs/ncpfs/dir.c	2007-12-23 20:43:19.000000000 +0100
@@ -23,6 +23,7 @@
 #include <linux/smp_lock.h>
 
 #include <linux/ncp_fs.h>
+#include <linux/jiffies.h>
 
 #include "ncplib_kernel.h"
 
@@ -447,7 +448,8 @@ static int ncp_readdir(struct file *filp
 		goto init_cache;
 
 	if (filp->f_pos == 2) {
-		if (jiffies - ctl.head.time >= NCP_MAX_AGE(server))
+		if (time_before_eq(jiffies,
+				   ctl.head.time + NCP_MAX_AGE(server)))
 			goto init_cache;
 
 		mtime = ncp_obtain_mtime(dentry);
diff -r -u -p a/fs/smbfs/dir.c b/fs/smbfs/dir.c
--- a/fs/smbfs/dir.c	2007-06-02 22:32:36.000000000 +0200
+++ b/fs/smbfs/dir.c	2007-12-23 20:43:34.000000000 +0100
@@ -18,6 +18,7 @@
 #include <linux/smb_fs.h>
 #include <linux/smb_mount.h>
 #include <linux/smbno.h>
+#include <linux/jiffies.h>
 
 #include "smb_debug.h"
 #include "proto.h"
@@ -131,7 +132,7 @@ smb_readdir(struct file *filp, void *dir
 	}
 
 	if (filp->f_pos == 2) {
-		if (jiffies - ctl.head.time >= SMB_MAX_AGE(server))
+		if (time_before_eq(jiffies, ctl.head.time+SMB_MAX_AGE(server)))
 			goto init_cache;
 
 		/*
