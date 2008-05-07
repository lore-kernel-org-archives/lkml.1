Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYEGDkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYEGDkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbYEGDjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:39:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50401 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760276AbYEGDje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:39:34 -0400
Date: Tue, 6 May 2008 20:36:30 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.25.2
Message-ID: <20080507033630.GB10503@kroah.com>
References: <20080507033607.GA10503@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507033607.GA10503@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 675d37c..621f7b3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 25
-EXTRAVERSION = .1
+EXTRAVERSION = .2
 NAME = Funky Weasel is Jiggy wit it
 
 # *DOCUMENTATION*
diff --git a/fs/locks.c b/fs/locks.c
index 43c0af2..159e0f6 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1750,6 +1750,7 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
 	struct file_lock *file_lock = locks_alloc_lock();
 	struct flock flock;
 	struct inode *inode;
+	struct file *f;
 	int error;
 
 	if (file_lock == NULL)
@@ -1822,7 +1823,15 @@ again:
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
@@ -1878,6 +1887,7 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
 	struct file_lock *file_lock = locks_alloc_lock();
 	struct flock64 flock;
 	struct inode *inode;
+	struct file *f;
 	int error;
 
 	if (file_lock == NULL)
@@ -1950,7 +1960,10 @@ again:
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
