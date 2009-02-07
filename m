Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZBGUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZBGUIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 15:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbZBGUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 15:07:04 -0500
Received: from vena.lwn.net ([206.168.112.25]:51333 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZBGUHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 15:07:01 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       David Miller <davem@davemloft.net>, Christoph Hellwig <hch@lst.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Mackall <mpm@selenic.com>,
       Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/4] Move FASYNC bit handling to f_op->fasync()
Date: Sat,  7 Feb 2009 13:06:56 -0700
Message-Id: <1234037217-16124-4-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.6.1.2
In-Reply-To: <1234037217-16124-1-git-send-email-corbet@lwn.net>
References: <1234037217-16124-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the BKL from FASYNC handling ran into the challenge of keeping the
setting of the FASYNC bit in filp->f_flags atomic with regard to calls to
the underlying fasync() function.  Andi Kleen suggested moving the handling
of that bit into fasync(); this patch does exactly that.  As a result, we
have a couple of internal API changes: fasync() must now manage the FASYNC
bit, and it will be called without the BKL held.

As it happens, every fasync() implementation in the kernel with one
exception calls fasync_helper().  So, if we make fasync_helper() set the
FASYNC bit, we can avoid making any changes to the other fasync()
functions - as long as those functions, themselves, have proper locking.
Most fasync() implementations do nothing but call fasync_helper() - which
has its own lock - so they are easily verified as correct.  The BKL had
already been pushed down into the rest.

The networking code has its own version of fasync_helper(), so that code
has been augmented with explicit FASYNC bit handling.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 fs/fcntl.c   |   29 ++++++++++++++++-------------
 fs/ioctl.c   |   13 +------------
 net/socket.c |    8 ++++++++
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 04df857..431bb64 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -141,7 +141,7 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 	return ret;
 }
 
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT | O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOATIME)
 
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {
@@ -177,23 +177,19 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
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
+	if (((arg ^ filp->f_flags) & FASYNC) && filp->f_op &&
+			filp->f_op->fasync) {
+		error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
+		if (error < 0)
+			goto out;
 	}
-
 	spin_lock(&filp->f_lock);
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
 	spin_unlock(&filp->f_lock);
+
  out:
-	unlock_kernel();
 	return error;
 }
 
@@ -518,7 +514,7 @@ static DEFINE_RWLOCK(fasync_lock);
 static struct kmem_cache *fasync_cache __read_mostly;
 
 /*
- * fasync_helper() is used by some character device drivers (mainly mice)
+ * fasync_helper() is used by almost all character device drivers
  * to set up the fasync queue. It returns negative on error, 0 if it did
  * no changes and positive if it added/deleted the entry.
  */
@@ -557,6 +553,13 @@ int fasync_helper(int fd, struct file * filp, int on, struct fasync_struct **fap
 		result = 1;
 	}
 out:
+	/* Fix up FASYNC bit while still holding fasync_lock */
+	spin_lock(&filp->f_lock);
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	spin_unlock(&filp->f_lock);
 	write_unlock_irq(&fasync_lock);
 	return result;
 }
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 421aab4..e8e89ed 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -427,19 +427,11 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
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
-	spin_lock(&filp->f_lock);
-	if (on)
-		filp->f_flags |= FASYNC;
-	else
-		filp->f_flags &= ~FASYNC;
-	spin_unlock(&filp->f_lock);
 	return error;
 }
 
@@ -507,10 +499,7 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIOASYNC:
-		/* BKL needed to avoid races tweaking f_flags */
-		lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
-		unlock_kernel();
 		break;
 
 	case FIOQSIZE:
diff --git a/net/socket.c b/net/socket.c
index 35dd737..5770398 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1030,6 +1030,14 @@ static int sock_fasync(int fd, struct file *filp, int on)
 
 	lock_sock(sk);
 
+	/* Maintaining the FASYNC bit is our job now */
+	spin_lock(&filp->f_lock);
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	spin_unlock(&filp->f_lock);
+
 	prev = &(sock->fasync_list);
 
 	for (fa = *prev; fa != NULL; prev = &fa->fa_next, fa = *prev)
-- 
1.6.1.2

