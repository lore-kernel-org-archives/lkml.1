Return-Path: <linux-kernel-owner+w=401wt.eu-S1764747AbXLOEH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764747AbXLOEH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbXLOEGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:06:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58931 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbXLOEGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:06:54 -0500
Date: Fri, 14 Dec 2007 20:06:02 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.11
Message-ID: <20071215040602.GB26274@kroah.com>
References: <20071215040535.GA26274@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215040535.GA26274@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3f2c4e3..ada10d5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 23
-EXTRAVERSION = .10
+EXTRAVERSION = .11
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 72183bd..ec116df 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -295,6 +295,7 @@ static int
 apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 {
 	struct apm_user *as = filp->private_data;
+	unsigned long flags;
 	int err = -EINVAL;
 
 	if (!as->suser || !as->writer)
@@ -330,16 +331,10 @@ apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
 			 */
-			freezer_do_not_count();
+			flags = current->flags;
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
-
-			/*
-			 * Since we are waiting until the suspend is done, the
-			 * try_to_freeze() in freezer_count() will not trigger
-			 */
-			freezer_count();
 		} else {
 			as->suspend_state = SUSPEND_WAIT;
 			mutex_unlock(&state_lock);
@@ -367,10 +362,14 @@ apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
 			 */
-			wait_event_freezable(apm_suspend_waitqueue,
+			flags = current->flags;
+
+			wait_event_interruptible(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
 		}
 
+		current->flags = flags;
+
 		mutex_lock(&state_lock);
 		err = as->suspend_result;
 		as->suspend_state = SUSPEND_NONE;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index eb57502..bc40377 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -44,7 +44,7 @@ int __init br_fdb_init(void)
 	return 0;
 }
 
-void __exit br_fdb_fini(void)
+void br_fdb_fini(void)
 {
 	kmem_cache_destroy(br_fdb_cache);
 }
