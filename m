Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbZBBSVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbZBBSVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbZBBSUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:20:21 -0500
Received: from vena.lwn.net ([206.168.112.25]:53488 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZBBSUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:20:15 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       linux-api@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/4] Move FASYNC bit handling to f_op->fasync()
Date: Mon,  2 Feb 2009 11:20:10 -0700
Message-Id: <1233598811-6871-4-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.6.1.1
In-Reply-To: <1233598811-6871-1-git-send-email-corbet@lwn.net>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the BKL from FASYNC handling ran into the challenge of keeping the
setting of the FASYNC bit in filp->f_flags atomic with regard to calls to
the underlying fasync() function.  Andi Kleen suggested moving the handling
of that bit into fasync(); this patch does exactly that.

As it happens, every fasync() implementation in the kernel with one
exception calls fasync_helper().  So, if we make fasync_helper() set the
FASYNC bit, we can avoid making any changes to the other fasync()
functions - as long as those functions, themselves, have proper locking.
Most fasync() implementations do nothing but call fasync_helper() - which
has its own lock - so they are easily verified as correct.  The BKL had
already been pushed down into the few exceptions.

The networking code has its own version of fasync_helper(), so that code
has been augmented with explicit FASYNC bit handling.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 fs/fcntl.c   |   21 ++++++++-------------
 fs/ioctl.c   |   11 +----------
 net/socket.c |    2 ++
 3 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 756119e..7b641d9 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -185,19 +185,14 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 		return error;
 
 	/*
-	 * We still need a lock here for now to keep multiple FASYNC calls
-	 * from racing with each other.
+	 * ->fasync() is responsible for setting the FASYNC bit.
 	 */
-	lock_kernel();
-	if ((arg ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
-			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
-			if (error < 0)
-				goto out;
-		}
-		change_bit(NR_FASYNC, &filp->f_flags);
+	if (((arg ^ filp->f_flags) & FASYNC) && filp->f_op &&
+			filp->f_op->fasync) {
+		error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
+		if (error < 0)
+			goto out;
 	}
-
 	/*
 	 * Now that we use bitops we have to tweak each bit individually.
 	 */
@@ -207,7 +202,6 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	tweak_flags_bit(NR_O_DIRECT, arg & O_DIRECT, &filp->f_flags);
 	tweak_flags_bit(NR_O_NOATIME, arg & O_NOATIME, &filp->f_flags);
  out:
-	unlock_kernel();
 	return error;
 }
 
@@ -532,7 +526,7 @@ static DEFINE_RWLOCK(fasync_lock);
 static struct kmem_cache *fasync_cache __read_mostly;
 
 /*
- * fasync_helper() is used by some character device drivers (mainly mice)
+ * fasync_helper() is used by almost all character device drivers
  * to set up the fasync queue. It returns negative on error, 0 if it did
  * no changes and positive if it added/deleted the entry.
  */
@@ -548,6 +542,7 @@ int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fap
 			return -ENOMEM;
 	}
 	write_lock_irq(&fasync_lock);
+	tweak_flags_bit(NR_FASYNC, on, &filp->f_flags);
 	for (fp = fapp; (fa = *fp) != NULL; fp = &fa->fa_next) {
 		if (fa->fa_file == filp) {
 			if(on) {
diff --git a/fs/ioctl.c b/fs/ioctl.c
index fc0db36..bc32cb2 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -427,17 +427,11 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 	/* Did FASYNC state change ? */
 	if ((flag ^ filp->f_flags) & FASYNC) {
 		if (filp->f_op && filp->f_op->fasync)
+			/* fasync() adjusts filp->f_flags */
 			error = filp->f_op->fasync(fd, filp, on);
 		else
 			error = -ENOTTY;
 	}
-	if (error)
-		return error;
-
-	if (on)
-		set_bit(NR_FASYNC, &filp->f_flags);
-	else
-		clear_bit(NR_FASYNC, &filp->f_flags);
 	return error;
 }
 
@@ -505,10 +499,7 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIOASYNC:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOQSIZE:
diff --git a/net/socket.c b/net/socket.c
index 35dd737..2b1e380 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1037,6 +1037,7 @@ static int sock_fasync(int fd, struct file *filp, int on)
 			break;
 
 	if (on) {
+		set_bit(NR_FASYNC, &filp->f_flags);
 		if (fa != NULL) {
 			write_lock_bh(&sk->sk_callback_lock);
 			fa->fa_fd = fd;
@@ -1053,6 +1054,7 @@ static int sock_fasync(int fd, struct file *filp, int on)
 		sock->fasync_list = fna;
 		write_unlock_bh(&sk->sk_callback_lock);
 	} else {
+		clear_bit(NR_FASYNC, &filp->f_flags);
 		if (fa != NULL) {
 			write_lock_bh(&sk->sk_callback_lock);
 			*prev = fa->fa_next;
-- 
1.6.1.1

