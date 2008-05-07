Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbYEGDlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbYEGDlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760912AbYEGDjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:39:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50418 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760849AbYEGDjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:39:48 -0400
Date: Tue, 6 May 2008 20:39:01 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.24.7
Message-ID: <20080507033901.GB10592@kroah.com>
References: <20080507033838.GA10592@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507033838.GA10592@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index f619bbc..78ec132 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 24
-EXTRAVERSION = .6
+EXTRAVERSION = .7
 NAME = Err Metey! A Heury Beelge-a Ret!
 
 # *DOCUMENTATION*
diff --git a/fs/locks.c b/fs/locks.c
index 2fd29d9..7127620 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1754,6 +1754,7 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
 	struct file_lock *file_lock = locks_alloc_lock();
 	struct flock flock;
 	struct inode *inode;
+	struct file *f;
 	int error;
 
 	if (file_lock == NULL)
@@ -1826,7 +1827,15 @@ again:
 	 * Attempt to detect a close/fcntl race and recover by
 	 * releasing the lock that was just acquired.
 	 */
-	if (!error && fcheck(fd) != filp && flock.l_type != F_UNLCK) {
+	/*
+	 * we need that spin_lock here - it prevents reordering between
+	 * update of inode->i_flock and check for it done in close().
+	 * rcu_read_lock() wouldn't do.
+	 */
+	spin_lock(&current->files->file_lock);
+	f = fcheck(fd);
+	spin_unlock(&current->files->file_lock);
+	if (!error && f != filp && flock.l_type != F_UNLCK) {
 		flock.l_type = F_UNLCK;
 		goto again;
 	}
@@ -1882,6 +1891,7 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
 	struct file_lock *file_lock = locks_alloc_lock();
 	struct flock64 flock;
 	struct inode *inode;
+	struct file *f;
 	int error;
 
 	if (file_lock == NULL)
@@ -1954,7 +1964,10 @@ again:
 	 * Attempt to detect a close/fcntl race and recover by
 	 * releasing the lock that was just acquired.
 	 */
-	if (!error && fcheck(fd) != filp && flock.l_type != F_UNLCK) {
+	spin_lock(&current->files->file_lock);
+	f = fcheck(fd);
+	spin_unlock(&current->files->file_lock);
+	if (!error && f != filp && flock.l_type != F_UNLCK) {
 		flock.l_type = F_UNLCK;
 		goto again;
 	}
