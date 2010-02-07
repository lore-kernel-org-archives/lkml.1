Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab0BGGq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 01:46:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab0BGGq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 01:46:56 -0500
Date: Sat, 6 Feb 2010 22:46:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: gregkh@suse.de, taviso@google.com, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       alan@lxorguk.ukuu.org.uk, jdike@addtoit.com, jln@google.com,
       mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency in
 tty_fasync
In-Reply-To: <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002062244310.3829@localhost.localdomain>
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp> <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Feb 2010, Linus Torvalds wrote:
> 
> Yeah. I think we need to just revert that commit.
> 
> Or maybe we could just do the following, rather than revert it outright: 
> just get a ref to the 'struct pid' while holding the spinlock, and then 
> releasing it after doing the __f_setown() call.

Btw, if we do this, then we should probably revert commit 
b04da8bfdfbbd79544cab2fadfdc12e87eb01600 at the same time.

Resulting patch would then look like the appended.

		Linus

---
 drivers/char/tty_io.c |    4 +++-
 fs/fcntl.c            |    6 ++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c6f3b48..dcb9083 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1951,8 +1951,10 @@ static int tty_fasync(int fd, struct file *filp, int on)
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
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 5ef953e..97e01dc 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -199,9 +199,7 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
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
@@ -213,7 +211,7 @@ static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
 			filp->f_owner.euid = cred->euid;
 		}
 	}
-	write_unlock_irqrestore(&filp->f_owner.lock, flags);
+	write_unlock_irq(&filp->f_owner.lock);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,
