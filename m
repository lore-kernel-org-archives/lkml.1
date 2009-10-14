Return-Path: <linux-kernel-owner+w=401wt.eu-S934672AbZJNPsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672AbZJNPsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934636AbZJNPsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:48:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:34064 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934609AbZJNPsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:48:37 -0400
Date: Wed, 14 Oct 2009 15:47:39 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gregkh@suse.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gregkh@suse.de, tglx@linutronix.de
In-Reply-To: <20091010153349.237173041@linutronix.de>
References: <20091010153349.237173041@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] drivers: Remove BKL from misc_open
Message-ID: <tip-40b798efe3460797a4ac928ee2e038774e2758eb@git.kernel.org>
Git-Commit-ID: 40b798efe3460797a4ac928ee2e038774e2758eb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:47:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40b798efe3460797a4ac928ee2e038774e2758eb
Gitweb:     http://git.kernel.org/tip/40b798efe3460797a4ac928ee2e038774e2758eb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:35:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:33:32 +0200

drivers: Remove BKL from misc_open

misc_open() is already serialized with misc_mtx. Remove the BKL
locking which got there via the BKL pushdown.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
LKML-Reference: <20091010153349.237173041@linutronix.de>
---
 drivers/char/misc.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 07fa612..96f1cd0 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -49,7 +49,6 @@
 #include <linux/device.h>
 #include <linux/tty.h>
 #include <linux/kmod.h>
-#include <linux/smp_lock.h>
 
 /*
  * Head entry for the doubly linked miscdevice list
@@ -118,8 +117,7 @@ static int misc_open(struct inode * inode, struct file * file)
 	struct miscdevice *c;
 	int err = -ENODEV;
 	const struct file_operations *old_fops, *new_fops = NULL;
-	
-	lock_kernel();
+
 	mutex_lock(&misc_mtx);
 	
 	list_for_each_entry(c, &misc_list, list) {
@@ -157,7 +155,6 @@ static int misc_open(struct inode * inode, struct file * file)
 	fops_put(old_fops);
 fail:
 	mutex_unlock(&misc_mtx);
-	unlock_kernel();
 	return err;
 }
 
