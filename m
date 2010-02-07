Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab0BGGcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 01:32:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab0BGGcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 01:32:13 -0500
Date: Sat, 6 Feb 2010 22:31:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: gregkh@suse.de, taviso@google.com, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       alan@lxorguk.ukuu.org.uk, jdike@addtoit.com, jln@google.com,
       mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency in
 tty_fasync
In-Reply-To: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain>
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 7 Feb 2010, Tetsuo Handa wrote:
> 
> Below problem (which was introduced between 2.6.33-rc4 and 2.6.33-rc5) is
> not yet fixed as of 2.6.33-rc7.
> "git bisect start v2.6.33-rc5 v2.6.33-rc4" reported that
> 703625118069f9f8960d356676662d3db5a9d116 tty: fix race in tty_fasync
> is first bad commit.

Yeah. I think we need to just revert that commit.

Or maybe we could just do the following, rather than revert it outright: 
just get a ref to the 'struct pid' while holding the spinlock, and then 
releasing it after doing the __f_setown() call.

That way we know 'pid' isn't going away.

What? Untested, of course.

			Linus

---
 drivers/char/tty_io.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

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
