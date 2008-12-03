Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYLCWpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYLCWpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYLCWpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:45:14 -0500
Received: from vena.lwn.net ([206.168.112.25]:48186 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbYLCWpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:45:12 -0500
Date: Wed, 3 Dec 2008 15:45:08 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
Message-ID: <20081203154508.3502b365@bike.lwn.net>
In-Reply-To: <4936F83E.7090506@linux.intel.com>
References: <20081128192508.GA21369@redhat.com>
	<4933CBB0.2060003@linux.intel.com>
	<20081201191555.GA21385@redhat.com>
	<20081201123405.51d20d84@bike.lwn.net>
	<20081202122939.GA3619@redhat.com>
	<493562B5.5020600@linux.intel.com>
	<20081203190648.GA23893@redhat.com>
	<4936F83E.7090506@linux.intel.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Dec 2008 22:21:02 +0100
Andi Kleen <ak@linux.intel.com> wrote:

> > Serioulsy, I think the best (partial, yes) fix for now is to restore
> > lock_kernel() in setfl() and change ioctl_fioxxx() accordingly.
> > At least this protect us from tty too.  
> 
> For 2.6.28 I agree.

OK, what do you all think of the following?  It returns fcntl.c to its
previous state, and adds locking in fs/ioctl.c.  It's worth noting that
ioctl_fioasync() has always been racy in exactly the same way.

If this passes muster I'll send it upward shortly.

jon

--

Restore BKL protection to manipulations of f_flags

Changeset a238b790d5f99c7832f9b73ac8847025815b85f7 (Call fasync()
functions without the BKL) introduced a race which could leave
file->f_flags in a state inconsistent with what the underlying
driver/filesystem believes.  Revert that change, and also fix the same
races in ioctl_fioasync() and ioctl_fionbio().

This is a minimal, short-term fix; the real fix will not involve the
BKL.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ac4f7db..549daf8 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -19,6 +19,7 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
+#include <linux/smp_lock.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
@@ -175,6 +176,11 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 	if (error)
 		return error;
 
+	/*
+	 * We still need a lock here for now to keep multiple FASYNC calls
+	 * from racing with each other.
+	 */
+	lock_kernel();
 	if ((arg ^ filp->f_flags) & FASYNC) {
 		if (filp->f_op && filp->f_op->fasync) {
 			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
@@ -185,6 +191,7 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
 
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
  out:
+	unlock_kernel();
 	return error;
 }
 
diff --git a/fs/ioctl.c b/fs/ioctl.c
index d152856..fc8fcaa 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -400,11 +400,9 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
 
 	/* Did FASYNC state change ? */
 	if ((flag ^ filp->f_flags) & FASYNC) {
-		if (filp->f_op && filp->f_op->fasync) {
-			lock_kernel();
+		if (filp->f_op && filp->f_op->fasync)
 			error = filp->f_op->fasync(fd, filp, on);
-			unlock_kernel();
-		} else
+		else
 			error = -ENOTTY;
 	}
 	if (error)
@@ -440,11 +438,17 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIONBIO:
+    		/* BKL needed to avoid races tweaking f_flags */
+	        lock_kernel();
 		error = ioctl_fionbio(filp, argp);
+		unlock_kernel();
 		break;
 
 	case FIOASYNC:
+    		/* BKL needed to avoid races tweaking f_flags */
+	        lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
+		unlock_kernel();
 		break;
 
 	case FIOQSIZE:
