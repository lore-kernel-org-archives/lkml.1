Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0BSRAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:00:24 -0500
Received: from kroah.org ([198.145.64.141]:57346 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab0BSRAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:05 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:31 2010
Message-Id: <20100219163230.971087292@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:28:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>
Subject: [05/93] Fix race in tty_fasync() properly
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 80e1e823989ec44d8e35bdfddadbddcffec90424 upstream.

This reverts commit 703625118069 ("tty: fix race in tty_fasync") and
commit b04da8bfdfbb ("fnctl: f_modown should call write_lock_irqsave/
restore") that tried to fix up some of the fallout but was incomplete.

It turns out that we really cannot hold 'tty->ctrl_lock' over calling
__f_setown, because not only did that cause problems with interrupt
disables (which the second commit fixed), it also causes a potential
ABBA deadlock due to lock ordering.

Thanks to Tetsuo Handa for following up on the issue, and running
lockdep to show the problem.  It goes roughly like this:

 - f_getown gets filp->f_owner.lock for reading without interrupts
   disabled, so an interrupt that happens while that lock is held can
   cause a lockdep chain from f_owner.lock -> sighand->siglock.

 - at the same time, the tty->ctrl_lock -> f_owner.lock chain that
   commit 703625118069 introduced, together with the pre-existing
   sighand->siglock -> tty->ctrl_lock chain means that we have a lock
   dependency the other way too.

So instead of extending tty->ctrl_lock over the whole __f_setown() call,
we now just take a reference to the 'pid' structure while holding the
lock, and then release it after having done the __f_setown.  That still
guarantees that 'struct pid' won't go away from under us, which is all
we really ever needed.

Reported-and-tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Américo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    4 +++-
 fs/fcntl.c            |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1930,8 +1930,10 @@ static int tty_fasync(int fd, struct fil
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		retval = __f_setown(filp, pid, type, 0);
+		get_pid(pid);
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		retval = __f_setown(filp, pid, type, 0);
+		put_pid(pid);
 		if (retval)
 			goto out;
 	} else {
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -199,9 +199,7 @@ static int setfl(int fd, struct file * f
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      int force)
 {
-	unsigned long flags;
-
-	write_lock_irqsave(&filp->f_owner.lock, flags);
+	write_lock_irq(&filp->f_owner.lock);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
@@ -213,7 +211,7 @@ static void f_modown(struct file *filp,
 			filp->f_owner.euid = cred->euid;
 		}
 	}
-	write_unlock_irqrestore(&filp->f_owner.lock, flags);
+	write_unlock_irq(&filp->f_owner.lock);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,


