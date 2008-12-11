Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYLKTW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYLKTW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYLKTST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:19 -0500
Received: from kroah.org ([198.145.64.141]:55856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756250AbYLKTSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:05 -0500
Date: Thu, 11 Dec 2008 11:14:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@linux.intel.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>
Subject: [patch 14/83] Fix a race condition in FASYNC handling
Message-ID: <20081211191400.GN5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-a-race-condition-in-fasync-handling.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan Corbet <corbet@lwn.net>

commit 218d11a8b071b23b76c484fd5f72a4fe3306801e upstream.

Changeset a238b790d5f99c7832f9b73ac8847025815b85f7 (Call fasync()
functions without the BKL) introduced a race which could leave
file->f_flags in a state inconsistent with what the underlying
driver/filesystem believes.  Revert that change, and also fix the same
races in ioctl_fioasync() and ioctl_fionbio().

This is a minimal, short-term fix; the real fix will not involve the
BKL.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fcntl.c |    7 +++++++
 fs/ioctl.c |   12 ++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -19,6 +19,7 @@
 #include <linux/signal.h>
 #include <linux/rcupdate.h>
 #include <linux/pid_namespace.h>
+#include <linux/smp_lock.h>
 
 #include <asm/poll.h>
 #include <asm/siginfo.h>
@@ -175,6 +176,11 @@ static int setfl(int fd, struct file * f
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
@@ -185,6 +191,7 @@ static int setfl(int fd, struct file * f
 
 	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
  out:
+	unlock_kernel();
 	return error;
 }
 
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -123,11 +123,9 @@ static int ioctl_fioasync(unsigned int f
 
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
@@ -163,11 +161,17 @@ int do_vfs_ioctl(struct file *filp, unsi
 		break;
 
 	case FIONBIO:
+		/* BKL needed to avoid races tweaking f_flags */
+		lock_kernel();
 		error = ioctl_fionbio(filp, argp);
+		unlock_kernel();
 		break;
 
 	case FIOASYNC:
+		/* BKL needed to avoid races tweaking f_flags */
+		lock_kernel();
 		error = ioctl_fioasync(fd, filp, argp);
+		unlock_kernel();
 		break;
 
 	case FIOQSIZE:

